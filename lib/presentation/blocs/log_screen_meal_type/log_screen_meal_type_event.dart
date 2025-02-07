abstract class MealTypeEvent {}

class FetchMealTypes extends MealTypeEvent {}
class SelectMealType extends MealTypeEvent {
  final String mealId;
  SelectMealType({required this.mealId});
}
// Add this to your MealTypeEvent classes
class ClearMealTypeSelection extends MealTypeEvent {}