import 'package:flutter/material.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:flutter_listin/products/screens/widgets/product_list_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("As informações básicas devem ser mostradas", (WidgetTester widgetTester) async {
    Product product = Product(
      id: 'ID001',
      name: 'Detergente',
      obs: "",
      category: "",
      isKilograms: false,
      isPurchased: false,
      price: 2.5,
      amount: 2,
    );

    widgetTester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ProductListItem(
              listinId: 'LISTIN_ID',
              product: product,
              onTap: (Product product) {},
              onCheckboxTap: ({required Product product, required String listinId}) {},
              onTrailButtonTap: (Product product) {},
            )
          ],
        ),
      ),
    ));
  });
}
