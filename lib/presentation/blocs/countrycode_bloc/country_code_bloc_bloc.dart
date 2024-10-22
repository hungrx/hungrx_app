import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_event.dart';
import 'package:hungrx_app/presentation/blocs/countrycode_bloc/country_code_bloc_state.dart';


class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState> {
  CountryCodeBloc() : super(const CountryCodeState()) {
    on<CountryCodeChanged>(_onCountryCodeChanged);
  }

  void _onCountryCodeChanged(CountryCodeChanged event, Emitter<CountryCodeState> emit) {
    emit(state.copyWith(selectedCountryCode: event.countryCode));
  }
}