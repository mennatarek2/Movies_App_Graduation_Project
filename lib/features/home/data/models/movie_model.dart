class MovieModel {
  final String id;
  final String title;
  final String? tagline;
  final String posterPath;
  final double rating;
  final String? category;
  final List<String>? cast;

  MovieModel({
    required this.id,
    required this.title,
    this.tagline,
    required this.posterPath,
    required this.rating,
    this.category,
    this.cast,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'tagline': tagline,
      'posterPath': posterPath,
      'rating': rating,
      'category': category,
      'cast': cast,
    };
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      tagline: json['tagline'] as String?,
      posterPath: json['posterPath'] as String,
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String?,
      cast: json['cast'] != null
          ? List<String>.from(json['cast'] as List)
          : null,
    );
  }
}

