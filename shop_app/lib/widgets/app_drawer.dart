// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shop_app/models/authentication_service.dart';
import 'package:shop_app/screens/login_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/registration_screen.dart';
import 'package:shop_app/screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return drawerContent();
  }
}

class drawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (context.watch<User?>() != null) {
      return Drawer(
          child: Column(
        children: [
          AppBar(
            title: Text("Hello!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Log out"),
            onTap: () {
              context.read<AuthenticationService>().signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
      ));
    } else {
      return Drawer(
          child: Column(
        children: [
          AppBar(
            title: Text("Hello!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text("Log in"),
            onTap: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text("Sign up"),
            onTap: () {
              Navigator.of(context).pushNamed(RegistrationScreen.routeName);
            },
          )
        ],
      ));
    }
  }
}
