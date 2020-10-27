import 'package:flutter/foundation.dart';

enum Complexity {
  Simple,
  Challenging,
  Hard,
}

class Meal with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String steps;
  bool isFavorite;
  final List categorie;
  // final List<String> ingredients;
  //final int duration;
  // final Complexity complexity;
  // final bool isVegetarian;

  Meal({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.steps,
    this.isFavorite = false,
    @required this.categorie,
    //@required this.ingredients,
    //@required this.duration,
    //@required this.complexity,
    //@required this.isVegetarian,
  });
/*
  String get complexityText {
    switch (complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Challenging:
        return 'Challenging';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      default:
        return 'Unknown';
    }
  }
*/
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
