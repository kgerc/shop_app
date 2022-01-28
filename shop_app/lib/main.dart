import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/registration_screen.dart';
import 'package:shop_app/screens/user_products.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import 'models/authentication_service.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'firebase_options.dart';


void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,
	);
	runApp(MyApp());
}

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);
	@override
	Widget build(BuildContext context) {
		return MultiProvider(
			providers: [
				ChangeNotifierProvider(
					create: (ctx) => Products(),
				),
				ChangeNotifierProvider(
					create: (ctx) => Cart(),
				),
				ChangeNotifierProvider(
					create: (ctx) => Orders(),
				),
				Provider<AuthenticationService>(
								create: (_) => AuthenticationService(FirebaseAuth.instance),
						),
				StreamProvider (
								create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
						),
			],
			child: MaterialApp(
				title: 'Flutter Demo',
				theme: ThemeData(
					colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
						.copyWith(secondary: Colors.deepOrange),
					fontFamily: 'Lato'),
				home: ProductsOverviewScreen(),
				routes: {
					ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
					CartScreen.routeName: (ctx) => CartScreen(),
					OrdersScreen.routeName: (ctx) => OrdersScreen(),
					UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
					EditProductScreen.routeName: (ctx) => EditProductScreen(),
					LoginScreen.routeName: (ctx) => LoginScreen(),
          RegistrationScreen.routeName: (ctx) => RegistrationScreen()
				},
			),
		);
	}
}

// class AuthenticationWrapper //extends StatelessWidget {
	//   	const AuthenticationWrapper({
	// 	  Key? key,
	// }) : super(key : key);

		// @override 
		// Widget build(BuildContext context){
		// 	final firebaseUser = context.watch<User?>();
	
	// 	if(firebaseUser != null){
	// 		return HomePage();
	// 	}
	// 	return SignInPage();
	// 	return 
	// }
// }