import 'package:flutter/material.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    this.icon,
    this.title,
    this.onTap,
    this.isNotification = false,
    this.notificationValue = false,
    this.onNotificationChanged,
  });

  final IconData? icon;
  final String? title;
  final bool? isNotification;
  final bool notificationValue;
  final void Function(bool)? onNotificationChanged;
  final void Function()? onTap;
  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
       clipBehavior: Clip.antiAlias,
      color: AppColors.darkBlackColor,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary),
      ),
      child: ListTile(
        leading: Icon(widget.icon, color: AppColors.primary),
        title: Text(
          widget.title ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        trailing: widget.isNotification!
            ? Switch(
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.primary,
                inactiveThumbColor: AppColors.primary,
                inactiveTrackColor: AppColors.grey.withAlpha(6),
                value: widget.notificationValue,
                onChanged: widget.onNotificationChanged,
              )
            : const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
           onTap: widget.onTap ,
      ),
    );
  }
}
