/// 自動停止時間設定ピッカー - パターンC（スライダー式）
///
/// スライダーで視覚的に時間を設定するモダンなUI
library;

import "package:flutter/material.dart";

/// 自動停止時間設定ピッカー - パターンC
class AutoStopDurationPickerC extends StatefulWidget {
  /// 初期の秒数
  final int initialSeconds;

  /// 秒数が変更された時のコールバック
  final ValueChanged<int> onChanged;

  const AutoStopDurationPickerC({
    super.key,
    required this.initialSeconds,
    required this.onChanged,
  });

  @override
  State<AutoStopDurationPickerC> createState() => _AutoStopDurationPickerCState();
}

class _AutoStopDurationPickerCState extends State<AutoStopDurationPickerC> {
  late double _sliderValue;
  late int _currentSeconds;

  // スライダーの最大値（秒）: 6時間 = 21600秒
  static const double _maxSeconds = 21600.0;

  // スナップポイント（秒）
  static const List<int> _snapPoints = [
    300,    // 5分
    600,    // 10分
    900,    // 15分
    1800,   // 30分
    2700,   // 45分
    3600,   // 1時間
    5400,   // 1.5時間
    7200,   // 2時間
    10800,  // 3時間
    14400,  // 4時間
    18000,  // 5時間
    21600,  // 6時間
  ];

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.initialSeconds;
    _sliderValue = _currentSeconds.toDouble();
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return "$hours時間$minutes分";
    } else if (hours > 0) {
      return "$hours時間";
    } else if (minutes > 0) {
      return "$minutes分";
    } else {
      return "0分";
    }
  }

  int _findNearestSnapPoint(double value) {
    int nearestPoint = value.round();
    double minDistance = double.infinity;

    for (final snapPoint in _snapPoints) {
      final distance = (value - snapPoint).abs();
      if (distance < minDistance && distance < 300) { // 5分以内ならスナップ
        minDistance = distance;
        nearestPoint = snapPoint;
      }
    }

    return nearestPoint;
  }

  void _updateValue(double value) {
    setState(() {
      _sliderValue = value;
      _currentSeconds = value.round();
    });
  }

  void _snapToNearest() {
    final snapped = _findNearestSnapPoint(_sliderValue);
    setState(() {
      _currentSeconds = snapped;
      _sliderValue = snapped.toDouble();
    });
    widget.onChanged(_currentSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 時間表示
          Center(
            child: Column(
              children: [
                Text(
                  _formatDuration(_currentSeconds),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "経過時間で自動停止",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // スライダー
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              thumbColor: Theme.of(context).primaryColor,
              overlayColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              trackHeight: 6,
            ),
            child: Slider(
              value: _sliderValue,
              min: 0,
              max: _maxSeconds,
              divisions: 120, // 3分刻み
              onChanged: _updateValue,
              onChangeEnd: (value) => _snapToNearest(),
            ),
          ),
          const SizedBox(height: 8),
          // 目盛りラベル
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0分",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "3時間",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                "6時間",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // クイックプリセットボタン
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetChip("5分", 300),
              _buildPresetChip("15分", 900),
              _buildPresetChip("30分", 1800),
              _buildPresetChip("1時間", 3600),
              _buildPresetChip("2時間", 7200),
              _buildPresetChip("3時間", 10800),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, int seconds) {
    final isSelected = (_currentSeconds - seconds).abs() < 60;

    return InkWell(
      onTap: () {
        setState(() {
          _currentSeconds = seconds;
          _sliderValue = seconds.toDouble();
        });
        widget.onChanged(seconds);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
