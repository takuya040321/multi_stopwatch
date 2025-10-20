/// アプリケーション全体で使用される定数を定義
///
/// ストップウォッチの制限値、ウィンドウサイズの設定など、
/// アプリケーション全体で共通して使用される定数を一元管理する
library;

/// ストップウォッチの最大数
const int maxStopwatchCount = 10;

/// ストップウォッチの最小数
const int minStopwatchCount = 2;

/// 自動停止時刻の最大設定数
const int maxAutoStopTimeCount = 5;

/// ウィンドウの最小幅（ピクセル）
const double minWindowWidth = 400.0;

/// ウィンドウの最小高さ（ピクセル）
const double minWindowHeight = 600.0;

/// デフォルトのウィンドウ幅（ピクセル）
const double defaultWindowWidth = 800.0;

/// デフォルトのウィンドウ高さ（ピクセル）
const double defaultWindowHeight = 800.0;

/// ストップウォッチのエージェントカラーリスト
/// 各ストップウォッチを識別するための色のリスト（最大10色）
const agentColors = [
  0xFF2196F3, // Blue
  0xFFF44336, // Red
  0xFF4CAF50, // Green
  0xFFFF9800, // Orange
  0xFF9C27B0, // Purple
  0xFFFFEB3B, // Yellow
  0xFF00BCD4, // Cyan
  0xFFE91E63, // Pink
  0xFF795548, // Brown
  0xFF607D8B, // Blue Grey
];
