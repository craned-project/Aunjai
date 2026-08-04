class ApiConfig {
  static const String baseUrl = 'http://localhost:8000';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String me = '/auth/me';

  // User Profile
  static const String updateProfile = '/users/me';

  // Analysis
  static const String analyze = '/actions/analyze';

  // Conversation (Phone Mode)
  static const String conversationStart = '/conversation/start';
  static String conversationMessage(String id) => '/conversation/$id/message';
  static String conversationStop(String id) => '/conversation/$id/stop';
  static const String conversations = '/conversation/';

  // Scam Reports
  static const String scamReports = '/scam/';
  static String scamReport(String id) => '/scam/$id';

  // Blacklist
  static const String blacklistCheck = '/blacklist/check';

  // Government Report
  static const String govSubmit = '/gov/submit';

  // Notifications
  static const String notifications = '/notifications/';
}
