/// Multi Stopwatch アプリケーションのエントリーポイント
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:window_manager/window_manager.dart";
import "models/auto_stop_time.dart";
import "models/stopwatch_model.dart";
import "repositories/settings_repository.dart";
import "views/home_screen.dart";

void main() async {
  // Flutterバインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // window_managerの初期化
  await windowManager.ensureInitialized();

  // Hiveの初期化
  await Hive.initFlutter();

  // Hiveアダプタの登録
  Hive.registerAdapter(StopwatchModelAdapter());
  Hive.registerAdapter(AutoStopTimeAdapter());

  // 設定の読み込みとウィンドウサイズの復元
  final settingsRepository = SettingsRepository();
  await settingsRepository.init();
  final settings = await settingsRepository.loadSettings();

  // ウィンドウの最小サイズを設定
  await windowManager.setMinimumSize(const Size(800, 600));

  // 保存済みサイズを復元（デフォルトは1200x800）
  final windowWidth = settings.windowWidth;
  final windowHeight = settings.windowHeight;
  await windowManager.setSize(Size(windowWidth, windowHeight));

  // ウィンドウを表示
  await windowManager.show();

  // Riverpodを使用するためProviderScopeでラップ
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// アプリケーションのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Multi Stopwatch",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
