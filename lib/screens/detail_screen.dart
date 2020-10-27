import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../a_Database/todb.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  @override
  Widget build(BuildContext context) {
    final mealID =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedMeal = Provider.of<ToDB>(
      context,
      listen: false,
    ).findById(mealID);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedMeal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Color.fromRGBO(153, 52, 255, 20),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedMeal.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedMeal.categorie.toString(),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedMeal.steps,
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
