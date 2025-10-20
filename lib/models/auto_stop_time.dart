import "package:hive/hive.dart";

part "auto_stop_time.g.dart";

/// 自動停止時刻の情報を保持するモデルクラス
///
/// 指定した時刻に全てのストップウォッチを自動停止する機能で使用する
@HiveType(typeId: 1)
class AutoStopTime {
  /// 自動停止時刻の一意識別子（UUID）
  @HiveField(0)
  final String id;

  /// 時（0-23）
  @HiveField(1)
  final int hour;

  /// 分（0-59）
  @HiveField(2)
  final int minute;

  /// この自動停止時刻が有効かどうか
  @HiveField(3)
  final bool isEnabled;

  const AutoStopTime({
    required this.id,
    required this.hour,
    required this.minute,
    required this.isEnabled,
  });

  /// オブジェクトのコピーを作成する（不変性を保つため）
  ///
  /// 指定されたフィールドのみを更新した新しいインスタンスを返す
  AutoStopTime copyWith({
    String? id,
    int? hour,
    int? minute,
    bool? isEnabled,
  }) {
    return AutoStopTime(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// JSONからAutoStopTimeを生成する
  ///
  /// [json] デシリアライズ対象のJSONマップ
  factory AutoStopTime.fromJson(Map<String, dynamic> json) {
    return AutoStopTime(
      id: json["id"] as String,
      hour: json["hour"] as int,
      minute: json["minute"] as int,
      isEnabled: json["isEnabled"] as bool,
    );
  }

  /// AutoStopTimeをJSONに変換する
  ///
  /// 戻り値: シリアライズされたJSONマップ
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "hour": hour,
      "minute": minute,
      "isEnabled": isEnabled,
    };
  }
}
