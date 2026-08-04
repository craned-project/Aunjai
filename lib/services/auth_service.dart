import 'package:dio/dio.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';
import 'package:aunjai/services/storage_service.dart';
import 'package:aunjai/core/auth_notifier.dart';

class AuthService {
  final Dio _dio = ApiClient().dio;
  final StorageService _storage = StorageService();
  final AuthNotifier _authNotifier = AuthNotifier();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );
      final token = response.data['access_token'];
      await _storage.saveToken(token);
      _authNotifier.login();
      return true;
    } on DioException {
      rethrow;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? phone,
    String? province,
  }) async {
    try {
      await _dio.post(
        ApiConfig.register,
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          if (province != null) 'province': province,
        },
      );
      return true;
    } on DioException {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    _authNotifier.logout();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.hasToken();
  }

  String getErrorMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['detail'] != null) {
      return e.response!.data['detail'];
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'การเชื่อมต่อหมดเวลา กรุณาลองใหม่';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้';
    }
    return 'เกิดข้อผิดพลาด กรุณาลองใหม่';
  }
}
