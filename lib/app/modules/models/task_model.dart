import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus {
  aguardando,
  feito,
}

extension TaskStatusExtensions on TaskStatus {
  static TaskStatus? fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return TaskStatus.aguardando;
      case 'completed':
        return TaskStatus.feito;
      default:
        return null;
    }
  }
}

class Task {
  String? id;
  String title;
  List<int> repeatDays;
  TaskStatus? status;
  DateTime? suggestedDate;
  String userId; // novo campo

  Task({
    this.id,
    required this.title,
    required this.repeatDays,
    this.status = TaskStatus.aguardando,
    this.suggestedDate,
    required this.userId, // novo campo
  });

  // ...

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'repeatDays': repeatDays,
      'status': status.toString(),
      'suggestedDate': suggestedDate?.toIso8601String(),
      'userId': userId, // novo campo
    };
  }

  Task.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        title = snapshot.data()!['title'],
        repeatDays = List<int>.from(snapshot.data()!['repeatDays']),
        status = TaskStatusExtensions.fromString(snapshot.data()!['status']),
        suggestedDate = snapshot.data()!['suggestedDate'] != null
            ? DateTime.parse(snapshot.data()!['suggestedDate'])
            : null,
        userId = snapshot.data()!['userId']; // novo campo
}