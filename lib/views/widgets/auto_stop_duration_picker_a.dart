/// 自動停止時間設定ピッカー - パターンA（ドロップダウン式）
///
/// プリセット時間とカスタム設定を組み合わせたシンプルな設定UI
library;

import "package:flutter/material.dart";

/// 自動停止時間設定ピッカー - パターンA
class AutoStopDurationPickerA extends StatefulWidget {
  /// 初期の秒数
  final int initialSeconds;

  /// 秒数が変更された時のコールバック
  final ValueChanged<int> onChanged;

  const AutoStopDurationPickerA({
    super.key,
    required this.initialSeconds,
    required this.onChanged,
  });

  @override
  State<AutoStopDurationPickerA> createState() => _AutoStopDurationPickerAState();
}

class _AutoStopDurationPickerAState extends State<AutoStopDurationPickerA> {
  late int _selectedSeconds;
  late bool _isCustom;
  late int _customHours;
  late int _customMinutes;

  // プリセット時間（秒）
  static const List<int> _presets = [
    300,    // 5分
    600,    // 10分
    900,    // 15分
    1800,   // 30分
    3600,   // 1時間
    7200,   // 2時間
    10800,  // 3時間
    14400,  // 4時間
    18000,  // 5時間
    -1,     // カスタム
  ];

  @override
  void initState() {
    super.initState();
    _selectedSeconds = widget.initialSeconds;
    _isCustom = !_presets.contains(_selectedSeconds);

    if (_isCustom) {
      _customHours = _selectedSeconds ~/ 3600;
      _customMinutes = (_selectedSeconds % 3600) ~/ 60;
    } else {
      _customHours = 0;
      _customMinutes = 30;
    }
  }

  String _formatPreset(int seconds) {
    if (seconds == -1) return "カスタム";

    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return "$hours時間$minutes分";
    } else if (hours > 0) {
      return "$hours時間";
    } else {
      return "$minutes分";
    }
  }

  void _updateSeconds() {
    int newSeconds;
    if (_isCustom) {
      newSeconds = _customHours * 3600 + _customMinutes * 60;
    } else {
      newSeconds = _selectedSeconds;
    }
    widget.onChanged(newSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // プリセット選択
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _isCustom ? -1 : _selectedSeconds,
              items: _presets.map((seconds) {
                return DropdownMenuItem<int>(
                  value: seconds,
                  child: Text(_formatPreset(seconds)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  if (value == -1) {
                    _isCustom = true;
                    _selectedSeconds = _customHours * 3600 + _customMinutes * 60;
                  } else {
                    _isCustom = false;
                    _selectedSeconds = value!;
                  }
                  _updateSeconds();
                });
              },
            ),
          ),
        ),

        // カスタム設定
        if (_isCustom) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                // 時間
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "時間",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: _customHours,
                            items: List.generate(24, (i) => i).map((hour) {
                              return DropdownMenuItem<int>(
                                value: hour,
                                child: Text("$hour時間"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _customHours = value!;
                                _updateSeconds();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // 分
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "分",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: _customMinutes,
                            items: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55].map((minute) {
                              return DropdownMenuItem<int>(
                                value: minute,
                                child: Text("$minute分"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _customMinutes = value!;
                                _updateSeconds();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
