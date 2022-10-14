import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> orderList = [];

  Future<void> getOrderConstants() async {
    DbHelper.getOrderConstants().listen((snapshot) {
      if (snapshot.exists) {
        orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  num getDiscountAmount(num subtotal) {
    return (subtotal * orderConstantsModel.discount) / 100;
  }

  num getVatAmount(num subtotal) {
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    return (priceAfterDiscount * orderConstantsModel.vat) / 100;
  }

  num getGrandTotal(num subtotal) {
    return (subtotal - getDiscountAmount(subtotal)) +
        getVatAmount(subtotal) +
        orderConstantsModel.deliveryCharge;
  }
}
