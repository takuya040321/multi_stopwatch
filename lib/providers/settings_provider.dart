import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/app_settings.dart";
import "../models/auto_stop_time.dart";
import "../repositories/settings_repository.dart";

/// 設定状態の管理を行うStateNotifier
///
/// アプリケーション設定の読み込み、保存、変更を管理する
class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(AppSettings.defaultSettings());

  /// リポジトリから設定を読み込む
  ///
  /// アプリ起動時に呼び出される
  Future<void> loadSettings() async {
    try {
      final settings = await _repository.loadSettings();
      state = settings;
    } catch (e) {
      debugPrint("設定の読み込みエラー: $e");
      // エラーが発生した場合はデフォルト設定を使用
      state = AppSettings.defaultSettings();
    }
  }

  /// 計測モードを切り替える
  ///
  /// [isSingleMode] true: 単一計測モード, false: 複数同時計測モード
  Future<void> toggleMeasurementMode(bool isSingleMode) async {
    try {
      final newSettings = state.copyWith(
        isSingleMeasurementMode: isSingleMode,
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("計測モード切り替えエラー: $e");
      throw Exception("計測モードの変更に失敗しました。もう一度お試しください。");
    }
  }

  /// レイアウトモードを切り替える
  ///
  /// [layoutMode] "LIST" または "GRID"
  Future<void> toggleLayoutMode(String layoutMode) async {
    // レイアウトモードの検証
    if (layoutMode != "LIST" && layoutMode != "GRID") {
      throw Exception("無効なレイアウトモードです。");
    }

    try {
      final newSettings = state.copyWith(
        layoutMode: layoutMode,
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("レイアウトモード切り替えエラー: $e");
      throw Exception("レイアウトモードの変更に失敗しました。もう一度お試しください。");
    }
  }

  /// ウィンドウサイズを更新する
  ///
  /// [width] ウィンドウの幅（最小800）
  /// [height] ウィンドウの高さ（最小600）
  Future<void> updateWindowSize(double width, double height) async {
    // 最小サイズの検証
    if (width < 800) {
      throw Exception("ウィンドウ幅は最小800px以上である必要があります。");
    }
    if (height < 600) {
      throw Exception("ウィンドウ高さは最小600px以上である必要があります。");
    }

    try {
      final newSettings = state.copyWith(
        windowWidth: width,
        windowHeight: height,
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("ウィンドウサイズ更新エラー: $e");
      throw Exception("ウィンドウサイズの保存に失敗しました。もう一度お試しください。");
    }
  }

  /// 自動停止時刻を追加する
  ///
  /// [autoStopTime] 追加する自動停止時刻
  /// 最大5個まで追加可能
  Future<void> addAutoStopTime(AutoStopTime autoStopTime) async {
    // 最大数チェック
    if (state.autoStopTimes.length >= 5) {
      throw Exception("自動停止時刻は最大5個までです。");
    }

    try {
      final newSettings = state.copyWith(
        autoStopTimes: [...state.autoStopTimes, autoStopTime],
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("自動停止時刻追加エラー: $e");
      throw Exception("自動停止時刻の追加に失敗しました。もう一度お試しください。");
    }
  }

  /// 自動停止時刻を削除する
  ///
  /// [id] 削除する自動停止時刻のID
  Future<void> removeAutoStopTime(String id) async {
    try {
      final newSettings = state.copyWith(
        autoStopTimes: state.autoStopTimes
            .where((time) => time.id != id)
            .toList(),
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("自動停止時刻削除エラー: $e");
      throw Exception("自動停止時刻の削除に失敗しました。もう一度お試しください。");
    }
  }

  /// 自動停止時刻を更新する
  ///
  /// [id] 更新する自動停止時刻のID
  /// [hour] 新しい時
  /// [minute] 新しい分
  /// [isEnabled] 新しい有効/無効状態
  Future<void> updateAutoStopTime({
    required String id,
    int? hour,
    int? minute,
    bool? isEnabled,
  }) async {
    try {
      final newSettings = state.copyWith(
        autoStopTimes: state.autoStopTimes.map((time) {
          if (time.id == id) {
            return time.copyWith(
              hour: hour,
              minute: minute,
              isEnabled: isEnabled,
            );
          }
          return time;
        }).toList(),
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("自動停止時刻更新エラー: $e");
      throw Exception("自動停止時刻の更新に失敗しました。もう一度お試しください。");
    }
  }

  /// 秒数表示の有効/無効を切り替える
  ///
  /// [showSeconds] true: HH:MM:SS形式, false: HH:MM形式
  Future<void> toggleShowSeconds(bool showSeconds) async {
    try {
      final newSettings = state.copyWith(
        showSeconds: showSeconds,
      );
      state = newSettings;
      await _repository.saveSettings(newSettings);
    } catch (e) {
      debugPrint("秒数表示切り替えエラー: $e");
      throw Exception("秒数表示の変更に失敗しました。もう一度お試しください。");
    }
  }
}

/// SettingsRepositoryのプロバイダー
///
/// リポジトリのインスタンスを提供し、アプリケーション全体で共有する
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// リポジトリの初期化を行うプロバイダー
///
/// アプリ起動時に一度だけ呼び出される
final initializeSettingsRepositoryProvider = FutureProvider<void>((ref) async {
  final repository = ref.read(settingsRepositoryProvider);
  await repository.init();
});

/// SettingsProviderのインスタンス
///
/// アプリケーション全体で設定状態を管理する
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});
