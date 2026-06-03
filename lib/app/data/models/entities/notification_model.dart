import 'dart:convert';

class NotificationModel {
  final String title;
  final String message;
  final DateTime createdAt;

  const NotificationModel({
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['created_at'] == null) {
      throw ArgumentError.notNull('created_at');
    }

    final parsedDate = DateTime.parse(json['created_at'] as String);

    return NotificationModel(
      title: json['title'] as String,
      message: json['message'] as String,

      createdAt: parsedDate.toLocal(),
    );
  }

  NotificationModel copyWith({
    String? title,
    String? message,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,

      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }

  String toJsonEncode() {
    return json.encode(toJson());
  }

  @override
  String toString() {
    return 'NotificationModel(title: "$title", message: "$message", createdAt: "${createdAt.toIso8601String()}")';
  }
}
