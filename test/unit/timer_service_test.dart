import "package:flutter_test/flutter_test.dart";
import "package:multi_stopwatch/services/timer_service.dart";

void main() {
  late TimerService timerService;

  setUp(() {
    timerService = TimerService();
  });

  tearDown(() {
    timerService.dispose();
  });

  group("TimerService", () {
    test("初期状態ではタイマーは実行されていない", () {
      expect(timerService.isRunning, false);
    });

    test("startを呼び出すとタイマーが開始される", () async {
      timerService.start(() {});

      expect(timerService.isRunning, true);
    });

    test("すでに実行中の場合、startを再度呼び出しても何も起こらない", () {
      int callCount = 0;
      timerService.start(() => callCount++);

      expect(timerService.isRunning, true);

      // 2回目のstart（何も起こらないはず）
      timerService.start(() => callCount++);

      expect(timerService.isRunning, true);
    });

    test("stopを呼び出すとタイマーが停止される", () {
      timerService.start(() {});
      expect(timerService.isRunning, true);

      timerService.stop();
      expect(timerService.isRunning, false);
    });

    test("タイマーは1秒ごとにコールバックを呼び出す", () async {
      int callCount = 0;
      timerService.start(() => callCount++);

      // 2.5秒待機（2回コールバックが呼ばれるはず）
      await Future.delayed(const Duration(milliseconds: 2500));

      expect(callCount, 2);

      timerService.stop();
    });

    test("stopを呼び出すとコールバックが呼ばれなくなる", () async {
      int callCount = 0;
      timerService.start(() => callCount++);

      // 1秒待機
      await Future.delayed(const Duration(milliseconds: 1100));
      final countAfter1Sec = callCount;

      timerService.stop();

      // さらに2秒待機
      await Future.delayed(const Duration(milliseconds: 2000));

      // stopした後はカウントが増えないはず
      expect(callCount, countAfter1Sec);
    });

    test("disposeを呼び出すとタイマーが停止される", () {
      timerService.start(() {});
      expect(timerService.isRunning, true);

      timerService.dispose();
      expect(timerService.isRunning, false);
    });

    test("複数回startとstopを繰り返しても正常に動作する", () async {
      int callCount = 0;

      // 1回目のstart
      timerService.start(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 1100));
      timerService.stop();
      final count1 = callCount;

      // 2回目のstart
      timerService.start(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 1100));
      timerService.stop();

      expect(callCount, greaterThan(count1));
    });
  });
}
