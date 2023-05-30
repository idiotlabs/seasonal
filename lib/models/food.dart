class Food {
  final int id;
  final String name;
  final String description;
  final String image;
  final List? months;

  const Food({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.months,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      months: json['months'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['months'] = months;
    return data;
  }
}