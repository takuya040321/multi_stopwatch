# 開発ガイドライン

本ドキュメントは、Flutter製ストップウォッチアプリの開発に参加する際のガイドラインです。

## 目次
1. [コーディング規約](#コーディング規約)
2. [ディレクトリ構造](#ディレクトリ構造)
3. [Git運用規則](#git運用規則)
4. [開発フロー](#開発フロー)
5. [プルリクエスト規約](#プルリクエスト規約)

## コーディング規約

### 基本原則
- **関数ベース**: クラスを使用せず、関数ベースでコーディングする
- **文字列**: シングルクォート（'）ではなくダブルクォート（"）を使用
- **パスエイリアス**: `@/*`は`./src/*`にマップ（該当する場合）

### コードスタイル
- **早期リターン**: if文でのネストを避け、条件不一致時は早期リターンを実行
- **ガード句の活用**: 異常系や前提条件チェックは関数の最初で処理
- **三項演算子の制限**: 複雑な条件分岐は避け、可読性を優先
- **関心の分離**: UI/ロジック分離を徹底

### Dart/Flutter固有の規約

#### 命名規則
- クラス名・型名: `PascalCase`（例: `StopwatchModel`, `AppSettings`）
- 関数名・変数名: `camelCase`（例: `startTimer`, `elapsedSeconds`）
- 定数: `lowerCamelCase`（例: `maxStopwatchCount`）
- プライベート変数・関数: 先頭にアンダースコア（例: `_privateMethod`）

#### コメント
- すべて日本語で記述
- 複雑なロジックには必ずコメントを付ける
- 関数の役割、引数、戻り値を説明する
```dart
/// ストップウォッチを開始する
/// 
/// [id] 開始するストップウォッチのID
/// 単一計測モードの場合、他の計測中ストップウォッチを停止する
void startStopwatch(String id) {
  // 実装
}
```

#### Widget構成
- StatelessWidget を優先的に使用
- 状態管理は Riverpod を使用
- const コンストラクタを積極的に使用してパフォーマンス向上

#### 非同期処理
- async/await を使用
- Future の適切なエラーハンドリング
```dart
Future<void> saveData() async {
  try {
    await repository.save(data);
  } catch (e) {
    // エラー処理
    debugPrint("データ保存エラー: $e");
  }
}
```

### フレームワーク固有
- Flutterベストプラクティスに準拠
- flutter_lints の推奨ルールに従う
- 警告を残さない

### ドキュメント作成
- mermaid記法使用可能
- 可読性を重視し、構造化された日本語ドキュメントを作成

## ディレクトリ構造

```
stopwatch_app/
├── lib/
│   ├── main.dart                      # エントリーポイント
│   ├── models/                        # データモデル
│   │   ├── stopwatch_model.dart
│   │   ├── app_settings.dart
│   │   └── auto_stop_time.dart
│   ├── providers/                     # Riverpod プロバイダー
│   │   ├── stopwatch_provider.dart
│   │   ├── settings_provider.dart
│   │   └── timer_provider.dart
│   ├── repositories/                  # データ永続化層
│   │   ├── stopwatch_repository.dart
│   │   └── settings_repository.dart
│   ├── views/                         # UI画面
│   │   ├── home_screen.dart
│   │   ├── settings_screen.dart
│   │   └── widgets/                   # 再利用可能なウィジェット
│   │       ├── stopwatch_card.dart
│   │       ├── time_display.dart
│   │       └── layout_switcher.dart
│   ├── services/                      # ビジネスロジック
│   │   ├── timer_service.dart
│   │   └── auto_stop_service.dart
│   └── utils/                         # ユーティリティ
│       ├── time_formatter.dart
│       └── constants.dart
├── test/                              # テストコード
│   ├── models/
│   ├── providers/
│   ├── repositories/
│   └── services/
├── assets/                            # 静的リソース
│   └── icons/
├── docs/                              # ドキュメント
│   ├── requirement.md
│   ├── technical_spec.md
│   ├── system_design.md
│   └── implementation_plan.md
├── .gitignore
├── pubspec.yaml
├── README.md
├── CONTRIBUTING.md
└── CLAUDE.md
```

### ディレクトリの役割

| ディレクトリ | 役割 |
|------------|------|
| models/ | データモデルの定義 |
| providers/ | Riverpod による状態管理 |
| repositories/ | データの永続化/読み込み処理 |
| views/ | UI画面とウィジェット |
| services/ | ビジネスロジック、ドメイン処理 |
| utils/ | 共通のユーティリティ関数 |
| test/ | ユニットテスト、ウィジェットテスト |

## Git運用規則（GitHub Flow）

### ブランチ戦略
```
main # 本番環境
├── feature/issue1-*** # Issue #1: 実装内容の概略
```

### ブランチ命名規則
`[type]/[issue番号]-[brief-description]`

**タイプ一覧**
- `feature/`: 新機能追加
- `fix/`: バグ修正
- `refactor/`: リファクタリング
- `docs/`: ドキュメント更新
- `test/`: テスト追加・修正

**例**
- `feature/issue1-add-stopwatch`
- `fix/issue5-timer-bug`
- `refactor/issue10-repository-structure`

### Issue駆動開発フロー

1. **Issue作成**
   - 実装する機能やバグ修正内容をIssueとして作成
   - タイトルは簡潔に、説明は詳細に記述

2. **ブランチ作成**
   ```bash
   git checkout -b feature/issue1-add-stopwatch
   ```

3. **実装とコミット**
   - 小さな単位でこまめにコミット
   - コミットメッセージ規約に従う

4. **プルリクエスト作成**
   - main ブランチへのPRを作成
   - Issue番号を本文に記載（`Close #1`）

5. **マージ**
   - レビュー完了後、マージコミットでマージ
   - ブランチは削除

### コミットメッセージ規約
形式: `[type]: [subject]`

**コミットタイプ一覧**
- `feat`: 新機能追加
- `fix`: バグ修正
- `style`: コードスタイル修正（機能に影響なし）
- `refactor`: リファクタリング
- `docs`: ドキュメント更新
- `test`: テスト追加・修正

**例**
```
feat: ストップウォッチ追加機能を実装
fix: タイマーが停止しないバグを修正
refactor: リポジトリ層の構造を改善
docs: README.mdにセットアップ手順を追加
```

### コミット粒度・品質
- 1つの論理的な変更ごとにコミットする
- 機能追加、バグ修正、リファクタリングを混在させない
- 小さすぎず大きすぎない適切な単位でコミット
- 動作する状態でコミットし、不具合を含む中途半端な状態は避ける
- コミットメッセージは変更内容が明確に分かるよう簡潔に記述
- コミット前に必ずDartエラー・リントエラーがないことを確認

### Issue連動キーワード

PRの本文に以下のキーワードを含めると、マージ時に自動的にIssueがクローズされる：

- `Close #N`
- `Closes #N`
- `Fix #N`
- `Fixes #N`

**例**
```markdown
## 概要
ストップウォッチの追加機能を実装しました。

## 変更内容
- ストップウォッチ追加ボタンの実装
- 最大10個までの制限を追加

Close #1
```

## 開発フロー

### 開発環境のセットアップ

1. **リポジトリのクローン**
   ```bash
   git clone https://github.com/your-username/stopwatch_app.git
   cd stopwatch_app
   ```

2. **依存パッケージのインストール**
   ```bash
   flutter pub get
   ```

3. **コード生成（必要な場合）**
   ```bash
   flutter pub run build_runner build
   ```

4. **アプリの起動**
   ```bash
   flutter run -d windows
   ```

### 開発時のチェック

#### コミット前
- [ ] flutter analyze でエラーがないことを確認
- [ ] flutter test でテストが通ることを確認
- [ ] 不要なコメントやデバッグコードを削除

#### プルリクエスト前
- [ ] 機能が要件通りに動作することを確認
- [ ] 新しい機能にはテストを追加
- [ ] ドキュメントを更新（必要な場合）

## プルリクエスト規約

### PRタイトル
- わかりやすく簡潔に
- Issue番号を含める（例: `[#1] ストップウォッチ追加機能を実装`）

### PR本文テンプレート
```markdown
## 概要
<!-- このPRの目的を簡潔に説明 -->

## 変更内容
<!-- 主な変更点をリストアップ -->
- 
- 

## 動作確認
<!-- どのように動作確認したか -->
- [ ] 
- [ ] 

## スクリーンショット（該当する場合）
<!-- UI変更がある場合はスクリーンショットを添付 -->

## 関連Issue
Close #
```

### レビュー観点
- コーディング規約に従っているか
- 適切なエラーハンドリングがされているか
- テストが追加されているか
- パフォーマンスへの影響はないか
- ドキュメントの更新が必要か

### PR・マージ規約
- **マージ方法**: 必ず `--merge` を使用してマージコミットを作成
- **ブランチ履歴**: squash merge は使用せず、ブランチの履歴を保持する
- **ブランチ削除**: マージ完了後はローカル・リモート両方のブランチを削除
- **PR本文**: Issue自動クローズキーワード（Close #N）を必ず含める

```bash
# マージコマンド例
git checkout main
git merge --no-ff feature/issue1-add-stopwatch
git push origin main

# ブランチ削除
git branch -d feature/issue1-add-stopwatch
git push origin --delete feature/issue1-add-stopwatch
```

## テスト方針

### テストの種類
- **ユニットテスト**: ビジネスロジック、ユーティリティ関数
- **ウィジェットテスト**: UIコンポーネント
- **統合テスト**: 画面全体の動作

### テストファイルの配置
- `test/` ディレクトリに `lib/` と同じ構造で配置
- ファイル名は `*_test.dart`

### テストの実行
```bash
# すべてのテストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/services/timer_service_test.dart

# カバレッジレポートを生成
flutter test --coverage
```

## リリースフロー

### バージョニング
- セマンティックバージョニング（`MAJOR.MINOR.PATCH`）を採用
- 例: `1.0.0`, `1.1.0`, `1.1.1`

### リリース手順
1. バージョン番号を更新（`pubspec.yaml`）
2. CHANGELOG.md を更新
3. リリースタグを作成
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. リリースビルドを作成
   ```bash
   flutter build windows --release
   ```

## トラブルシューティング

### よくある問題

#### パッケージの依存関係エラー
```bash
flutter pub get
flutter clean
flutter pub get
```

#### コード生成が失敗する
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Windowsビルドが失敗する
- Visual Studio 2022 以降がインストールされているか確認
- C++ デスクトップ開発ツールがインストールされているか確認

## 質問・サポート

開発中に不明な点や問題が発生した場合：
1. このドキュメントを確認
2. 既存のIssueを検索
3. 新しいIssueを作成して質問

## 参考リンク

- [Flutter公式ドキュメント](https://flutter.dev/docs)
- [Dart公式ドキュメント](https://dart.dev/guides)
- [Riverpod公式ドキュメント](https://riverpod.dev/)
- [Flutter for Desktop](https://docs.flutter.dev/platform-integration/windows/building)