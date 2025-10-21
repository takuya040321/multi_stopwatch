import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";
import "../models/stopwatch_model.dart";
import "../repositories/stopwatch_repository.dart";
import "settings_provider.dart";

/// ストップウォッチリストの状態管理を行うStateNotifier
///
/// ストップウォッチの追加、削除、名称変更、開始、停止、リセットなどの操作を管理する
class StopwatchNotifier extends StateNotifier<List<StopwatchModel>> {
  final StopwatchRepository _repository;
  final Ref _ref;

  StopwatchNotifier(this._repository, this._ref) : super([]);

  /// リポジトリからストップウォッチデータを読み込む
  ///
  /// アプリ起動時に呼び出される
  Future<void> loadStopwatches() async {
    try {
      final stopwatches = await _repository.loadStopwatches();
      
      // データが存在しない場合はデフォルトで2個作成
      if (stopwatches.isEmpty) {
        state = [
          _createDefaultStopwatch(1),
          _createDefaultStopwatch(2),
        ];
        await _repository.saveStopwatches(state);
      } else {
        // すべて停止状態にして読み込む（アプリ起動時は計測を継続しない仕様）
        state = stopwatches.map((sw) => sw.copyWith(isRunning: false)).toList();
      }
    } catch (e) {
      // エラーが発生した場合はデフォルトデータを作成
      state = [
        _createDefaultStopwatch(1),
        _createDefaultStopwatch(2),
      ];
    }
  }

  /// デフォルトのストップウォッチを作成する
  ///
  /// [index] ストップウォッチの番号（名前に使用）
  StopwatchModel _createDefaultStopwatch(int index) {
    return StopwatchModel(
      id: const Uuid().v4(),
      name: "ストップウォッチ $index",
      elapsedSeconds: 0,
      isRunning: false,
      createdAt: DateTime.now(),
    );
  }

  /// 新しいストップウォッチを追加する
  ///
  /// 最大10個まで追加可能
  Future<void> addStopwatch() async {
    // 最大数チェック
    if (state.length >= 10) {
      throw Exception("ストップウォッチは最大10個までです。");
    }

    final newStopwatch = StopwatchModel(
      id: const Uuid().v4(),
      name: "ストップウォッチ ${state.length + 1}",
      elapsedSeconds: 0,
      isRunning: false,
      createdAt: DateTime.now(),
    );

    state = [...state, newStopwatch];
    await _repository.saveStopwatches(state);
  }

  /// 指定されたIDのストップウォッチを削除する
  ///
  /// [id] 削除するストップウォッチのID
  /// 最小2個は残す必要がある
  Future<void> removeStopwatch(String id) async {
    // 最小数チェック
    if (state.length <= 2) {
      throw Exception("ストップウォッチは最低2個必要です。");
    }

    state = state.where((sw) => sw.id != id).toList();
    await _repository.saveStopwatches(state);
  }

  /// ストップウォッチの名称を変更する
  ///
  /// [id] 名称を変更するストップウォッチのID
  /// [name] 新しい名称
  Future<void> updateName(String id, String name) async {
    state = [
      for (final sw in state)
        if (sw.id == id) sw.copyWith(name: name) else sw
    ];
    await _repository.saveStopwatches(state);
  }

  /// ストップウォッチを開始する
  ///
  /// [id] 開始するストップウォッチのID
  /// 単一計測モードの場合、他の計測中のストップウォッチを停止する
  Future<void> startStopwatch(String id) async {
    // 設定から単一計測モードを取得
    final isSingleMeasurementMode = _ref.read(settingsProvider).isSingleMeasurementMode;

    state = [
      for (final sw in state)
        if (sw.id == id)
          sw.copyWith(isRunning: true)
        else if (isSingleMeasurementMode && sw.isRunning)
          // 単一計測モードの場合は他を停止
          sw.copyWith(isRunning: false)
        else
          sw
    ];
    await _repository.saveStopwatches(state);
  }

  /// ストップウォッチを停止する
  ///
  /// [id] 停止するストップウォッチのID
  Future<void> stopStopwatch(String id) async {
    state = [
      for (final sw in state)
        if (sw.id == id) sw.copyWith(isRunning: false) else sw
    ];
    await _repository.saveStopwatches(state);
  }

  /// ストップウォッチをリセットする
  ///
  /// [id] リセットするストップウォッチのID
  /// 経過時間を0にし、停止状態にする
  Future<void> resetStopwatch(String id) async {
    state = [
      for (final sw in state)
        if (sw.id == id)
          sw.copyWith(elapsedSeconds: 0, isRunning: false)
        else
          sw
    ];
    await _repository.saveStopwatches(state);
  }

  /// 指定されたストップウォッチの経過時間を1秒増やす
  ///
  /// [id] 経過時間を増やすストップウォッチのID
  /// このメソッドはTimerProviderから1秒ごとに呼び出される
  void incrementElapsedTime(String id) {
    state = [
      for (final sw in state)
        if (sw.id == id && sw.isRunning)
          sw.copyWith(elapsedSeconds: sw.elapsedSeconds + 1)
        else
          sw
    ];
    // 経過時間の更新は頻繁に発生するため、ここでは保存しない
    // 停止時やリセット時に保存される
  }

  /// 計測中のストップウォッチが存在するかどうか
  ///
  /// タイマーの起動/停止判定に使用
  bool get hasRunningStopwatch {
    return state.any((sw) => sw.isRunning);
  }
}

/// StopwatchRepositoryのプロバイダー
///
/// リポジトリのインスタンスを提供し、アプリケーション全体で共有する
final stopwatchRepositoryProvider = Provider<StopwatchRepository>((ref) {
  return StopwatchRepository();
});

/// リポジトリの初期化を行うプロバイダー
///
/// アプリ起動時に一度だけ呼び出される
final initializeRepositoryProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(stopwatchRepositoryProvider);
  await repository.init();
});

/// StopwatchProviderのインスタンス
///
/// アプリケーション全体でストップウォッチの状態を管理する
final stopwatchProvider =
    StateNotifierProvider<StopwatchNotifier, List<StopwatchModel>>((ref) {
  final repository = ref.watch(stopwatchRepositoryProvider);
  return StopwatchNotifier(repository, ref);
});
