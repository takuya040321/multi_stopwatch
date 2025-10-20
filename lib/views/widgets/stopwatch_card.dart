/// ストップウォッチカードウィジェット
///
/// 個々のストップウォッチを表示するカード型UI
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../models/stopwatch_model.dart";
import "../../providers/stopwatch_provider.dart";
import "../../utils/constants.dart";
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
                        // 開始ボタン
                        IconButton(
                          icon: const Icon(Icons.play_arrow),
                          onPressed: widget.stopwatch.isRunning ? null : _startStopwatch,
                          tooltip: "開始",
                          color: widget.stopwatch.isRunning ? Colors.grey : Colors.green,
                        ),
                        // 停止ボタン
                        IconButton(
                          icon: const Icon(Icons.pause),
                          onPressed: widget.stopwatch.isRunning ? _stopStopwatch : null,
                          tooltip: "停止",
                          color: widget.stopwatch.isRunning ? Colors.orange : Colors.grey,
                        ),
                        // リセットボタン
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _resetStopwatch,
                          tooltip: "リセット",
                          color: Colors.blue,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("名称の更新に失敗しました: $e"),
              backgroundColor: Colors.red,
            ),
          );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("開始に失敗しました: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ストップウォッチを停止する
  Future<void> _stopStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).stopStopwatch(widget.stopwatch.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("停止に失敗しました: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ストップウォッチをリセットする
  Future<void> _resetStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).resetStopwatch(widget.stopwatch.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("リセットに失敗しました: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// ストップウォッチを削除する
  Future<void> _deleteStopwatch() async {
    // 確認ダイアログを表示
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("削除確認"),
        content: Text("${widget.stopwatch.name}を削除しますか？"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("キャンセル"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("削除"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(stopwatchProvider.notifier).removeStopwatch(widget.stopwatch.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceFirst("Exception: ", "")),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
