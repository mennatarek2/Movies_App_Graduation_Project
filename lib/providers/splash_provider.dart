import 'package:flutter/foundation.dart';

/// Provider for splash screen state management
class SplashProvider with ChangeNotifier {
  bool _isLoading = true;
  bool _isInitialized = false;

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  /// Initialize the app
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Simulate initialization tasks
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Add actual initialization logic here
    // - Check if user is logged in
    // - Load app preferences
    // - Initialize services
    // - etc.

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }

  /// Reset splash state
  void reset() {
    _isLoading = false;
    _isInitialized = false;
    notifyListeners();
  }
}
