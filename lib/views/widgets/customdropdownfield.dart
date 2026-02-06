import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class DropDownButtonWidget<T> extends StatefulWidget {
  const DropDownButtonWidget({
    super.key,
    this.hintText,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    this.buttonStyleData,
    this.validator,
  });

  final String? hintText;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final Widget? hint;
  final ButtonStyleData? buttonStyleData;
  final String? Function(T?)? validator;
  @override
  State<DropDownButtonWidget<T>> createState() =>
      _DropDownButtonWidgetState<T>();
}

class _DropDownButtonWidgetState<T> extends State<DropDownButtonWidget<T>> {
  T? _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  void _updateItem(T? value) {
    setState(() {
      _value = value;
    });
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        hint:
            widget.hint ??
            (widget.hintText == null
                ? null
                : Text(
                    widget.hintText!,
                    style: AppTextStyles.s13M.copyWith(color: AppColors.white),
                  )),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          errorStyle: AppTextStyles.errorTextStyle,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: AppColors.primerColorThree,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.red, width: 1.8),
          ),
          filled: true,
          fillColor: AppColors.darkBlackColor,
        ),
        buttonStyleData:
            widget.buttonStyleData ??
            ButtonStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              width: double.infinity,
              height: 52,
              elevation: 0,
            ),
        value: _value,
        items: widget.items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e.toString(),
                  style: AppTextStyles.s14M.copyWith(color: AppColors.white),
                ),
              ),
            )
            .toList(),
        dropdownStyleData: DropdownStyleData(
          elevation: 0,
          maxHeight: 300,
          decoration: BoxDecoration(
            color: AppColors.darkBlackColor,
            border: Border.all(color: AppColors.primary, width: 1.2),
            borderRadius: BorderRadius.circular(10),
          ),
          offset: const Offset(0, 4),
        ),
        validator:
            widget.validator ?? (value) => value == null ? 'Required' : null,
        onChanged: _updateItem,
      ),
    );
  }
}
