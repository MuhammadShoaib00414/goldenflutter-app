import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldexia_fx/providers/login_screen_provider.dart';
import 'package:goldexia_fx/providers/on_boarding_provider.dart';
import 'package:goldexia_fx/providers/profile_provider.dart';
import 'package:goldexia_fx/providers/signal_list_provider.dart';
import 'package:goldexia_fx/providers/trade_provider.dart';
import 'package:goldexia_fx/providers/upload_image_provider.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/providers/videos_provider.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/views/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/app_providers.dart';
import 'services/local_db/local_storage.dart';
import 'services/notification/notification_service.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorageService.init();
  NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UploadImageProvider()),
          ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => SignalProvider()),
          ChangeNotifierProvider(create: (_)=>LoginScreenProvider()),
          ChangeNotifierProvider(create:(_)=>VideosProvider()),
          ChangeNotifierProvider(create: (_)=>ProofUploadsProvider()),
          ChangeNotifierProvider(create: (_)=>TradeReportProvider())
        ],
        child: MaterialApp(
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // or any color you want
              statusBarIconBrightness: Brightness.light, // white icons
              statusBarBrightness: Brightness.dark, // for iOS
            ),
            child: SafeArea(child: child!),
          ),

          navigatorKey: Nav.key,
          debugShowCheckedModeBanner: false,
          title: 'Goldexia FX',

          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackgrounColor,
            primaryColor: AppColors.primary,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.black,
              surfaceTintColor: AppColors.black,
              foregroundColor: AppColors.white,
              centerTitle: true,
            ),
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackgrounColor,
            primaryColor: AppColors.primary,

            appBarTheme: AppBarTheme(
              surfaceTintColor: Colors.black45,
              backgroundColor: AppColors.black,
              foregroundColor: AppColors.white,
              centerTitle: true,
            ),
          ),
          themeMode: ThemeMode.dark,
          home: 
          SplashScreen(),
        ),
      ),
    );
  }
}
