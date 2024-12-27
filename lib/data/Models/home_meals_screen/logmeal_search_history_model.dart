class LogMealSearchHistoryModel {
  final String userId;
  final String productId;
  final FoodItemModel foodItem;
  final SearchInfoModel searchInfo;
  final String viewedAt;
  final String id;

  LogMealSearchHistoryModel({
    required this.userId,
    required this.productId,
    required this.foodItem,
    required this.searchInfo,
    required this.viewedAt,
    required this.id,
  });

  factory LogMealSearchHistoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return LogMealSearchHistoryModel(
        userId: json['userId']?.toString() ?? '',
        productId: json['productId']?.toString() ?? '',
        foodItem: FoodItemModel.fromJson(json['foodItem'] ?? {}),
        searchInfo: SearchInfoModel.fromJson(json['searchInfo'] ?? {}),
        viewedAt: json['viewedAt']?.toString() ?? '',
        id: json['_id']?.toString() ?? '',
      );
    } catch (e) {
      // print('Error parsing LogMealSearchHistoryModel: $json');
      // print('Error details: $e');
      rethrow;
    }
  }
}

class FoodItemModel {
  final String id;
  final String name;
  final String brandName;
  final String image;

  FoodItemModel({
    required this.id,
    required this.name,
    required this.brandName,
    required this.image,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return FoodItemModel(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        brandName: json['brandName']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
      );
    } catch (e) {
      // print('Error parsing FoodItemModel: $json');
      // print('Error details: $e');
      rethrow;
    }
  }
}

class SearchInfoModel {
  final String date;
  final String time;
  final String timestamp;

  SearchInfoModel({
    required this.date,
    required this.time,
    required this.timestamp,
  });

  factory SearchInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      return SearchInfoModel(
        date: json['date']?.toString() ?? '',
        time: json['time']?.toString() ?? '',
        timestamp: json['timestamp']?.toString() ?? '',
      );
    } catch (e) {
      // print('Error parsing SearchInfoModel: $json');
      // print('Error details: $e');
      rethrow;
    }
  }
}