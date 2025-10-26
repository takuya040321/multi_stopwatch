/// コンパクトストップウォッチカード - パターンA (ミニマルカード型)
///
/// 最小限の情報で構成されたコンパクトなカード
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/stopwatch_model.dart";
import "../../providers/stopwatch_provider.dart";
import "../../utils/constants.dart";
import "../../utils/snackbar_helper.dart";
import "time_display.dart";

/// コンパクトストップウォッチカード - パターンA
class StopwatchCardCompactA extends ConsumerWidget {
  final StopwatchModel stopwatch;

  const StopwatchCardCompactA({
    super.key,
    required this.stopwatch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatches = ref.watch(stopwatchProvider);
    final index = stopwatches.indexWhere((sw) => sw.id == stopwatch.id);
    final agentColor = Color(agentColors[index % agentColors.length]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            agentColor.withValues(alpha: 0.1),
            agentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: agentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // 左側: 名前と時間表示
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 名前
                  Text(
                    stopwatch.name.isEmpty ? "ストップウォッチ ${index + 1}" : stopwatch.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: agentColor.withValues(alpha: 0.9),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // 時間表示
                  TimeDisplay(elapsedSeconds: stopwatch.elapsedSeconds),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 右側: ボタン
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 開始/一時停止ボタン
                _CompactIconButton(
                  icon: stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                  onPressed: () => stopwatch.isRunning
                      ? _stopStopwatch(ref, context)
                      : _startStopwatch(ref, context),
                  color: stopwatch.isRunning ? Colors.orange : Colors.green,
                  size: 32,
                ),
                const SizedBox(width: 4),
                // リセットボタン
                _CompactIconButton(
                  icon: Icons.refresh,
                  onPressed: () => _resetStopwatch(ref, context),
                  color: Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 4),
                // 削除ボタン
                _CompactIconButton(
                  icon: Icons.close,
                  onPressed: () => _deleteStopwatch(ref, context),
                  color: Colors.red,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startStopwatch(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(stopwatchProvider.notifier).startStopwatch(stopwatch.id);
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "開始に失敗しました");
      }
    }
  }

  Future<void> _stopStopwatch(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(stopwatchProvider.notifier).stopStopwatch(stopwatch.id);
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "停止に失敗しました");
      }
    }
  }

  Future<void> _resetStopwatch(WidgetRef ref, BuildContext context) async {
    if (stopwatch.elapsedSeconds > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("リセット確認"),
          content: const Text("計測時間をリセットしますか？"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("リセット", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    try {
      await ref.read(stopwatchProvider.notifier).resetStopwatch(stopwatch.id);
      if (context.mounted) {
        showSuccessSnackBar(context, "リセットしました");
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, "リセットに失敗しました");
      }
    }
  }

  Future<void> _deleteStopwatch(WidgetRef ref, BuildContext context) async {
    try {
      await ref.read(stopwatchProvider.notifier).removeStopwatch(stopwatch.id);
      if (context.mounted) {
        showSuccessSnackBar(context, "削除しました");
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(context, e.toString().replaceFirst("Exception: ", ""));
      }
    }
  }
}

/// コンパクトアイコンボタン
class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const _CompactIconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: color,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}
