import 'package:flutter/cupertino.dart';
import 'package:users1/global/global.dart';

class BasketPostCounter extends ChangeNotifier
{
  int basketListPostCounter = sharedPreferences!.getStringList("userBasket")!.length - 1;
  int get count => basketListPostCounter;

  Future<void> displayBasketListPostsNumber() async
  {
    basketListPostCounter = sharedPreferences!.getStringList("userBasket")!.length - 1;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}