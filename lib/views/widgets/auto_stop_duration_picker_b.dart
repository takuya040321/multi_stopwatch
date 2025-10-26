/// 自動停止時間設定ピッカー - パターンB（数値入力式）
///
/// 時間・分を直接入力できる柔軟なタイマー式UI
library;

import "package:flutter/material.dart";
import "package:flutter/services.dart";

/// 自動停止時間設定ピッカー - パターンB
class AutoStopDurationPickerB extends StatefulWidget {
  /// 初期の秒数
  final int initialSeconds;

  /// 秒数が変更された時のコールバック
  final ValueChanged<int> onChanged;

  const AutoStopDurationPickerB({
    super.key,
    required this.initialSeconds,
    required this.onChanged,
  });

  @override
  State<AutoStopDurationPickerB> createState() => _AutoStopDurationPickerBState();
}

class _AutoStopDurationPickerBState extends State<AutoStopDurationPickerB> {
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;
  late int _hours;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _hours = widget.initialSeconds ~/ 3600;
    _minutes = (widget.initialSeconds % 3600) ~/ 60;
    _hoursController = TextEditingController(text: _hours.toString());
    _minutesController = TextEditingController(text: _minutes.toString());
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  void _updateSeconds() {
    final seconds = _hours * 3600 + _minutes * 60;
    widget.onChanged(seconds);
  }

  void _incrementHours() {
    setState(() {
      if (_hours < 23) {
        _hours++;
        _hoursController.text = _hours.toString();
        _updateSeconds();
      }
    });
  }

  void _decrementHours() {
    setState(() {
      if (_hours > 0) {
        _hours--;
        _hoursController.text = _hours.toString();
        _updateSeconds();
      }
    });
  }

  void _incrementMinutes() {
    setState(() {
      if (_minutes < 59) {
        _minutes++;
      } else {
        _minutes = 0;
        if (_hours < 23) _hours++;
        _hoursController.text = _hours.toString();
      }
      _minutesController.text = _minutes.toString();
      _updateSeconds();
    });
  }

  void _decrementMinutes() {
    setState(() {
      if (_minutes > 0) {
        _minutes--;
      } else {
        _minutes = 59;
        if (_hours > 0) _hours--;
        _hoursController.text = _hours.toString();
      }
      _minutesController.text = _minutes.toString();
      _updateSeconds();
    });
  }

  Widget _buildTimeInput({
    required String label,
    required TextEditingController controller,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    required Function(String) onChanged,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // デクリメントボタン
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrement,
                iconSize: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
            const SizedBox(width: 12),
            // 数値入力
            SizedBox(
              width: 60,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 12),
            // インクリメントボタン
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrement,
                iconSize: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 時間入力
          Expanded(
            child: _buildTimeInput(
              label: "時間",
              controller: _hoursController,
              onIncrement: _incrementHours,
              onDecrement: _decrementHours,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null && parsed >= 0 && parsed <= 23) {
                  setState(() {
                    _hours = parsed;
                    _updateSeconds();
                  });
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32, left: 8, right: 8),
            child: Text(
              ":",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // 分入力
          Expanded(
            child: _buildTimeInput(
              label: "分",
              controller: _minutesController,
              onIncrement: _incrementMinutes,
              onDecrement: _decrementMinutes,
              onChanged: (value) {
                final parsed = int.tryParse(value);
                if (parsed != null && parsed >= 0 && parsed <= 59) {
                  setState(() {
                    _minutes = parsed;
                    _updateSeconds();
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
