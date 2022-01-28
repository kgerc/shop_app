// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/models/authentication_service.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';

class LoginScreen extends StatelessWidget {
	static const routeName = '/log-in';
	final TextEditingController emailController = TextEditingController();
	final TextEditingController passwordController = TextEditingController();
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text("Log in")),
			body: 
				Padding(
					padding: const EdgeInsets.all(16.0),
					child: Column(
					children: [
						TextField(
							controller: emailController,
							decoration: InputDecoration(labelText: "Email"),
						),
						TextField(
							controller: passwordController,
							decoration: InputDecoration(labelText: "Password"),
							obscureText: true,
						),
						ElevatedButton(
							onPressed: () async {
								await context.read<AuthenticationService>().signIn(
									email: emailController.text.trim(),
									password: passwordController.text.trim()
								);
								if (FirebaseAuth.instance.currentUser != null)
								{
									Navigator.of(context).pushReplacementNamed('/');
								} else {
									Fluttertoast.showToast(
										msg: "Uncorrect email or password!",
										toastLength: Toast.LENGTH_SHORT,
										gravity: ToastGravity.BOTTOM,
										timeInSecForIosWeb: 1,
										backgroundColor: Colors.purple[50],
										textColor: Colors.black87,
										fontSize: 16.0
									);
								}
							},
							child: Text("Sign in"),
						)
					],
				),
			));
	}
}
