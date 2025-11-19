import 'package:movies_app_graduation_project/features/home/data/models/movie_model.dart';

class MovieRepository {
  // Mock data - in production, this would come from an API
  static List<MovieModel> getAvailableNowMovies() {
    return [
      MovieModel(
        id: '2',
        title: 'Baby Driver',
        tagline: 'ATLANTA',
        posterPath: 'assets/images/movies_posters_2.png',
        rating: 7.7,
        cast: [
          'ANSEL ELGORT',
          'KEVIN SPACEY',
          'LILY JAMES',
          'EIZA GONZALEZ',
          'JON HAMM',
          'JAMIE FOXX',
        ],
      ),
      MovieModel(
        id: '1',
        title: '1917',
        tagline: 'TIME IS THE ENEMY',
        posterPath: 'assets/images/movies_posters_1.png',
        rating: 7.7,
      ),
      MovieModel(
        id: '3',
        title: 'Captain America: The First Avenger',
        posterPath: 'assets/images/movies_posters_3.png',
        rating: 7.7,
      ),
    ];
  }

  static List<MovieModel> getActionMovies() {
    return [
      MovieModel(
        id: '5',
        title: 'Black Widow',
        tagline: 'MARVEL STUDIOS',
        posterPath: 'assets/images/movies_posters_5.png',
        rating: 7.7,
        category: 'Action',
      ),
      MovieModel(
        id: '4',
        title: 'The Dark Knight',
        tagline: 'WELCOME TO A WORLD WITHOUT RULES',
        posterPath: 'assets/images/movies_posters_4.png',
        rating: 7.7,
        category: 'Action',
      ),
      MovieModel(
        id: '3',
        title: 'Captain America: The First Avenger',
        posterPath: 'assets/images/movies_posters_3.png',
        rating: 7.7,
        category: 'Action',
      ),
      MovieModel(
        id: '6',
        title: 'Avengers',
        posterPath: 'assets/images/movies_posters_6.png',
        rating: 7.7,
        category: 'Action',
      ),
    ];
  }

  static List<MovieModel> getMoviesByCategory(String category) {
    return getActionMovies();
  }

  static List<String> getCategories() {
    return [
      'Action',
      'Adventure',
      'Animation',
      'Biography',
      'Comedy',
      'Crime',
      'Drama',
      'Fantasy',
      'Horror',
      'Sci-Fi',
    ];
  }
}
