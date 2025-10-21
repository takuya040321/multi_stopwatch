import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../providers/settings_provider.dart";

/// 設定画面
///
/// 計測モード、レイアウトなどのアプリケーション設定を管理する画面
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(
        children: [
          // 計測モードセクション
          _buildSectionTitle("計測モード"),
          SwitchListTile(
            title: const Text("単一計測モード"),
            subtitle: const Text("ONの場合、他のストップウォッチを自動停止します"),
            value: settings.isSingleMeasurementMode,
            onChanged: (value) => _toggleMeasurementMode(context, ref, value),
          ),
          const Divider(),

          // レイアウトセクション
          _buildSectionTitle("レイアウト"),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("縦スクロールリスト"),
            value: "LIST",
            // ignore: deprecated_member_use
            groupValue: settings.layoutMode,
            // ignore: deprecated_member_use
            onChanged: (value) => _toggleLayoutMode(context, ref, value!),
          ),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("グリッド"),
            value: "GRID",
            // ignore: deprecated_member_use
            groupValue: settings.layoutMode,
            // ignore: deprecated_member_use
            onChanged: (value) => _toggleLayoutMode(context, ref, value!),
          ),
          _buildNote("※グリッドレイアウトは次のPhaseで実装予定です"),
        ],
      ),
    );
  }

  /// セクションタイトルを構築する
  ///
  /// [title] セクションのタイトル文字列
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 注意書きテキストを構築する
  ///
  /// [text] 注意書きの文字列
  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 計測モードを切り替える
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [isSingleMode] 単一計測モードかどうか
  Future<void> _toggleMeasurementMode(
    BuildContext context,
    WidgetRef ref,
    bool isSingleMode,
  ) async {
    try {
      await ref.read(settingsProvider.notifier).toggleMeasurementMode(isSingleMode);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// レイアウトモードを切り替える
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [layoutMode] レイアウトモード ("LIST" または "GRID")
  Future<void> _toggleLayoutMode(
    BuildContext context,
    WidgetRef ref,
    String layoutMode,
  ) async {
    try {
      await ref.read(settingsProvider.notifier).toggleLayoutMode(layoutMode);
    } catch (e) {
      if (context.mounted) {
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
