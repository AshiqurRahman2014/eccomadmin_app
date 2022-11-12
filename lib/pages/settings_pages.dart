import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../models/order_constant_model.dart';
import '../provider/order_provider.dart';
import '../uitls/helper_function.dart';


class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  @override
  State<SettingsPage> createState() => _SettingsPageState();

  SettingsPage();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _discountController = TextEditingController();
  final _vatController = TextEditingController();
  final _delevaryChargeController = TextEditingController();
  late OrderProvider orderProvider;

  @override
  void didChangeDependencies() {
    orderProvider = Provider.of<OrderProvider>(context);
    _discountController.text = orderProvider.orderConstantModel.discount.toString();
    _vatController.text = orderProvider.orderConstantModel.vat.toString();
    _delevaryChargeController.text = orderProvider.orderConstantModel.deliveryCharge.toString();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _discountController.dispose();
    _delevaryChargeController.dispose();
    _vatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Discount %',
                    prefixIcon: Icon(Icons.discount),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _vatController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Vat %',
                    prefixIcon: Icon(Icons.discount),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: _delevaryChargeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Delevary Charge',
                    prefixIcon: Icon(Icons.discount),
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: _saveInfo,
                  child: const Text('Update'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveInfo() {
    if(_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait');
      final model = OrderConstantModel(
        discount: num.parse(_discountController.text),
        vat: num.parse(_vatController.text),
        deliveryCharge: num.parse(_delevaryChargeController.text),
      );
      orderProvider.updateOrderConstants(model)
          .then((value) {
        EasyLoading.dismiss();
        showMsg(context, 'Updated Successfully');
      })
          .catchError((error) {
        EasyLoading.dismiss();
        showMsg(context, 'Failed to update.');
      });
    }
  }
}
