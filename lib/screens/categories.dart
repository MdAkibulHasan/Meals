import 'package:flutter/material.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meals.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/services/category_api_service.dart';
import 'package:meals/services/meal-service.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavorite,
  });

  final void Function(Meal meal) onToggleFavorite;

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  List<Meal> _meals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final categoriesFuture = CategoryApiService.fetchCategories();
      final mealsFuture = MealsService.fetchMeals();

      final results = await Future.wait([categoriesFuture, mealsFuture]);

      setState(() {
        _categories = results[0] as List<Category>;
        _meals = results[1] as List<Meal>;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Unable to load data. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals =
        _meals.where((meal) => meal.categories.contains(category.id)).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          onToggleFavorite: widget.onToggleFavorite,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : GridView(
                padding: const EdgeInsets.all(24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                children: _categories
                    .map((category) => CategoryGridItem(
                          category: category,
                          onSelectCategory: () {
                            _selectCategory(context, category);
                          },
                        ))
                    .toList(),
              );

    return content;
  }
}
