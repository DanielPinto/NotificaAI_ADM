class Zone {
  String description;
  String sigla;
  String id;

  Zone({required this.description, required this.sigla, required this.id});

  Map<String, dynamic> toJson() =>
      {'description': description, 'sigla': sigla, 'id': id};

  static Zone fromJson(Map<String, dynamic> json) => Zone(
      description: json['description'], sigla: json['sigla'], id: json['id']);
}
