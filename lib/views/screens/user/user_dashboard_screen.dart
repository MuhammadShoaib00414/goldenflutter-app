import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/user.dart';
import 'package:goldexia_fx/providers/upload_proof_provider.dart';
import 'package:goldexia_fx/providers/videos_provider.dart';
import 'package:goldexia_fx/services/base_service.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/report_pref.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/screens/user/componets/pending_screen.dart';
import 'package:goldexia_fx/views/screens/user/componets/rejected_screen.dart';
import 'package:goldexia_fx/views/screens/user/componets/subscription_expire.dart';
import 'package:goldexia_fx/views/screens/user/componets/video_tutorial.dart';
import 'package:goldexia_fx/views/screens/user/links_screen.dart';
import 'package:goldexia_fx/views/screens/user/subscription.dart';
import 'package:goldexia_fx/views/screens/user/upload_image.dart';
import 'package:provider/provider.dart';
import '../../../services/local_db/local_storage.dart';
import '../../../utils/dialogs/notification_permission_dialog.dart';
import '../admin/signals_screen.dart';
import 'profile_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _DasboardScreenState();
}

class _DasboardScreenState extends State<UserDashboardScreen>
    with WidgetsBindingObserver {
  Timer? expiryDate;
  List<Widget> screens = [];
  int screenIndex = 0;
  bool get isSubscriptionLoading {
    return UserSession.currentUser?.user?.subscriptionExpire == null;
  }

  bool get isSubscriptionExpired {
    final expiry = UserSession.currentUser?.user?.subscriptionExpire;
    if (expiry == null) return false; // still loading
    return DateTime.now().isAfter(expiry);
  }

  @override
  void initState() {
    Log.d('user status ${UserSession.currentUser?.user?.status}');
    LocalStorageService.instance.setOnboardingCompleted(true);
    if (!LocalStorageService.instance.hasAskedNotificationPermission) {
      Future.delayed(Duration(seconds: 1), () async {
        await NotificationPermissionDialog.show();
      });
    }
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
      forceReportDialog(context);
  });
    WidgetsBinding.instance.addObserver(this);
   
  context.read<ProofUploadsProvider>().fetchProofs();
    _loadSubscriptionExpiry();
  }

  void _setupExpiryTimer() {
    final expireDate = UserSession.currentUser?.user?.subscriptionExpire;

    if (expireDate == null) {
      Log.d(AppStrings.subscriptionsdateNotLoaded);
      return;
    }

    expiryDate?.cancel();

    final now = DateTime.now();
    if (expireDate.isAfter(now)) {
      final duration = expireDate.difference(now);

      expiryDate = Timer(duration, () {
        if (!mounted) return;
        setState(() {
          screenIndex = 0;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    expiryDate?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _loadSubscriptionExpiry() async {
    try {
      final user = await UserDataService().getUserData();

      if (user?.user?.subscriptionExpire != null) {
        // update ONLY expiry date
        UserSession.currentUser = UserSession.currentUser?.copyWith(
          user: user?.user,
        );
        _setupExpiryTimer();
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Failed to load user data: $e');
    }
  }

  Widget _buildHome(ProofUploadsProvider provider) {
  final status=UserSession.currentUser?.user?.status;

    if (!provider.isApproved) {
      return const SizedBox();
    }

    if (isSubscriptionLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (!isSubscriptionExpired && status =="1") {
      return SignalsScreen();
    }
   
    return SubscriptionExpiredScreen();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProofUploadsProvider>();
    final videosProvider = context.watch<VideosProvider>();

    if (provider.isNewUser) {
      screens = [
        LinksScreen(),
        SubscriptionScreen(),
        UploadImageScreen(),
        VideoTutorialScreen(),
        ProfileScreen(),
      ];
    } else if (provider.isApproved) {
      screens = [_buildHome(provider),VideoTutorialScreen(), ProfileScreen()];
    }

    
    if (provider.proofUploads.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (provider.isPending) {
      return const PendingScreen();
    }

    if (provider.isRejected) {
      return RejectedScreen(reason: provider.rejectionReason);
    }

    return Scaffold(
      body: screens[screenIndex],
      extendBody: true,
      bottomNavigationBar: (provider.isApproved || provider.isNewUser) && !videosProvider.isFullScreen
          ? _buildBottomNav(provider)
          : null,
    );
  }

  Widget _buildBottomNav(ProofUploadsProvider provider) {
    List<Map<String, dynamic>> items = [];

    if (provider.isNewUser) {
      items = [
        {'icon': Icons.link, 'label': AppStrings.link},
        {'icon': Icons.subscriptions, 'label': AppStrings.subscription},
        {'icon': Icons.upload_file_outlined, 'label': AppStrings.uploadDoc},
        {'icon':  Icons.play_circle_outline, 'label': AppStrings.watch},
        {'icon': CupertinoIcons.profile_circled, 'label': AppStrings.profile},
      ];
    } else if (provider.isApproved) {
      if (isSubscriptionExpired) {
        items = [
          {
            'icon': Icons.subscriptions,
            'label': AppStrings.subscription,
          },
          {'icon':  Icons.play_circle_outline, 'label': AppStrings.watch},
          {'icon': CupertinoIcons.profile_circled, 'label': AppStrings.profile},
        ];
      } else {
        items = [
          {
            'icon': Icons.signal_cellular_alt_outlined,
            'label': AppStrings.signal,
          },
          {'icon':  Icons.play_circle_outline, 'label': AppStrings.watch},
          {'icon': CupertinoIcons.profile_circled, 'label': AppStrings.profile},
        ];
      }
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.black.withValues(alpha: 0.7),
            AppColors.black.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = screenIndex == index;
          
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      screenIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            item['icon'],
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey.withValues(alpha: 0.7),
                            size: isSelected ? 24 : 22,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.grey.withValues(alpha: 0.7),
                            fontSize: isSelected ? 11 : 10,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          child: Text(
                            item['label'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class UserDataService extends BaseService {
  Future<User?> getUserData() async {
    final response = await get('/user');
    return User.fromMap(response['data']);
  }
}









