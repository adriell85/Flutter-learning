import 'dart:convert';

import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "dart:async";
import "dart:convert";

const request = "https://api.hgbrasil.com/finance?format=json&key=5373fe47";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme:ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.amber,
      ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);

  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();


  double dollar;
  double euro;

  void _realChanged(String text) {
    double real  = double.parse(text);
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro ).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$Conversor\$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          // ignore: missing_return
          builder: (context, snapshot) {
            // ignore: missing_return
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );

              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150.0, color:Colors.amber),
                        buildTextField("Reais","R\$",realController,_realChanged),
                        Divider(),
                        buildTextField("Dólares","US\$",dollarController,_dollarChanged),
                        Divider(),
                        buildTextField("Euros","€",euroController,_euroChanged)
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}


Widget buildTextField(String label, String Prefix,TextEditingController contro, Function func) {
  return TextField(
    controller: contro,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.amber)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.white)),
        prefixText: Prefix
    ),
    style: TextStyle(
        color: Colors.amber,fontSize: 25.0
    ),
    onChanged: func,
    keyboardType: TextInputType.number,
  );
}