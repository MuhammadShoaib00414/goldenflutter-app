class AppUrls {
  static const String base = 'https://admin.dracademy.pk/api';
  static const String login = '/login';
  static const String register = '/register';

  static const String refreshLogin = '/refresh';
  // EMAIL VERIFY
  static const String sendEmailOtp = '/otp/email/send';
  static const String verifyEmailOtp = '/otp/email/verify';
  // RESET PASSWORD VERIFY
  static const String sendPasswordOtp = '/otp/password/send';
  static const String verifyPasswordOtp = '/otp/password/verify';

  static const String resetPassword = '/password/reset';

  static const String uploadProof = '/user/upload-proof';

  static const String registerFcmToken = '/user/fcm-token';

  static const String subscriptions = '/subscriptions';

  static const String signals = '/signals';
  static const String createSignal = '/admin/signals';
   static const String updateSignal = '/admin/signals//{signal_id}';
   static const String deleteSignal = '/admin/signals//{signal_id}';

  
  static const String videos = '/videos';
  static const String proofUploads="/user/proof-uploads";
   static const String tradeReportDailyofAdmin =
      '/admin/reports/trades/daily';
      static const String tradeReportWeeklyofAdmin =
      '/admin/reports/trades/weekly';

  static const String tradeReportMonthlyofAdmin =
      '/admin/reports/trades/monthly';

  static const String tradeReportYearlyofAdmin =
      '/admin/reports/trades/yearly';


static const String tradeReportDailyofUser =
      '/reports/trades/daily';
static const String tradeReportWeeklyofUser =
      '/reports/trades/weekly';

  static const String tradeReportMonthlyofUser =
      '/reports/trades/monthly';

  static const String tradeReportYearlyofUser =
      '/reports/trades/yearly';

  

  AppUrls._();
}
