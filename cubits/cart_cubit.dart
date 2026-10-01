import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem(this.product, this.quantity);
}

class CartState {
  final List<CartItem> items;
  CartState(this.items);

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  double get tax => subtotal * 0.10;

  double get total => subtotal + tax;

  int get count => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState([]));

  void addToCart(Product product) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == product.id);

    if (index == -1) {
      items.add(CartItem(product, 1));
    } else {
      items[index] = CartItem(product, items[index].quantity + 1);
    }
    emit(CartState(items));
  }

  void increase(Product product) => addToCart(product);

  void decrease(Product product) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((i) => i.product.id == product.id);
    if (index == -1) return;

    if (items[index].quantity > 1) {
      items[index] = CartItem(product, items[index].quantity - 1);
    } else {
      items.removeAt(index);
    }
    emit(CartState(items));
  }

  void clear() => emit(CartState([]));
}
