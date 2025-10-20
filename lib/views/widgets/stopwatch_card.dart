/// ストップウォッチカードウィジェット
///
/// 個々のストップウォッチを表示するカード型UI
library;

import "package:flutter/material.dart";
import "../../utils/constants.dart";
import "time_display.dart";

/// ストップウォッチカード
///
/// [index] ストップウォッチのインデックス（エージェントカラー判定に使用）
/// [name] ストップウォッチの名称
/// [elapsedSeconds] 経過秒数
class StopwatchCard extends StatelessWidget {
  /// ストップウォッチのインデックス
  final int index;

  /// ストップウォッチの名称
  final String name;

  /// 経過秒数
  final int elapsedSeconds;

  const StopwatchCard({
    super.key,
    required this.index,
    required this.name,
    required this.elapsedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    // エージェントカラーを取得
    final agentColor = Color(agentColors[index % agentColors.length]);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 左端のエージェントカラー縦線
            Container(
              width: 4,
              color: agentColor,
            ),
            // カード本体
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名称入力欄
                    TextField(
                      decoration: InputDecoration(
                        hintText: name,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    // 時間表示
                    Center(
                      child: TimeDisplay(elapsedSeconds: elapsedSeconds),
                    ),
                    const SizedBox(height: 16),
                    // 操作ボタン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 開始ボタン
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            // TODO: Phase 3で実装
                            debugPrint("開始ボタンが押されました: $name");
                          },
                          tooltip: "開始",
                        ),
                        // 停止ボタン
                        IconButton(
                          icon: const Icon(Icons.pause),
                          onPressed: () {
                            // TODO: Phase 3で実装
                            debugPrint("停止ボタンが押されました: $name");
                          },
                          tooltip: "停止",
                        ),
                        // リセットボタン
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            // TODO: Phase 3で実装
                            debugPrint("リセットボタンが押されました: $name");
                          },
                          tooltip: "リセット",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
