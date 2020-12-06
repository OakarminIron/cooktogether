import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import '../classx/meal.dart';

class ToDB with ChangeNotifier {
  List<Meal> _meals = [];

  List<Meal> get items {
    return [..._meals];
  }

  List<Meal> get favoriteItems {
    return _meals.where((jsonItem) => jsonItem.isFavorite).toList();
  }

  Meal findById(String id) {
    return _meals.firstWhere((json) => json.id == id);
  }

  Future<void> fetchAndSetMeals() async {
    const url = 'https://cooktogether-1d65e-default-rtdb.firebaseio.com/meals.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Meal> loadedMeals = [];
      print("Json Data--------------------------------------------------");
      print(extractedData);
      extractedData.forEach((jsonId, jsonData) {
        loadedMeals.add(Meal(
          id: jsonId,
          title: jsonData['title'],
          description: jsonData['description'],
          isFavorite: jsonData['isFavorite'],
          imageUrl: jsonData['imageUrl'],
          steps: jsonData['steps'],
          categorie: jsonData['categorie'],

          /*
         
          ingredients: jsonData['ingredients'],
          duration: jsonData['duration'],
          isVegetarian: jsonData['isVegetarian'],
          complexity: jsonData['complexity'],
          */
        ));
      });
      _meals = loadedMeals;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addMeal(Meal addJsonMeal) async {
    const url = 'https://cooktogether-1d65e-default-rtdb.firebaseio.com/meals.json';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': addJsonMeal.title,
          'description': addJsonMeal.description,
          'isFavorite': addJsonMeal.isFavorite,
          'imageUrl': addJsonMeal.imageUrl,
          'steps': addJsonMeal.steps,
          'categorie': addJsonMeal.categorie,
        }),
      );
      final newMeal = Meal(
        id: json.decode(response.body)['name'],
        title: addJsonMeal.title,
        description: addJsonMeal.description,
        isFavorite: addJsonMeal.isFavorite,
        imageUrl: addJsonMeal.imageUrl,
        steps: addJsonMeal.steps,
        categorie: addJsonMeal.categorie,
      );
      _meals.add(newMeal);

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateMeal(String id, Meal jsonUP) async {
    final mealID = _meals.indexWhere((prod) => prod.id == id);
    if (mealID >= 0) {
      final url = 'https://cooktogether-1d65e-default-rtdb.firebaseio.com/meals/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': jsonUP.title,
            'description': jsonUP.description,
            'isFavorite': jsonUP.isFavorite,
            'imageUrl': jsonUP.imageUrl,
            'steps': jsonUP.steps,
            'categorie': jsonUP.categorie,
          }));
      _meals[mealID] = jsonUP;
      notifyListeners();
    } else {
      print('Update Fail');
    }
  }

  Future<void> deleteMeal(String id) async {
    final url = 'https://cooktogether-1d65e-default-rtdb.firebaseio.com/meals/$id.json';
    final existingMealIndex = _meals.indexWhere((prod) => prod.id == id);
    var existingMeal = _meals[existingMealIndex];
    _meals.removeAt(existingMealIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _meals.insert(existingMealIndex, existingMeal);
      notifyListeners();

      throw HttpException('Delete Fail');
    }
    existingMeal = null;
    print('Delecte Success');
  }
}
