class AnalysisResult {
  final String scamType;
  final String platform;
  final String riskLevel;
  final int totalRiskScore;
  final Map<String, dynamic> riskScore;
  final List<String> suggestion;
  final Map<String, dynamic> scammerInfo;
  final String? reportId;

  AnalysisResult({
    required this.scamType,
    required this.platform,
    required this.riskLevel,
    required this.totalRiskScore,
    required this.riskScore,
    required this.suggestion,
    required this.scammerInfo,
    this.reportId,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      scamType: json['scam_type'] ?? '',
      platform: json['platform'] ?? '',
      riskLevel: json['risk_level'] ?? 'low',
      totalRiskScore: json['total_risk_score'] ?? 0,
      riskScore: Map<String, dynamic>.from(json['risk_score'] ?? {}),
      suggestion: List<String>.from(json['suggestion'] ?? []),
      scammerInfo: Map<String, dynamic>.from(json['scammer_info'] ?? {}),
      reportId: json['id'],
    );
  }

  int get actionsScore =>
      (riskScore['ActionsAndRequest'] as Map?)?['Score'] ?? 0;

  String get actionsDescription =>
      (riskScore['ActionsAndRequest'] as Map?)?['description'] ?? '';

  int get identityScore =>
      (riskScore['IdentityRisk'] as Map?)?['Score'] ?? 0;

  String get identityDescription =>
      (riskScore['IdentityRisk'] as Map?)?['description'] ?? '';
}
