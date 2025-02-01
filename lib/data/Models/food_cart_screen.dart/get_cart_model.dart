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
  final int quantity;  // Added quantity field

  CartItem({
    required this.dishId, 
    required this.servingSize,
    required this.quantity,  // Added to constructor
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      dishId: json['dishId'],
      servingSize: json['servingSize'].toString(),
      quantity: json['quantity'] as int,  // Parse quantity
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
  final int? quantity;  // Added quantity field
  final NutritionInfo nutritionInfo;
  final String? url;

  DishDetail({
    required this.restaurantId,
    required this.restaurantName,
    required this.categoryName,
    this.subCategoryName,
    required this.dishId,
    required this.dishName,
    required this.servingSize,
     this.quantity,  // Added to constructor
    required this.nutritionInfo,
    this.url,
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
      quantity: json['quantity'] as int,  // Parse quantity
      nutritionInfo: NutritionInfo.fromJson(json['nutritionInfo']),
      url: json['url'],
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