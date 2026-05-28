class ApiUrl {
  const ApiUrl._();

  static const me = '/me';
  static const authFirebase = '/auth/firebase';
  static const authPhoneRegister = '/auth/phone/register';
  static const authPhoneLogin = '/auth/phone/login';
  static const authLogout = '/auth/logout';
  static const plans = '/plans';
  static const notifications = '/notifications';
  static const deviceTokens = '/device-tokens';

  static String plan(String planId) => '/plans/$planId';
  static String planTasks(String planId) => '/plans/$planId/tasks';
  static String planTask(String planId, String taskId) =>
      '/plans/$planId/tasks/$taskId';
  static String planNotes(String planId) => '/plans/$planId/notes';
  static String planActivity(String planId) => '/plans/$planId/activity';
  static String planInvites(String planId) => '/plans/$planId/invites';
  static String notificationRead(String notificationId) =>
      '/notifications/$notificationId/read';
  static String upload(String driver) => '/uploads/$driver';
}
