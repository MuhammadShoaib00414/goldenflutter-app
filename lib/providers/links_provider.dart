import 'package:flutter/foundation.dart';
import 'package:goldexia_fx/models/api_response.dart';
import 'package:goldexia_fx/models/subscription.dart';
import 'package:goldexia_fx/repositories/subsciptions_repo.dart';

class LinksProvider extends ChangeNotifier {
  final SubsciptionsRepo _repo = SubsciptionsRepo();
  ApiResponse<List<SubscriptionData>?> subscriptions = ApiResponse.loading();
  SubscriptionData? selectedSubscription;

  void setSubscriptions(ApiResponse<List<SubscriptionData>?> res) {
    subscriptions = res;
    notifyListeners();
  }

  void selectSubscription(SubscriptionData sub) {
    selectedSubscription = sub;
    notifyListeners();
  }

  //
  Future<void> getSubscriptions() async {
    final res = await _repo.getSubscriptions();
    setSubscriptions(res);
  }
}
