# 推奨コマンド一覧

## プロジェクト管理

### 依存関係のインストール
```bash
flutter pub get
```

### コード生成（Riverpod等で必要な場合）
```bash
flutter pub run build_runner build
# または、競合ファイルを削除して生成
flutter pub run build_runner build --delete-conflicting-outputs
```

## 開発・実行

### アプリケーションの起動（Windows）
```bash
flutter run -d windows
```

### デバッグモードで実行
```bash
flutter run -d windows --debug
```

### リリースモードで実行
```bash
flutter run -d windows --release
```

## テスト・品質管理

### 静的解析（リント）
```bash
flutter analyze
```

### テスト実行
```bash
# すべてのテストを実行
flutter test

# 特定のテストファイルを実行
flutter test test/services/timer_service_test.dart

# カバレッジレポートを生成
flutter test --coverage
```

### コードフォーマット
```bash
# ファイルをフォーマット
dart format lib/

# フォーマットが必要かチェックのみ
dart format --output=none --set-exit-if-changed lib/
```

## ビルド

### リリースビルド（Windows）
```bash
flutter build windows --release
```

### クリーンビルド
```bash
flutter clean
flutter pub get
flutter build windows --release
```

## トラブルシューティング

### パッケージ依存関係の問題解決
```bash
flutter clean
flutter pub get
```

### ビルド生成物のクリーン
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## Git操作

### ブランチ作成
```bash
git checkout -b feature/issue1-description
```

### コミット
```bash
git add .
git commit -m "feat: 機能の説明"
```

### プッシュ
```bash
git push origin branch-name
```

## タスク完了時のチェックリスト

### コミット前
1. `flutter analyze` でエラーがないことを確認
2. `flutter test` でテストが通ることを確認
3. 不要なコメントやデバッグコードを削除

### プルリクエスト前
1. 機能が要件通りに動作することを確認
2. 新しい機能にはテストを追加
3. ドキュメントを更新（必要な場合）

## macOS（Darwin）システム固有のコマンド

### ファイル検索
```bash
find . -name "*.dart"
```

### ディレクトリ一覧
```bash
ls -la
```

### ファイル内容の確認
```bash
cat file.dart
```

### パターン検索
```bash
grep -r "pattern" lib/
```
