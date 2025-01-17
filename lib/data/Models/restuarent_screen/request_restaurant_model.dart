class RequestRestaurantModel {
  final String userId;
  final String restaurantName;
  final String restaurantType;
  final String area;

  RequestRestaurantModel({
    required this.userId,
    required this.restaurantName,
    required this.restaurantType,
    required this.area,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'restaurantName': restaurantName,
    'restaurantType': restaurantType,
    'area': area,
  };

  factory RequestRestaurantModel.fromJson(Map<String, dynamic> json) {
    return RequestRestaurantModel(
      userId: json['userId'],
      restaurantName: json['restaurantName'],
      restaurantType: json['restaurantType'],
      area: json['area'],
    );
  }
}