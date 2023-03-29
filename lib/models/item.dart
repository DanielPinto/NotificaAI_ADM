class Item {
  String title;
  String body;
  String date;
  String description;
  bool status;
  String id;
  String users;
  List<dynamic> zones;
  Item(
      {required this.title,
      required this.body,
      required this.date,
      required this.description,
      required this.status,
      required this.id,
      required this.users,
      required this.zones});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'date': date,
        'description': description,
        'status': status,
        'users': users,
        'zones': zones
      };

  static Item fromJson(Map<String, dynamic> json) => Item(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        date: json['date'],
        description: json['description'],
        status: json['status'],
        users: json['users'],
        zones: json['zones'],
      );
}
