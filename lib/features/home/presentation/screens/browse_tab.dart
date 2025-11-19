import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app_graduation_project/core/resources/colors.dart';
import 'package:movies_app_graduation_project/features/home/data/models/movie_model.dart';
import 'package:movies_app_graduation_project/features/home/data/repositories/movie_repository.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  String _selectedCategory = 'Action';

  @override
  Widget build(BuildContext context) {
    final categories = MovieRepository.getCategories();
    final categoryMovies = MovieRepository.getMoviesByCategory(
      _selectedCategory,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Category Filters
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == _selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: AppColors.primary,
                                    width: 1,
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              // Movie Grid - 6 rows, 2 columns
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildMovieGrid(categoryMovies),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieGrid(List<MovieModel> movies) {
    final displayMovies = movies.length > 12 ? movies.sublist(0, 12) : movies;
    final rows = <Widget>[];

    for (int i = 0; i < displayMovies.length; i += 2) {
      final rowMovies = displayMovies.skip(i).take(2).toList();
      rows.add(
        Row(
          children: [
            for (int j = 0; j < 2; j++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: j < 1 ? 12 : 0),
                  child: j < rowMovies.length
                      ? _buildMovieGridCard(rowMovies[j])
                      : const SizedBox(),
                ),
              ),
          ],
        ),
      );
      if (i + 2 < displayMovies.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildMovieGridCard(MovieModel movie) {
    return AspectRatio(
      aspectRatio: 0.65,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.asset(
              movie.posterPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                );
              },
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
