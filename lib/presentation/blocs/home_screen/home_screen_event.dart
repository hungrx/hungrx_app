import 'package:hungrx_app/data/Models/dashboad_screen/home_screen_model.dart';

abstract class HomeEvent {}

class InitializeHomeData extends HomeEvent {
  final HomeData homeData;
  InitializeHomeData(this.homeData);
}


class RefreshHomeData extends HomeEvent {}
