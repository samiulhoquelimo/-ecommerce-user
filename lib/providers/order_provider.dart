import 'package:ecommerce_user/auth/auth_service.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/cart_model.dart';
import '../models/order_constants_model.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  List<OrderModel> orderList = [];

  getOrderByUser() {
    DbHelper.getAllOrders(AuthService.user!.uid).listen((event) {
      orderList = List.generate(event.docs.length,
          (index) => OrderModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addNewOrder(
      OrderModel orderModel, List<CartModel> cartList) async {
    await DbHelper.addOrder(orderModel, cartList);
    return DbHelper.clearCartItems(orderModel.userId!, cartList);
  }

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
