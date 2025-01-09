import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_bloc.dart';
// import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/nearby_restaurant/nearby_restaurant_state.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_bloc.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_event.dart';
import 'package:hungrx_app/presentation/blocs/suggested_restaurants/suggested_restaurants_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_tile.dart';
import 'package:hungrx_app/routes/route_names.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final _restaurantTypeController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _areaController = TextEditingController();
  bool showNearbyRestaurants = false;
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
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
            // _buildHeader(),
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

  // Widget _buildHeader() {
  //   return Row(
  //     children: [
  //       IconButton(
  //         onPressed: () {
  //           context.pop();
  //         },
  //         icon: const Icon(
  //           Icons.arrow_back,
  //           color: Colors.white,
  //           size: 24,
  //         ),
  //       ),
  //       const Text(
  //         'Restaurants',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 24,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),

  //     ],
  //   );
  // }

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
          ],
        ),
      ],
    );
  }

  void _showRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Request New Restaurant',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _restaurantNameController,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Name',
                    prefixIcon: const Icon(Icons.restaurant),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _restaurantTypeController,
                  decoration: InputDecoration(
                    labelText: 'Restaurant Type',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    labelText: 'Area',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: AppColors.buttonColors),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle the restaurant request here
                        // You can access the values using:
                        // _restaurantNameController.text
                        // _restaurantTypeController.text
                        // _areaController.text
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// In your RestaurantScreen
Widget _buildSearchBar() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: GestureDetector(
      onTap: () {
        final suggestedBloc = context.read<SuggestedRestaurantsBloc>();
        if (suggestedBloc.state is SuggestedRestaurantsLoaded) {
          final restaurants = (suggestedBloc.state as SuggestedRestaurantsLoaded).restaurants;
          context.pushNamed(
            RouteNames.restaurantSearch,
            extra: restaurants,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
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
        onPressed: () {},
        // () {
        //   setState(() {
        //     showNearbyRestaurants = true;
        //   });
        //   context.read<NearbyRestaurantBloc>().add(FetchNearbyRestaurants());
        // },
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
                    ontap: () => _onRestaurantTap(restaurant.id),
                    name: restaurant.name,
                    imageUrl: restaurant.id,
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
        BlocBuilder<SuggestedRestaurantsBloc, SuggestedRestaurantsState>(
          builder: (context, state) {
            if (state is SuggestedRestaurantsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SuggestedRestaurantsError) {
              return _buildErrorState(state.message);
            } else if (state is SuggestedRestaurantsLoaded) {
              if (state.restaurants.isEmpty) {
                return _buildEmptyState('No suggested restaurants available');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = state.restaurants[index];
                  return RestaurantItem(
                    ontap: () {
                      _onRestaurantTap(restaurant.id);
                    },
                    name: restaurant.name,
                    imageUrl: restaurant.logo,
                    rating: null,
                    address: null,
                    distance: restaurant.distance != null
                        ? '${(restaurant.distance! / 1000).toStringAsFixed(1)} km'
                        : 'Distance not available',
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
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

  void _onRestaurantTap(String? restaurantId) {
    context.pushNamed(RouteNames.menu, extra: restaurantId);
  }
}
