import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_user/models/address_model.dart';
import 'package:ecommerce_user/pages/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../models/date_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import 'order_successful_page.dart';

class CheckoutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  String paymentMethodGroupValue = PaymentMethod.cod;
  bool isFirst = true;
  String? city, area;
  final addressController = TextEditingController();
  final zcodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserModel? userModel;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      cartProvider = Provider.of<CartProvider>(context);
      orderProvider = Provider.of<OrderProvider>(context);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      orderProvider.getOrderConstants();
      userProvider.getUserByUid().then((value) {
        setState(() {
          userModel = value;
          if (userModel!.address != null) {
            addressController.text = userModel!.address!.streetAddress;
            zcodeController.text = userModel!.address!.zipCode;
            city = userModel!.address!.city;
            area = userModel!.address!.area;
          }
        });
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    addressController.dispose();
    zcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  'Product Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                productSection(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Info',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                summerSection(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (userModel != null) buildAddressSection(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                paymentSection(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _saveOrder,
            child: const Text('Proceed to Order'),
          )
        ],
      ),
    );
  }

  Card paymentSection() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Radio<String>(
              value: PaymentMethod.cod,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.cod),
            const SizedBox(
              width: 10,
            ),
            Radio<String>(
              value: PaymentMethod.online,
              groupValue: paymentMethodGroupValue,
              onChanged: (value) {
                setState(() {
                  paymentMethodGroupValue = value!;
                });
              },
            ),
            const Text(PaymentMethod.online),
          ],
        ),
      ),
    );
  }

  Card productSection() {
    return Card(
      elevation: 5,
      child: Column(
        children: cartProvider.cartList
            .map((cartM) => ListTile(
                  dense: true,
                  title: Text(cartM.productName!),
                  trailing: Text(
                      '${cartM.quantity}x$currencySymbol${cartM.salePrice}'),
                ))
            .toList(),
      ),
    );
  }

  Card summerSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Subtotal'),
            trailing: Text('$currencySymbol${cartProvider.getCartSubtotal()}'),
          ),
          ListTile(
            title: Text(
                'Discount(${orderProvider.orderConstantsModel.discount})%'),
            trailing: Text(
                '$currencySymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubtotal())}'),
          ),
          ListTile(
            title: Text('VAT(${orderProvider.orderConstantsModel.vat})%'),
            trailing: Text(
                '$currencySymbol${orderProvider.getVatAmount(cartProvider.getCartSubtotal())}'),
          ),
          ListTile(
            title: const Text('Delivery Charge'),
            trailing: Text(
                '$currencySymbol${orderProvider.orderConstantsModel.deliveryCharge}'),
          ),
          const Divider(
            height: 2,
            color: Colors.black,
          ),
          ListTile(
            title: const Text('Grand Total'),
            trailing: Text(
              '$currencySymbol${orderProvider.getGrandTotal(cartProvider.getCartSubtotal())}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                    hintText: 'Enter delivery address',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a Street Address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: zcodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Enter Zip Code', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a Zip Code';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                isExpanded: true,
                hint: const Text('Select City '),
                value: city,
                items: cityArea.keys
                    .toList()
                    .map((c) => DropdownMenuItem<String>(
                          value: c,
                          child: Text(c),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    city = value;
                    area = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a City';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                isExpanded: true,
                hint: const Text('Select Area '),
                value: area,
                items: cityArea[city]
                    ?.map((a) => DropdownMenuItem<String>(
                          value: a,
                          child: Text(a),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    area = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an Area';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveOrder() {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      final orderM = OrderModel(
        userId: AuthService.user!.uid,
        deliveryAddress: AddressModel(
          streetAddress: addressController.text,
          area: area!,
          city: city!,
          zipCode: zcodeController.text,
        ),
        paymentMethod: paymentMethodGroupValue,
        orderStatus: OrderStatus.pending,
        orderDate: DateModel(
          timestamp: Timestamp.fromDate(DateTime.now()),
          day: DateTime.now().day,
          month: DateTime.now().month,
          year: DateTime.now().year,
        ),
        grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubtotal()),
        discount: orderProvider.orderConstantsModel.discount,
        vat: orderProvider.orderConstantsModel.vat,
        deliveryCharge: orderProvider.orderConstantsModel.deliveryCharge,
      );
      orderProvider.addNewOrder(orderM, cartProvider.cartList).then((value) {
        EasyLoading.dismiss();
        Navigator.pushNamedAndRemoveUntil(
            context,
            OrderSuccessfulPage.routeName,
            ModalRoute.withName(ProductPage.routeName));
      }).catchError((error) {
        EasyLoading.dismiss();
      });
    }
  }
}
