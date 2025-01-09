import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_tile.dart';
import 'package:hungrx_app/routes/route_names.dart';

class RestaurantSearchScreen extends StatefulWidget {
  final List<SuggestedRestaurantModel> restaurants;
  
  const RestaurantSearchScreen({
    super.key, 
    required this.restaurants,
  });

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<RestaurantSearchBloc>().add(
        SearchRestaurants(_searchController.text),
      );
    });
  }

  @override
Widget build(BuildContext context) {
  return BlocProvider.value(
    value: context.read<RestaurantSearchBloc>(),
    child: _RestaurantSearchContent(
      searchController: _searchController,
    ),
  );
}
}

class _RestaurantSearchContent extends StatelessWidget {
  final TextEditingController searchController;

  const _RestaurantSearchContent({
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search restaurants...',
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                searchController.clear();
                context.read<RestaurantSearchBloc>().add(ClearRestaurantSearch());
              },
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<RestaurantSearchBloc, RestaurantSearchState>(

        builder: (context, state) {
          debugPrint('Rebuilding UI with ${state.searchResults.length} results');
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          }

          if (state.error.isNotEmpty) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (state.searchResults.isEmpty && searchController.text.isNotEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    color: Colors.grey,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No restaurants found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final restaurant = state.searchResults[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
                child: RestaurantItem(
                  ontap: () => context.pushNamed(
                    RouteNames.menu,
                    extra: restaurant.id,
                  ),
                  name: restaurant.name,
                  imageUrl: restaurant.logo,
                  rating: null,
                  address: restaurant.address,
                  distance: restaurant.distance != null
                      ? '${(restaurant.distance! / 1000).toStringAsFixed(1)} km'
                      : 'Distance not available',
                ),
              );
            },
          );
        },
      ),
    );
  }
}