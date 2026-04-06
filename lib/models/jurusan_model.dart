class TrainingModel {
  final String? message;
  final List<TrainingData>? data;

  const TrainingModel({this.message, this.data});

  factory TrainingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TrainingModel();

    return TrainingModel(
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => TrainingData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class TrainingData {
  final int? id;
  final String? title;

  const TrainingData({this.id, this.title});

  factory TrainingData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const TrainingData();

    return TrainingData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
