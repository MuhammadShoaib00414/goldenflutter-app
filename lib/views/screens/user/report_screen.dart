import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/trade_report.dart';
import 'package:goldexia_fx/providers/trade_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/widgets/report_card.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  void initState() {
    super.initState();
    // fetch report once screen opens
    Future.microtask(() {
      context.read<TradeReportProvider>().fetchReport();
    });
  }

  List<Map<String, String>> getReportCards(TradeStats stats) {
    return [
      {"title": "Total Trades", "value": stats.totalTradesExecuted.toString()},
      {"title": "TP1 Hits", "value": stats.tp1.toString()},
      {"title": "TP2 Hits", "value": stats.tp2.toString()},
      {"title": "TP3 Hits", "value": stats.tp3.toString()},
      {"title": "Stop Loss", "value": stats.sl.toString()},
      {"title": "Pips Earned", "value": stats.totalPipsEarned.toString()},
      {"title": "Pips Lost", "value": stats.totalPipsLost.toString()},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TradeReportProvider>();
    final stats = provider.stats;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppStrings.performanceReport,
          style: AppTextStyles.appBarText.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.greyShade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<FilterType>(
                  dropdownColor: AppColors.greyShade900,
                  value: provider.selectedFilter,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                  style: const TextStyle(color: AppColors.white),
                  isExpanded: true,
                  onChanged: (value) {
                    provider.changeFilter(value!);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: FilterType.daily,
                      child: Text("Daily"),
                    ),
                     DropdownMenuItem(
                      value: FilterType.weekly,
                      child: Text("Weekly"),
                    ),
                    DropdownMenuItem(
                      value: FilterType.monthly,
                      child: Text("Monthly"),
                    ),
                    DropdownMenuItem(
                      value: FilterType.yearly,
                      child: Text("Yearly"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📊 BODY
            Expanded(
              child: Builder(
                builder: (_) {
                  if (provider.report.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (provider.report.isError) {
                    return Center(
                      child: Text(
                        provider.report.message ??
                            AppStrings.somethingWentWrong,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (stats == null) {
                    return const Center(
                      child: Text(
                        AppStrings.noReportData,
                        style: TextStyle(color: AppColors.white70),
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      ReportCard(stats: stats, filter: provider.selectedFilter),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
