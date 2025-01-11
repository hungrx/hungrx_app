abstract class CommonFoodSearchEvent {}

class CommonFoodSearchStarted extends CommonFoodSearchEvent {
  final String query;
  CommonFoodSearchStarted(this.query);
}

class CommonFoodSearchCleared extends CommonFoodSearchEvent {}