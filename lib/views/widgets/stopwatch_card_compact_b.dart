/// コンパクトストップウォッチカード - パターンB (フラットリスト型)
///
/// 1行に全情報を配置したフラットなデザイン
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/stopwatch_model.dart";
import "../../providers/stopwatch_provider.dart";
import "../../utils/constants.dart";
import "../../utils/snackbar_helper.dart";
import "../../utils/time_formatter.dart";
import "../../providers/settings_provider.dart";

/// コンパクトストップウォッチカード - パターンB
class StopwatchCardCompactB extends ConsumerWidget {
  final StopwatchModel stopwatch;

  const StopwatchCardCompactB({
    super.key,
    required this.stopwatch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stopwatches = ref.watch(stopwatchProvider);
    final index = stopwatches.indexWhere((sw) => sw.id == stopwatch.id);
    final agentColor = Color(agentColors[index % agentColors.length]);
    final showSeconds = ref.watch(settingsProvider.select((s) => s.showSeconds));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: stopwatch.isRunning
            ? agentColor.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: agentColor,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // インデックス表示
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: agentColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // 名前
            Expanded(
              flex: 2,
              child: Text(
                stopwatch.name.isEmpty ? "ストップウォッチ ${index + 1}" : stopwatch.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // 時間表示
            Expanded(
              flex: 1,
              child: Text(
                showSeconds
                    ? formatToHHMMSS(stopwatch.elapsedSeconds)
                    : formatToHHMM(stopwatch.elapsedSeconds),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: stopwatch.isRunning ? agentColor : Colors.black87,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 12),
            // ボタン群
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FlatButton(
                  icon: stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                  onPressed: () => stopwatch.isRunning
                      ? _stopStopwatch(ref, context)
                      : _startStopwatch(ref, context),
                  color: stopwatch.isRunning ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 4),
                _FlatButton(
                  icon: Icons.refresh,
                  onPressed: () => _resetStopwatch(ref, context),
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                _FlatButton(
                  icon: Icons.close,
                  onPressed: () => _deleteStopwatch(ref, context),
                  color: Colors.red,
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

/// フラットボタン
class _FlatButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _FlatButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
      ),
    );
  }
}
