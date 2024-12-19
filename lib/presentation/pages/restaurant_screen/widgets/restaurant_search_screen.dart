import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_bloc.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_event.dart';
import 'package:hungrx_app/presentation/blocs/search_restaurant/search_restaurant_state.dart';
import 'package:hungrx_app/presentation/pages/restaurant_screen/widgets/restaurant_tile.dart';

class RestaurantSearchScreen extends StatelessWidget {
  const RestaurantSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantSearchBloc(),
      child: const RestaurantSearchView(),
    );
  }
}

class RestaurantSearchView extends StatefulWidget {
  const RestaurantSearchView({super.key});

  @override
  State<RestaurantSearchView> createState() => _RestaurantSearchViewState();
}

class _RestaurantSearchViewState extends State<RestaurantSearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(context),
            _buildSearchBar(context),
            Expanded(
              child: _buildSearchResults(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
            Expanded(
              // Moved Expanded here to wrap the TextField
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  context.read<RestaurantSearchBloc>().add(
                        RestaurantSearchQueryChanged(query),
                      );
                },
                decoration: InputDecoration(
                  hintText: 'Search restaurants...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            context.read<RestaurantSearchBloc>().add(
                                  RestaurantSearchQueryChanged(''),
                                );
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    return BlocBuilder<RestaurantSearchBloc, RestaurantSearchState>(
      builder: (context, state) {
        if (state is RestaurantSearchInitial) {
          return _buildMessageWidget(
            icon: Icons.search,
            message: 'Start typing to search restaurants',
          );
        }

        if (state is RestaurantSearchLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
              strokeWidth: 3,
            ),
          );
        }

        if (state is RestaurantSearchError) {
          return _buildMessageWidget(
            icon: Icons.error_outline,
            message: state.message,
            isError: true,
          );
        }

        if (state is RestaurantSearchEmpty) {
          return _buildMessageWidget(
            icon: Icons.restaurant_outlined,
            message:
                'No restaurants found matching "${_searchController.text}"',
          );
        }

        if (state is RestaurantSearchSuccess) {
          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
            itemCount: state.restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = state.restaurants[index];
              return RestaurantItem(
                name: restaurant.name,
                imageUrl: restaurant.logo,
                rating: 0.0,
                address: 'unknow',
                distance: 'unknow',
                ontap: () => context.push('/restaurant/${restaurant.id}'),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildMessageWidget({
    required IconData icon,
    required String message,
    bool isError = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: isError ? Colors.red[400] : Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: isError ? Colors.red[400] : Colors.grey[400],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
