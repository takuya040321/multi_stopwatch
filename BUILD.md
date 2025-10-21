# ビルドガイド

このドキュメントでは、Multi Stopwatchのリリースビルドを作成する手順を説明します。

## 前提条件

### 開発環境
- Flutter SDK 3.24.0以降
- Dart SDK 3.5.0以降
- Windows 10以降のOS
- Visual Studio 2022以降（C++デスクトップ開発ツールを含む）

### 必要なツール
- Git
- Flutter（path設定済み）
- Visual Studio（Windows C++ Desktop Development）

## ビルド手順

### 1. リポジトリのクローン

```bash
git clone https://github.com/takuya040321/multi_stopwatch.git
cd multi_stopwatch
```

### 2. 依存パッケージのインストール

```bash
flutter pub get
```

### 3. コード生成（Hiveアダプタ）

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. テストの実行（オプション）

```bash
flutter test
```

全26テストが成功することを確認してください。

### 5. コード分析（オプション）

```bash
flutter analyze
```

エラーや警告がないことを確認してください。

### 6. リリースビルドの作成

```bash
flutter build windows --release
```

ビルドには数分かかります。完了すると、以下のパスに実行ファイルが生成されます：

```
build/windows/x64/runner/Release/
```

### 7. 実行ファイルの確認

生成されたフォルダには以下のファイルが含まれています：

- `multi_stopwatch.exe` - メイン実行ファイル
- `flutter_windows.dll` - Flutterランタイム
- `data/` - アプリケーションデータ
- その他のDLLファイル

### 8. 配布パッケージの作成

配布用のZIPファイルを作成します：

```bash
cd build/windows/x64/runner/Release
7z a multi_stopwatch_v1.0.0_windows.zip *
```

または、手動でフォルダ全体をZIPに圧縮します。

## ビルドの検証

### 1. 動作確認

1. `multi_stopwatch.exe`を実行
2. 以下の機能を確認：
   - ストップウォッチの追加/削除
   - 計測の開始/停止/リセット
   - 設定画面の表示
   - データの保存と復元（アプリを再起動）
   - ウィンドウサイズの変更と保存

### 2. パフォーマンステスト

- **起動時間**: 3秒以内
- **タイマー更新の遅延**: 100ms以内
- **メモリ使用量**: 200MB以下

タスクマネージャーで確認できます。

### 3. クリーンインストールテスト

1. 新しいWindowsユーザーアカウントまたは仮想マシンで実行
2. 初回起動時の動作を確認
3. データが正しく保存されることを確認

## トラブルシューティング

### ビルドエラー

#### エラー: "No valid Flutter SDK found"

**原因**: Flutter SDKのパスが通っていない

**解決策**:
```bash
flutter doctor
```
を実行して、Flutter SDKが正しくインストールされているか確認。

#### エラー: "Visual Studio not found"

**原因**: Visual StudioのC++デスクトップ開発ツールがインストールされていない

**解決策**:
1. Visual Studio Installerを起動
2. 「C++によるデスクトップ開発」をインストール

#### エラー: "build_runner failed"

**原因**: コード生成の失敗

**解決策**:
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 実行時エラー

#### エラー: "DLL not found"

**原因**: 必要なDLLファイルが不足

**解決策**:
`build/windows/x64/runner/Release/`フォルダ全体を配布してください。
単独の`multi_stopwatch.exe`だけでは動作しません。

#### エラー: "Failed to initialize Hive"

**原因**: データディレクトリへの書き込み権限がない

**解決策**:
アプリを管理者権限で実行するか、別のディレクトリにインストールしてください。

## デバッグビルド

開発中はデバッグビルドを使用します：

```bash
flutter run -d windows
```

または

```bash
flutter build windows --debug
```

デバッグビルドには以下の機能が含まれます：
- ホットリロード
- デバッグコンソール出力
- パフォーマンス計測ツール

## プロファイルビルド

パフォーマンス分析には、プロファイルビルドを使用します：

```bash
flutter build windows --profile
```

プロファイルビルドには以下の機能が含まれます：
- パフォーマンス計測
- リリースに近い最適化
- デバッグツールの一部

## CI/CDでのビルド

GitHub ActionsなどのCI/CDでビルドする場合の例：

```yaml
name: Build Windows Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Generate code
        run: flutter pub run build_runner build --delete-conflicting-outputs

      - name: Run tests
        run: flutter test

      - name: Build Windows
        run: flutter build windows --release

      - name: Create archive
        run: |
          cd build/windows/x64/runner/Release
          7z a ../../../../../multi_stopwatch_windows.zip *

      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: multi_stopwatch_windows
          path: multi_stopwatch_windows.zip
```

## バージョン管理

### バージョン番号の更新

`pubspec.yaml`でバージョンを更新します：

```yaml
version: 1.0.0+1
```

形式: `メジャー.マイナー.パッチ+ビルド番号`

### リリースタグの作成

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

## 配布

### 配布ファイルの構成

```
multi_stopwatch_v1.0.0_windows.zip
├── multi_stopwatch.exe
├── flutter_windows.dll
├── data/
│   ├── icudtl.dat
│   └── ...
└── README.txt (使い方を簡潔に記載)
```

### 配布時の注意事項

1. **フォルダ全体を配布**: 単独のEXEファイルだけでは動作しません
2. **必要なランタイム**: Visual C++ Redistributableが必要な場合があります
3. **ファイアウォール**: 初回起動時にファイアウォールの許可が必要な場合があります

## サポート

ビルドに関する質問や問題は、以下で報告してください：

- [GitHub Issues](https://github.com/takuya040321/multi_stopwatch/issues)
- [GitHub Discussions](https://github.com/takuya040321/multi_stopwatch/discussions)

---

**最終更新**: 2025年1月22日
**対象バージョン**: v1.0.0
