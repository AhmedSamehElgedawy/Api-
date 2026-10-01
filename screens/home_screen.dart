import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/products_cubit.dart';
import '../widgets/primary_button.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(

        child: BlocConsumer<ProductsCubit, ProductsState>(
          listener: (context, state) {
            if (state is ProductsSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductListScreen()),
              );
            } else if (state is ProductsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'ShopLite',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (state is ProductsLoading)
                    const CircularProgressIndicator()
                  else
                    PrimaryButton(
                      text: state is ProductsError ? 'Try Again' : 'Fetch Products',
                      icon: Icons.shopping_cart,
                      onPressed: () => context.read<ProductsCubit>().fetchProducts(),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    state is ProductsError
                        ? state.message
                        : 'Explore our collection of quality products.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: state is ProductsError ? Colors.red : Colors.black87,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
