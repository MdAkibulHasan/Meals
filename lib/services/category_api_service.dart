import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals/models/category.dart';

class CategoryApiService {
  static const String _baseUrl =
      'https://retoolapi.dev/tCwJX2/categories'; // Replace with actual API endpoint

  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> categoriesData = json.decode(response.body);

        return categoriesData.map((categoryData) {
          return Category(
            id: categoryData['id'], // Convert to int
            title: categoryData['title'],
            color: _parseColor(categoryData['color']),
          );
        }).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  // Helper method to convert hex color string to Color
  static Color _parseColor(String hexColor) {
    // Remove the '#' if present
    final cleanHexColor = hexColor.replaceFirst('#', '');

    // Convert to an 8-digit hex color (with alpha)
    final fullHexColor =
        cleanHexColor.length == 6 ? 'ff$cleanHexColor' : cleanHexColor;

    // Parse the color
    return Color(int.parse(fullHexColor, radix: 16));
  }
}
