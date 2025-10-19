# 技術スタック

## フレームワーク・言語
- **Flutter**: 3.24.0以降
- **Dart**: 3.5.0以降（現在のSDK: 3.9.2）
- **対象プラットフォーム**: Windows 10以降

## 主要パッケージ

### データ永続化
- **shared_preferences**: 設定情報、ウィンドウサイズ、レイアウト設定の保存
- **hive** または **isar**: ストップウォッチの計測データ、名称、状態の保存

### 状態管理
- **Riverpod (flutter_riverpod)**: アプリケーション全体の状態管理
  - ストップウォッチの状態、設定、UIの状態を管理

### UI関連
- **window_manager**: ウィンドウサイズ、位置の制御
- **intl**: 時間フォーマット、ローカライゼーション対応

### その他
- **path_provider**: アプリケーションデータディレクトリの取得
- **flutter_lints**: Dart/Flutterの静的解析ルール

## 現在の依存関係（pubspec.yaml）
- flutter SDK
- cupertino_icons: ^1.0.8
- flutter_lints: ^5.0.0 (dev dependency)

## アーキテクチャパターン
- **MVVM（Model-View-ViewModel）パターン**
- Riverpodによる状態管理でUIロジックとビジネスロジックを分離
- **Repository パターン**: データ層の抽象化
