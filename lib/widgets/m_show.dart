import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/detail_screen.dart';
import '../classx/meal.dart';

class MShow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealX = Provider.of<Meal>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              DetailScreen.routeName,
              arguments: mealX.id,
            );
          },
          child: Image.network(
            mealX.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Meal>(
            builder: (ctx, mealX, _) => IconButton(
              icon: Icon(
                mealX.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                mealX.toggleFavoriteStatus();
              },
            ),
          ),
          title: Text(
            mealX.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_location,
            ),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Clicked',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {},
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
