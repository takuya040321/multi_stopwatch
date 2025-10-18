# 技術仕様書

## 1. 技術スタック

### 1.1 フレームワーク・言語
- **Flutter**: 3.24.0以降
- **Dart**: 3.5.0以降
- **対象プラットフォーム**: Windows 10以降

### 1.2 主要パッケージ

#### データ永続化
- **shared_preferences**: ローカルストレージへのキーバリュー形式でのデータ保存
  - 設定情報、ウィンドウサイズ、レイアウト設定の保存に使用
- **hive** または **isar**: 構造化データの保存
  - ストップウォッチの計測データ、名称、状態の保存に使用
  - パフォーマンスとクエリの柔軟性を考慮して選択

#### 状態管理
- **Riverpod**: 状態管理ライブラリ
  - ストップウォッチの状態、設定、UIの状態を管理
  - テスタビリティと保守性を重視した選択

#### UI関連
- **window_manager**: ウィンドウサイズ、位置の制御
- **flutter_riverpod**: RiverpodのFlutter統合
- **intl**: 時間フォーマット、ローカライゼーション対応

#### その他
- **path_provider**: アプリケーションデータディレクトリの取得
- **flutter_lints**: Dart/Flutterの静的解析ルール

### 1.3 開発ツール
- **Flutter DevTools**: デバッグ、パフォーマンス分析
- **VS Code / Android Studio**: 推奨IDE
- **Git**: バージョン管理

## 2. アーキテクチャ設計

### 2.1 アーキテクチャパターン
- **MVVM（Model-View-ViewModel）パターン**を採用
- Riverpodを用いた状態管理により、UIロジックとビジネスロジックを分離

### 2.2 ディレクトリ構成（予定）
```
lib/
├── main.dart                      # アプリケーションエントリーポイント
├── models/                        # データモデル
│   ├── stopwatch_model.dart      # ストップウォッチのデータモデル
│   ├── app_settings.dart         # アプリケーション設定モデル
│   └── auto_stop_time.dart       # 自動停止時刻モデル
├── providers/                     # Riverpod プロバイダー
│   ├── stopwatch_provider.dart   # ストップウォッチ状態管理
│   ├── settings_provider.dart    # 設定状態管理
│   └── timer_provider.dart       # タイマー制御
├── repositories/                  # データ永続化層
│   ├── stopwatch_repository.dart # ストップウォッチデータの保存/読み込み
│   └── settings_repository.dart  # 設定データの保存/読み込み
├── views/                         # UI画面
│   ├── home_screen.dart          # メイン画面
│   ├── settings_screen.dart      # 設定画面
│   └── widgets/                  # 再利用可能なウィジェット
│       ├── stopwatch_card.dart   # ストップウォッチカード
│       ├── time_display.dart     # 時間表示ウィジェット
│       └── layout_switcher.dart  # レイアウト切り替え
├── services/                      # ビジネスロジック
│   ├── timer_service.dart        # タイマー制御サービス
│   └── auto_stop_service.dart    # 自動停止機能サービス
└── utils/                         # ユーティリティ
    ├── time_formatter.dart       # 時間フォーマット関数
    └── constants.dart            # 定数定義
```

### 2.3 データフロー
1. **UI層（View）**: ユーザー操作を受け付け、Providerにアクションを送信
2. **状態管理層（Provider）**: ビジネスロジックを実行し、Repositoryを通じてデータを永続化
3. **データ層（Repository）**: ローカルストレージとのやり取りを担当
4. **UI層への通知**: Providerの状態変更がUIに自動反映

## 3. データ設計

### 3.1 ストップウォッチデータモデル
```
StopwatchModel:
  - id: String (一意識別子)
  - name: String (名称、空の場合はデフォルト名を表示)
  - elapsedSeconds: int (経過秒数)
  - isRunning: bool (計測中かどうか)
  - createdAt: DateTime (作成日時)
```

### 3.2 アプリケーション設定モデル
```
AppSettings:
  - isSingleMeasurementMode: bool (単一計測モード: true, 複数同時計測モード: false)
  - layoutMode: LayoutMode (縦スクロール or グリッド)
  - windowWidth: double (ウィンドウ幅)
  - windowHeight: double (ウィンドウ高さ)
  - autoStopTimes: List<AutoStopTime> (自動停止時刻リスト)
```

### 3.3 自動停止時刻モデル
```
AutoStopTime:
  - id: String (一意識別子)
  - hour: int (時)
  - minute: int (分)
  - isEnabled: bool (有効/無効)
```

### 3.4 保存形式
- **Hive/Isar**: ストップウォッチのリストと設定をオブジェクト形式で保存
- **Shared Preferences**: ウィンドウサイズなどの単純な設定値をキーバリュー形式で保存

## 4. 環境設定

### 4.1 開発環境要件
- **OS**: Windows 10以降、macOS、またはLinux（開発用）
- **Flutter SDK**: 3.24.0以降
- **Dart SDK**: 3.5.0以降
- **IDE**: VS Code（推奨）またはAndroid Studio
- **Git**: バージョン管理

### 4.2 プロジェクト初期設定
```bash
# Flutter プロジェクト作成
flutter create --platforms windows stopwatch_app

# 依存パッケージのインストール
flutter pub get

# Windows アプリとして実行
flutter run -d windows
```

