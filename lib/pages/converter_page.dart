import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  double amount = 1.0;
  String fromCurrency = 'IDR';
  String toCurrency = 'USD';
  double convertedAmount = 0.0;
  List<String> toCurrencyOptions = ['USD', 'EUR', 'GBP', 'JPY', 'IDR'];

  Map<String, String> currencyLabels = {
    'USD': 'Dollar',
    'EUR': 'Euro',
    'GBP': 'Pound',
    'JPY': 'Yen',
    'IDR': 'Rupiah',
  };

  Future<double> convertCurrency() async {
    final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/$fromCurrency'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final rates = data['rates'];
      double rate = rates[toCurrency];
      return amount * rate;
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Currency Converter'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Convert $amount ${currencyLabels[fromCurrency]} to ${currencyLabels[toCurrency]}',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            SizedBox(height: 20.0),
            Text(
              'Converted Amount: $convertedAmount ${currencyLabels[toCurrency]}',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Convert', style: TextStyle(color: Colors.white)),
              onPressed: () {
                convertCurrency().then((value) {
                  setState(() {
                    convertedAmount = value;
                  });
                }).catchError((error) {
                  print(error);
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    onChanged: (String? newValue) {
                      if (newValue != toCurrency) {
                        setState(() {
                          fromCurrency = newValue!;
                          if (!toCurrencyOptions.contains(fromCurrency)) {
                            toCurrency = toCurrencyOptions[0];
                          }
                        });
                      }
                    },
                    items: <String>['IDR', 'USD', 'EUR', 'GBP', 'JPY']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.black),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    value: toCurrency,
                    onChanged: (String? newValue) {
                      if (newValue != fromCurrency) {
                        setState(() {
                          toCurrency = newValue!;
                        });
                      }
                    },
                    items: toCurrencyOptions
                        .where((option) => option != fromCurrency)
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child:
                            Text(value, style: TextStyle(color: Colors.black)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
              decoration: InputDecoration(
                labelText: 'Amount in ${currencyLabels[fromCurrency]}',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
