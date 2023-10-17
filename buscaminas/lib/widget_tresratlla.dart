import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_tresratlla_painter.dart';

class WidgetTresRatlla extends StatefulWidget {
  const WidgetTresRatlla({Key? key}) : super(key: key);

  @override
  WidgetTresRatllaState createState() => WidgetTresRatllaState();
}

class WidgetTresRatllaState extends State<WidgetTresRatlla> {
  Future<void>? _loadImagesFuture;

  // Al iniciar el widget, carrega les imatges
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppData appData = Provider.of<AppData>(context, listen: false);
      _loadImagesFuture = appData.loadImages(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return GestureDetector(
      // Este widget lo usamos para recoger la casilla en la que se esta haciendo el tap
      onTapUp: (TapUpDetails details) {
        final int row =
            (details.localPosition.dy / (context.size!.height / 9)).floor();
        // Resum linea de arriba (posicion de y del toque / (altura / 3))¿.floor()? creo que el resultado es 1, 2 o 3
        final int col =
            (details.localPosition.dx / (context.size!.width / 9)).floor();

        appData.playMove(
            row, col); // Mandomos la fila y la columna a appdata linea 29
        setState(() {}); // Actualitza la vista
      },
      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // Ocupa tot l'ample de la pantalla
        height: MediaQuery.of(context).size.height -
            56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
        child: FutureBuilder(
          // Segons si les imatges estan disponibles mostra un progrés o el joc
          future: _loadImagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const CupertinoActivityIndicator();
            } else {
              return GestureDetector(
                onTapUp: (TapUpDetails details) {
                  final int row =
                      (details.localPosition.dy / (context.size!.height / 9))
                          .floor();
                  final int col =
                      (details.localPosition.dx / (context.size!.width / 9))
                          .floor();

                  appData.playMove(row, col);
                  setState(() {}); // Actualitza la vista
                },
                child: SizedBox(
                  width: MediaQuery.of(context)
                      .size
                      .width, // Ocupa tot l'ample de la pantalla
                  height: MediaQuery.of(context).size.height -
                      56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
                  child: CustomPaint(
                    painter: WidgetTresRatllaPainter(appData),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
