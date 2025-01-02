class TaskModel {
  final String? id;
  final String? title;
  final String? description;
  final String? scheduleDateTime;

  TaskModel({this.id, this.title, this.description, this.scheduleDateTime});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduleDateTime: json['scheduleDateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduleDateTime': scheduleDateTime,
    };
  }
}
