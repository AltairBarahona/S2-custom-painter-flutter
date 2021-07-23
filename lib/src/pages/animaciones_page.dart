import 'package:flutter/material.dart';
import 'dart:math' as Math;

class AnimacionesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CuadradoAnimado(),
      ),
    );
  }
}

class CuadradoAnimado extends StatefulWidget {
  @override
  _CuadradoAnimadoState createState() => _CuadradoAnimadoState();
}

class _CuadradoAnimadoState extends State<CuadradoAnimado>
    with SingleTickerProviderStateMixin {
  /*Toda animación personalizada tiene 2 componentes.
  Animation y AnimationController */

  //Controllador de la animación
  AnimationController controller;

  //Qué tipo de cosa quiero animar
  Animation<double> rotacion;
  Animation<double> opacidad;
  Animation<double> opacidadOut;
  Animation<double> moverDerecha;
  Animation<double> agrandar;

  /*todo stateful widget tiene 2 pasos de ciclo de vida importantes.
  El initState y el dispose. Es importante deshacerse del controller
  en el dispose ya que siempre estará escuchando los cambios,
  suscribirnos a eventos, etc. Por eso debemos hacer la limpieza
  para evitar fuga de memoria*/

  @override
  void initState() {
    //ocupamos vsync y duration
    //vsync cuadra los cuadros de la pantalla con la renderización flutter
    //duration es la duración de la animación

    /*para el vscyn necesito un mixin con sigleTickerProviderStateMixin */
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );

    //tween pide inicio, fin, y quién lo controla como método
    rotacion = Tween(begin: 0.0, end: 1 * Math.pi).animate(
      CurvedAnimation(parent: controller, curve: Curves.bounceOut),
    );

    //opacidad siempre va de 0 a 1
    opacidad = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0, 0.25, curve: Curves.easeOut),
    ));

    opacidadOut = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.75, 1.0, curve: Curves.easeOut),
    ));
    moverDerecha = Tween(begin: 0.0, end: 200.0).animate(controller);

    agrandar = Tween(begin: 0.0, end: 2.0).animate(controller);

    //saber el estado de la animación
    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();

    //puedo lanzar la animación donde sea
    return AnimatedBuilder(
      //quién controlará la animación
      animation: controller,
      /*Este es opcional porque puedo trabajar con la contrucción del 
      rectángulo desde el builder de abajo. Aunque yo voy a preferir este porque
      si lo paso como child se maneja como referencia en lugar de 
      siempre volver a dibujarse*/
      child: _Rectangulo(),
      builder: (context, child) {
        // print("Status: ${opacidad.value}");
        // print("Rotación: ${rotacion.status}");

        return Transform.translate(
          //transform.transale requiere offset
          //offset define coordenadas relativas desde donde se encuentra
          offset: Offset(moverDerecha.value, 0),
          child: Transform.rotate(
            angle: rotacion.value,
            child: Opacity(
              opacity: opacidad.value - opacidadOut.value,
              child: Transform.scale(
                scale: agrandar.value,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Rectangulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(color: Colors.blue),
    );
  }
}
