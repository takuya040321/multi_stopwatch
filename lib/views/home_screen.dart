/// メイン画面
///
/// ストップウォッチ一覧を表示し、追加・設定などの操作を提供する
library;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../providers/stopwatch_provider.dart";
import "../providers/timer_provider.dart";
import "widgets/stopwatch_card.dart";

/// ホーム画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// アプリケーションの初期化
  ///
  /// リポジトリの初期化とストップウォッチデータの読み込みを行う
  Future<void> _initializeApp() async {
    try {
      // リポジトリの初期化
      await ref.read(initializeRepositoryProvider.future);

      // ストップウォッチデータの読み込み
      await ref.read(stopwatchProvider.notifier).loadStopwatches();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("初期化エラー: $e");
      // エラーが発生しても初期化済みとして扱う
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // タイマー制御を監視（タイマーの自動起動/停止のため）
    ref.watch(timerControllerProvider);

    // 初期化中はローディング表示
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // ストップウォッチリストを取得
    final stopwatches = ref.watch(stopwatchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Multi Stopwatch"),
        actions: [
          // 追加ボタン
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addStopwatch,
            tooltip: "ストップウォッチを追加",
          ),
          // 設定ボタン
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Phase 6で設定画面に遷移
              debugPrint("設定ボタンが押されました");
            },
            tooltip: "設定",
          ),
        ],
      ),
      body: stopwatches.isEmpty
          ? const Center(
              child: Text("ストップウォッチがありません"),
            )
          : ListView.builder(
              itemCount: stopwatches.length,
              itemBuilder: (context, index) {
                final stopwatch = stopwatches[index];
                return StopwatchCard(
                  key: ValueKey(stopwatch.id),
                  stopwatch: stopwatch,
                );
              },
            ),
    );
  }

  /// ストップウォッチを追加する
  Future<void> _addStopwatch() async {
    try {
      await ref.read(stopwatchProvider.notifier).addStopwatch();
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
