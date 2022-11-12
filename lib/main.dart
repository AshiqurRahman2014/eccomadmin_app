import 'package:ecommarce/pages/add_product_pages.dart';
import 'package:ecommarce/pages/catagory_pages.dart';
import 'package:ecommarce/pages/dashbord.dart';
import 'package:ecommarce/pages/launcher_pages.dart';
import 'package:ecommarce/pages/login_pages.dart';
import 'package:ecommarce/pages/order_list.dart';
import 'package:ecommarce/pages/product_details_pages.dart';
import 'package:ecommarce/pages/product_repurchage_pages.dart';
import 'package:ecommarce/pages/report_pages.dart';
import 'package:ecommarce/pages/settings_pages.dart';
import 'package:ecommarce/pages/user_list_pages.dart';
import 'package:ecommarce/provider/order_provider.dart';
import 'package:ecommarce/provider/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'pages/view_product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: EasyLoading.init(),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName : (_) => const LauncherPage(),
        LoginPage.routeName : (_) => const LoginPage(),
        DashboardPage.routeName : (_) => const DashboardPage(),
        AddProductPage.routeName : (_) => const AddProductPage(),
        ViewProductPage.routeName : (_) => const ViewProductPage(),
        ProductDetailsPage.routeName : (_) => ProductDetailsPage(),
        CategoryPage.routeName : (_) => const CategoryPage(),
        OrderPage.routeName : (_) => const OrderPage(),
        ReportPage.routeName : (_) => const ReportPage(),
        SettingsPage.routeName : (_) =>  SettingsPage(),
        ProductRepurchasePage.routeName : (_) => const ProductRepurchasePage(),
        UserListPage.routeName : (_) => const UserListPage(),
      },
    );
  }
}

