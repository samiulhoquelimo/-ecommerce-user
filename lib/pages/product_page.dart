import 'package:ecommerce_user/customwidgets/main_drawer.dart';
import 'package:ecommerce_user/customwidgets/product_item.dart';
import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/product';

  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<CartProvider>(context, listen: false).getAllCartItems();
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  Positioned(
                    left: -2,
                    top: -1,
                    child: Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: FittedBox(
                        child: Consumer<CartProvider>(
                            builder: (context, provider, _) =>
                                Text('${provider.totalItemsInCart}')),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => provider.productList.isEmpty
            ? const Center(
                child: Text('No item found'),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.65),
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];
                  return ProductItem(productModel: product);
                },
              ),
      ),
    );
  }
}
