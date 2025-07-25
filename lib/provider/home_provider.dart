import 'package:fe_training/model/product_model.dart';
import 'package:fe_training/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TextEditingController namaController = TextEditingController();
  TextEditingController descController = TextEditingController();
  List<Product> _items = [];
  List<Product> get items => _items;
  set items(List<Product> value) {
    _items = value;
    notifyListeners();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  set errorMessage(String value) {
    _errorMessage = value;
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    notifyListeners();
  }

  final HomeRepository _homeRepository = HomeRepository();

  Future<void> fetchItems() async {
    isLoading = true;
    final items = await _homeRepository.fetchProducts();
    final favoriteItems = await _homeRepository.fetchFavorite();
    for (var item in items) {
      item.isFavorite = favoriteItems.any((fav) => fav.productId == item.id);
    }
    _items = items;

    isLoading = false;
  }

  Future<void> addItem() async {
    if (namaController.text.isNotEmpty && descController.text.isNotEmpty) {
      try {
        isLoading = true;
        var res = await _homeRepository.addProduct(
          namaController.text,
          descController.text,
        );
        if (res) {
          namaController.clear();
          descController.clear();
        }
        await fetchItems();
        notifyListeners();
      } catch (e) {
        errorMessage = 'Failed to add item';
      } finally {
        isLoading = false;
      }
    }
  }

  Future<void> updateItem(int index) async {
    if (index >= 0 && index < _items.length) {
      try {
        isLoading = true;
        var res = await _homeRepository.updateProduct(
          _items[index].id ?? -1,
          namaController.text,
          descController.text,
        );
        if (res) {
          namaController.clear();
          descController.clear();
        }
        await fetchItems();
      } catch (e) {
        errorMessage = 'Failed to update item';
      } finally {
        isLoading = false;
      }
    }
  }

  void toggleFavorite(int index) async {
    if (index >= 0 && index < _items.length) {
      try {
        if (!_items[index].isFavorite) {
          var res = await _homeRepository.addFavorite(_items[index].id ?? -1);
          if (res) {
            _items[index].isFavorite = true;
          }
        } else {
          var res = await _homeRepository.removeFavorite(
            _items[index].id ?? -1,
          );
          if (res) {
            _items[index].isFavorite = false;
          }
        }
      } catch (e) {
        errorMessage = 'Failed to toggle favorite';
      } finally {
        notifyListeners();
      }
    }
  }

  Future<void> removeItem(int index) async {
    try {
      if (index >= 0 && index < _items.length) {
        isLoading = true;
        await _homeRepository.removeProduct(_items[index].id ?? -1);
        await fetchItems();
      }
    } catch (e) {
      errorMessage = 'Failed to remove item';
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }
}
