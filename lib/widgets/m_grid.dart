import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../a_Database/todb.dart';
import '../widgets/m_show.dart';

class MGrid extends StatelessWidget {
  final bool showFavs;

  MGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ToDB>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: MShow(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
