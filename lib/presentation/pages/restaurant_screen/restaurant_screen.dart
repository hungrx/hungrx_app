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
  static const cacheDuration =
      Duration(minutes: 15); // Cache expires after 15 minutes

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

      await prefs.setString(
          'suggested_restaurants_cache', json.encode(responseData.toJson()));
      await prefs.setString(
          'restaurants_last_fetch_time', DateTime.now().toIso8601String());
      _lastFetchTime = DateTime.now();
    } catch (e) {
      debugPrint('Error caching restaurants: $e');
    }
  }

  void _initializeData() {
    // Prevent frequent refetches
    if (_lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) <
            const Duration(seconds: 30)) {
      return;
    }
    context.read<SuggestedRestaurantsBloc>().add(FetchSuggestedRestaurants());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final padding = screenSize.width * 0.04;

    return Scaffold(
      appBar: _buildAppBar(isSmallScreen),
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
                      _buildSearchBar(padding),
                      _buildNearbyRestaurantsButton(padding, isSmallScreen),
                      if (showNearbyRestaurants)
                        _buildNearbyRestaurantsSection(padding, isSmallScreen),
                      _buildSuggestedRestaurantsSection(padding, isSmallScreen),
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

  PreferredSizeWidget _buildAppBar(bool isSmallScreen) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: isSmallScreen ? 20 : 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Restaurants',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 20 : 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          color: Colors.black,
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
            size: isSmallScreen ? 20 : 24,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'request_restaurant',
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: isSmallScreen ? 18 : 22,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'Request New Restaurant',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'set_distance',
              child: Row(
                children: [
                  Icon(
                    Icons.radio_button_checked,
                    color: Colors.white,
                    size: isSmallScreen ? 18 : 22,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'Set Search Radius',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'request_restaurant') {
              _showRequestDialog();
            } else if (value == 'set_distance') {
              _showDistanceDialog();
            }
          },
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

  Widget _buildSearchBar(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: GestureDetector(
        onTap: () {
          final suggestedBloc = context.read<SuggestedRestaurantsBloc>();
          if (suggestedBloc.state is SuggestedRestaurantsLoaded) {
            final restaurants =
                (suggestedBloc.state as SuggestedRestaurantsLoaded).restaurants;
            context.pushNamed(RouteNames.restaurantSearch, extra: restaurants);
          }
        },
        child: Container(
          height: 50,
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

  Widget _buildNearbyRestaurantsButton(double padding, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(
        bottom: padding,
        left: padding,
        right: padding,
      ),
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
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          Icons.location_on,
          color: Colors.black,
          size: isSmallScreen ? 20 : 24,
        ),
        label: Text(
          'Find Nearby Restaurants',
          style: TextStyle(
            color: Colors.black,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDistance(num distanceInMeters) {
    // Convert meters to miles (1 meter = 0.000621371 miles)
    final miles = distanceInMeters * 0.000621371;

    // Format based on distance
    if (miles < 0.1) {
      // If less than 0.1 miles, show in feet (1 mile = 5280 feet)
      final feet = (miles * 5280).round();
      if (feet < 50) {
        return 'Nearby';
      }
      return '$feet ft';
    } else if (miles >= 100) {
      // If more than 100 miles, show without decimal
      return '${miles.round()} mi';
    } else {
      // Show in miles with one decimal place
      return '${miles.toStringAsFixed(1)} mi';
    }
  }

  Widget _buildNearbyRestaurantsSection(double padding, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: padding,
            horizontal: padding,
          ),
          child: Text(
            'Nearby Restaurants',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocBuilder<NearbyRestaurantBloc, NearbyRestaurantState>(
          builder: (context, state) {
            if (state is NearbyRestaurantLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(padding * 1.5),
                  child: const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                  ),
                ),
              );
            } else if (state is NearbyRestaurantError) {
              return _buildErrorState(state.message, isSmallScreen);
            } else if (state is NearbyRestaurantLoaded) {
              if (state.restaurants.isEmpty) {
                return _buildEmptyState(
                    'No nearby restaurants found', isSmallScreen);
              }
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.restaurants.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: isSmallScreen ? 8 : 12,
                  ),
                  itemBuilder: (context, index) {
                    final restaurant = state.restaurants[index];
                    final formattedDistance =
                        _formatDistance(restaurant.distance);

                    return RestaurantItem(
                      ontap: () => _onRestaurantTap(restaurant.id, restaurant),
                      name: restaurant.restaurantName,
                      imageUrl: restaurant.logo,
                      rating: formattedDistance,
                      address: restaurant.address,
                      distance: formattedDistance,
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildSuggestedRestaurantsSection(double padding, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: padding,
          ),
          child: Text(
            'Restaurants',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BlocConsumer<SuggestedRestaurantsBloc, SuggestedRestaurantsState>(
          listener: (context, state) {
            if (state is SuggestedRestaurantsLoaded) {
              if (_cachedRestaurants == null ||
                  !_areRestaurantsEqual(
                      _cachedRestaurants!, state.restaurants)) {
                _cacheData(state.restaurants);
                setState(() {
                  _cachedRestaurants = state.restaurants;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is SuggestedRestaurantsLoading &&
                _cachedRestaurants == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.buttonColors),
                  ),
                ),
              );
            } else if (state is SuggestedRestaurantsError &&
                _cachedRestaurants == null) {
              return _buildErrorState(state.message, isSmallScreen);
            }

            final restaurants = _cachedRestaurants ??
                (state is SuggestedRestaurantsLoaded ? state.restaurants : []);

            if (restaurants.isEmpty) {
              return _buildEmptyState(
                  'No suggested restaurants available', isSmallScreen);
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: restaurants.length,
                separatorBuilder: (context, index) => SizedBox(
                  height: isSmallScreen ? 8 : 12,
                ),
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
              ),
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

  Widget _buildErrorState(String message, bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, bool isSmallScreen) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              color: Colors.grey,
              size: isSmallScreen ? 40 : 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 14 : 16,
              ),
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
