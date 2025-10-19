/// 時間を様々な形式でフォーマットするユーティリティ関数群
library;

/// 秒数をHH:MM形式の文字列に変換する
///
/// [seconds] 変換する秒数（0以上の整数）
/// 戻り値: "HH:MM" 形式の文字列（例: "01:30", "12:45"）
String formatToHHMM(int seconds) {
  if (seconds < 0) {
    seconds = 0;
  }

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;

  return "${hours.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}";
}

/// 秒数を0.25単位（15分単位）の小数表記に変換する
///
/// [seconds] 変換する秒数（0以上の整数）
/// 戻り値: 0.25単位で表現された時間（例: 1.5, 2.75）
///
/// 変換例:
/// - 5400秒（1時間30分） → 1.5
/// - 9900秒（2時間45分） → 2.75
/// - 3600秒（1時間） → 1.0
double formatToQuarterHour(int seconds) {
  if (seconds < 0) {
    seconds = 0;
  }

  // 秒を時間に変換し、15分単位（0.25時間）で丸める
  final hours = seconds / 3600.0;
  final quarterHours = (hours * 4).round() / 4.0;

  return quarterHours;
}
