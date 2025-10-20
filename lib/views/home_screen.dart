/// メイン画面
///
/// ストップウォッチ一覧を表示し、追加・設定などの操作を提供する
library;

import "package:flutter/material.dart";
import "widgets/stopwatch_card.dart";

/// ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Phase 3でProviderから取得
    // 現時点ではダミーデータを使用
    final dummyStopwatches = [
      {"index": 0, "name": "ストップウォッチ 1", "elapsedSeconds": 3665}, // 1時間1分5秒
      {"index": 1, "name": "ストップウォッチ 2", "elapsedSeconds": 5430}, // 1時間30分30秒
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Stopwatch"),
        actions: [
          // 追加ボタン
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Phase 3で実装
              debugPrint("追加ボタンが押されました");
            },
            tooltip: "ストップウォッチを追加",
          ),
          // 設定ボタン
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Phase 5で実装
              debugPrint("設定ボタンが押されました");
            },
            tooltip: "設定",
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyStopwatches.length,
        itemBuilder: (context, index) {
          final stopwatch = dummyStopwatches[index];
          return StopwatchCard(
            index: stopwatch["index"] as int,
            name: stopwatch["name"] as String,
            elapsedSeconds: stopwatch["elapsedSeconds"] as int,
          );
        },
      ),
    );
  }
}
