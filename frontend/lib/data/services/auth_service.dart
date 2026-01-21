import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final user = User.fromJson(response.data);
      if (user.token != null) {
        await _storage.write(key: 'token', value: user.token);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Register
  Future<User> register(String username, String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.register,
        data: {
          'name': username, // Backend expects 'name' not 'username'
          'email': email,
          'password': password,
        },
      );

      final user = User.fromJson(response.data);
      if (user.token != null) {
        await _storage.write(key: 'token', value: user.token);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Get Profile
  Future<User> getProfile() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.profile);
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Update Profile (name/email)
  Future<User> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final response = await _apiService.dio.put(
        ApiConstants.profile,
        data: {'name': name, 'email': email},
      );
      return User.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Send Reset Email
  Future<void> sendResetEmail(String email) async {
    try {
      await _apiService.dio.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _apiService.dio.post(
        '${ApiConstants.resetPassword}/$token',
        data: {'password': newPassword},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Change Password (logged-in)
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _apiService.dio.post(
        ApiConstants.changePassword,
        data: {'currentPassword': currentPassword, 'password': newPassword},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Verify Email
  Future<void> verifyEmail(String token) async {
    try {
      await _apiService.dio.get('${ApiConstants.verifyEmail}/$token');
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }

  Stream<void> get sessionExpired => _apiService.authStateChanges;
}
