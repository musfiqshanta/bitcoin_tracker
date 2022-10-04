import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'price_screen.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CoinData extends StatefulWidget {
  const CoinData({Key? key}) : super(key: key);

  @override
  State<CoinData> createState() => _CoinDataState();
}

class _CoinDataState extends State<CoinData> {
  CupertinoPicker getCurrencyIos() {
    List<Text> dropdownItem = [];
    for (String currancy in currancyList) {
      dropdownItem.add(Text(currancy));
    }
    return CupertinoPicker(
      itemExtent: 35.0,
      onSelectedItemChanged: (int value) {
        print(value);
      },
      children: dropdownItem,
    );
  }

  String intvalue = "USD";
  String fromcurr = "BTC";
  DropdownButton<String> getCurrencyAndroid() {
    List<DropdownMenuItem<String>> dropdownItem = [];
    for (String currancy in currancyList) {
      dropdownItem.add(DropdownMenuItem<String>(
          value: currancy,
          child: Text(
            currancy,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )));
    }
    return DropdownButton<String>(
        dropdownColor: Colors.blue,
        value: intvalue,
        items: dropdownItem,
        iconEnabledColor: Colors.white,
        onChanged: (String? value) {
          setState(() {
            intvalue = value!;
          });
        });
  }

  DropdownButton<String> fgetCurrencyAndroid() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currancy in fcurrancyList) {
      dropdownItems.add(DropdownMenuItem<String>(
          value: currancy,
          child: Text(
            currancy,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          )));
    }
    return DropdownButton<String>(
        dropdownColor: Colors.blue,
        value: fromcurr,
        iconEnabledColor: Colors.white,
        items: dropdownItems,
        onChanged: (String? value) {
          setState(() {
            fromcurr = value!;
          });
        });
  }

  Future getData({String? from, String? to}) async {
    var url = Uri.parse(
        'https://rest.coinapi.io/v1/exchangerate/${from}/${to}?apikey=ABBC0BFE-2001-454C-8C4B-694FA9E3A742');
    var response = await http.get(url);
    var jasonDecod = convert.jsonDecode(response.body) as Map<String, dynamic>;
    double x = jasonDecod['rate'];
    String assetQuote = jasonDecod['asset_id_quote'];
    String assetId = jasonDecod['asset_id_base'];
    print("rate");
    print(jasonDecod);
    return [assetQuote, assetId, x.toStringAsFixed(3)];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Card(
            elevation: 5,
            color: Colors.lightBlue,
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: FutureBuilder(
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Text(
                        "1 ${snapshot.data![1]} = ${snapshot.data![2]} ${snapshot.data![0]}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text("No data");
                  }
                  return Text("Loading...");
                }),
                future: getData(from: fromcurr, to: intvalue),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Container(
              height: 50,
              color: Colors.lightBlue,
              child: Center(child: fgetCurrencyAndroid()),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              color: Colors.lightBlue,
              child: Center(
                  child: Platform.isAndroid
                      ? getCurrencyAndroid()
                      : getCurrencyIos()),
            ),
          ],
        )
      ],
    );
  }
}
