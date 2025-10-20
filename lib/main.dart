/// Multi Stopwatch アプリケーションのエントリーポイント
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "views/home_screen.dart";

void main() {
  runApp(
    // Riverpodを使用するためProviderScopeでラップ
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
