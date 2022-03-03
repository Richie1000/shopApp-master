import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dt;
import 'package:http/http.dart' as http;
import "./cart.dart";

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(@required this.id, @required this.amount, @required this.products,
      @required this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  Orders(this._orders, this.authToken); 

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    Uri url = Uri.parse(
        'https://shop-app-d00fc-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    DateTime now = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': now.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList(),
        }));

    //final newOrder = OrderItem(CartItem , amount, cartProducts, dateTime)

    _orders.insert(
      0,
      OrderItem(
        json.decode(response.body)['name'],
        total,
        cartProducts,
        DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final Uri url = Uri.parse(
        'https://shop-app-d00fc-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(OrderItem(
          orderId,
          orderData['amount'],
          (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrder;
    notifyListeners();
  }
}
