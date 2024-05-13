class Genre {
  final int id;
  final String genreName;

  Genre({required this.id, required this.genreName});
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(id: json['id'], genreName: json['genreName']);
  }
}
