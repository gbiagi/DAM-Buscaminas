import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetBuscaminasPainter extends CustomPainter {
  final AppData appData;

  WidgetBuscaminasPainter(this.appData);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    // Definim els punts on es creuaran les línies verticals
    final List<double> verticalLines = [0];
    final double firstVertical = size.width / appData.boardSize;
    verticalLines.add(firstVertical);
    for (int i = 2; i < appData.boardSize + 2; i++) {
      verticalLines.add(firstVertical * i);
    }

    // Dibuixem les línies verticals
    for (double line in verticalLines) {
      canvas.drawLine(Offset(line, 0), Offset(line, size.height), paint);
    }

    // Definim els punts on es creuaran les línies horitzontals
    final List<double> horizontalLines = [0];
    final double firstHorizontal = size.height / appData.boardSize;
    horizontalLines.add(firstHorizontal);
    for (int i = 2; i < appData.boardSize + 2; i++) {
      horizontalLines.add(firstHorizontal * i);
    }

    // Dibuixem les línies horitzontals
    for (double line in horizontalLines) {
      canvas.drawLine(Offset(0, line), Offset(size.width, line), paint);
    }
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  // Dibuia una creu centrada a una casella del taulell
  // void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
  //     Color color, double strokeWidth) {
  //   Paint paint = Paint()
  //     ..color = color
  //     ..strokeWidth = strokeWidth;

  //   canvas.drawLine(
  //     Offset(x0, y0),
  //     Offset(x1, y1),
  //     paint,
  //   );
  //   canvas.drawLine(
  //     Offset(x1, y0),
  //     Offset(x0, y1),
  //     paint,
  //   );
  // }

  // Dibuixa un cercle centrat a una casella del taulell
  // void drawCircle(Canvas canvas, double x, double y, double radius, Color color,
  //     double strokeWidth) {
  //   final paint = Paint()
  //     ..style = PaintingStyle.stroke
  //     ..color = color
  //     ..strokeWidth = strokeWidth;
  //   canvas.drawCircle(Offset(x, y), radius, paint);
  // }

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    // Dibuixar 'X' i 'O' del tauler
    double cellWidth = size.width / appData.boardSize;
    double cellHeight = size.height / appData.boardSize;

    for (int i = 0; i < appData.boardSize; i++) {
      for (int j = 0; j < appData.boardSize; j++) {
        if (appData.board[i][j] == 'X') {
          // Dibuixar una X amb el color del jugador
          Color color = Colors.blue;
          switch ("Blau") {
            case "Blau":
              color = Colors.blue;
              break;
            case "Verd":
              color = Colors.green;
              break;
            case "Gris":
              color = Colors.grey;
              break;
          }
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imagePlayer!, x0, y0, x1, y1);
          //drawCross(canvas, x0, y0, x1, y1, color, 5.0);
        } else if (appData.board[i][j] == 'O') {
          // Dibuixar una O amb el color de l'oponent
          Color color = Colors.blue;
          switch ("Vermell") {
            case "Vermell":
              color = Colors.red;
              break;
            case "Taronja":
              color = Colors.orange;
              break;
            case "Marró":
              color = Colors.brown;
              break;
          }

          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          double cX = x0 + (x1 - x0) / 2;
          double cY = y0 + (y1 - y0) / 2;
          double radius = (min(cellWidth, cellHeight) / 2) - 5;

          drawImage(canvas, appData.imageOpponent!, x0, y0, x1, y1);
          //drawCircle(canvas, cX, cY, radius, color, 5.0);
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = "El joc ha acabat!";

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    //if (appData.gameWinner != '-') {
    //  drawGameOver(canvas, size);}
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
