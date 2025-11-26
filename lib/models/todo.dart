class Todo {
  final String id;
  final String title;
  final DateTime date;
  final String status; 

  Todo({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'status': status,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }
}
