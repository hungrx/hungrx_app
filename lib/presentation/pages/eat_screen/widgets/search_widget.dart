import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/data/Models/eat_screen_search_models.dart';
import 'package:hungrx_app/data/datasources/api/eat_search_screen_api_service.dart';
import 'package:hungrx_app/data/repositories/eat_search_screen_repository.dart';
import 'package:hungrx_app/domain/usecases/eat_screen_search_food_usecase.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_bloc.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_event.dart';
import 'package:hungrx_app/presentation/blocs/eat_screen_search/eat_screen_search_state.dart';
import 'package:hungrx_app/routes/route_names.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EatScreenSearchBloc(
        searchUseCase: EatScreenSearchFoodUsecase(
          EatSearchScreenRepository(
            EatSearchScreenApiService(),
          ),
        ),
      ),
      child: const SearchScreenContent(),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  const SearchScreenContent({super.key});

  @override
  State<SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SearchTextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade400),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<EatScreenSearchBloc, EatScreenSearchState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state is SearchLoading)
                LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade900,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                ),
              Expanded(
                child: _buildSearchResults(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(EatScreenSearchState state) {
    if (state is SearchInitial) {
      return const Center(
        child: Text(
          'Search for food or restaurants',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    if (state is SearchError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            const Text(
              'No Food Found!',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (state is SearchSuccess) {
      if (state.results.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey.shade600),
                const SizedBox(height: 16),
                Text(
                  'No results found for "${state.query}"',
                  style: TextStyle(color: Colors.grey.shade400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          final item = state.results[index];
          return SearchResultTile(item: item);
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for food or restaurants...',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 0,
        ),
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear, color: Colors.grey.shade400),
          onPressed: () {
            controller.clear();
            context.read<EatScreenSearchBloc>().add(SearchTextChanged(''));
          },
        ),
      ),
      onChanged: (value) {
        print("search value: $value");
        context.read<EatScreenSearchBloc>().add(SearchTextChanged(value));
      },
    );
  }
}

class SearchResultTile extends StatelessWidget {
  final SearchItemModel item;

  const SearchResultTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: item.image != null
            ? Image.network(
                item.image!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade800,
                    child: Icon(Icons.fastfood, color: Colors.grey.shade400),
                  );
                },
              )
            : Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade800,
                child: Icon(Icons.fastfood, color: Colors.grey.shade400),
              ),
      ),
      title: Text(
        item.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      subtitle: !item.isRestaurant && item.nutritionFacts != null
          ? Text(
              '${item.nutritionFacts!.calories} calories',
              style: TextStyle(color: Colors.grey.shade400),
            )
          : item.isRestaurant
              ? Text(
                  'Restaurant',
                  style: TextStyle(color: Colors.blue.shade300),
                )
              : null,
      onTap: () {
        if (item.isRestaurant) {
          context.pushNamed(
            RouteNames.restaurantDetails,
            extra: item,
          );
        } else {
        //  context.goNamed(
        //     RouteNames.foodDetail,
        //     pathParameters: {'id': item.id},
        //     extra: item,
        //   );
        }
      },
    );
  }
}
