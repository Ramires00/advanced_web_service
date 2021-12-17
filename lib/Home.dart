import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async {
    String url = "";
    http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
        future: _recuperarPreco(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none :
              print("Conexao none");
              break;
            case ConnectionState.waiting :
              print("Conexao waiting");
              break;
            case ConnectionState.active :
              print("Conexao active");
              break;
            case ConnectionState.done :
              print("conexao done");
              break;
          }
        }
    );
  }
}


