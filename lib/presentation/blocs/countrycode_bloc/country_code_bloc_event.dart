import 'package:equatable/equatable.dart';

abstract class CountryCodeEvent extends Equatable {
  const CountryCodeEvent();

  @override
  List<Object> get props => [];
}

class CountryCodeChanged extends CountryCodeEvent {
  final String countryCode;

  const CountryCodeChanged(this.countryCode);

  @override
  List<Object> get props => [countryCode];
}