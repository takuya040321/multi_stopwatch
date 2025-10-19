# コーディング規約とスタイル

## 基本原則
- **関数ベース**: クラスを使用せず、関数ベースでコーディングする
- **文字列**: シングルクォート（'）ではなくダブルクォート（"）を使用
- **日本語**: すべてのコメント、UI表示テキスト、エラーメッセージは日本語で記述

## コードスタイル
- **早期リターン**: if文でのネストを避け、条件不一致時は早期リターンを実行
- **ガード句の活用**: 異常系や前提条件チェックは関数の最初で処理
- **三項演算子の制限**: 複雑な条件分岐は避け、可読性を優先
- **関心の分離**: UI/ロジック分離を徹底

## Dart/Flutter固有の規約

### 命名規則
- クラス名・型名: `PascalCase`（例: `StopwatchModel`, `AppSettings`）
- 関数名・変数名: `camelCase`（例: `startTimer`, `elapsedSeconds`）
- 定数: `lowerCamelCase`（例: `maxStopwatchCount`）
- プライベート変数・関数: 先頭にアンダースコア（例: `_privateMethod`）

### Widget構成
- StatelessWidget を優先的に使用
- 状態管理は Riverpod を使用
- const コンストラクタを積極的に使用

### 非同期処理
- async/await を使用
- 適切なエラーハンドリング

### コメント
- すべて日本語で記述
- 関数の役割、引数、戻り値を説明
- 複雑なロジックには必ずコメントを付ける

### フレームワーク固有
- Flutterベストプラクティスに準拠
- flutter_lints の推奨ルールに従う
- 警告を残さない

## 早期リターンの例
```dart
// 良い例
void processData(String? data) {
  if (data == null) return;
  if (data.isEmpty) return;
  
  // メイン処理
}

// 悪い例
void processData(String? data) {
  if (data != null) {
    if (data.isNotEmpty) {
      // メイン処理
    }
  }
}
```

## コメントの例
```dart
/// ストップウォッチを開始する
/// 
/// [id] 開始するストップウォッチのID
/// 単一計測モードの場合、他の計測中ストップウォッチを停止する
void startStopwatch(String id) {
  // 実装
}
```
