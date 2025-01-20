class ItemModel {
  final String id;
  final String title;
  final String image;
  final int value; // Ensure this is an int
  final String type;

  ItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.value,
    required this.type,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      value: json['value'] is int ? json['value'] : int.parse(json['value']), // Parse value as int
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'value': value,
      'type': type,
    };
  }
}