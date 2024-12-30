import 'dart:math';

import 'package:flutter_listin/products/helpers/calculate_total_price.dart';
import 'package:flutter_listin/products/model/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Entradas simples:',
    () {
      test('Se a lista de produtos estiver vazia, o total deve ser 0.0', () {
        List<Product> listProducts = [];

        double result = calculateTotalPriceFromListProduct(listProducts);

        expect(result, 0);
      });

      test('Se a lista tiver apenas um produto, retornar a multiplicação dos valores', () {
        List<Product> listProducts = [];

        Product product = Product(
          id: 'id',
          name: 'Produto 1',
          obs: 'Obs',
          price: 10,
          amount: 2,
          category: '',
          isKilograms: false,
          isPurchased: true,
        );

        listProducts.add(product);

        expect(calculateTotalPriceFromListProduct(listProducts), product.amount! * product.price!,
            reason: 'Deve retornar a multiplicação dos valores');
      });

      test('A função não pode retornar valores negativos', () {
        List<Product> listProducts = [];

        Product product = Product(
          id: 'id',
          name: 'Produto 1',
          obs: 'Obs',
          amount: Random().nextInt(10).toDouble(),
          price: Random().nextDouble() * 10,
          category: '',
          isKilograms: false,
          isPurchased: true,
        );

        listProducts.add(product);

        expect(calculateTotalPriceFromListProduct(listProducts), isNonNegative, reason: 'O total não pode ser negativo');
      }, retry: 1000);
    },
  );
  group(
    'Casos exepcionais:',
    () {
      test(
        'A função deve levantar uma exeção se um dos produtos nao estiver no carrinho',
        () {
          List<Product> listProducts = [
            Product(
              id: 'id',
              name: 'Produto 1',
              obs: 'Obs',
              amount: Random().nextInt(10).toDouble(),
              price: Random().nextDouble() * 10,
              category: '',
              isKilograms: false,
              isPurchased: true,
            ),
            Product(
              id: 'id',
              name: 'Produto 2',
              obs: 'Obs',
              amount: Random().nextInt(10).toDouble(),
              price: Random().nextDouble() * 10,
              category: '',
              isKilograms: false,
              isPurchased: false,
            ),
          ];

          expect(() => calculateTotalPriceFromListProduct(listProducts), throwsA(isA<ProductNotPurchasedException>()));
        },
      );
    },
  );
}
