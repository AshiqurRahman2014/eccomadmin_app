import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/date_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';
import '../provider/product_provider.dart';
import '../uitls/helper_function.dart';

class ProductRepurchasePage extends StatefulWidget {
  static const String routeName = '/repurchase';

  const ProductRepurchasePage({Key? key}) : super(key: key);

  @override
  State<ProductRepurchasePage> createState() => _ProductRepurchasePageState();
}

class _ProductRepurchasePageState extends State<ProductRepurchasePage> {
  late ProductModel productModel;
  final _formKey = GlobalKey<FormState>();
  final _purchasePriceController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? purchaseDate;
  @override
  void didChangeDependencies() {
    productModel =
    ModalRoute.of(context)!.settings.arguments as ProductModel;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repurchase'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(productModel.productName, style: Theme.of(context).textTheme.headline5,),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _purchasePriceController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Purchase Price',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) <= 0) {
                      return 'Price should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: 'Enter Quantity',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    if (num.parse(value) <= 0) {
                      return 'Quantity should be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _selectDate,
                        icon: const Icon(Icons.calendar_month),
                        label: const Text('Select Purchase Date'),
                      ),
                      Text(purchaseDate == null
                          ? 'No date chosen'
                          : getFormattedDate(purchaseDate!)),
                    ],
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: _repurchase,
                child: const Text('Re-Purchase'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if(date != null) {
      setState(() {
        purchaseDate = date;
      });
    }
  }

  @override
  void dispose() {
    _purchasePriceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _repurchase() {
    if(purchaseDate == null) {
      showMsg(context, 'Please select purchase date');
      return;
    }

    if(_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      final purchaseModel = PurchaseModel(
        productId: productModel.productId,
        purchasePrice: num.parse(_purchasePriceController.text),
        purchaseQuantity: num.parse(_quantityController.text),
        dateModel: DateModel(
          timestamp: Timestamp.fromDate(purchaseDate!),
          day: purchaseDate!.day,
          month: purchaseDate!.month,
          year: purchaseDate!.year,
        ),
      );
      Provider
          .of<ProductProvider>(context, listen: false)
          .repurchase(purchaseModel, productModel)
          .then((value) {
        EasyLoading.dismiss();
        Navigator.pop(context);
      } )
          .catchError((error) {
        EasyLoading.dismiss();
        showMsg(context, 'Failed to save');
      });
    }
  }
}
