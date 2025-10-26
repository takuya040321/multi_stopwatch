import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../providers/settings_provider.dart";
import "widgets/auto_stop_duration_picker_a.dart";
import "widgets/auto_stop_duration_picker_b.dart";
import "widgets/auto_stop_duration_picker_c.dart";

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

          // 時間表示セクション
          _buildSectionTitle("時間表示"),
          SwitchListTile(
            title: const Text("秒数を表示"),
            subtitle: const Text("ONの場合、時間を HH:MM:SS 形式で表示します"),
            value: settings.showSeconds,
            onChanged: (value) => _toggleShowSeconds(context, ref, value),
          ),
          const Divider(),

          // UIスタイルセクション
          _buildSectionTitle("UIスタイル"),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンA: ミニマルカード"),
            subtitle: const Text("グラデーションカードの最小限デザイン"),
            value: "COMPACT_A",
            // ignore: deprecated_member_use
            groupValue: settings.uiStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _toggleUiStyle(context, ref, value!),
          ),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンB: フラットリスト"),
            subtitle: const Text("1行に全情報を配置したフラットデザイン"),
            value: "COMPACT_B",
            // ignore: deprecated_member_use
            groupValue: settings.uiStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _toggleUiStyle(context, ref, value!),
          ),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンC: グラスモーフィズム"),
            subtitle: const Text("半透明の背景とぼかし効果のモダンデザイン"),
            value: "COMPACT_C",
            // ignore: deprecated_member_use
            groupValue: settings.uiStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _toggleUiStyle(context, ref, value!),
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
          const Divider(),

          // 自動停止時間ピッカースタイルセクション
          _buildSectionTitle("自動停止時間設定スタイル"),
          _buildNote("経過時間で自動停止する時間の設定方法を選択できます"),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンA: ドロップダウン式"),
            subtitle: const Text("プリセット時間とカスタム設定を組み合わせたシンプルなUI"),
            value: "PICKER_A",
            // ignore: deprecated_member_use
            groupValue: settings.autoStopPickerStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _togglePickerStyle(context, ref, value!),
          ),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンB: 数値入力式"),
            subtitle: const Text("時間・分を直接入力できる柔軟なタイマー式UI"),
            value: "PICKER_B",
            // ignore: deprecated_member_use
            groupValue: settings.autoStopPickerStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _togglePickerStyle(context, ref, value!),
          ),
          // ignore: deprecated_member_use
          RadioListTile<String>(
            title: const Text("パターンC: スライダー式"),
            subtitle: const Text("スライダーで視覚的に時間を設定するモダンなUI"),
            value: "PICKER_C",
            // ignore: deprecated_member_use
            groupValue: settings.autoStopPickerStyle,
            // ignore: deprecated_member_use
            onChanged: (value) => _togglePickerStyle(context, ref, value!),
          ),
          const Divider(),

          // 自動停止時間設定デモ
          _buildSectionTitle("設定デモ"),
          _buildNote("選択したスタイルのピッカーを試すことができます"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _buildDurationPicker(settings.autoStopPickerStyle),
          ),
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

  /// 秒数表示を切り替える
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [showSeconds] 秒数を表示するかどうか
  Future<void> _toggleShowSeconds(
    BuildContext context,
    WidgetRef ref,
    bool showSeconds,
  ) async {
    try {
      await ref.read(settingsProvider.notifier).toggleShowSeconds(showSeconds);
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

  /// UIスタイルを切り替える
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [uiStyle] UIスタイル ("COMPACT_A", "COMPACT_B", "COMPACT_C")
  Future<void> _toggleUiStyle(
    BuildContext context,
    WidgetRef ref,
    String uiStyle,
  ) async {
    try {
      await ref.read(settingsProvider.notifier).toggleUiStyle(uiStyle);
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

  /// ピッカースタイルを切り替える
  ///
  /// [context] BuildContext
  /// [ref] WidgetRef
  /// [pickerStyle] ピッカースタイル (\"PICKER_A\", \"PICKER_B\", \"PICKER_C\")
  Future<void> _togglePickerStyle(
    BuildContext context,
    WidgetRef ref,
    String pickerStyle,
  ) async {
    try {
      await ref.read(settingsProvider.notifier).toggleAutoStopPickerStyle(pickerStyle);
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

  /// 選択されたスタイルのピッカーを構築する
  ///
  /// [pickerStyle] ピッカースタイル
  Widget _buildDurationPicker(String pickerStyle) {
    switch (pickerStyle) {
      case "PICKER_A":
        return AutoStopDurationPickerA(
          initialSeconds: 1800, // デフォルト30分
          onChanged: (seconds) {
            debugPrint("選択された時間: $seconds秒");
          },
        );
      case "PICKER_B":
        return AutoStopDurationPickerB(
          initialSeconds: 1800, // デフォルト30分
          onChanged: (seconds) {
            debugPrint("選択された時間: $seconds秒");
          },
        );
      case "PICKER_C":
        return AutoStopDurationPickerC(
          initialSeconds: 1800, // デフォルト30分
          onChanged: (seconds) {
            debugPrint("選択された時間: $seconds秒");
          },
        );
      default:
        return AutoStopDurationPickerA(
          initialSeconds: 1800,
          onChanged: (seconds) {
            debugPrint("選択された時間: $seconds秒");
          },
        );
    }
  }
}
