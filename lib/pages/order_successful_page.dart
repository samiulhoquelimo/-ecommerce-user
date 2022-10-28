import 'package:flutter/material.dart';

class OrderSuccessfulPage extends StatelessWidget {
  static const String routeName = '/order_successful';

  const OrderSuccessfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Successful'),
      ),
      body: Center(
        child: Column(
          children: const [
            Icon(
              Icons.done,
              size: 150,
            ),
            Text(
              'Your order has been placed successfully',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
