import "package:flutter/foundation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../models/app_settings.dart";
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
