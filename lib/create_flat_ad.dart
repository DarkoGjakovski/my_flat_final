import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home.dart';
import 'dart:convert';

String _selectedLocation = "Скопје";
List<City> cities = getCities();

TextEditingController price = new TextEditingController();
TextEditingController title = new TextEditingController();

getCities() async {
  return await fetchCity();
}

class MyFlatsAdPage extends StatefulWidget {
  const MyFlatsAdPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyFlatsAdPageState createState() => _MyFlatsAdPageState();
}

class _MyFlatsAdPageState extends State<MyFlatsAdPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  BuildContext? scaffoldContext;

  var cities = [
    new City(name: "Скопје"),
    new City(name: "Битола"),
    new City(name: "Кавадарци"),
    new City(name: "Прилеп"),
    new City(name: "Куманово"),
    new City(name: "Тетово"),
    new City(name: "Велес"),
    new City(name: "Штип")
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Име на оглас',
            ),
            controller: title,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Ве молиме внесете име';
              }
              return null;
            },
          ),
          Container(
              child: Center(
                  child: DropdownButton(
            items: cities
                .map(
                  (map) => DropdownMenuItem(child: Text(map.name), value: map.name),
                )
                .toList(),
            value: _selectedLocation,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue!;
              });
            },
          ))),
          TextFormField(
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: 'Цена',
            ),
            controller: price,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Ве молиме внесете цена';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  _postFlatAd().then((statusCode) => {
                        if (statusCode == 200)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Успешно додадовте оглас'),
                            ))
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Грешка'),
                            ))
                          }
                      });
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

_postFlatAd() async {
  try {
    var response = await http.post(Uri.parse("https://myflat-d6495-default-rtdb.europe-west1.firebasedatabase.app/flats.json"),
        body: json.encode({
          "City": _selectedLocation,
          "Manupacity": "",
          "Price": int.parse(price.value.text),
          "Title": title.value.text
        }));
    return response.statusCode;
  } catch (e) {
    print(e);
    return null;
  }
}
