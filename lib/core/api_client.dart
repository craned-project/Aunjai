import 'package:dio/dio.dart';
import 'package:aunjai/config/api_config.dart';
import 'package:aunjai/services/storage_service.dart';
import 'package:aunjai/core/auth_notifier.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final StorageService _storage = StorageService();
  final AuthNotifier _authNotifier = AuthNotifier();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await _storage.deleteToken();
          _authNotifier.logout();
        }
        return handler.next(error);
      },
    ));
  }
}
