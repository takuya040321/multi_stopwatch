import "package:hive/hive.dart";

part "stopwatch_model.g.dart";

/// ストップウォッチの情報を保持するモデルクラス
///
/// 各ストップウォッチの状態（経過時間、実行状態など）を管理する
@HiveType(typeId: 0)
class StopwatchModel {
  /// ストップウォッチの一意識別子（UUID）
  @HiveField(0)
  final String id;

  /// ストップウォッチの名前（最大50文字、空欄可）
  @HiveField(1)
  final String name;

  /// 経過時間（秒単位、0以上）
  @HiveField(2)
  final int elapsedSeconds;

  /// 計測中かどうか
  @HiveField(3)
  final bool isRunning;

  /// ストップウォッチの作成日時
  @HiveField(4)
  final DateTime createdAt;

  const StopwatchModel({
    required this.id,
    required this.name,
    required this.elapsedSeconds,
    required this.isRunning,
    required this.createdAt,
  });

  /// オブジェクトのコピーを作成する（不変性を保つため）
  ///
  /// 指定されたフィールドのみを更新した新しいインスタンスを返す
  StopwatchModel copyWith({
    String? id,
    String? name,
    int? elapsedSeconds,
    bool? isRunning,
    DateTime? createdAt,
  }) {
    return StopwatchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// JSONからStopwatchModelを生成する
  ///
  /// [json] デシリアライズ対象のJSONマップ
  factory StopwatchModel.fromJson(Map<String, dynamic> json) {
    return StopwatchModel(
      id: json["id"] as String,
      name: json["name"] as String,
      elapsedSeconds: json["elapsedSeconds"] as int,
      isRunning: json["isRunning"] as bool,
      createdAt: DateTime.parse(json["createdAt"] as String),
    );
  }

  /// StopwatchModelをJSONに変換する
  ///
  /// 戻り値: シリアライズされたJSONマップ
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "elapsedSeconds": elapsedSeconds,
      "isRunning": isRunning,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
