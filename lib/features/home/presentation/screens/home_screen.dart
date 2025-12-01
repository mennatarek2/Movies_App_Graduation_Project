import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:movies_app_graduation_project/core/resources/colors.dart';
import 'package:movies_app_graduation_project/core/routes/app_routes.dart';
import 'package:movies_app_graduation_project/features/home/data/models/movie_model.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/search_tab.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/browse_tab.dart';
import 'package:movies_app_graduation_project/features/home/presentation/screens/profile_tab.dart';
import 'package:movies_app_graduation_project/providers/movie_provider.dart';
import 'package:movies_app_graduation_project/providers/search_provider.dart';
import 'package:movies_app_graduation_project/features/home/data/repositories/movie_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _searchProvider = SearchProvider(context.read<MovieRepository>());
  }

  @override
  void dispose() {
    _searchProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const HomeTab(),
          ChangeNotifierProvider<SearchProvider>.value(
            value: _searchProvider,
            child: const SearchTab(),
          ),
          const BrowseTab(),
          const ProfileTab(),
        ],
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
    final movieProvider = context.watch<MovieProvider>();
    final availableMovies = movieProvider.availableNow;
    final actionMovies = movieProvider.actionMovies;

    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<MovieProvider>().loadHomeData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Image.asset(
                  'assets/images/available_now.png',
                  height: 70,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      'Available Now',
                      style: GoogleFonts.dancingScript(
                        fontSize: 70,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildAvailableSection(movieProvider, availableMovies),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/watch_now.png',
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Text(
                      'Watch Now',
                      style: GoogleFonts.dancingScript(
                        fontSize: 100,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                        context.read<MovieProvider>().refreshCategory('Action');
                      },
                      child: Text(
                        'Refresh →',
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
              _buildActionSection(movieProvider, actionMovies),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableSection(
    MovieProvider provider,
    List<MovieModel> availableMovies,
  ) {
    if (provider.isLoading && availableMovies.isEmpty) {
      return _buildLoadingState(height: 400);
    }

    if (provider.errorMessage != null && availableMovies.isEmpty) {
      return _buildErrorState(
        message: provider.errorMessage!,
        onRetry: provider.loadHomeData,
        height: 400,
      );
    }

    if (availableMovies.isEmpty) {
      return _buildEmptyState(
        message: 'No movies found right now.',
        height: 200,
      );
    }

    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: _pageController,
        itemCount: availableMovies.length,
        itemBuilder: (context, index) {
          final movie = availableMovies[index];
          final double pageDifference = (index.toDouble() - _currentPage).abs();
          final double scale = (1.0 - (pageDifference * 0.2)).clamp(0.8, 1.0);
          final double opacity = (1.0 - (pageDifference * 0.4)).clamp(0.6, 1.0);
          return _buildMainMovieCard(movie, scale, opacity);
        },
      ),
    );
  }

  Widget _buildActionSection(
    MovieProvider provider,
    List<MovieModel> actionMovies,
  ) {
    if (provider.isLoading && actionMovies.isEmpty) {
      return _buildLoadingState(height: 200);
    }

    if (provider.errorMessage != null && actionMovies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildErrorState(
          message: provider.errorMessage!,
          onRetry: provider.loadHomeData,
          height: 160,
        ),
      );
    }

    if (actionMovies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildEmptyState(
          message: 'No action movies found.',
          height: 160,
        ),
      );
    }

    return SizedBox(
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
    );
  }

  Widget _buildLoadingState({double height = 200}) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState({
    required String message,
    required Future<void> Function() onRetry,
    double height = 200,
  }) {
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Something went wrong',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                onRetry();
              },
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({required String message, double height = 200}) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
      ),
    );
  }

  Widget _buildMainMovieCard(MovieModel movie, double scale, double opacity) {
    final isCentered = scale >= 0.95;

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
                        _buildPosterImage(
                          movie.posterPath,
                          width: 250,
                          height: 350,
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
              _buildPosterImage(movie.posterPath, width: 140, height: 200),
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

  Widget _buildPosterImage(
    String path, {
    required double width,
    required double height,
  }) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) =>
            _buildImageFallback(width, height),
      );
    }

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildImageFallback(width, height);
      },
    );
  }

  Widget _buildImageFallback(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[800],
      child: const Icon(Icons.movie, color: Colors.grey, size: 40),
    );
  }
}
