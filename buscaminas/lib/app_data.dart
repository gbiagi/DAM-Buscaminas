import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  /* App status */
  String colorPlayer = "Verd"; //TODO quitar
  String colorOpponent = "Taronja"; //TODO quitar

  List<List<String>> board = []; // Matriz
  bool gameIsOver = false;
  String gameWinner = '-'; //TODO quitar

  // TODO cambiar imagenes para que hayan bomba, bombaExplotada y bandera
  // tambien se puede mirar de hacer con vectores
  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  // Cosas nuevas
  int flagCount = 0; // Banderas que coloca el usuario
  int bombCount = 0; // Bombas que estan bien marcadas
  int totalBomb = 0; // Total de bombas
  int totalCasilla = 0; //Se puede cambiar el nombre

  /*
  Metodos
   */
  // TODO cambiar a metodo para que sea automatico segun las filas y columnas
  void resetGame() {
    board = [
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ['-', '-', '-', '-', '-', '-', '-', '-', '-']
    ];
    gameIsOver = false;
    gameWinner = '-'; //Eliminar o cambiar?
  }

  // Fa una jugada, primer el jugador després la maquina
  /* 
  TODO cambiar por metodo recursivo que podria:
  Recivir int row, int col y bool flag
  Si tiene flag se suman los counts y se termina el metodo
  Sino se mira de forma recursiva las casillas hasta despejar todas las casillas que hagan falta
  */
  void playMove(int row, int col) {
    if (board[row][col] == '-') {
      board[row][col] = 'X';
      checkGameWinner();
      if (gameWinner == '-') {
        machinePlay();
      }
    }
  }

  // Fa una jugada de la màquina, només busca la primera posició lliure
  //Quitar?
  void machinePlay() {
    bool moveMade = false;

    // Buscar una casella lliure '-'
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j] == '-') {
          board[i][j] = 'O';
          moveMade = true;
          break;
        }
      }
      if (moveMade) break;
    }

    checkGameWinner();
  }

  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  void checkGameWinner() {
    for (int i = 0; i < 9; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        gameIsOver = true;
        gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        gameIsOver = true;
        gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      gameIsOver = true;
      gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      gameIsOver = true;
      gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
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

    Image tmpPlayer = Image.asset('assets/images/bomb.png');
    Image tmpOpponent = Image.asset('assets/images/flag.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
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
