import 'package:flutter/foundation.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/trade_report.dart';
import 'package:goldexia_fx/repositories/trade_repo.dart';

enum FilterType { daily,weekly, monthly, yearly }

class TradeReportProvider extends ChangeNotifier {
  final ReportRepo _repo = ReportRepo();

  ApiResponse<TradeReport?> report = ApiResponse.loading();

  FilterType selectedFilter = FilterType.daily;

  Future<void> fetchReport() async {
    report = ApiResponse.loading();
    notifyListeners();

    final res = await _repo.getReport(selectedFilter);
    report = res;
    notifyListeners();
  }

  void changeFilter(FilterType type) {
    selectedFilter = type;
    fetchReport();
  }

  TradeStats? get stats {
    final data = report.data?.data;
    if (data == null) return null;

    if (selectedFilter == FilterType.daily) {
      return data.daily;
    } else if (selectedFilter == FilterType.weekly) {
      return data.weekly;
    }else if (selectedFilter == FilterType.monthly) {
      return data.monthly;
    } else {
      return data.yearly;
    }
  }
}
