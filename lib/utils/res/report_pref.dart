import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/user/report_screen.dart';
import 'package:goldexia_fx/views/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPreference {
  static const _key = "last_report_seen_date";

  static Future<bool> hasSeenToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().substring(0, 10);
    return prefs.getString(_key) == today;
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toString().substring(0, 10);
    await prefs.setString(_key, today);
  }
}


Future<void> forceReportDialog(BuildContext context) async {
  final seen = await ReportPreference.hasSeenToday();
  if (seen) return;

  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (context) {
      return PopScope(
        canPop: false, 
        child: AlertDialog(
          backgroundColor:  AppColors.dialogBacgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title:  Text("📊 Report",style: AppTextStyles.appBarText.copyWith(color: AppColors.amber),textAlign: TextAlign.center,),
          content:  Text(
            "Your latest performance report is ready.\n"
            "Please review it to continue.",style: AppTextStyles.s16M.copyWith(color: AppColors.white70),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child:CustomButton(onTap: () async{
                  Nav.back(); 

                  await Navigator.push(context,MaterialPageRoute(builder: (ctx)=>ReportScreen()));
                  await ReportPreference.markSeen();
             
              }, title: "Show Report")
            ),
          ],
        ),
      );
    },
  );
}
