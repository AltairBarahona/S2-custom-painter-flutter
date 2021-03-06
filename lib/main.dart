import 'package:flutter/material.dart';
import 'package:s2_custom_painter/src/challenges/cuadrado_animado.dart';
import 'package:s2_custom_painter/src/pages/animaciones_page.dart';
import 'package:s2_custom_painter/src/pages/headers_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diseños App',
      home: CuadradoAnimadoPage(),
    );
  }
}
