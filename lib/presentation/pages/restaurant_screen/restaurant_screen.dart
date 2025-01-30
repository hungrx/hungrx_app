import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/nearby_restaurant_model.dart';
import 'package:hungrx_app/data/Models/restuarent_screen/suggested_restaurant_model.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_state.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_event.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/distance_dialog.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/request_restaurant_dialog.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_tile.dart';
import 'package:hungrx_app/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {

  bool showNearbyRestaurants = false;
  List<SuggestedRestaurantModel>? _cachedRestaurants;
  DateTime? _lastFetchTime;
  static const cacheDuration = Duration(minutes: 15); // Cache expires after 15 minutes

  @override
  void initState() {
    super.initState();
    _loadCachedData();
  }

  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('suggested_restaurants_cache');
    final lastFetchTimeStr = prefs.getString('restaurants_last_fetch_time');

    if (cachedData != null && lastFetchTimeStr != null) {
      final lastFetchTime = DateTime.parse(lastFetchTimeStr);
      if (DateTime.now().difference(lastFetchTime) < cacheDuration) {
        try {
          final jsonData = json.decode(cachedData);
          final restaurantsResponse = RestaurantsResponse.fromJson(jsonData);
          
          if (restaurantsResponse.status) {
            setState(() {
              _cachedRestaurants = restaurantsResponse.restaurants;
              _lastFetchTime = lastFetchTime;
            });
          }
        } catch (e) {
          debugPrint('Error loading cached restaurants: $e');
        }
      }
    }
    
    // Fetch fresh data
    _initializeData();
  }

  Future<void> _cacheData(List<SuggestedRestaurantModel> restaurants) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final responseData = RestaurantsResponse(
        status: true,
        restaurants: restaurants,
      );
      
      await prefs.setString('suggested_restaurants_cache', 
        json.encode(responseData.toJson()));
      await prefs.setString('restaurants_last_fetch_time', 
        DateTime.now().toIso8601String());
      _lastFetchTime = DateTime.now();
    } catch (e) {
      debugPrint('Error caching restaurants: $e');
    }
  }

  void _initializeData() {
    // Prevent frequent refetches
    if (_lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < const Duration(seconds: 30)) {
      return;
    }
    context.read<SuggestedRestaurantsBloc>().add(FetchSuggestedRestaurants());
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  _initializeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      _buildNearbyRestaurantsButton(),
                      if (showNearbyRestaurants)
                        _buildNearbyRestaurantsSection(),
                      _buildSuggestedRestaurantsSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Restaurants',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: Colors.black,
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'request_restaurant') {
              _showRequestDialog();
            } else if (value == 'set_distance') {
              _showDistanceDialog();
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem<String>(
              value: 'request_restaurant',
              child: Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Request New Restaurant',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'set_distance',
              child: Row(
                children: [
                  Icon(Icons.radio_button_checked, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Set Search Radius',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDistanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DistanceDialog(
          initialDistanceInMiles: 3.1,
          onDistanceChanged: (double distanceInMeters) {
            context
                .read<NearbyRestaurantBloc>()
                .add(UpdateSearchRadius(distanceInMeters));
          },
        );
      },
    );
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const RequestRestaurantDialog();
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          final suggestedBloc = context.read<SuggestedRestaurantsBloc>();
          if (suggestedBloc.state is SuggestedRestaurantsLoaded) {
            final restaurants =
                (suggestedBloc.state as SuggestedRestaurantsLoaded).restaurants;
            context.pushNamed(
              RouteNames.restaurantSearch,
              extra: restaurants,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.tileColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const IgnorePointer(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search restaurants...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurantsButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          setState(() {
            showNearbyRestaurants = true;
          });
          context.read<NearbyRestaurantBloc>().add(FetchNearbyRestaurants());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColors,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.location_on, color: Colors.black),
        label: const Text(
          'Find Nearby Restaurants',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Text(
            'Nearby Restaurants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<NearbyRestaurantBloc, NearbyRestaurantState>(
          builder: (context, state) {
            if (state is NearbyRestaurantLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                  ),
                ),
              );
            } else if (state is NearbyRestaurantError) {
              return _buildErrorState(state.message);
            } else if (state is NearbyRestaurantLoaded) {
              if (state.restaurants.isEmpty) {
                return _buildEmptyState('No nearby restaurants found');
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.restaurants.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final restaurant = state.restaurants[index];
                  return RestaurantItem(
                    ontap: () => _onRestaurantTap(restaurant.id, restaurant),
                    name: restaurant.restaurantName,
                    imageUrl: restaurant.logo,
                    rating:
                        '${(restaurant.distance / 1000).toStringAsFixed(1)} km',
                    address: restaurant.address,
                    distance:
                        '${(restaurant.distance / 1000).toStringAsFixed(1)} km',
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSuggestedRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text(
            'Restaurants',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocConsumer<SuggestedRestaurantsBloc, SuggestedRestaurantsState>(
          listener: (context, state) {
            if (state is SuggestedRestaurantsLoaded) {
              // Only update cache if data has changed
              if (_cachedRestaurants == null || 
                  !_areRestaurantsEqual(_cachedRestaurants!, state.restaurants)) {
                _cacheData(state.restaurants);
                setState(() {
                  _cachedRestaurants = state.restaurants;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is SuggestedRestaurantsLoading && _cachedRestaurants == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SuggestedRestaurantsError && _cachedRestaurants == null) {
              return _buildErrorState(state.message);
            }

            // Use cached data or new data
            final restaurants = _cachedRestaurants ?? 
              (state is SuggestedRestaurantsLoaded ? state.restaurants : []);

            if (restaurants.isEmpty) {
              return _buildEmptyState('No suggested restaurants available');
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return RestaurantItem(
                  ontap: () {
                    _onRestaurantTap(restaurant.id, null);
                  },
                  name: restaurant.name,
                  imageUrl: restaurant.logo,
                  rating: null,
                  address: restaurant.address,
                  distance: restaurant.distance != null
                      ? '${(restaurant.distance! / 1000).toStringAsFixed(1)} km'
                      : 'Distance not available',
                );
              },
            );
          },
        ),
      ],
    );
  }

  bool _areRestaurantsEqual(List<SuggestedRestaurantModel> list1, 
      List<SuggestedRestaurantModel> list2) {
    if (list1.length != list2.length) return false;
    
    for (int i = 0; i < list1.length; i++) {
      if (!list1[i].equals(list2[i])) return false;
    }
    
    return true;
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              color: Colors.grey,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onRestaurantTap(
      String? restaurantId, NearbyRestaurantModel? restaurant) {
    context.pushNamed(RouteNames.menu, extra: {
      'restaurantId': restaurantId,
      'restaurant': restaurant,
    });
  }
}
