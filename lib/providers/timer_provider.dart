import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/timer_service.dart";
import "stopwatch_provider.dart";

/// タイマーサービスのプロバイダー
///
/// TimerServiceのインスタンスを提供し、アプリケーション全体で共有する
final timerServiceProvider = Provider<TimerService>((ref) {
  final service = TimerService();
  
  // Providerが破棄されるときにタイマーを停止
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// タイマー制御のプロバイダー
///
/// StopwatchProviderと連携してタイマーの起動/停止を制御する
/// 計測中のストップウォッチがある場合にのみタイマーを起動し、
/// すべて停止している場合はタイマーを停止してリソースを節約する
final timerControllerProvider = Provider<void>((ref) {
  final timerService = ref.watch(timerServiceProvider);
  final stopwatchNotifier = ref.read(stopwatchProvider.notifier);
  final stopwatches = ref.watch(stopwatchProvider);
  
  // 計測中のストップウォッチが存在するかチェック
  final hasRunning = stopwatches.any((sw) => sw.isRunning);
  
  if (hasRunning) {
    // 計測中のストップウォッチがある場合、タイマーを起動
    if (!timerService.isRunning) {
      timerService.start(() {
        // 1秒ごとに計測中のストップウォッチの経過時間を更新
        for (final sw in ref.read(stopwatchProvider)) {
          if (sw.isRunning) {
            stopwatchNotifier.incrementElapsedTime(sw.id);
          }
        }
      });
    }
  } else {
    // 計測中のストップウォッチがない場合、タイマーを停止
    if (timerService.isRunning) {
      timerService.stop();
    }
  }
});