### 4.3 ビルド設定
- **Windows アプリケーション名**: ストップウォッチアプリ
- **アイコン**: カスタムアイコンを設定（flutter_launcher_icons パッケージ使用）
- **最小ウィンドウサイズ**: 幅400px、高さ600px
- **デフォルトウィンドウサイズ**: 幅600px、高さ800px

### 4.4 pubspec.yaml の主要設定
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.5.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  window_manager: ^0.3.7
  path_provider: ^2.1.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
```

## 5. 機能実装の技術方針

### 5.1 時間計測機能
- **Timer.periodic** を使用して1秒ごとに時間を更新
- 計測中のストップウォッチの経過秒数をインクリメント
- Providerの状態変更により、UIに自動反映

### 5.2 自動停止機能
- アプリ起動時に現在時刻と自動停止時刻を比較
- 1分ごとに現在時刻をチェックし、自動停止時刻に到達したら計測中のストップウォッチをすべて停止
- 停止時にデータを自動保存

### 5.3 データ永続化
- ストップウォッチの停止時、リセット時、名称変更時にデータを保存
- アプリ終了時にも現在の状態を保存
- 起動時に保存されたデータを読み込み、UIに反映

### 5.4 レイアウト切り替え
- **縦スクロール**: ListView を使用
- **グリッド**: GridView を使用し、ウィンドウサイズに応じて列数を動的に調整
- MediaQuery でウィンドウサイズを取得し、最適な列数を計算

### 5.5 ウィンドウ管理
- window_manager パッケージでウィンドウサイズを制御
- リサイズイベントをリッスンし、変更後のサイズを保存
- 起動時に保存されたサイズでウィンドウを復元

## 6. パフォーマンス最適化

### 6.1 UI更新の最適化
- Riverpodの部分的な状態更新により、必要な部分のみ再描画
- 重い処理（データ保存など）は非同期で実行
- リストの描画には ListView.builder を使用し、遅延ロード

### 6.2 タイマーの効率化
- 計測中のストップウォッチがない場合はタイマーを停止
- バックグラウンド動作時もタイマーは継続するが、UIの更新頻度を調整

### 6.3 データ保存の最適化
- 頻繁な保存操作はデバウンス（一定時間待機してから実行）
- Hive/Isarの軽量なデータベースを活用し、I/O負荷を最小化

## 7. セキュリティ要件

### 7.1 データ保護
- ローカルストレージに保存されるデータは暗号化不要（個人情報を含まないため）
- アプリケーションデータディレクトリはユーザーのホームディレクトリ配下に配置

### 7.2 入力検証
- 名称入力欄には文字数制限を設定（最大50文字など）
- 自動停止時刻の入力は時刻ピッカーで制御し、不正な値を防止

### 7.3 エラーハンドリング
- データ保存/読み込み時のエラーを適切にキャッチし、ユーザーに通知
- アプリがクラッシュしても、最後に保存した状態を復元可能

## 8. テスト方針

### 8.1 ユニットテスト
- ビジネスロジック（時間計算、自動停止判定など）のテストを実施
- Repositoryのモックを使用し、データ層から独立したテストを実施

### 8.2 ウィジェットテスト
- 各ウィジェット（ストップウォッチカード、時間表示など）の表示と操作をテスト
- ユーザー操作（ボタンクリックなど）のシミュレーション

### 8.3 統合テスト
- アプリ全体の動作を確認
- データの保存/読み込み、レイアウト切り替え、自動停止機能などをテスト

## 9. 今後の技術的拡張可能性

### 9.1 クロスプラットフォーム対応
- macOS、Linuxへの展開が容易な設計
- プラットフォーム固有の処理は分離し、共通ロジックを再利用

### 9.2 データエクスポート機能
- CSV、Excel形式でのエクスポート機能追加が可能
- パッケージ（csv、excel）の追加で実現

### 9.3 クラウド同期
- 将来的にFirebaseなどのバックエンドと統合可能
- Repositoryパターンにより、データ層の変更が容易

### 9.4 テーマカスタマイズ
- ダークモード、カラーテーマの切り替え機能
- ThemeDataの拡張で実現

## 10. 依存関係管理

### 10.1 パッケージのバージョン管理
- pubspec.yamlでバージョンを固定し、予期しない破壊的変更を防止
- 定期的にパッケージを更新し、セキュリティパッチを適用

### 10.2 ビルドツール
- build_runner を使用してコード生成（Hiveのアダプタなど）
- コード生成の自動化により、手動でのボイラープレート記述を削減

## 11. デプロイメント

### 11.1 リリースビルド
```bash
# Windows リリースビルド
flutter build windows --release
```

### 11.2 配布形式
- **実行ファイル**: ビルド後のexeファイルを配布
- **インストーラー**: 将来的にInno SetupなどでWindows インストーラーを作成

### 11.3 アップデート方針
- 初期バージョンは手動配布
- 将来的に自動アップデート機能を検討（updaterパッケージなど）

## 12. 制約事項と技術的考慮事項

### 12.1 技術的制約
- Flutterのデスクトップサポートは安定版だが、一部機能に制限がある可能性
- ウィンドウ管理の詳細な制御にはプラットフォーム固有のコードが必要な場合がある

### 12.2 パフォーマンス考慮事項
- 10個のストップウォッチが同時計測されても、UIの応答性を維持
- バックグラウンド動作時のCPU使用率を監視し、最適化

### 12.3 互換性
- Windows 10以降をサポート
- 古いバージョンのWindowsでは動作保証なし