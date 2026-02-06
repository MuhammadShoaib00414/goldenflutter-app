import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/trade_report.dart';
import 'package:goldexia_fx/providers/trade_provider.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';

class ReportCard extends StatelessWidget {
  final TradeStats stats;
  final FilterType filter;

  const ReportCard({super.key, required this.stats, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greyShade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔝 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stats.displayPeriod,
                style: AppTextStyles.s14M.copyWith(color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filter.name,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🟡 TOTAL TRADES
          StatHighlight(
            title: "Total Trades Executed",
            value: stats.totalTradesExecuted ?? 0,
          ),

          const SizedBox(height: 14),

          /// 🔢 GRID STATS
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.6,
            ),
            children: [
              _MiniStat(title: "TP1", value: stats.tp1),
              _MiniStat(title: "TP2", value: stats.tp2),
              _MiniStat(title: "TP3", value: stats.tp3),
              _MiniStat(title: "SL", value: stats.sl, isLoss: true),
            ],
          ),

          const SizedBox(height: 14),

          /// 🟢 PIPS
          _PipsStat(
            title: "Total Pips Earned",
            value: stats.totalPipsEarned ?? 0,
            isPositive: true,
          ),

          const SizedBox(height: 10),

          _PipsStat(
            title: "Total Pips Lost",
            value: stats.totalPipsLost ?? 0,
            isPositive: false,
          ),
        ],
      ),
    );
  }
}

class StatHighlight extends StatelessWidget {
  final String title;
  final int value;

  const StatHighlight({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.white70, fontSize: 14),
          ),
          Text(
            value.toString(),
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final int? value;
  final bool isLoss;

  const _MiniStat({
    required this.title,
    required this.value,
    this.isLoss = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLoss ? Colors.red : Colors.green;

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value?.toString() ?? "0",
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipsStat extends StatelessWidget {
  final String title;
  final int value;
  final bool isPositive;

  const _PipsStat({
    required this.title,
    required this.value,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.white70, fontSize: 14),
          ),
          Text(
            "${isPositive ? '+' : ''}$value",
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}





extension TradeStatsX on TradeStats {
  String get displayPeriod {
    if (date != null) {
      return date!; // 2026-01-27
    }
    if(year !=null&& week !=null){
       return "$year-Week(${week!.toString().padLeft(1, '0')})"; 
    }
    if (year != null && month != null) {
      return "$year-${month!.toString().padLeft(2, '0')}"; // 2026-01
    }

    if (year != null) {
      return year.toString(); // 2026
    }

    return "-";
  }
}
