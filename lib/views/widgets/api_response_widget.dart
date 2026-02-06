import 'package:flutter/material.dart';

import '../../models/api_response.dart';
import '../../utils/res/app_colors.dart';

class ApiResponseWidget<T> extends StatelessWidget {
  final ApiResponse response;
  final Widget Function(BuildContext) successBuilder;
  final Widget Function(BuildContext)? loadingBuilder;
  final void Function()? onRetry;
  final List<T>? data;
  final bool showError;
  final bool isLoaderInCenter;
  final Widget Function(BuildContext)? errorBuilder;
  final Widget Function(BuildContext)? emptyBuilder;
  const ApiResponseWidget({
    super.key,
    this.errorBuilder,
    this.emptyBuilder,
    required this.successBuilder,
    this.loadingBuilder,
    required this.response,
    this.showError = true,
    this.onRetry,
    this.data,
    this.isLoaderInCenter = true,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data ?? response.data;
    switch (response.status) {
      case ResStatus.loading:
        return loadingBuilder != null
            ? loadingBuilder!(context)
            : Center(child: CircularProgressIndicator(color: AppColors.primary,));

      case ResStatus.error:
        String msg = 'Something went wrong';
        try {
          final res = response.message;
          msg = res.runtimeType == String ? res : res.message;
        } catch (e) {
          /**/
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showError) Text(msg),
                if (onRetry != null) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: isLoaderInCenter
                        ? Alignment.center
                        : Alignment.centerLeft,
                    child: InkWell(
                      onTap: onRetry, //() => value.getPhoto(),
                      child: const Icon(
                        Icons.refresh,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      default:
        if (data == null) {
          if (errorBuilder != null) {
            return errorBuilder!(context);
          }
          return Center(child: Text(''));
        } else {
          if (data is List && data.isEmpty) {
            return buildEmptyBuilder(context);
          }
          try {
            if (data.items.isEmpty) return buildEmptyBuilder(context);
          } catch (e) {
            // Log.ex(e, name: 'ApiResponseWidget errorBuilder');
          }
          return successBuilder(context);
        }
    }
  }

  Widget buildEmptyBuilder(BuildContext context) =>
      emptyBuilder == null ? Center(child: Text('')) : emptyBuilder!(context);
}
