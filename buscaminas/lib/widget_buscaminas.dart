import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';
import 'widget_buscaminas_painter.dart';

class WidgetBuscaminas extends StatefulWidget {
  const WidgetBuscaminas({Key? key}) : super(key: key);

  @override
  WidgetBuscaminasState createState() => WidgetBuscaminasState();
  
}

class WidgetBuscaminasState extends State<WidgetBuscaminas> {
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

    return Column(
      children: [
        IgnorePointer(
          // El siguiente SizedBox no será interactivo
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 56.0,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                        "Bombas encontradas: ${appData.flagCount} / ${appData.bombAmount}"),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Time: ${appData.time}"),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
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
                    final int row = (details.localPosition.dy /
                            (context.size!.height / appData.boardSize))
                        .floor();
                    final int col = (details.localPosition.dx /
                            (context.size!.width / appData.boardSize))
                        .floor();

                    if (appData.firstMove) {
                      appData.startGame(row, col);
                    } else {
                      appData.compBomb(row, col);
                    }
                    setState(() {}); // Actualitza la vista
                  },
                  onDoubleTapDown: (details) {
                    final int row = (details.localPosition.dy /
                            (context.size!.height / appData.boardSize))
                        .floor();
                    final int col = (details.localPosition.dx /
                            (context.size!.width / appData.boardSize))
                        .floor();

                    if (!appData.firstMove) {
                      appData.checkFlag(row, col);
                    }

                    setState(() {}); // Actualitza la vista
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Ocupa tot l'ample de la pantalla
                    height: MediaQuery.of(context).size.height -
                        56.0, // Ocupa tota l'altura disponible menys l'altura de l'AppBar
                    child: CustomPaint(
                      painter: WidgetBuscaminasPainter(appData),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
