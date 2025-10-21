import "auto_stop_time.dart";

/// アプリケーション全体の設定情報を保持するモデルクラス
///
/// 計測モード、レイアウト、ウィンドウサイズ、自動停止時刻などの設定を管理する
class AppSettings {
  /// 単一計測モード（true）か複数計測モード（false）か
  final bool isSingleMeasurementMode;

  /// レイアウトモード（"LIST" または "GRID"）
  final String layoutMode;

  /// ウィンドウの幅（最小400）
  final double windowWidth;

  /// ウィンドウの高さ（最小600）
  final double windowHeight;

  /// 自動停止時刻のリスト（最大5個）
  final List<AutoStopTime> autoStopTimes;

  const AppSettings({
    required this.isSingleMeasurementMode,
    required this.layoutMode,
    required this.windowWidth,
    required this.windowHeight,
    required this.autoStopTimes,
  });

  /// デフォルト設定を返すファクトリコンストラクタ
  factory AppSettings.defaultSettings() {
    return const AppSettings(
      isSingleMeasurementMode: true,
      layoutMode: "LIST",
      windowWidth: 1200.0,
      windowHeight: 800.0,
      autoStopTimes: [],
    );
  }

  /// オブジェクトのコピーを作成する（不変性を保つため）
  ///
  /// 指定されたフィールドのみを更新した新しいインスタンスを返す
  AppSettings copyWith({
    bool? isSingleMeasurementMode,
    String? layoutMode,
    double? windowWidth,
    double? windowHeight,
    List<AutoStopTime>? autoStopTimes,
  }) {
    return AppSettings(
      isSingleMeasurementMode: isSingleMeasurementMode ?? this.isSingleMeasurementMode,
      layoutMode: layoutMode ?? this.layoutMode,
      windowWidth: windowWidth ?? this.windowWidth,
      windowHeight: windowHeight ?? this.windowHeight,
      autoStopTimes: autoStopTimes ?? this.autoStopTimes,
    );
  }

  /// JSONからAppSettingsを生成する
  ///
  /// [json] デシリアライズ対象のJSONマップ
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final autoStopTimesList = (json["autoStopTimes"] as List<dynamic>?)
        ?.map((item) => AutoStopTime.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];

    return AppSettings(
      isSingleMeasurementMode: json["isSingleMeasurementMode"] as bool? ?? true,
      layoutMode: json["layoutMode"] as String? ?? "LIST",
      windowWidth: (json["windowWidth"] as num?)?.toDouble() ?? 1200.0,
      windowHeight: (json["windowHeight"] as num?)?.toDouble() ?? 800.0,
      autoStopTimes: autoStopTimesList,
    );
  }

  /// AppSettingsをJSONに変換する
  ///
  /// 戻り値: シリアライズされたJSONマップ
  Map<String, dynamic> toJson() {
    return {
      "isSingleMeasurementMode": isSingleMeasurementMode,
      "layoutMode": layoutMode,
      "windowWidth": windowWidth,
      "windowHeight": windowHeight,
      "autoStopTimes": autoStopTimes.map((time) => time.toJson()).toList(),
    };
  }
}
