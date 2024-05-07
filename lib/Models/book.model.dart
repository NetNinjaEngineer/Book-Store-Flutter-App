class Book {
  final int bookId;
  final List<String> authors;
  final String genre;
  final String imageUrl;
  final String title;
  final int publicationYear;
  final double price;

  Book({
    required this.bookId,
    required this.authors,
    required this.genre,
    required this.imageUrl,
    required this.title,
    required this.publicationYear,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['id'],
      authors: List<String>.from(json['authors']),
      genre: json['genre'],
      imageUrl: json['imageUrl'],
      title: json['title'],
      publicationYear: json['publicationYear'],
      price: json['price'],
    );
  }
}
