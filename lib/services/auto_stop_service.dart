import "dart:async";
import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../providers/settings_provider.dart";
import "../providers/stopwatch_provider.dart";

/// 自動停止サービス
///
/// 1分ごとに現在時刻をチェックし、設定された自動停止時刻と一致した場合、
/// 計測中のすべてのストップウォッチを自動停止する
class AutoStopService {
  /// 内部で使用するTimer
  Timer? _timer;

  /// Riverpod Ref（プロバイダーにアクセスするため）
  final Ref _ref;

  /// コンストラクタ
  ///
  /// [_ref] Riverpod Ref
  AutoStopService(this._ref);

  /// サービスを開始する
  ///
  /// Timer.periodic(Duration(minutes: 1))で1分ごとにチェック
  void start() {
    // すでに実行中の場合は何もしない
    if (_timer != null && _timer!.isActive) return;

    // 1分ごとにチェック
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _checkAutoStop(),
    );

    debugPrint("自動停止サービスを開始しました");
  }

  /// サービスを停止する
  ///
  /// タイマーをキャンセルし、リソースを解放する
  void stop() {
    _timer?.cancel();
    _timer = null;
    debugPrint("自動停止サービスを停止しました");
  }

  /// 自動停止時刻をチェックする
  ///
  /// 現在時刻と一致する有効な自動停止時刻がある場合、
  /// 計測中のすべてのストップウォッチを停止する
  void _checkAutoStop() {
    // 現在時刻を取得
    final now = DateTime.now();

    // 設定から有効な自動停止時刻を取得
    final settings = _ref.read(settingsProvider);
    final enabledAutoStopTimes = settings.autoStopTimes
        .where((time) => time.isEnabled)
        .toList();

    // 現在時刻と一致する自動停止時刻があるかチェック
    final shouldStop = enabledAutoStopTimes.any(
      (time) => time.hour == now.hour && time.minute == now.minute,
    );

    if (!shouldStop) return;

    // 計測中のストップウォッチをすべて停止
    final stopwatches = _ref.read(stopwatchProvider);
    final runningStopwatches = stopwatches.where((sw) => sw.isRunning);

    for (final sw in runningStopwatches) {
      _ref.read(stopwatchProvider.notifier).stopStopwatch(sw.id);
    }

    debugPrint("自動停止を実行しました: ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}");
  }

  /// サービスを破棄する
  ///
  /// タイマーを停止し、リソースをクリーンアップする
  void dispose() {
    stop();
  }
}
