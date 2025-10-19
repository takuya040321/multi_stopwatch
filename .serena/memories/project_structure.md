# プロジェクト構造

## 現在のディレクトリ構造

```
multi_stopwatch/
├── lib/
│   └── main.dart                      # エントリーポイント
├── test/                              # テストコード
├── docs/                              # プロジェクトドキュメント
│   ├── requirement.md                 # 要件定義書
│   ├── technical_spec.md              # 技術仕様書
│   ├── system_design.md               # システム設計書
│   └── implementation_plan.md         # 実装計画書
├── android/                           # Androidプラットフォーム固有ファイル
├── ios/                               # iOSプラットフォーム固有ファイル
├── linux/                             # Linuxプラットフォーム固有ファイル
├── macos/                             # macOSプラットフォーム固有ファイル
├── web/                               # Webプラットフォーム固有ファイル
├── windows/                           # Windowsプラットフォーム固有ファイル
├── .dart_tool/                        # Dartツールの生成ファイル
├── .git/                              # Gitリポジトリ
├── .idea/                             # IDE設定ファイル
├── .serena/                           # Serena MCP設定
├── .claude/                           # Claude Code設定
├── .gitignore                         # Git除外設定
├── .metadata                          # Flutterメタデータ
├── pubspec.yaml                       # パッケージ依存関係
├── pubspec.lock                       # ロックファイル
├── analysis_options.yaml              # 静的解析設定
├── README.md                          # プロジェクト説明
├── CONTRIBUTING.md                    # 開発ガイドライン
└── CLAUDE.md                          # Claude Code開発ガイド
```

## 計画されているディレクトリ構造（実装後）

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

## ディレクトリの役割

| ディレクトリ | 役割 |
|------------|------|
| models/ | データモデルの定義 |
| providers/ | Riverpod による状態管理 |
| repositories/ | データの永続化/読み込み処理 |
| views/ | UI画面とウィジェット |
| services/ | ビジネスロジック、ドメイン処理 |
| utils/ | 共通のユーティリティ関数 |
| test/ | ユニットテスト、ウィジェットテスト |
| docs/ | プロジェクトドキュメント |

## データフロー
1. **UI層（View）**: ユーザー操作を受け付け、Providerにアクションを送信
2. **状態管理層（Provider）**: ビジネスロジックを実行し、Repositoryを通じてデータを永続化
3. **データ層（Repository）**: ローカルストレージとのやり取りを担当
4. **UI層への通知**: Providerの状態変更がUIに自動反映
