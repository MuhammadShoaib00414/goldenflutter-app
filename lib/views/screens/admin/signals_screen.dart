import 'package:flutter/material.dart';
import 'package:goldexia_fx/providers/profile_provider.dart';
import 'package:goldexia_fx/providers/signal_list_provider.dart';
import 'package:goldexia_fx/services/local_db/user_session.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/widgets/api_response_widget.dart';
import 'package:provider/provider.dart';

import 'create_signal_screen.dart';

class SignalsScreen extends StatefulWidget {
  const SignalsScreen({super.key});

  @override
  State<SignalsScreen> createState() => _SignalsScreenState();
}

class _SignalsScreenState extends State<SignalsScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignalProvider>().fetchSignals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.goldexiafxTradingSignal),
        actions: [
          if (UserSession.currentUser?.user?.role == 'admin')
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  profileProvider.logoutUser(context);
                },
                icon: const Icon(Icons.logout),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<SignalProvider>(
          builder: (context, provider, _) {
            return ApiResponseWidget<SignalProvider>(
              response: provider.signalsResponse,
              onRetry: provider.fetchSignals,
              emptyBuilder: (_) => Center(
                child: Text(
                  AppStrings.noSignal,
                  style: AppTextStyles.s15M.copyWith(color: AppColors.white70),
                ),
              ),
              successBuilder: (_) {
                final signals = provider.signals;

                return ListView.builder(
                  itemCount: signals.length,
                  itemBuilder: (context, index) {
                    final signal = signals[index];

                    final zoneTextColor = signal.orderType == AppStrings.buyZone
                        ? AppColors.white
                        : AppColors.white;

                    final zoneBgColor =signal.orderType == AppStrings.buyZone? AppColors.buyZoneBgColor:AppColors.redAccent;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Dismissible( 
                        key: ValueKey(signal.id),
                        direction:UserSession.isAdmin? DismissDirection.horizontal:DismissDirection.none,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: AppColors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      
                        confirmDismiss: (direction) async {
                          return await showDeleteingDialog(context);
                        },
                      
                        onDismissed: (direction) async {
                          final provider = context.read<SignalProvider>();
                          final success = await provider.deleteSignal(signal.id!);
                          
                          if (success) {
                            AppUtils.showToast('Signal deleted');
                          } else {
                            AppUtils.showToast('Failed to delete signal');
                            provider.fetchSignals(
                              showLoader: false,
                            ); // optional recovery
                          }
                        },
                      
                        child: Material(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                      
                            onTap: () async {
                              if (!UserSession.isAdmin) return;
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateSignalScreen(
                                    existingSignal: signal,
                                    isEditMode: true,
                                  ),
                                ),
                              );
                      
                              if (result == true) {
                                context.read<SignalProvider>().fetchSignals();
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  // margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:  AppColors.primary,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        signal.symbol,
                                        style: AppTextStyles.s20M.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                      
                                      Chip(
                                        backgroundColor: zoneBgColor,
                                        label: Text(
                                          signal.orderType,
                                          style: AppTextStyles.s15M.copyWith(
                                            color: zoneTextColor,
                                          ),
                                        ),
                                      ),
                      
                                      const SizedBox(height: 8),
                                      _infoRow(
                                        AppStrings.entryZone,
                                        signal.entryZone,
                                        AppColors.primary,
                                      ),
                                      _infoRow(
                                        AppStrings.stopLoss,
                                        signal.stopLoss,
                                        AppColors.redAccent,
                                      ),
                                      _infoRow(
                                        AppStrings.tp1,
                                        signal.takeProfit1,
                                        AppColors.tealAccent,
                                      ),
                                      _infoRow(
                                        AppStrings.tp2,
                                        signal.takeProfit2 ?? '-',
                                        AppColors.tealAccent,
                                      ),
                                      _infoRow(
                                        AppStrings.tp3,
                                        signal.takeProfit3 ?? '-',
                                        AppColors.tealAccent,
                                      ),
                      
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            signal.tradeStatus,
                                            style: AppTextStyles.s15M.copyWith(
                                              color: AppColors.white,
                                            ),
                                          ),
                                          Text(
                                            signal.tradeProbability??'',
                                            style: AppTextStyles.s15M.copyWith(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                      
                                      if (signal.adminNotes?.isNotEmpty ==
                                          true) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          '💡 ${signal.adminNotes}',
                                          style: AppTextStyles.s14M.copyWith(
                                            color: AppColors.primary,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                      
                                if (signal.tradeStatusImage != null &&
                                    signal.tradeStatusImage!.isNotEmpty)
                                  Positioned(
                                    top: 162,
                                    child: Image.network(
                                      signal.tradeStatusImage ?? '',
                                      width: 190,
                                      height: 90,
                                      fit: BoxFit.fitWidth,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const SizedBox(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: UserSession.isAdmin
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: AppColors.black),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateSignalScreen()),
                );

                if (result == true) {
                  context.read<SignalProvider>().fetchSignals();
                }
              },
            )
          : null,
    );
  }

  Widget _infoRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.s15M.copyWith(color: AppColors.white),
          ),
          Text(
            value,
            style: AppTextStyles.s15M.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
