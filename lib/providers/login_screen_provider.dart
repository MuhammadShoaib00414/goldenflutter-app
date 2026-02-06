



import 'package:flutter/foundation.dart';

class LoginScreenProvider extends ChangeNotifier {
   bool _Forgot = false;
  bool _visible = false;

  bool _confirmVisible=false;
 

 
 bool get isForgot=>_Forgot;
  bool get isVisible=>_visible;
  bool get isconfirmVisible=>_confirmVisible;
 

  void checkVisible(){
    _visible=!_visible;
    notifyListeners();
  }

   void checkConfirmVisible(){
   _confirmVisible=!_confirmVisible;
    notifyListeners();
  }

  void checkForgot(){
    _Forgot=true;
    notifyListeners();
  }
}