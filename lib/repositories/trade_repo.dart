import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/trade_report.dart';
import 'package:goldexia_fx/providers/trade_provider.dart';
import 'package:goldexia_fx/services/base_controller.dart';
import 'package:goldexia_fx/services/base_service.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/logs.dart';
import 'package:goldexia_fx/utils/res/app_urls.dart';

class ReportRepo extends BaseService with BaseController {
  Future<ApiResponse<TradeReport?>> getReport(FilterType filter) async {
    try {
      String endpoint = _getEndpoint(filter);

      final res = await get(endpoint);
      if (res == null) {
        return ApiResponse.error('Something went wrong');
      }

      return ApiResponse.success(TradeReport.fromMap(res));
    } catch (e) {
      Log.ex(e, name: 'Trade Report Repo');
      return handleError(e);
    }
  }

  final user = UserSession.currentUser?.user?.role;
  String _getEndpoint(FilterType filter) {
    if (filter == FilterType.daily) {
      if (user == "user") {
        return AppUrls.tradeReportDailyofUser;
      } else {
        return AppUrls.tradeReportDailyofAdmin;
      }
    } else if (filter == FilterType.weekly) {
      if (user == "user") {
        return AppUrls.tradeReportWeeklyofUser;
      } else {
        return AppUrls.tradeReportWeeklyofAdmin;
      }
    } else if (filter == FilterType.monthly) {
      if (user == "user") {
        return AppUrls.tradeReportMonthlyofUser;
      } else {
        return AppUrls.tradeReportMonthlyofAdmin;
      }
    } else {
      if (user == "user") {
        return AppUrls.tradeReportYearlyofUser;
      } else {
        return AppUrls.tradeReportYearlyofAdmin;
      }
    }
  }
}
