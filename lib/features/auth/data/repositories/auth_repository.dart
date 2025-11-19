import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:movies_app_graduation_project/core/prefs_manager/prefs_manager.dart';
import 'package:movies_app_graduation_project/features/auth/data/models/user_model.dart';

class AuthRepository {
  final PrefsManager _prefsManager;

  AuthRepository(this._prefsManager);

  // Storage keys
  static const String _keyToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsers =
      'stored_users'; // Store registered users locally

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get stored users
      final usersJson = _prefsManager.getString(_keyUsers);
      if (usersJson == null) {
        throw Exception('No user found for that email.');
      }

      final users = jsonDecode(usersJson) as Map<String, dynamic>;
      final userKey = email.trim().toLowerCase();

      if (!users.containsKey(userKey)) {
        throw Exception('No user found for that email.');
      }

      final userData = users[userKey] as Map<String, dynamic>;
      final storedPassword = userData['password'] as String?;

      if (storedPassword != password) {
        throw Exception('Wrong password provided.');
      }

      // Create user model from stored data
      final user = UserModel(
        id: userData['id'] as String,
        name: userData['name'] as String? ?? 'User',
        email: userData['email'] as String? ?? email.trim(),
        phone: userData['phone'] as String? ?? '',
        avatar: userData['avatar'] as String? ?? 'assets/images/avt_1.png',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Save user data
      await _saveUserData(user);
      return user;
    } catch (e) {
      if (e.toString().contains('No user found') ||
          e.toString().contains('Wrong password')) {
        rethrow;
      }
      throw Exception('Login failed. Please try again.');
    }
  }

  /// Register new user
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String avatar,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get stored users
      final usersJson = _prefsManager.getString(_keyUsers);
      Map<String, dynamic> users = {};
      if (usersJson != null) {
        users = jsonDecode(usersJson) as Map<String, dynamic>;
      }

      final userKey = email.trim().toLowerCase();

      // Check if user already exists
      if (users.containsKey(userKey)) {
        throw Exception('An account already exists for that email.');
      }

      // Validate password
      if (password.length < 6) {
        throw Exception('The password provided is too weak.');
      }

      // Create new user
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = UserModel(
        id: userId,
        name: name,
        email: email.trim(),
        phone: phone,
        avatar: avatar,
        token: 'mock_token_$userId',
      );

      // Store user in local storage
      users[userKey] = {
        'id': userId,
        'name': name,
        'email': email.trim(),
        'phone': phone,
        'avatar': avatar,
        'password':
            password,
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _prefsManager.setString(_keyUsers, jsonEncode(users));

      // Save user data
      await _saveUserData(user);
      return user;
    } catch (e) {
      if (e.toString().contains('already exists') ||
          e.toString().contains('too weak')) {
        rethrow;
      }
      throw Exception('Registration failed. Please try again.');
    }
  }

  /// Send password reset email
  Future<void> forgotPassword(String email) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Get stored users
      final usersJson = _prefsManager.getString(_keyUsers);
      if (usersJson == null) {
        throw Exception('No user found for that email.');
      }

      final users = jsonDecode(usersJson) as Map<String, dynamic>;
      final userKey = email.trim().toLowerCase();

      if (!users.containsKey(userKey)) {
        throw Exception('No user found for that email.');
      }

      if (kDebugMode) {
        debugPrint('Password reset email would be sent to: $email');
      }
    } catch (e) {
      if (e.toString().contains('No user found')) {
        rethrow;
      }
      throw Exception('Failed to send password reset email.');
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final isLoggedIn = _prefsManager.getBool(_keyIsLoggedIn) ?? false;
      if (!isLoggedIn) {
        return null;
      }

      final userId = _prefsManager.getString(_keyUserId);
      if (userId == null) {
        await _clearUserData();
        return null;
      }

      // Get stored users
      final usersJson = _prefsManager.getString(_keyUsers);
      if (usersJson == null) {
        await _clearUserData();
        return null;
      }

      final users = jsonDecode(usersJson) as Map<String, dynamic>;

      // Find user by ID
      Map<String, dynamic>? userData;

      for (var entry in users.entries) {
        if (entry.value is Map<String, dynamic>) {
          final data = entry.value as Map<String, dynamic>;
          if (data['id'] == userId) {
            userData = data;
            break;
          }
        }
      }

      if (userData == null) {
        await _clearUserData();
        return null;
      }

      final user = UserModel(
        id: userData['id'] as String,
        name: userData['name'] as String? ?? 'User',
        email: userData['email'] as String? ?? '',
        phone: userData['phone'] as String? ?? '',
        avatar: userData['avatar'] as String? ?? 'assets/images/avt_1.png',
        token: _prefsManager.getString(_keyToken) ?? '',
      );

      return user;
    } catch (e) {
      await _clearUserData();
      return null;
    }
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _prefsManager.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Logout
  Future<void> logout() async {
    await _clearUserData();
  }

  /// Clear user data from local storage
  Future<void> _clearUserData() async {
    await _prefsManager.remove(_keyToken);
    await _prefsManager.remove(_keyUserId);
    await _prefsManager.remove(_keyUserData);
    await _prefsManager.setBool(_keyIsLoggedIn, false);
  }

  /// Save user data to local storage
  Future<void> _saveUserData(UserModel user) async {
    await _prefsManager.setString(_keyToken, user.token ?? '');
    await _prefsManager.setString(_keyUserId, user.id);
    await _prefsManager.setBool(_keyIsLoggedIn, true);
  }
}
