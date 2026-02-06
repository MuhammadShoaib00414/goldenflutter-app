import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goldexia_fx/models/subscription.dart';
import 'package:goldexia_fx/utils/nav.dart';
import 'package:goldexia_fx/utils/res/app_colors.dart';
import 'package:goldexia_fx/utils/res/app_text_styles.dart';
import 'package:goldexia_fx/views/widgets/custom_elevated.dart';
import 'package:goldexia_fx/views/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPopUp extends StatelessWidget {
  const QrPopUp({super.key, required this.subscription});
  final SubscriptionData subscription;

  @override
  Widget build(BuildContext context) {
    final qrData =
        '${subscription.networkType ?? ''}:${subscription.address ?? ''}';
     print("...........${subscription.address}");
     print("...........${subscription.networkType}");
    return AlertDialog(
      backgroundColor: AppColors.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Payment QR',
        style: AppTextStyles.s18M.copyWith(color: AppColors.white),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: 200,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 15),
          Text(
            'Network: ${subscription.networkType ?? 'N/A'}',
            style: AppTextStyles.s16M.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 6),
          SelectableText(
            'Address: ${subscription.address ?? 'N/A'}',
            style: AppTextStyles.s14M.copyWith(color: AppColors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          CustomElevatedButton(
            onTap: () {
                final address = subscription.address ?? '';
              if (address.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: address));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address copied to clipboard')),
                );
             }
             
            },
            icon: const Icon(Icons.copy, size: 18) ,
            width: 300,
            height: 40,
            child: const Text('Copy Address') ,
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        CustomOutlinedButton(text:'Close' , onPressed:(){
          Nav.back();
        })
        // OutlinedButton(
        //    style:OutlinedButton.styleFrom(
        //       foregroundColor: AppColors.white,
        //       backgroundColor: AppColors.primary,
        //       shape: RoundedRectangleBorder(
                
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //     ),
        //   onPressed: () => Navigator.pop(context),
        //   child: const Text(, style: TextStyle(color: Colors.white70)),
        // ),
      ],
    );
  }
}
