import "dart:async";

/// タイマー制御サービス
///
/// Timer.periodicを使用して1秒ごとにコールバック関数を呼び出す
/// 計測中のストップウォッチが存在する場合のみタイマーを起動し、
/// すべて停止している場合はタイマーを停止してリソースを節約する
class TimerService {
  /// 内部で使用するTimer
  Timer? _timer;

  /// タイマーが実行中かどうか
  bool get isRunning => _timer != null && _timer!.isActive;

  /// タイマーを開始する
  ///
  /// [callback] 1秒ごとに呼び出されるコールバック関数
  void start(void Function() callback) {
    // すでに実行中の場合は何もしない
    if (isRunning) return;

    // 1秒ごとにコールバックを実行
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => callback(),
    );
  }

  /// タイマーを停止する
  ///
  /// タイマーをキャンセルし、リソースを解放する
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// サービスを破棄する
  ///
  /// タイマーを停止し、リソースをクリーンアップする
  void dispose() {
    stop();
  }
}
