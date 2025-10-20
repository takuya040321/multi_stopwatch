import "package:flutter/foundation.dart";
import "package:hive_flutter/hive_flutter.dart";
import "../models/stopwatch_model.dart";

/// ストップウォッチデータの永続化を担当するリポジトリ
///
/// Hiveを使用してストップウォッチのデータを保存・読み込み・削除する
class StopwatchRepository {
  /// Hiveボックス名
  static const String _boxName = "stopwatches";

  /// Hiveボックスのインスタンス
  Box<StopwatchModel>? _box;

  /// ボックスを開く
  ///
  /// アプリケーション起動時に一度だけ呼び出す
  Future<void> init() async {
    try {
      _box = await Hive.openBox<StopwatchModel>(_boxName);
    } catch (e) {
      debugPrint("ストップウォッチリポジトリの初期化エラー: $e");
      rethrow;
    }
  }

  /// ストップウォッチリストを保存する
  ///
  /// [stopwatches] 保存するストップウォッチのリスト
  Future<void> saveStopwatches(List<StopwatchModel> stopwatches) async {
    if (_box == null) {
      throw Exception("リポジトリが初期化されていません。init()を呼び出してください。");
    }

    try {
      // 既存のデータをクリア
      await _box!.clear();

      // 新しいデータを保存
      for (var i = 0; i < stopwatches.length; i++) {
        await _box!.put(stopwatches[i].id, stopwatches[i]);
      }
    } catch (e) {
      debugPrint("ストップウォッチデータの保存エラー: $e");
      throw Exception("データの保存に失敗しました。もう一度お試しください。");
    }
  }

  /// ストップウォッチリストを読み込む
  ///
  /// 戻り値: 保存されているストップウォッチのリスト（存在しない場合は空リスト）
  Future<List<StopwatchModel>> loadStopwatches() async {
    if (_box == null) {
      throw Exception("リポジトリが初期化されていません。init()を呼び出してください。");
    }

    try {
      final stopwatches = _box!.values.toList();
      // 作成日時順にソート
      stopwatches.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return stopwatches;
    } catch (e) {
      debugPrint("ストップウォッチデータの読み込みエラー: $e");
      throw Exception("データの読み込みに失敗しました。もう一度お試しください。");
    }
  }

  /// 指定されたIDのストップウォッチを削除する
  ///
  /// [id] 削除するストップウォッチのID
  Future<void> deleteStopwatch(String id) async {
    if (_box == null) {
      throw Exception("リポジトリが初期化されていません。init()を呼び出してください。");
    }

    try {
      await _box!.delete(id);
    } catch (e) {
      debugPrint("ストップウォッチデータの削除エラー: $e");
      throw Exception("データの削除に失敗しました。もう一度お試しください。");
    }
  }

  /// リポジトリを閉じる
  ///
  /// アプリケーション終了時に呼び出す
  Future<void> dispose() async {
    await _box?.close();
  }
}
