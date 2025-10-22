/// ストップウォッチカードウィジェット
///
/// 個々のストップウォッチを表示するカード型UI
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/stopwatch_model.dart";
import "../../providers/stopwatch_provider.dart";
import "../../utils/constants.dart";
import "../../utils/snackbar_helper.dart";
import "time_display.dart";

/// ストップウォッチカード
///
/// [stopwatch] ストップウォッチのモデル
class StopwatchCard extends ConsumerStatefulWidget {
  /// ストップウォッチのモデル
  final StopwatchModel stopwatch;

  const StopwatchCard({
    super.key,
    required this.stopwatch,
  });

  @override
  ConsumerState<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends ConsumerState<StopwatchCard> {
  late TextEditingController _nameController;
  bool _isEditing = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.stopwatch.name);
  }

  @override
  void didUpdateWidget(StopwatchCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ストップウォッチが変更された場合、名称コントローラーを更新
    if (oldWidget.stopwatch.name != widget.stopwatch.name && !_isEditing) {
      _nameController.text = widget.stopwatch.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // すべてのストップウォッチを取得してインデックスを計算
    final stopwatches = ref.watch(stopwatchProvider);
    final index = stopwatches.indexWhere((sw) => sw.id == widget.stopwatch.id);

    // エージェントカラーを取得
    final agentColor = Color(agentColors[index % agentColors.length]);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: _isHovered ? 8 : 2,
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
                    // 名称入力欄と削除ボタン
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "ストップウォッチ ${index + 1}",
                              border: const OutlineInputBorder(),
                              isDense: true,
                            ),
                            style: const TextStyle(fontSize: 16),
                            maxLength: 50,
                            onChanged: (_) {
                              _isEditing = true;
                            },
                            onSubmitted: _updateName,
                            onEditingComplete: () {
                              _updateName(_nameController.text);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 削除ボタン
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: _deleteStopwatch,
                          tooltip: "削除",
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 時間表示
                    Center(
                      child: TimeDisplay(elapsedSeconds: widget.stopwatch.elapsedSeconds),
                    ),
                    const SizedBox(height: 16),
                    // 操作ボタン
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 開始/一時停止ボタン（一体化）
                        _AnimatedButton(
                          icon: widget.stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                          onPressed: widget.stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                          tooltip: widget.stopwatch.isRunning ? "計測を一時停止" : "計測を開始",
                          color: widget.stopwatch.isRunning ? Colors.orange : Colors.green,
                          isEnabled: true,
                        ),
                        // リセットボタン
                        _AnimatedButton(
                          icon: Icons.refresh,
                          onPressed: _resetStopwatch,
                          tooltip: "計測時間をリセット",
                          color: Colors.blue,
                          isEnabled: true,
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
        ),
      ),
    );
  }

  /// 名称を更新する
  Future<void> _updateName(String newName) async {
    _isEditing = false;
    final trimmedName = newName.trim();
    if (trimmedName != widget.stopwatch.name) {
      try {
        await ref.read(stopwatchProvider.notifier).updateName(
              widget.stopwatch.id,
              trimmedName,
            );
      } catch (e) {
        if (mounted) {
          showErrorSnackBar(context, "名称の更新に失敗しました: $e");
        }
      }
    }
  }

  /// ストップウォッチを開始する
  Future<void> _startStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).startStopwatch(widget.stopwatch.id);
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, "開始に失敗しました: $e");
      }
    }
  }

  /// ストップウォッチを停止する
  Future<void> _stopStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).stopStopwatch(widget.stopwatch.id);
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, "停止に失敗しました: $e");
      }
    }
  }

  /// ストップウォッチをリセットする
  Future<void> _resetStopwatch() async {
    // 経過時間が0秒より大きい場合のみ確認ダイアログを表示
    if (widget.stopwatch.elapsedSeconds > 0) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("リセット確認"),
          content: const Text("計測時間をリセットしますか？この操作は取り消せません。"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("キャンセル"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                "リセット",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    try {
      await ref.read(stopwatchProvider.notifier).resetStopwatch(widget.stopwatch.id);
      if (mounted) {
        showSuccessSnackBar(context, "計測時間をリセットしました");
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, "リセットに失敗しました: $e");
      }
    }
  }

  /// ストップウォッチを削除する
  Future<void> _deleteStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).removeStopwatch(widget.stopwatch.id);
      if (mounted) {
        showSuccessSnackBar(context, "ストップウォッチを削除しました");
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, e.toString().replaceFirst("Exception: ", ""));
      }
    }
  }
}

/// アニメーション付きボタンウィジェット
///
/// ホバー時にスケールアニメーションを適用するアイコンボタン
class _AnimatedButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final Color color;
  final bool isEnabled;

  const _AnimatedButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.color,
    required this.isEnabled,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered && widget.isEnabled ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Tooltip(
          message: widget.tooltip,
          waitDuration: const Duration(milliseconds: 500),
          child: IconButton(
            icon: Icon(widget.icon),
            onPressed: widget.onPressed,
            color: widget.color,
            iconSize: 28,
          ),
        ),
      ),
    );
  }
}
