import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsSuccess extends ProductsState {
  final List<Product> products;
  ProductsSuccess(this.products);
}

class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent': 'Mozilla/5.0 (Linux; Android 14) ShopLite/1.0',
  };

  Future<void> fetchProducts() async {
    emit(ProductsLoading());

    try {
      final products = await _fromFakeStore();
      emit(ProductsSuccess(products));
    } catch (e1) {
      try {
        final products = await _fromDummyJson();
        emit(ProductsSuccess(products));
      } catch (e2) {
        emit(ProductsError('Could not load products.\n$e2'));
      }
    }
  }

  Future<List<Product>> _fromFakeStore() async {
    final response = await http
        .get(Uri.parse('https://fakestoreapi.com/products'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Fake Store API error ${response.statusCode}');
    }
    final List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> _fromDummyJson() async {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/products?limit=20'), headers: _headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('DummyJSON error ${response.statusCode}');
    }
    final List data = jsonDecode(response.body)['products'];
    return data.map((e) => Product.fromDummyJson(e)).toList();
  }
}
