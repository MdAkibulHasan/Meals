import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meals/models/meals.dart';

class MealsService {
  static const apiUrl =
      'https://mocki.io/v1/5b36a777-6c65-465a-bde0-472875b8195d';

  static Future<List<Meal>> fetchMeals() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> mealsData = json.decode(response.body);
        return mealsData.map((mealJson) => _parseMeal(mealJson)).toList();
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }

  static Meal _parseMeal(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? '',
      categories: _parseCategories(json['categories']),
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((ingredient) => ingredient.toString())
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((step) => step.toString())
          .toList(),
      duration: json['duration'] ?? 0,
      complexity: _parseComplexity(json['complexity']),
      affordability: _parseAffordability(json['affordability']),
      isGlutenFree: json['isGlutenFree'] ?? false,
      isLactoseFree: json['isLactoseFree'] ?? false,
      isVegan: json['isVegan'] ?? false,
      isVegetarian: json['isVegetarian'] ?? false,
    );
  }

  static List<int> _parseCategories(dynamic categories) {
    if (categories == null) return [];

    if (categories is List) {
      return categories
          .map((cat) => int.tryParse(cat.toString()) ?? 0)
          .toList();
    }

    return [int.tryParse(categories.toString()) ?? 0];
  }

// ... rest of the code remains the same

  static Complexity _parseComplexity(String? complexityStr) {
    switch (complexityStr) {
      case 'Complexity.simple':
        return Complexity.simple;
      case 'Complexity.challenging':
        return Complexity.challenging;
      case 'Complexity.hard':
        return Complexity.hard;
      default:
        return Complexity.simple;
    }
  }

  static Affordability _parseAffordability(String? affordabilityStr) {
    switch (affordabilityStr) {
      case 'Affordability.affordable':
        return Affordability.affordable;
      case 'Affordability.pricey':
        return Affordability.pricey;
      case 'Affordability.luxurious':
        return Affordability.luxurious;
      default:
        return Affordability.affordable;
    }
  }
}
