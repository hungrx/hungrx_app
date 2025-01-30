class ApiConstants {
  //! base url
  static const String baseUrl = 'https://hungrx.xyz';
  // auth screen
  static const String google = '/users/signup/google';
  static const String sendOTP = '/users/sendOTP';
  static const String verifyOTP = '/users/verifyOTP';
// weight screen
  static const String weightUpdate = '/users/updateWeight';
  static const String getWeightHistory = '/users/getWeightHistory';

  // cart screen
  static const String getCart = '/users/getCart';
  static const String removeCart = '/users/removeCart';
  static const String removeOneItem = '/users/removeOneItem';
  //  dialy insght screen
  static const String getConsumedFoodByDate = '/users/getConsumedFoodByDate';
  static const String deleteDishFromMeal = '/users/deleteDishFromMeal';
  //  dashboard screen
  static const String homeScreen = '/users/home';
  static const String feedback = '/users/feedback';
  static const String trackuser = '/users/trackuser';

  static const String changecaloriesToReachGoal =
      '/users/changecaloriesToReachGoal';
  // eat screen
  static const String eatPage = '/users/eatPage';
  static const String eatScreenSearch = '/users/eatScreenSearch';
  // home meals
  static const String getCalorieMetrics = '/users/getCalorieMetrics';
  static const String getMeals = '$baseUrl/users/getMeals';
  static const String addCommonFoodToHistory = '/users/addCommonFoodToHistory';
  static const String addConsumedFood = '/users/addConsumedFood';
  static const String addConsumedCommonFood = '/users/addConsumedCommonFood';
  static const String searchCommonfood = '/users/searchCommonfood';
  static const String addUnknown = '/users/addUnknown';
  static const String grocerySearch = '/users/searchGrocery';
  static const String getUserhistory = '/users/getUserhistory';
  static const String addHistory = '/users/addHistory';
// profile screen
  static const String deleteUser = '/users/deleteUser';
  static const String basicInfo = '/users/basicInfo';
  static const String profileScreen = '/users/profileScreen';
  static const String goalSetting = '/users/goalSetting';
  static const String bug = '/users/bug';
  static const String updateBasicInfo = '/users/updateBasicInfo';
  static const String updateGoalSetting = '/users/updateGoalSetting';
//  profile settings screen
  static const String createProfile = '/users/createProfile';
  static const String calculateMetricsEndpoint = '/users/calculate-metrics';
  // progress bar
  static const String progressBar = '/users/progressBar';
  //  restuarant menu screen
  static const String addToCart = '/users/addToCart';
  static const String getMenu = '/users/getMenu';
  //  restuarant screen
  static const String nearby = '/users/nearby';
  static const String reqrestaurant = '/users/reqrestaurant';
  static const String searchRestaurant = '/users/searchRestaurant';
  static const String suggestions = '/users/suggestions';
  // service api
  static const String checkUser = '/users/checkUser';
  // water screen
  static const String removeWaterEntry = '/users/removeWaterEntry';
  static const String getWaterIntakeData = '/users/getWaterIntakeData';
  static const String addWater = '/users/addWater';
}
