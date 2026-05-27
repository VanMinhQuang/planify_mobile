class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api/v1',
  );

  static const realtimeUrl = String.fromEnvironment(
    'REALTIME_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  static const uploadMode = String.fromEnvironment(
    'UPLOAD_MODE',
    defaultValue: 'firebase',
  );
}
