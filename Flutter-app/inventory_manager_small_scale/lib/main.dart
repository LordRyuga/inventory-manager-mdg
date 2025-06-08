import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/product/presentation/bloc/product_bloc.dart';
import 'features/product/presentation/pages/product_list_page.dart';
import 'core/utils/app_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // <-- initialize dependencies
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => di.sl<ProductBloc>(),
        ),
        // Add other Blocs here in future
      ],
      child: MaterialApp(
        title: 'Inventory App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        navigatorKey: AppUtils.navigatorKey,
        home: const ProductListPage(),
      ),
    );
  }
}
