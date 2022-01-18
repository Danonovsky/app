class Category {
  String id;
  String name;
  Category? parentCategory;

  Category({required this.id, required this.name, this.parentCategory});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name']);
  }
}
