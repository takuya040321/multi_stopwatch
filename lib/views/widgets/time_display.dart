/// 経過時間を表示するウィジェット
///
/// HH:MM形式またはHH:MM:SS形式と0.25単位の2つの表示形式で時間を表示する
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../utils/time_formatter.dart";
import "../../providers/settings_provider.dart";

/// 経過時間表示ウィジェット
///
/// [elapsedSeconds] 表示する経過秒数
class TimeDisplay extends ConsumerWidget {
  /// 表示する経過秒数
  final int elapsedSeconds;

  const TimeDisplay({
    super.key,
    required this.elapsedSeconds,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 設定から秒数表示の有効/無効を取得
    final showSeconds = ref.watch(settingsProvider.select((s) => s.showSeconds));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // HH:MM形式またはHH:MM:SS形式の表示
        Text(
          showSeconds ? formatToHHMMSS(elapsedSeconds) : formatToHHMM(elapsedSeconds),
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
