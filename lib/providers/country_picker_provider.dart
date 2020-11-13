import 'package:codex/models/country.dart';
import 'package:flutter/foundation.dart';

class CountryPickerProvider extends ChangeNotifier {
  Country selctedCountry = Country(
    isoCode: "US",
    phoneCode: "1",
    name: "United States",
    iso3Code: "USA",
  );

  void setCountry(Country country) {
    selctedCountry = country;
    notifyListeners();
  }

  String get countryName => selctedCountry.name;
  String get countryCode => "${selctedCountry.phoneCode}";
}
