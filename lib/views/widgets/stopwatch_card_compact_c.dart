/// コンパクトストップウォッチカード - パターンC (グラスモーフィズム型)
///
/// 半透明の背景とぼかし効果を使用したモダンなデザイン
library;

import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/stopwatch_model.dart";
import "../../providers/stopwatch_provider.dart";
import "../../utils/constants.dart";
import "../../utils/snackbar_helper.dart";
import "../../utils/time_formatter.dart";
import "../../providers/settings_provider.dart";

/// コンパクトストップウォッチカード - パターンC
class StopwatchCardCompactC extends ConsumerWidget {
  final StopwatchModel stopwatch;

  const StopwatchCardCompactC({
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  agentColor.withValues(alpha: 0.2),
                  agentColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ヘッダー行
                  Row(
                    children: [
                      // インデックスバッジ
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: agentColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "#${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 名前
                      Expanded(
                        child: Text(
                          stopwatch.name.isEmpty ? "ストップウォッチ ${index + 1}" : stopwatch.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // ステータスインジケーター
                      if (stopwatch.isRunning)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 時間表示とボタン
                  Row(
                    children: [
                      // 時間表示
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            showSeconds
                                ? formatToHHMMSS(stopwatch.elapsedSeconds)
                                : formatToHHMM(stopwatch.elapsedSeconds),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: stopwatch.isRunning ? agentColor : Colors.black87,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ボタン群
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _GlassButton(
                                icon: stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                                onPressed: () => stopwatch.isRunning
                                    ? _stopStopwatch(ref, context)
                                    : _startStopwatch(ref, context),
                                color: stopwatch.isRunning ? Colors.orange : Colors.green,
                                size: 36,
                              ),
                              const SizedBox(width: 4),
                              _GlassButton(
                                icon: Icons.refresh,
                                onPressed: () => _resetStopwatch(ref, context),
                                color: Colors.blue,
                                size: 32,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _GlassButton(
                            icon: Icons.delete_outline,
                            onPressed: () => _deleteStopwatch(ref, context),
                            color: Colors.red,
                            size: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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

/// グラスモーフィズムボタン
class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;

  const _GlassButton({
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: size * 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
