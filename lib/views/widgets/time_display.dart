/// 経過時間を表示するウィジェット
///
/// HH:MM形式と0.25単位の2つの表示形式で時間を表示する
library;

import "package:flutter/material.dart";
import "../../utils/time_formatter.dart";

/// 経過時間表示ウィジェット
///
/// [elapsedSeconds] 表示する経過秒数
class TimeDisplay extends StatelessWidget {
  /// 表示する経過秒数
  final int elapsedSeconds;

  const TimeDisplay({
    super.key,
    required this.elapsedSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // HH:MM形式の表示
        Text(
          formatToHHMM(elapsedSeconds),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        // 0.25単位の表示
        Text(
          "${formatToQuarterHour(elapsedSeconds).toStringAsFixed(2)}h",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
