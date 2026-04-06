import 'dart:convert';

BatchResponse batchResponseFromJson(String str) =>
    BatchResponse.fromJson(json.decode(str));

String batchResponseToJson(BatchResponse data) => json.encode(data.toJson());

class BatchResponse {
  final String? message;
  final List<BatchData> data;

  const BatchResponse({this.message, this.data = const []});

  factory BatchResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BatchResponse();

    return BatchResponse(
      message: json["message"],
      data:
          (json["data"] as List?)?.map((e) => BatchData.fromJson(e)).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.map((e) => e.toJson()).toList(),
  };
}

class BatchData {
  final int? id;
  final String? batchKe;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdAt;
  final String? updatedAt;
  final List<Training> trainings;

  const BatchData({
    this.id,
    this.batchKe,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.trainings = const [],
  });

  factory BatchData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const BatchData();

    return BatchData(
      id: json["id"],
      batchKe: json["batch_ke"],
      startDate: json["start_date"] != null
          ? DateTime.tryParse(json["start_date"])
          : null,
      endDate: json["end_date"] != null
          ? DateTime.tryParse(json["end_date"])
          : null,
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      trainings:
          (json["trainings"] as List?)
              ?.map((e) => Training.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_ke": batchKe,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "trainings": trainings.map((e) => e.toJson()).toList(),
  };
}

class Training {
  final int? id;
  final String? title;
  final Pivot? pivot;

  const Training({this.id, this.title, this.pivot});

  factory Training.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Training();

    return Training(
      id: json["id"],
      title: json["title"],
      pivot: json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "pivot": pivot?.toJson(),
  };
}

class Pivot {
  final String? trainingBatchId;
  final String? trainingId;

  const Pivot({this.trainingBatchId, this.trainingId});

  factory Pivot.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const Pivot();

    return Pivot(
      trainingBatchId: json["training_batch_id"],
      trainingId: json["training_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "training_batch_id": trainingBatchId,
    "training_id": trainingId,
  };
}
