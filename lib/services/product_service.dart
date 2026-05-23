import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';
import '../models/product.dart';

class ProductService {
  final String _endpoint = ApiConstants.productsEndpoint;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Could not load products. Code: ${response.statusCode}');
    }
  }

  Future<Product> createProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Could not save product. Code: ${response.statusCode}');
    }
  }

  Future<void> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$_endpoint/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not update product. Code: ${response.statusCode}');
    }
  }

  Future<void> removeProduct(String id) async {
    final response = await http.delete(Uri.parse('$_endpoint/$id'));

    if (response.statusCode != 200) {
      throw Exception('Could not delete product. Code: ${response.statusCode}');
    }
  }
}