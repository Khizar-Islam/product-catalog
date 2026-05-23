import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _items = [];
  bool _loading = false;
  String? _error;

  List<Product> get products => List.unmodifiable(_items);
  bool get isLoading => _loading;
  String? get errorMessage => _error;
  bool get hasError => _error != null;
  bool get isEmpty => !_loading && _items.isEmpty;

  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _service.fetchProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final saved = await _service.createProduct(product);
      _items = [..._items, saved];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _service.updateProduct(product);
      final idx = _items.indexWhere((p) => p.id == product.id);
      if (idx != -1) {
        final updated = List<Product>.from(_items);
        updated[idx] = product;
        _items = updated;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _service.removeProduct(id);
      _items = _items.where((p) => p.id != id).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}