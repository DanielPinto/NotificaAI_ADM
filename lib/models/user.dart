class User {
  String id;
  final String title;
  final String body;
  final String date;

  User(
      {this.id = '',
      required this.title,
      required this.body,
      required this.date});

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'body': body, 'date': date};

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        date: json['date'],
      );
}
