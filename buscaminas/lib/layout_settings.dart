import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutSettings extends StatefulWidget {
  const LayoutSettings({Key? key}) : super(key: key);

  @override
  LayoutSettingsState createState() => LayoutSettingsState();
}

class LayoutSettingsState extends State<LayoutSettings> {
  List<String> sizeOptions = ["9 x 9", "15 x 15"];
  List<String> bombsOptions = ["5", "10", "20"];

  // Mostra el CupertinoPicker en un diàleg.
  void _showPicker(String type) {
    List<String> options = type == "size" ? sizeOptions : bombsOptions;
    String title = type == "size"
        ? "Selecciona el tamanyo del tablero"
        : "Selecciona la cantidad de bombas";

    // Troba l'índex de la opció actual a la llista d'opcions
    AppData appData = Provider.of<AppData>(context, listen: false);
    String currentValue = type == "size"
        ? "${appData.boardSize} x ${appData.boardSize}"
        : appData.bombAmount.toString();
    int currentIndex = options.indexOf(currentValue);
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: currentIndex);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground
                  .resolveFrom(context),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: scrollController,
                  onSelectedItemChanged: (index) {
                    if (type == "size") {
                      if (options[index] == "9 x 9") {
                        appData.boardSize = 9;
                      } else {
                        appData.boardSize = 15;
                      }
                    } else {
                      appData.bombAmount = int.parse(options[index]);
                    }
                    // Actualitzar el widget
                    setState(() {});
                  },
                  children: options
                      .map((color) => Center(child: Text(color)))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Configuració"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Tamaño del tablero: "),
              CupertinoButton(
                onPressed: () => _showPicker("size"),
                child: Text("${appData.boardSize} x ${appData.boardSize}"),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Numero de Bombas: "),
              CupertinoButton(
                onPressed: () => _showPicker("bombs"),
                child: Text(appData.bombAmount.toString()),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
