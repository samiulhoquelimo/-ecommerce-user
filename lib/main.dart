import 'package:ecommerce_user/pages/cart_page.dart';
import 'package:ecommerce_user/providers/cart_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'pages/launcher_page.dart';
import 'pages/login_page.dart';
import 'pages/product_details_page.dart';
import 'pages/product_page.dart';
import 'pages/user_page.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => OrderProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LauncherPage.routeName,
      builder: EasyLoading.init(),
      routes: {
        LauncherPage.routeName: (_) => const LauncherPage(),
        LoginPage.routeName: (_) => const LoginPage(),
        ProductPage.routeName: (_) => const ProductPage(),
        ProductDetailsPage.routeName: (_) => const ProductDetailsPage(),
        CartPage.routeName: (_) => const CartPage(),
        //OrderPage.routeName: (_) => OrderPage(),
        //OrderListPage.routeName: (_) => OrderListPage(),
        UserPage.routeName: (_) => const UserPage(),
      },
    );
  }
}
