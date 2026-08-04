import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';
import 'package:aunjai/models/analysis_result.dart';

class AnalysisService {
  final Dio _dio = ApiClient().dio;

  Future<AnalysisResult> analyzeChat(
      List<String> messages, String platform) async {
    final response = await _dio.post(
      ApiConfig.analyze,
      data: {
        'analysis_type': 'chat',
        'input_data': {
          'conversation': messages,
          'platform': platform,
        },
        'platform': platform,
      },
    );
    return AnalysisResult.fromJson(response.data);
  }

  Future<AnalysisResult> analyzeImage(
      List<XFile> images, String platform) async {
    final base64Images = <String>[];
    for (final image in images) {
      final bytes = await image.readAsBytes();
      final b64 = base64Encode(bytes);
      final ext = image.path.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      base64Images.add('data:$mimeType;base64,$b64');
    }

    final response = await _dio.post(
      ApiConfig.analyze,
      data: {
        'analysis_type': 'image',
        'input_data': {
          'image': base64Images.first,
          'platform': platform,
        },
        'platform': platform,
      },
    );
    return AnalysisResult.fromJson(response.data);
  }

  Future<AnalysisResult> analyzeLink(String url, String platform) async {
    final response = await _dio.post(
      ApiConfig.analyze,
      data: {
        'analysis_type': 'link',
        'input_data': {
          'url': url,
          'platform': platform,
        },
        'platform': platform,
      },
    );
    return AnalysisResult.fromJson(response.data);
  }

  Future<AnalysisResult> analyzeFakeNews(
      String content, String source, String platform) async {
    final response = await _dio.post(
      ApiConfig.analyze,
      data: {
        'analysis_type': 'fake_news',
        'input_data': {
          'content': content,
          'source': source,
          'platform': platform,
        },
        'platform': platform,
      },
    );
    return AnalysisResult.fromJson(response.data);
  }

  Future<AnalysisResult> analyzePhone(
      String phoneNumber, List<String> conversation, String platform) async {
    final response = await _dio.post(
      ApiConfig.analyze,
      data: {
        'analysis_type': 'phone',
        'input_data': {
          'phone_number': phoneNumber,
          'conversation': conversation,
          'platform': platform,
        },
        'platform': platform,
      },
    );
    return AnalysisResult.fromJson(response.data);
  }

  String getErrorMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['detail'] != null) {
      return e.response!.data['detail'];
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'การวิเคราะห์หมดเวลา กรุณาลองใหม่';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'ไม่สามารถเชื่อมต่อเซิร์ฟเวอร์ได้';
    }
    return 'เกิดข้อผิดพลาดในการวิเคราะห์';
  }
}
