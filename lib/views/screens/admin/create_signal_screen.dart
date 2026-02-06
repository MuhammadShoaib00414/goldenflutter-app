import 'package:flutter/material.dart';
import 'package:goldexia_fx/models/trade_signal.dart';
import 'package:goldexia_fx/providers/signal_list_provider.dart';
import 'package:goldexia_fx/utils/app_strings.dart';
import 'package:goldexia_fx/utils/app_utils.dart';
import 'package:goldexia_fx/utils/utils.dart';
import 'package:goldexia_fx/views/widgets/custom_elevated.dart';
import 'package:goldexia_fx/views/widgets/customdropdownfield.dart';
import 'package:goldexia_fx/views/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CreateSignalScreen extends StatefulWidget {
  const CreateSignalScreen({
    super.key,
    this.existingSignal,
    this.isEditMode = false,
  });
  final TradeSignal? existingSignal;
  final bool isEditMode;
  @override
  State<CreateSignalScreen> createState() => _CreateSignalScreenState();
}

class _CreateSignalScreenState extends State<CreateSignalScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _symbolController;
  late TextEditingController _entryZoneController;
  late TextEditingController _stopLossController;
  late TextEditingController _tp1Controller;
  late TextEditingController _tp2Controller;
  late TextEditingController _tp3Controller;
  late TextEditingController _notesController;

  String? _orderType;
  String? _tradeProbability;
  String? _tradeStatus;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _symbolController = TextEditingController();
    _entryZoneController = TextEditingController();
    _stopLossController = TextEditingController();
    _tp1Controller = TextEditingController();
    _tp2Controller = TextEditingController();
    _tp3Controller = TextEditingController();
    _notesController = TextEditingController();

    if (widget.isEditMode && widget.existingSignal != null) {
      final signal = widget.existingSignal!;
      _symbolController.text = signal.symbol;
      _entryZoneController.text = signal.entryZone;
      _stopLossController.text = signal.stopLoss;
      _tp1Controller.text = signal.takeProfit1;
      _tp2Controller.text = signal.takeProfit2 ?? '';
      _tp3Controller.text = signal.takeProfit3 ?? '';
      _notesController.text = signal.adminNotes ?? '';
      _orderType = signal.orderType;
      _tradeProbability = signal.tradeProbability ?? '';

      _tradeStatus = signal.tradeStatus;
    }
  }

  @override
  void dispose() {
    _symbolController.dispose();
    _entryZoneController.dispose();
    _stopLossController.dispose();
    _tp1Controller.dispose();
    _tp2Controller.dispose();
    _tp3Controller.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      AppUtils.showToast('Please fill all required fields');
      return false;
    }

    if (_orderType == null || _orderType!.isEmpty) {
      AppUtils.showToast('Please select order type');
      return false;
    }

    // if (_zoneValidity == null || _zoneValidity!.isEmpty) {
    //   AppUtils.showToast('Please select zone validity');
    //   return false;
    // }

    if (_tradeStatus == null || _tradeStatus!.isEmpty) {
      AppUtils.showToast('Please select trade status');
      return false;
    }

    return true;
  }

  Future<void> _saveSignal(BuildContext context) async {
    if (!_validateForm()) return;

    final signal = TradeSignal(
      id: widget.existingSignal?.id,
      symbol: _symbolController.text.trim(),
      orderType: _orderType ?? '',
      entryZone: _entryZoneController.text.trim(),
      stopLoss: _stopLossController.text.trim(),
      takeProfit1: _tp1Controller.text.trim(),
      takeProfit2: _tp2Controller.text.isNotEmpty
          ? _tp2Controller.text.trim()
          : null,
      takeProfit3: _tp3Controller.text.isNotEmpty
          ? _tp3Controller.text.trim()
          : null,
      tradeProbability: _tradeProbability ?? '',
      tradeStatus: _tradeStatus ?? '',
      adminNotes: _notesController.text.isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    bool success;
    if (widget.isEditMode) {
      success = await context.read<SignalProvider>().updateSignal(signal);
    } else {
      success = await context.read<SignalProvider>().createSignal(signal);
    }

    if (success) {
      AppUtils.showToast(
        widget.isEditMode
            ? 'Signal updated successfully'
            : 'Signal created successfully',
      );
      if (mounted) {
        Nav.back(true);
      }
    } else {
      AppUtils.showToast(
        'Failed to ${widget.isEditMode ? "update" : "create"} signal',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? AppStrings.editSignal : AppStrings.createSignal,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _symbolController,
                      label: AppStrings.symbol,
                      validator: (v) =>
                          v == null || v.isEmpty ? AppStrings.required : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropDownButtonWidget<String>(
                      hintText: AppStrings.orderType,
                      value: _orderType,
                      items: const ['Buy Zone', 'Sell Zone'],
                      onChanged: (value) {
                        _orderType = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                keyboardtype: TextInputType.number,
                controller: _entryZoneController,
                label: AppStrings.entryZone,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return AppStrings.required;
                  }
                  if (!v.trim().contains('-')) {
                    return AppStrings.validZone;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardtype: TextInputType.number,
                      controller: _stopLossController,
                      label: AppStrings.stopLoss,
                      validator: (v) =>
                          v == null || v.isEmpty ? AppStrings.required : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      keyboardtype: TextInputType.number,
                      controller: _tp1Controller,
                      label: AppStrings.takeProfitOne,
                      validator: (v) =>
                          v == null || v.isEmpty ? AppStrings.required : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      keyboardtype: TextInputType.number,

                      controller: _tp2Controller,
                      label: AppStrings.takeProfitTwo,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      keyboardtype: TextInputType.number,

                      controller: _tp3Controller,
                      label: AppStrings.takeProfitThree,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropDownButtonWidget<String>(
                      hintText: AppStrings.tradeProbabilityoptional,
                      value: _tradeProbability,
                      items: const [
                        AppStrings.highlyRiskyTrade,
                        AppStrings.riskyTrade,
                        AppStrings.highprobabilitysetup,
                      ],
                      onChanged: (value) {
                        _tradeProbability = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropDownButtonWidget<String>(
                      hintText: AppStrings.tradeStatus,
                      value: _tradeStatus,
                      items: const [
                        AppStrings.valid,
                        AppStrings.inValid,

                        AppStrings.tP1Hit,
                        AppStrings.tP2Hit,
                        AppStrings.tP3Hit,
                        AppStrings.tP4Hit,
                        AppStrings.sLHit,
                      ],
                      onChanged: (value) {
                        _tradeStatus = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _notesController,
                label: AppStrings.adminNotes,
                maxLine: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onTap: () {
                        _saveSignal(context);
                      },
                      child: Text(
                        widget.isEditMode
                            ? AppStrings.updateSignal
                            : AppStrings.createSignal,
                        style: AppTextStyles.s15M,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomOutlinedButton(
                      text: AppStrings.cancel,
                      onPressed: () => Nav.back(),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
