import 'package:dio/dio.dart';
import 'package:aunjai/core/api_client.dart';
import 'package:aunjai/config/api_config.dart';
import 'package:aunjai/models/analysis_result.dart';

class ConversationService {
  final Dio _dio = ApiClient().dio;

  Future<String> startConversation() async {
    final response = await _dio.post(ApiConfig.conversationStart);
    return response.data['id'];
  }

  Future<Map<String, dynamic>> sendMessage(
      String conversationId, String content) async {
    final response = await _dio.post(
      ApiConfig.conversationMessage(conversationId),
      data: {'role': 'user', 'content': content},
    );
    final messages = List<Map<String, dynamic>>.from(
        response.data['messages'] ?? []);
    final lastAssistant = messages.lastWhere(
      (m) => m['role'] == 'assistant',
      orElse: () => {'content': ''},
    );
    return {
      'messages': messages,
      'ai_response': lastAssistant['content'] ?? '',
      'status': response.data['status'],
    };
  }

  Future<AnalysisResult?> stopConversation(String conversationId) async {
    final response = await _dio.post(
      ApiConfig.conversationStop(conversationId),
    );
    final analysisResult = response.data['analysis_result'];
    if (analysisResult != null) {
      return AnalysisResult.fromJson(analysisResult);
    }
    return null;
  }

  String getErrorMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['detail'] != null) {
      return e.response!.data['detail'];
    }
    return 'เกิดข้อผิดพลาดในการสนทนา';
  }
}
