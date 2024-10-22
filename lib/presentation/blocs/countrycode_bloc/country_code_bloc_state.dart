import 'package:equatable/equatable.dart';

class CountryCodeState extends Equatable {
  final String selectedCountryCode;

  const CountryCodeState({this.selectedCountryCode = '+1'});

  CountryCodeState copyWith({String? selectedCountryCode}) {
    return CountryCodeState(
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
    );
  }

  @override
  List<Object> get props => [selectedCountryCode];
}