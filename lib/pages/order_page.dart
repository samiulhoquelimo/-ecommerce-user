import 'package:ecommerce_user/providers/order_provider.dart';
import 'package:ecommerce_user/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

class OrderPage extends StatelessWidget {
  static const String routeName = '/myorders';

  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).getOrderByUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          return provider.orderList.isEmpty
              ? const Center(child: Text('You have no orders'))
              : ListView.builder(
                  itemCount: provider.orderList.length,
                  itemBuilder: (context, index) {
                    final orderM = provider.orderList[index];
                    return ListTile(
                      title: Text(getFormattedDateTime(
                          orderM.orderDate.timestamp.toDate(),
                          'dd/MM/yyyy hh:mm:s a')),
                      subtitle: Text(orderM.orderStatus),
                      trailing: Text('$currencySymbol${orderM.grandTotal}'),
                    );
                  },
                );
        },
      ),
    );
  }
}
