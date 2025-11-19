import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:movies_app_graduation_project/core/resources/colors.dart';
import 'package:movies_app_graduation_project/core/routes/app_routes.dart';
import 'package:movies_app_graduation_project/features/home/data/models/movie_model.dart';
import 'package:movies_app_graduation_project/features/home/data/repositories/movie_repository.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/edit_profile_screen.dart';
import 'package:movies_app_graduation_project/providers/auth_provider.dart';
import 'package:movies_app_graduation_project/providers/favorites_provider.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  int _selectedTab = 0; // 0 = Watch List, 1 = History
  String _userName = 'Menna Tarek';
  String _userAvatar = 'assets/images/avt_2.png';
  int _historyCount = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Header Section - Avatar and Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left side - Avatar and Name
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage: AssetImage(_userAvatar),
                          ),
                          const SizedBox(height: 16),
                          // User Name
                          Text(
                            _userName,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Right side - Stats (horizontal)
                    Consumer<FavoritesProvider>(
                      builder: (context, favoritesProvider, _) {
                        final wishListCount =
                            favoritesProvider.favoriteMovieIds.length;
                        return Row(
                          children: [
                            _buildStatItem('$wishListCount', 'Wish List'),
                            const SizedBox(width: 32),
                            _buildStatItem('$_historyCount', 'History'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Edit Profile Button (2/3 width)
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  userName: _userName,
                                  userAvatar: _userAvatar,
                                  onProfileUpdated: (name, avatar) {
                                    setState(() {
                                      _userName = name;
                                      _userAvatar = avatar;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Exit Button (1/3 width)
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Exit',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Tab Navigator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabItem(
                        icon: Icons.list_alt,
                        label: 'Watch List',
                        isSelected: _selectedTab == 0,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTabItem(
                        icon: Icons.folder,
                        label: 'History',
                        isSelected: _selectedTab == 1,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Tab Content
              _buildTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    if (_selectedTab == 0) {
      // Watch List - Show Favorite Movies
      return Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          final favoriteIds = favoritesProvider.favoriteMovieIds;

          if (favoriteIds.isEmpty) {
            // Empty State
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Image.asset(
                  'assets/images/search_tab_image.png',
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 100,
                    );
                  },
                ),
              ),
            );
          }

          // Get all movies and filter favorites
          final allMovies = [
            ...MovieRepository.getAvailableNowMovies(),
            ...MovieRepository.getActionMovies(),
          ];
          final favoriteMovies = allMovies
              .where((movie) => favoriteIds.contains(movie.id))
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildMovieGrid(favoriteMovies),
          );
        },
      );
    } else {
      // History - Movie Grid
      final historyMovies = MovieRepository.getActionMovies();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildMovieGrid(historyMovies),
      );
    }
  }

  Widget _buildMovieGrid(List<MovieModel> movies) {
    final displayMovies = movies.length > 12 ? movies.sublist(0, 12) : movies;
    final rows = <Widget>[];

    for (int i = 0; i < displayMovies.length; i += 3) {
      final rowMovies = displayMovies.skip(i).take(3).toList();
      rows.add(
        Row(
          children: [
            for (int j = 0; j < 3; j++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: j < 2 ? 12 : 0),
                  child: j < rowMovies.length
                      ? _buildMovieCard(rowMovies[j])
                      : const SizedBox(),
                ),
              ),
          ],
        ),
      );
      if (i + 3 < displayMovies.length) {
        rows.add(const SizedBox(height: 12));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildMovieCard(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.movieDetails, arguments: movie);
      },
      child: AspectRatio(
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
                    child: const Icon(
                      Icons.movie,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
              // Rating Badge
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.primary,
                        size: 14,
                      ),
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
      ),
    );
  }

  Future<void> _handleLogout() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    if (!mounted) return;

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }
}
