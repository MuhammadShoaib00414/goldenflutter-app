import 'package:flutter/material.dart';
import 'package:goldexia_fx/services/local_db/local_storage.dart';
import 'package:goldexia_fx/utils/dialogs/notification_permission_dialog.dart';
import 'package:goldexia_fx/views/screens/admin/signals_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    
    super.initState();
      if (!LocalStorageService.instance.hasAskedNotificationPermission) {
      Future.delayed(Duration(seconds: 1), () async {
        await NotificationPermissionDialog.show();
      });
    }
  //    WidgetsBinding.instance.addPostFrameCallback((_) {
  //     forceReportDialog(context);
  // });
  }
  @override
  Widget build(BuildContext context) {
    return SignalsScreen();
  }
}