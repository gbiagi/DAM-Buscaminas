import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  /*------------
    App status
  ------------*/
  int boardSize = 9;
  int bombAmount = 10;

  int time = 0;

  List<List<String>> board = [];

  bool gameIsOver = false;
  bool gameIsWin = false;
  bool firstMove = true;

  // Imagenes del juego
  ui.Image? imageBomb;
  ui.Image? imageFlag;
  ui.Image? imageExplosion;
  ui.Image? imagePopcorn;

  bool imagesReady = false;

  int flagCount = 0; // Banderas que coloca el usuario
  int bombsWithFlag = 0; // Casilla con bandera y bomba
  int exploredBoxes = 0; // Casillas que estan exploradas

  /*-------
   Metodos
  -------*/
  // Mostrar matriz por terminal
  void dibujarMatriz() {
    String matriz = "";
    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        matriz += "| ${board[row][col]} |";
      }
      matriz += "\n";
    }
    // ignore: avoid_print
    print("\n$matriz");
  }

  // Resetear juego
  void resetGame() {
    board.clear();
    gameIsOver = false;
    gameIsWin = false;
    firstMove = true;

    flagCount = 0;
    bombsWithFlag = 0;
    exploredBoxes = 0;
    time = 0;

    // Se crea la matriz con el tamaño seleccionado rellenada con guiones(-)
    for (int row = 0; row < boardSize; row++) {
      board.add([]);
      for (int col = 0; col < boardSize; col++) {
        board[row].add("-");
      }
    }
  }

  // Generar tablero
  void startGame(int pRow, int pCol) {
    // Se hace el calculo del PBC(Porcentaje de Bombas por Casill)
    double pbc = ((bombAmount * 100) / (boardSize * boardSize)) * 10;

    firstMove = false;

    int bombsCount = 0;

    // Se crea la casilla palomita
    board[pRow][pCol] = "p";

    bool bombasPuestas = false;

    Random rnd = Random();

    // Se ponen bombas hasta que se iguale el bombAmount
    while (!bombasPuestas) {
      // Se colocan las bombas usando el PBC
      for (int row = 0; row < board.length; row++) {
        for (int col = 0; col < board[row].length; col++) {
          // Evitamos la casilla palomita
          if (((row < pRow - 1) | (row > pRow + 1)) |
              ((col < pCol - 1) | (col > pCol + 1))) {
            // Comprobamos el PBC
            if ((pbc >= rnd.nextInt(1001)) & (board[row][col] != "+")) {
              board[row][col] = "+";
              bombsCount++;
              //Comprobamos si estan todas las bombas puestas
              if (bombAmount == bombsCount) bombasPuestas = true;
              break;
            }
          }
        }
        if (bombasPuestas) break;
      }
    }

    // Limpiamos la zona de alrededor de la palomita
    compBomb(pRow, pCol);
  }

  // Comprobar bombas
  void compBomb(int uRow, int uCol) {
    // Comprobamos si ha pulsado sobre una bomba
    if (board[uRow][uCol] == "+") {
      gameIsOver = true;
      board[uRow][uCol] = "x";
    }

    // Si la casilla no es una bomba empezamos a quitar casillas
    if (!gameIsOver &
        ((board[uRow][uCol] == "-") | (board[uRow][uCol] == "p"))) {
      // Marcamos la casilla como explorada
      if (board[uRow][uCol] != "p") {
        board[uRow][uCol] = ".";
      }
      exploredBoxes++;

      int count = 0;
      // Miramos cuantas bombas hay alrededor
      for (int row = uRow - 1; row < uRow + 2; row++) {
        if ((row >= 0) & (row <= board.length - 1)) {
          for (int col = uCol - 1; col < uCol + 2; col++) {
            if ((!((uRow == row) & (uCol == col))) &
                ((col >= 0) & (col <= board[row].length - 1))) {
              if ((board[row][col] == "+") | (board[row][col] == "+!")) {
                count++;
                board[uRow][uCol] = count.toString();
              }
            }
          }
        }
      }

      // Si no tenia bombas comprueba las casillas de alrededor
      if (count == 0) {
        for (int row = uRow - 1; row < uRow + 2; row++) {
          if ((row >= 0) & (row <= board.length - 1)) {
            for (int col = uCol - 1; col < uCol + 2; col++) {
              if (!((uRow == row) & (uCol == col)) &
                  ((col >= 0) & (col <= board[row].length - 1))) {
                if (board[row][col] == "-") {
                  compBomb(row, col);
                }
              }
            }
          }
        }
      }
    }

    checkWin(); //Comprobamos si la partida a terminado
  }

  // Marcar bandera
  void checkFlag(int row, int col) {
    if (board[row][col] == "+") {
      // Si tiene bomba
      board[row][col] = "+!";
      flagCount++;
      bombsWithFlag++;
    } else if (board[row][col] == "-") {
      // Si esta vacia
      board[row][col] = "!";
      flagCount++;
    } else if (board[row][col] == "+!") {
      // Si ya estaba marcada y tenia bomba
      board[row][col] = "+";
      flagCount--;
      bombsWithFlag--;
    } else if (board[row][col] == "!") {
      // Si ya estaba marcada sin bomba
      board[row][col] = "-";
      flagCount--;
    }
    checkWin(); //Comprobamos si la partida a terminado
  }

  // Comprobar si ha ganado
  void checkWin() {
    if ((exploredBoxes + bombAmount == boardSize * boardSize) &
        (bombsWithFlag == bombAmount)) {
      gameIsWin = true;
      gameIsOver = true;
    }
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpBomb = Image.asset('assets/images/bomb.png');
    Image tmpFlag = Image.asset('assets/images/flag.png');
    Image tmpExplosion = Image.asset('assets/images/explosion.png');
    Image tmpPopcorn = Image.asset('assets/images/palometo.png');

    // Carrega les imatges
    if (context.mounted) {
      imageBomb = await convertWidgetToUiImage(tmpBomb);
    }
    if (context.mounted) {
      imageFlag = await convertWidgetToUiImage(tmpFlag);
    }
    if (context.mounted) {
      imageExplosion = await convertWidgetToUiImage(tmpExplosion);
    }
    if (context.mounted) {
      imagePopcorn = await convertWidgetToUiImage(tmpPopcorn);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}
