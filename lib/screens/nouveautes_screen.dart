import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterOptions {
  Favorite,
  All,
}

class NouveautesScreen extends StatefulWidget {
  static const routeName = '/nouveautes';
  @override
  NouveautesScreenState createState() => NouveautesScreenState();
}

class NouveautesScreenState extends State<NouveautesScreen> {
  var _showOnlyfav = false;
  var _isInit = true;
  var _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOUVEAUTES'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only favorites'), value: FilterOptions.Favorite),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showOnlyfav = true;
                } else {
                  _showOnlyfav = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.count.toString(),
            ),
            child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: HogeApp(), //ProductsGrid(_showOnlyfav),
    );
  }
}

class HogeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // <1> Use FutureBuilder
    return FutureBuilder<QuerySnapshot>(
      // <2> Pass `Future<QuerySnapshot>` to future
        future: FirebaseFirestore.instance.collection('rdv').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
                children: documents
                    .map((doc) => Card(
                  child: ListTile(
                    title: Text(doc['title']+' du '+doc['jour']+' '+doc['nbjour']+' '+doc['mois']+' '+doc['annee']),
                    subtitle: Text(doc['description']),
                  ),
                ))
                    .toList());
          } else if (snapshot.hasError) {
            return Text('un probleme est survenu!');
          }
        });
  }
}