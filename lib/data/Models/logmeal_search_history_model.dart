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
    return LogMealSearchHistoryModel(
      userId: json['userId'],
      productId: json['productId'],
      foodItem: FoodItemModel.fromJson(json['foodItem']),
      searchInfo: SearchInfoModel.fromJson(json['searchInfo']),
      viewedAt: json['viewedAt'],
      id: json['_id'],
    );
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
    return FoodItemModel(
      id: json['id'],
      name: json['name'],
      brandName: json['brandName'],
      image: json['image'],
    );
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
    return SearchInfoModel(
      date: json['date'],
      time: json['time'],
      timestamp: json['timestamp'],
    );
  }
}