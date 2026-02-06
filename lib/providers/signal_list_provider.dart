import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/trade_signal.dart';
import 'package:goldexia_fx/repositories/signals_repo.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';

class SignalProvider extends ChangeNotifier {
  final SignalsRepo _repo = SignalsRepo();


  ApiResponse<List<TradeSignal>> signalsResponse = ApiResponse.loading();

  List<TradeSignal> get signals => signalsResponse.data ?? [];

  void _setSignals(ApiResponse<List<TradeSignal>> res) {
    signalsResponse = res;
    notifyListeners();
  }

  Future<void> fetchSignals({bool showLoader = true}) async {
    if (showLoader) {
      _setSignals(ApiResponse.loading());
    }

    final res = await _repo.fetchSignals();

    if (res.isSuccess) {
      _setSignals(ApiResponse.success(res.data ?? []));
    } else {
      _setSignals(ApiResponse.error(res.message));
    }
  }

  /// Create signal (pure business logic)
  Future<bool> createSignal(TradeSignal signal) async {
    final res = await _repo.createSignal(signal);

    if (!res.isSuccess) return false;

    /// Optimistic update
    _setSignals(ApiResponse.success([signal, ...signals]));
    return true;
  }

  void removeSignal(int index) {
    final updated = List<TradeSignal>.from(signals)..removeAt(index);
    _setSignals(ApiResponse.success(updated));
  }

  void clearSignals() {
    _setSignals(ApiResponse.success([]));
  }

  Future<bool> updateSignal(TradeSignal signal) async {
    final res = await _repo.updateSignal(signal);

    if (!res.isSuccess) return false;

    // Update in local list
    final updatedList = signals.map((s) {
      if (s.id == signal.id) return signal;
      return s;
    }).toList();

    _setSignals(ApiResponse.success(updatedList));
    return true;
  }

  Future<bool> deleteSignal(String id) async {
    final res = await _repo.deleteSignal(id);

    if (!res.isSuccess) return false;

    final updatedList = signals.where((s) => s.id != id).toList();
    _setSignals(ApiResponse.success(updatedList));
    return true;
  }

}




















Future<dynamic> showDeleteingDialog(BuildContext context) async {
  return await showDialog<bool>(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.primary,
        insetPadding: const EdgeInsets.all(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.darkBlackColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete signal?',
                style: AppTextStyles.s18M.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Are you sure you want to delete this signal?',
                textAlign: TextAlign.center,
                style: AppTextStyles.s15M.copyWith(color: AppColors.gray),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(AppStrings.cancel),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.whiteDark,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

