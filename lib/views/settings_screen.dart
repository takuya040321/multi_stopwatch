import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:uuid/uuid.dart";
import "../models/auto_stop_time.dart";
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

          // 時間表示セクション
          _buildSectionTitle("時間表示"),
          SwitchListTile(
            title: const Text("秒数を表示"),
            subtitle: const Text("ONの場合、時間を HH:MM:SS 形式で表示します"),
            value: settings.showSeconds,
            onChanged: (value) => _toggleShowSeconds(context, ref, value),
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

          // 自動停止時刻セクション
          _buildSectionTitle("自動停止時刻"),
          _buildNote("設定した時刻になると、計測中のストップウォッチをすべて自動停止します（最大5個）"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 自動停止時刻リスト
                ...settings.autoStopTimes.map((autoStopTime) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        "${autoStopTime.hour.toString().padLeft(2, "0")}:${autoStopTime.minute.toString().padLeft(2, "0")}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 有効/無効スイッチ
                          Switch(
                            value: autoStopTime.isEnabled,
                            onChanged: (value) {
                              ref.read(settingsProvider.notifier).updateAutoStopTime(
                                    id: autoStopTime.id,
                                    isEnabled: value,
                                  );
                            },
                          ),
                          // 削除ボタン
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(settingsProvider.notifier).removeAutoStopTime(autoStopTime.id);
                            },
                            tooltip: "削除",
                          ),
                        ],
                      ),
                      onTap: () async {
                        // タップで編集
                        await _editAutoStopTime(context, ref, autoStopTime);
                      },
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // 追加ボタン
                if (settings.autoStopTimes.length < 5)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _addAutoStopTime(context, ref);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("自動停止時刻を追加"),
                    ),
                  ),
                if (settings.autoStopTimes.length >= 5)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "最大5個まで追加できます",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
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
}

/// 自動停止時刻を追加する
///
/// [context] BuildContext
/// [ref] WidgetRef
Future<void> _addAutoStopTime(BuildContext context, WidgetRef ref) async {
  final now = DateTime.now();

  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (pickedTime == null) return;

  try {
    final autoStopTime = AutoStopTime(
      id: const Uuid().v4(),
      hour: pickedTime.hour,
      minute: pickedTime.minute,
      isEnabled: true,
    );

    await ref.read(settingsProvider.notifier).addAutoStopTime(autoStopTime);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("自動停止時刻を追加しました"),
          backgroundColor: Colors.green,
        ),
      );
    }
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

/// 自動停止時刻を編集する
///
/// [context] BuildContext
/// [ref] WidgetRef
/// [autoStopTime] 編集対象の自動停止時刻
Future<void> _editAutoStopTime(
  BuildContext context,
  WidgetRef ref,
  AutoStopTime autoStopTime,
) async {
  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: autoStopTime.hour, minute: autoStopTime.minute),
    builder: (context, child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
  );

  if (pickedTime == null) return;

  try {
    await ref.read(settingsProvider.notifier).updateAutoStopTime(
          id: autoStopTime.id,
          hour: pickedTime.hour,
          minute: pickedTime.minute,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("自動停止時刻を更新しました"),
          backgroundColor: Colors.green,
        ),
      );
    }
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
