class CartResponseModel {
  final bool success;
  final String message;
  final List<CartModel> data;
  final double remaining;

  CartResponseModel({
    required this.success,
    required this.message,
    required this.data,
    required this.remaining,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List).map((e) => CartModel.fromJson(e)).toList(),
      remaining: (json['remaining'] as num).toDouble(),
    );
  }
}

class CartModel {
  final String cartId;
  final List<OrderItem> orders;
  final List<DishDetail> dishDetails;
  final DateTime createdAt;

  CartModel({
    required this.cartId,
    required this.orders,
    required this.dishDetails,
    required this.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'],
      orders: (json['orders'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      dishDetails: (json['dishDetails'] as List).map((e) => DishDetail.fromJson(e)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OrderItem {
  final String restaurantId;
  final List<CartItem> items;

  OrderItem({required this.restaurantId, required this.items});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      restaurantId: json['restaurantId'],
      items: (json['items'] as List).map((e) => CartItem.fromJson(e)).toList(),
    );
  }
}

class CartItem {
  final String dishId;
  final String servingSize;

  CartItem({required this.dishId, required this.servingSize});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      dishId: json['dishId'],
      servingSize: json['servingSize'].toString(), // Convert to string in case it's a number
    );
  }
}

class DishDetail {
  final String restaurantId;
  final String restaurantName;
  final String categoryName;
  final String? subCategoryName;
  final String dishId;
  final String dishName;
  final String servingSize;
  final NutritionInfo nutritionInfo;
  final String? url;  // Added url field

  DishDetail({
    required this.restaurantId,
    required this.restaurantName,
    required this.categoryName,
    this.subCategoryName,
    required this.dishId,
    required this.dishName,
    required this.servingSize,
    required this.nutritionInfo,
    this.url,  // Made optional since it might not always be present
  });

  factory DishDetail.fromJson(Map<String, dynamic> json) {
    return DishDetail(
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      categoryName: json['categoryName'],
      subCategoryName: json['subCategoryName'],
      dishId: json['dishId'],
      dishName: json['dishName'].toString().trim(),
      servingSize: json['servingSize'].toString(),
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo']),
      url: json['url'],  // Added url parsing
    );
  }
}

class NutritionInfo {
  final NutritionValue calories;
  final NutritionValue protein;
  final NutritionValue carbs;
  final NutritionValue totalFat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.totalFat,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: NutritionValue.fromJson(json['calories']),
      protein: NutritionValue.fromJson(json['protein']),
      carbs: NutritionValue.fromJson(json['carbs']),
      totalFat: NutritionValue.fromJson(json['totalFat']),
    );
  }
}

class NutritionValue {
  final String value;
  final String unit;

  NutritionValue({required this.value, required this.unit});

  factory NutritionValue.fromJson(Map<String, dynamic> json) {
    return NutritionValue(
      value: json['value'].toString(),
      unit: json['unit'],
    );
  }
}