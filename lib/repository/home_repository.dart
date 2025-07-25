import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fe_training/model/login_model.dart';
import 'package:fe_training/model/product_model.dart';
import 'package:fe_training/utils/api_service.dart';
import 'package:fe_training/utils/nav_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeRepository {
  final apiService = NavService.navKey.currentContext!.read<ApiService>();
  Future<bool> login(LoginModel login) async {
    String apiUrl = '${apiService.baseUrl}/login';
    final String requestBody = loginModelToJson(login);

    try {
      final Response response = await apiService.dio.post(
        apiUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        await apiService.setToken(token);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', login.username);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("error when login repo $e");
      return false;
    }
  }

  Future<bool> regis(LoginModel login) async {
    String apiUrl = '${apiService.baseUrl}/partner';
    final String requestBody = loginModelToJson(login);

    try {
      final Response response = await apiService.dio.post(
        apiUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final String token = response.data['token'];
        await apiService.setToken(token);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', login.username);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("error when login repo $e");
      return false;
    }
  }

  Future<List<Product>> fetchProducts() async {
    String apiUrl = '${apiService.baseUrl}/product';
    try {
      final Response response = await apiService.dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      log("response fetch products ${response.data}");
      if (response.statusCode == 200) {
        return productFromJson(jsonEncode(response.data));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<Favorite>> fetchFavorite() async {
    String apiUrl = '${apiService.baseUrl}/favorite';
    try {
      final Response response = await apiService.dio.get(
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return favoriteFromJson(jsonEncode(response.data));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<bool> addFavorite(int productId) async {
    String apiUrl = '${apiService.baseUrl}/favorite';
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final Response response = await apiService.dio.post(
        apiUrl,
        data: jsonEncode({'product_id': productId, 'user_id': '$username'}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add favorite');
      }
    } catch (e) {
      throw Exception('Error adding favorite: $e');
    }
  }

  Future<bool> removeFavorite(int productId) async {
    String apiUrl = '${apiService.baseUrl}/favorite';
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final Response response = await apiService.dio.delete(
        apiUrl,
        data: jsonEncode({'product_id': productId, 'user_id': '$username'}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove favorite');
      }
    } catch (e) {
      throw Exception('Error removing favorite: $e');
    }
  }

  Future<bool> addProduct(String name, String description) async {
    String apiUrl = '${apiService.baseUrl}/product';
    try {
      final Response response = await apiService.dio.post(
        apiUrl,
        data: jsonEncode({'name': name, 'desc': description}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<bool> updateProduct(int id, String name, String description) async {
    String apiUrl = '${apiService.baseUrl}/product?id=$id';
    try {
      final Response response = await apiService.dio.put(
        apiUrl,
        data: jsonEncode({'name': name, 'desc': description}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  Future<bool> removeProduct(int productId) async {
    String apiUrl = '${apiService.baseUrl}/product?id=$productId';
    try {
      final Response response = await apiService.dio.delete(
        apiUrl,
        data: jsonEncode({'product_id': productId}),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': apiService.token,
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to remove product');
      }
    } catch (e) {
      throw Exception('Error removing product: $e');
    }
  }
}
