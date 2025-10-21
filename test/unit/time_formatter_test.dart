import "package:flutter_test/flutter_test.dart";
import "package:multi_stopwatch/utils/time_formatter.dart";

void main() {
  group("formatToHHMM", () {
    test("0秒は00:00として表示される", () {
      expect(formatToHHMM(0), "00:00");
    });

    test("負の値は0として扱われる", () {
      expect(formatToHHMM(-100), "00:00");
    });

    test("1時間未満の時間が正しくフォーマットされる", () {
      expect(formatToHHMM(60), "00:01"); // 1分
      expect(formatToHHMM(900), "00:15"); // 15分
      expect(formatToHHMM(1800), "00:30"); // 30分
      expect(formatToHHMM(3540), "00:59"); // 59分
    });

    test("1時間以上の時間が正しくフォーマットされる", () {
      expect(formatToHHMM(3600), "01:00"); // 1時間
      expect(formatToHHMM(5400), "01:30"); // 1時間30分
      expect(formatToHHMM(7200), "02:00"); // 2時間
      expect(formatToHHMM(9900), "02:45"); // 2時間45分
    });

    test("10時間以上の時間が正しくフォーマットされる", () {
      expect(formatToHHMM(36000), "10:00"); // 10時間
      expect(formatToHHMM(86400), "24:00"); // 24時間
      expect(formatToHHMM(90000), "25:00"); // 25時間
    });

    test("秒数は切り捨てられる", () {
      expect(formatToHHMM(61), "00:01"); // 1分1秒 → 1分
      expect(formatToHHMM(3659), "01:00"); // 59分59秒 → 1時間
      expect(formatToHHMM(3661), "01:01"); // 1時間1分1秒 → 1時間1分
    });
  });

  group("formatToQuarterHour", () {
    test("0秒は0.0として表示される", () {
      expect(formatToQuarterHour(0), 0.0);
    });

    test("負の値は0として扱われる", () {
      expect(formatToQuarterHour(-100), 0.0);
    });

    test("15分単位で正しく丸められる", () {
      expect(formatToQuarterHour(900), 0.25); // 15分 → 0.25時間
      expect(formatToQuarterHour(1800), 0.5); // 30分 → 0.5時間
      expect(formatToQuarterHour(2700), 0.75); // 45分 → 0.75時間
      expect(formatToQuarterHour(3600), 1.0); // 1時間 → 1.0時間
    });

    test("1時間以上の時間が正しく変換される", () {
      expect(formatToQuarterHour(5400), 1.5); // 1時間30分 → 1.5
      expect(formatToQuarterHour(7200), 2.0); // 2時間 → 2.0
      expect(formatToQuarterHour(9900), 2.75); // 2時間45分 → 2.75
    });

    test("15分単位に近い値が正しく丸められる", () {
      expect(formatToQuarterHour(800), 0.25); // 13分20秒 → 0.25（四捨五入）
      expect(formatToQuarterHour(1000), 0.25); // 16分40秒 → 0.25（四捨五入）
      expect(formatToQuarterHour(450), 0.25); // 7分30秒 → 0.25（四捨五入）
      expect(formatToQuarterHour(1100), 0.25); // 18分20秒 → 0.25（四捨五入）
    });

    test("大きな値が正しく変換される", () {
      expect(formatToQuarterHour(36000), 10.0); // 10時間
      expect(formatToQuarterHour(86400), 24.0); // 24時間
    });
  });
}
