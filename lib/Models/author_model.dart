class Author {
  final int id;
  final String authorName;

  Author({required this.id, required this.authorName});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(id: json['id'], authorName: json['authorName']);
  }
}
