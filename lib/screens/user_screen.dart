import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../a_Database/todb.dart';
import '../widgets/user_item.dart';
import '../widgets/sidebar.dart';
import 'edit_screen.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ToDB>(context).fetchAndSetMeals();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ToDB>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meals'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditScreen.routeName);
            },
          ),
        ],
      ),
      drawer: Sidebar(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserItem(
                  productsData.items[i].id,
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
