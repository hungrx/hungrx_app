import 'package:hungrx_app/data/Models/daily_food_response.dart';
import 'package:hungrx_app/data/datasources/api/daily_insight_datasource.dart';

class DailyInsightRepository {
  final DailyInsightDataSource dataSource;

  DailyInsightRepository(this.dataSource);

  Future<DailyFoodResponse> getDailyInsightData({
    required String userId,
    required String date,
  }) async {
    return await dataSource.getDailyInsightData(
      userId: userId,
      date: date,
    );
  }
}
