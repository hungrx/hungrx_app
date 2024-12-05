abstract class MealTypeEvent {}

class FetchMealTypes extends MealTypeEvent {}
class SelectMealType extends MealTypeEvent {
  final String mealId;
  SelectMealType({required this.mealId});
}