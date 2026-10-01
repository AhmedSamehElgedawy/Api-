import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/cart_cubit.dart';
import 'cubits/products_cubit.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProductsCubit()),
        BlocProvider(create: (_) => CartCubit()),
      ],
      child: MaterialApp(
        title: 'ShopLite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF1F4E8C),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
