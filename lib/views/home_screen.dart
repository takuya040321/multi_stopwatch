/// メイン画面
///
/// ストップウォッチ一覧を表示し、追加・設定などの操作を提供する
library;

import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:window_manager/window_manager.dart";
import "../providers/stopwatch_provider.dart";
import "../providers/timer_provider.dart";
import "../providers/settings_provider.dart";
import "widgets/stopwatch_card.dart";
import "settings_screen.dart";

/// ホーム画面
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with WidgetsBindingObserver, WindowListener {
  bool _isInitialized = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // アプリライフサイクルの監視を開始
    WidgetsBinding.instance.addObserver(this);
    // ウィンドウリサイズの監視を開始
    windowManager.addListener(this);
    _initializeApp();
  }

  @override
  void dispose() {
    // アプリライフサイクルの監視を停止
    WidgetsBinding.instance.removeObserver(this);
    // ウィンドウリサイズの監視を停止
    windowManager.removeListener(this);
    // デバウンスタイマーをキャンセル
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void onWindowResize() {
    super.onWindowResize();
    // デバウンス処理: 500ms後にウィンドウサイズを保存
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _saveWindowSize();
    });
  }

  /// ウィンドウサイズを保存する
  ///
  /// リサイズイベント発生時にデバウンス処理を経て呼び出される
  Future<void> _saveWindowSize() async {
    try {
      final size = await windowManager.getSize();
      final width = size.width;
      final height = size.height;

      await ref.read(settingsProvider.notifier).updateWindowSize(width, height);
      debugPrint("ウィンドウサイズを保存しました: ${width}x$height");
    } catch (e) {
      debugPrint("ウィンドウサイズ保存エラー: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // アプリがバックグラウンドに移行する際に現在の状態を保存
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveCurrentState();
    }
  }

  /// 現在のストップウォッチ状態を保存する
  ///
  /// アプリがバックグラウンドに移行する際に呼び出される
  Future<void> _saveCurrentState() async {
    try {
      final repository = ref.read(stopwatchRepositoryProvider);
      final stopwatches = ref.read(stopwatchProvider);
      await repository.saveStopwatches(stopwatches);
      debugPrint("アプリ終了時の状態を保存しました");
    } catch (e) {
      debugPrint("アプリ終了時の保存エラー: $e");
    }
  }

  /// アプリケーションの初期化
  ///
  /// リポジトリの初期化とストップウォッチデータの読み込みを行う
  Future<void> _initializeApp() async {
    try {
      // ストップウォッチリポジトリの初期化
      await ref.read(initializeRepositoryProvider.future);

      // 設定リポジトリの初期化
      await ref.read(initializeSettingsRepositoryProvider.future);

      // ストップウォッチデータの読み込み
      await ref.read(stopwatchProvider.notifier).loadStopwatches();

      // 設定データの読み込み
      await ref.read(settingsProvider.notifier).loadSettings();

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

    // 設定を取得（レイアウトモードの判定に使用）
    final settings = ref.watch(settingsProvider);
    final layoutMode = settings.layoutMode;

    // ウィンドウ幅を取得してグリッドの列数を計算
    final screenWidth = MediaQuery.of(context).size.width;
    // 最小400pxで1列、以降400pxごとに1列追加（最大10列）
    final crossAxisCount = (screenWidth / 400).floor().clamp(1, 10);

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            tooltip: "設定",
          ),
        ],
      ),
      body: stopwatches.isEmpty
          ? const Center(
              child: Text("ストップウォッチがありません"),
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: layoutMode == "GRID"
                  ? GridView.builder(
                      key: const ValueKey("grid"),
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5, // カードの縦横比
                      ),
                      itemCount: stopwatches.length,
                      itemBuilder: (context, index) {
                        final stopwatch = stopwatches[index];
                        return StopwatchCard(
                          key: ValueKey(stopwatch.id),
                          stopwatch: stopwatch,
                        );
                      },
                    )
                  : ListView.builder(
                      key: const ValueKey("list"),
                      itemCount: stopwatches.length,
                      itemBuilder: (context, index) {
                        final stopwatch = stopwatches[index];
                        return StopwatchCard(
                          key: ValueKey(stopwatch.id),
                          stopwatch: stopwatch,
                        );
                      },
                    ),
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
