import 'package:flutter/material.dart';
import './ui/climate.dart';
// import './ui/klimatic.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Weather Data",
    // home: new Klimatic(),
    home: new Climate(),
  ));
}
