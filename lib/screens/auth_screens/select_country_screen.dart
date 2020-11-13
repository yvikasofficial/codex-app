import 'package:codex/config/palette.dart';
import 'package:codex/models/country.dart';
import 'package:codex/providers/country_picker_provider.dart';
import 'package:codex/utils/countries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectCountryScreen extends StatefulWidget {
  @override
  _SelectCountryScreenState createState() => _SelectCountryScreenState();
}

class _SelectCountryScreenState extends State<SelectCountryScreen> {
  String countryName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Palette.mainColor.withOpacity(0.7),
            ),
            child: TextField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              onChanged: (v) {
                setState(() {
                  countryName = v.trim();
                });
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search for country",
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
          searchQuery(),
        ],
      ),
    );
  }

  Widget searchQuery() {
    var list = countryName.length == 0
        ? countryList
        : countryList
            .where(
                (c) => c.name.toLowerCase().contains(countryName.toLowerCase()))
            .toList();

    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return CountryCard(
            country: list[index],
          );
        },
      ),
    );
  }
}

class CountryCard extends StatelessWidget {
  final Country country;
  CountryCard({this.country});
  @override
  Widget build(BuildContext context) {
    var countryPrickerProvider = Provider.of<CountryPickerProvider>(context);

    return GestureDetector(
      onTap: () {
        countryPrickerProvider.setCountry(country);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    country.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "+${country.phoneCode}",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(),
          ],
        ),
      ),
    );
  }
}
