import 'dart:convert';

TradeReport tradeReportFromMap(String str) =>
    TradeReport.fromMap(json.decode(str));

class TradeReport {
  bool? success;
  String? message;
  ReportData? data;

  TradeReport({this.success, this.message, this.data});

  TradeReport copyWith({bool? success, String? message, ReportData? data}) =>
      TradeReport(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory TradeReport.fromMap(Map<String, dynamic> json) => TradeReport(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ReportData.fromMap(json["data"]),
  );
}

class ReportData {
  TradeStats? daily;
  TradeStats? weekly;
  TradeStats? monthly;
  TradeStats? yearly;

  ReportData({this.daily,this.weekly, this.monthly, this.yearly});

  factory ReportData.fromMap(Map<String, dynamic> json) => ReportData(
    daily: json["daily"] == null ? null : TradeStats.fromMap(json["daily"]),
    weekly: json["weekly"]== null ? null : TradeStats.fromMap(json["weekly"]),
    monthly: json["monthly"] == null
        ? null
        : TradeStats.fromMap(json["monthly"]),
    yearly: json["yearly"] == null ? null : TradeStats.fromMap(json["yearly"]),
  );
}

class TradeStats {
  String? date;
  int? week;
  int? year;
  int? month;
  int? totalTradesExecuted;
  int? tp1;
  int? tp2;
  int? tp3;
  int? sl;
  int? totalPipsEarned;
  int? totalPipsLost;

  TradeStats({
    this.date,
    this.week,
    this.month,
    this.year,
    this.totalTradesExecuted,
    this.tp1,
    this.tp2,
    this.tp3,
    this.sl,
    this.totalPipsEarned,
    this.totalPipsLost,
  });

  factory TradeStats.fromMap(Map<String, dynamic> json) => TradeStats(
    date: json["date"],
    week: json["week"],
    month: json["month"],
    year: json["year"],
    totalTradesExecuted: json["total_trades_executed"],
    tp1: json["tp1"],
    tp2: json["tp2"],
    tp3: json["tp3"],
    sl: json["sl"],
    totalPipsEarned: json["total_pips_earned"],
    totalPipsLost: json["total_pips_lost"],
  );
}
