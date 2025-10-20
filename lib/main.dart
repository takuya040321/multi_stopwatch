/// Multi Stopwatch アプリケーションのエントリーポイント
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:hive_flutter/hive_flutter.dart";
import "models/stopwatch_model.dart";
import "views/home_screen.dart";

void main() async {
  // Flutterバインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // Hiveの初期化
  await Hive.initFlutter();

  // StopwatchModelアダプタの登録
  Hive.registerAdapter(StopwatchModelAdapter());

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
