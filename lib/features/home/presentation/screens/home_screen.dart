import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app_graduation_project/core/resources/colors.dart';
import 'package:movies_app_graduation_project/core/routes/app_routes.dart';
import 'package:movies_app_graduation_project/features/home/data/models/movie_model.dart';
import 'package:movies_app_graduation_project/features/home/data/repositories/movie_repository.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/search_tab.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/browse_tab.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: const [HomeTab(), SearchTab(), BrowseTab(), ProfileTab()],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: 'assets/images/home_icon.png',
              isSelected: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _buildNavItem(
              icon: 'assets/images/search_icon.png',
              isSelected: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
            _buildNavItem(
              icon: 'assets/images/explore_icon.png',
              isSelected: _currentIndex == 2,
              onTap: () => setState(() => _currentIndex = 2),
            ),
            _buildNavItem(
              icon: 'assets/images/Profile_icon.png',
              isSelected: _currentIndex == 3,
              onTap: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            isSelected ? AppColors.primary : Colors.white,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            icon,
            width: 28,
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.circle,
                color: isSelected ? AppColors.primary : Colors.white,
                size: 28,
              );
            },
          ),
        ),
      ),
    );
  }
}

// Home Tab
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PageController _pageController = PageController(
    viewportFraction: 0.65,
    initialPage: 1,
  );
  double _currentPage = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableMovies = MovieRepository.getAvailableNowMovies();
    final actionMovies = MovieRepository.getActionMovies();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Available Now Header - Centered
            Center(
              child: Image.asset(
                'assets/images/available_now.png',
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Available Now',
                    style: GoogleFonts.caveat(
                      fontSize: 48,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Main Movie Carousel with PageView
            SizedBox(
              height: 400,
              child: PageView.builder(
                controller: _pageController,
                itemCount: availableMovies.length,
                itemBuilder: (context, index) {
                  final movie = availableMovies[index];
                  // Calculate distance from current page 
                  final double pageDifference =
                      (index.toDouble() - _currentPage).abs();
                  final double scale = (1.0 - (pageDifference * 0.2)).clamp(
                    0.8,
                    1.0,
                  );
                  final double opacity = (1.0 - (pageDifference * 0.4)).clamp(
                    0.6,
                    1.0,
                  );
                  return _buildMainMovieCard(movie, scale, opacity);
                },
              ),
            ),
            const SizedBox(height: 16),
            // Watch Now Header
            Center(
              child: Image.asset(
                'assets/images/watch_now.png',
                height: 45,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'Watch Now',
                    style: GoogleFonts.caveat(
                      fontSize: 42,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Action Category Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Action',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      'See More →',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Action Movies List
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: actionMovies.length,
                itemBuilder: (context, index) {
                  final movie = actionMovies[index];
                  return _buildCategoryMovieCard(movie);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMovieCard(MovieModel movie, double scale, double opacity) {
    final isCentered =
        scale >= 0.95; 

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.movieDetails, arguments: movie);
                },
                child: Container(
                  width: 250,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isCentered
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20.0,
                              offset: const Offset(0.0, 10.0),
                              spreadRadius: 5.0,
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10.0,
                              offset: const Offset(0.0, 5.0),
                              spreadRadius: 2.0,
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        // Movie Poster Image
                        Image.asset(
                          movie.posterPath,
                          width: 250,
                          height: 350,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 250,
                              height: 350,
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.grey,
                                size: 50,
                              ),
                            );
                          },
                        ),
                        // Rating Badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  movie.rating.toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
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
              ),
              if (movie.tagline != null && isCentered) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    movie.tagline!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryMovieCard(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.movieDetails, arguments: movie);
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                movie.posterPath,
                width: 140,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 140,
                    height: 200,
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
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        movie.rating.toString(),
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
}
