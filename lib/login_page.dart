import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'register.dart';

getUsers() async {
  return await fetchUsers();
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String _title = 'Најди стан';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: const MyStatefulWidget(),
      ),
    );
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('https://myflat-d6495-default-rtdb.europe-west1.firebasedatabase.app/users.json'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final users = json.decode(response.body) as Map<String, dynamic>;

    final List<User> loadedUsers = [];
    users.forEach((userIs, userDetails) {
      loadedUsers.add(User(username: userDetails['username'], password: userDetails['password']));
    });
    return loadedUsers;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load flats');
  }
}

Future<bool> fetchUser(User user) async {
  List<User> users = await getUsers();
  bool isTrue = false;
  users.forEach((element) {
    if (element.username == user.username) {
      isTrue = true;
    }
  });

  return await isTrue;
}

class User {
  String username;
  String password;

  User({required this.username, required this.password});

  //factory User.fromJson(Map<String, dynamic> json) => User(username: json["username"], password: json["password"]);
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                margin: new EdgeInsets.symmetric(vertical: 40.0),
                child: const Text(
                  'Најди стан',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Најави се',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Корисничко име',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Лозинка',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                  ),
                  child: const Text('Најави се'),
                  onPressed: () {
                    User user = new User(username: nameController.value.text, password: passwordController.value.text);

                    fetchUser(user).then((value) => {
                          if (value == true)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              )
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Please register, user not valid'),
                              ))
                            },
                        });
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Немате профил?'),
                TextButton(
                  child: const Text(
                    'Регистрирај се',
                    // style: TextStyle(fontSize: 20),
                    style: TextStyle(fontSize: 20, color: Colors.red // this is for your text colour
                        ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    );
                    //signup screen
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}
