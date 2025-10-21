import "package:flutter_riverpod/flutter_riverpod.dart";
import "../services/auto_stop_service.dart";

/// AutoStopServiceのプロバイダー
///
/// アプリケーション全体でAutoStopServiceのインスタンスを共有する
final autoStopServiceProvider = Provider<AutoStopService>((ref) {
  final service = AutoStopService(ref);

  // アプリ起動時にサービスを開始
  service.start();

  // プロバイダーが破棄される際にサービスも破棄
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// AutoStopServiceの初期化を行うプロバイダー
///
/// アプリ起動時に呼び出され、サービスを起動する
final initializeAutoStopServiceProvider = Provider<void>((ref) {
  // autoStopServiceProviderを読み込むことでサービスを起動
  ref.watch(autoStopServiceProvider);
});
