import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/trade_signal.dart';
import 'package:goldexia_fx/repositories/signals_repo.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/utils.dart';

class CreateSignalProvider extends ChangeNotifier {
  final SignalsRepo _repo = SignalsRepo();

  // Form controllers
  late TextEditingController symbolController;
  late TextEditingController entryZoneController;
  late TextEditingController stopLossController;
  late TextEditingController tp1Controller;
  late TextEditingController tp2Controller;
  late TextEditingController tp3Controller;
  late TextEditingController notesController;

  // Dropdown state
  String? orderType;
  String? zoneValidity;
  String? tradeStatus;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  CreateSignalProvider() {
    _initControllers();
  }

  void _initControllers() {
    symbolController = TextEditingController();
    entryZoneController = TextEditingController();
    stopLossController = TextEditingController();
    tp1Controller = TextEditingController();
    tp2Controller = TextEditingController();
    tp3Controller = TextEditingController();
    notesController = TextEditingController();
  }

  /// Update order type dropdown value
  void updateOrderType(String? value) {
    orderType = value;
    notifyListeners();
  }

  /// Update zone validity dropdown value
  void updateZoneValidity(String? value) {
    zoneValidity = value;
    notifyListeners();
  }

  /// Update trade status dropdown value
  void updateTradeStatus(String? value) {
    tradeStatus = value;
    notifyListeners();
  }

  /// Validate form and return true if valid
  bool validateForm(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) {
      AppUtils.showToast('Please fill all required fields');
      return false;
    }

    if (orderType == null || orderType!.isEmpty) {
      AppUtils.showToast('Please select order type');
      return false;
    }

    if (zoneValidity == null || zoneValidity!.isEmpty) {
      AppUtils.showToast('Please select zone validity');
      return false;
    }

    if (tradeStatus == null || tradeStatus!.isEmpty) {
      AppUtils.showToast('Please select trade status');
      return false;
    }

    return true;
  }

  /// Create and post signal
  Future<bool> postSignal(BuildContext context) async {
    try {
      _setLoading(true);

      final signal = TradeSignal(
        symbol: symbolController.text.trim(),
        orderType: orderType ?? '',
        entryZone: entryZoneController.text.trim(),
        stopLoss: stopLossController.text.trim(),
        takeProfit1: tp1Controller.text.trim(),
        takeProfit2: tp2Controller.text.isNotEmpty
            ? tp2Controller.text.trim()
            : null,
        takeProfit3: tp3Controller.text.isNotEmpty
            ? tp3Controller.text.trim()
            : null,
        zoneValidity: zoneValidity ?? '',
        tradeStatus: tradeStatus ?? '',
        adminNotes: notesController.text.isNotEmpty
            ? notesController.text.trim()
            : null,
      );

      final response = await _repo.createSignal(signal);

      if (!response.isSuccess) {
        AppUtils.showToast(response.message ?? 'Failed to create signal');
        return false;
      }

      AppUtils.showToast('Signal created successfully');
      _clearForm();
      return true;
    } catch (e) {
      Log.ex(e, name: 'CreateSignalProvider postSignal');
      AppUtils.showToast('An error occurred. Please try again');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Clear form fields
  void _clearForm() {
    symbolController.clear();
    entryZoneController.clear();
    stopLossController.clear();
    tp1Controller.clear();
    tp2Controller.clear();
    tp3Controller.clear();
    notesController.clear();
    orderType = null;
    zoneValidity = null;
    tradeStatus = null;
    notifyListeners();
  }

  @override
  void dispose() {
    symbolController.dispose();
    entryZoneController.dispose();
    stopLossController.dispose();
    tp1Controller.dispose();
    tp2Controller.dispose();
    tp3Controller.dispose();
    notesController.dispose();
    super.dispose();
  }
}
