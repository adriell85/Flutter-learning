import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
void main() {



  Firestore.instance.collection("teste").document("teste").setData({"teste" : "teste"});


  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
