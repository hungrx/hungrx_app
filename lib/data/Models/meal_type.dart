class MealType {
  final String id;
  final String meal;

  MealType({
    required this.id,
    required this.meal,
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      id: json['_id'],
      meal: json['meal'],
    );
  }
}