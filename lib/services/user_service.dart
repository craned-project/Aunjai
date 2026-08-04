import 'package:dio/dio.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';

class UserProfile {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String? province;
  final String role;
  final bool isVerified;
  final String createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.province,
    required this.role,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      province: json['province'],
      role: json['role'] ?? 'user',
      isVerified: json['is_verified'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class UserService {
  final Dio _dio = ApiClient().dio;

  Future<UserProfile> getProfile() async {
    final response = await _dio.get(ApiConfig.me);
    return UserProfile.fromJson(response.data);
  }

  Future<UserProfile> updateProfile({
    String? username,
    String? email,
    String? phone,
    String? province,
    String? password,
  }) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (province != null) data['province'] = province;
    if (password != null) data['password'] = password;

    final response = await _dio.put(ApiConfig.updateProfile, data: data);
    return UserProfile.fromJson(response.data);
  }

  String getErrorMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['detail'] != null) {
      return e.response!.data['detail'];
    }
    return 'เกิดข้อผิดพลาด กรุณาลองใหม่';
  }
}
