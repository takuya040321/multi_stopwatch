import "dart:convert";
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/app_settings.dart";

/// アプリケーション設定の永続化を担当するリポジトリ
///
/// SharedPreferencesを使用してアプリケーション設定を保存・読み込みする
class SettingsRepository {
  /// SharedPreferencesのキー名
  static const String _settingsKey = "app_settings";

  /// SharedPreferencesのインスタンス
  SharedPreferences? _prefs;

  /// 初期化処理
  ///
  /// アプリケーション起動時に一度だけ呼び出す
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint("設定リポジトリの初期化エラー: $e");
      rethrow;
    }
  }

  /// アプリケーション設定を保存する
  ///
  /// [settings] 保存する設定オブジェクト
  Future<void> saveSettings(AppSettings settings) async {
    if (_prefs == null) {
      throw Exception("リポジトリが初期化されていません。init()を呼び出してください。");
    }

    try {
      final jsonString = jsonEncode(settings.toJson());
      await _prefs!.setString(_settingsKey, jsonString);
    } catch (e) {
      debugPrint("設定データの保存エラー: $e");
      throw Exception("設定の保存に失敗しました。もう一度お試しください。");
    }
  }

  /// アプリケーション設定を読み込む
  ///
  /// 戻り値: 保存されている設定（存在しない場合はデフォルト設定）
  Future<AppSettings> loadSettings() async {
    if (_prefs == null) {
      throw Exception("リポジトリが初期化されていません。init()を呼び出してください。");
    }

    try {
      final jsonString = _prefs!.getString(_settingsKey);

      // データが存在しない場合はデフォルト設定を返す
      if (jsonString == null) {
        return AppSettings.defaultSettings();
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppSettings.fromJson(jsonMap);
    } catch (e) {
      debugPrint("設定データの読み込みエラー: $e");
      // エラーが発生した場合もデフォルト設定を返す
      return AppSettings.defaultSettings();
    }
  }
}
