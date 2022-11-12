
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_services.dart';
import '../curstomwidegt/dashbord_item_view.dart';
import '../models/dashbord_model.dart';
import '../provider/order_provider.dart';
import '../provider/product_provider.dart';
import 'launcher_pages.dart';


class DashboardPage extends StatelessWidget {
  static const String routeName = '/dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductProvider>(context, listen: false).getAllPurchases();
    Provider.of<OrderProvider>(context, listen: false).getOrderConstants();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(context, LauncherPage.routeName));
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600? 3 : 2,
        ),
        itemCount: dashboardModelList.length,
        itemBuilder: (context, index) =>
            DashboardItemView(model: dashboardModelList[index],),
      ),
    );
  }
}
