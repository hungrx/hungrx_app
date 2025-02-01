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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final padding = screenSize.width * 0.04;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isSmallScreen ? 48 : 56),
        child: AppBar(
          backgroundColor: Colors.black,
          title: SizedBox(
            height: isSmallScreen ? 40 : 48,
            child: TextField(
              controller: searchController,
              autofocus: true,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: isSmallScreen ? 20 : 24,
            ),
            constraints: BoxConstraints(
              minWidth: isSmallScreen ? 32 : 40,
              minHeight: isSmallScreen ? 32 : 40,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: BlocBuilder<RestaurantSearchBloc, RestaurantSearchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: SizedBox(
                width: isSmallScreen ? 24 : 32,
                height: isSmallScreen ? 24 : 32,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            );
          }

          if (state.error.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  state.error,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.searchResults.isEmpty && searchController.text.isNotEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      color: Colors.grey,
                      size: isSmallScreen ? 40 : 48,
                    ),
                    SizedBox(height: padding),
                    Text(
                      'No restaurants found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: padding * 0.75,
              horizontal: padding * 0.5,
            ),
            itemCount: state.searchResults.length,
            itemBuilder: (context, index) {
              final restaurant = state.searchResults[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: padding * 0.25,
                ),
                child: RestaurantItem(
                  ontap: () {
                    context.pushNamed(
                      RouteNames.menu,
                      extra: {
                        'restaurantId': restaurant.id,
                        'restaurant': null,
                      },
                    );
                  },
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
