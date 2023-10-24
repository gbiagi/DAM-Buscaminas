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
    for (int i = 2; i < appData.boardSize + 1; i++) {
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
    for (int i = 2; i < appData.boardSize + 1; i++) {
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

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    double cellWidth = size.width / appData.boardSize;
    double cellHeight = size.height / appData.boardSize;

    for (int i = 0; i < appData.boardSize; i++) {
      for (int j = 0; j < appData.boardSize; j++) {
        // Comprobar si es una bandera
        if ((appData.board[i][j] == '!') | (appData.board[i][j] == '+!')) {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageFlag!, x0, y0, x1, y1);
        }
        // Comprobar si es una bomba
        else if ((appData.board[i][j] == '+') & (appData.gameIsOver)) {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageBomb!, x0, y0, x1, y1);
        }
        // Comprobar si es una bomba explotada
        else if (appData.board[i][j] == 'p') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imagePopcorn!, x0, y0, x1, y1);
        }
        // Comprobar si es la casilla palomita
        else if (appData.board[i][j] == 'x') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageExplosion!, x0, y0, x1, y1);
        }
        // Comprobar si en la casilla hay un numero
        else if ((appData.board[i][j] == '+') | (appData.board[i][j] == '-')) {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          final textPainter = TextPainter(
            text: const TextSpan(text: "UwU", style: textStyle),
            textDirection: TextDirection.ltr,
          );

          textPainter.layout(maxWidth: x1 - x0);

          final position = Offset(
            x0 + (x1 - x0 - textPainter.width) / 2,
            y0 + (y1 - y0 - textPainter.height) / 2,
          );

          textPainter.paint(canvas, position);
        } else {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;
          final textPainter = TextPainter(
            text: TextSpan(text: appData.board[i][j], style: textStyle),
            textDirection: TextDirection.ltr,
          );

          textPainter.layout(maxWidth: x1 - x0);

          final position = Offset(
            x0 + (x1 - x0 - textPainter.width) / 2,
            y0 + (y1 - y0 - textPainter.height) / 2,
          );

          textPainter.paint(canvas, position);
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size, String msg) {
    String message = msg;

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

  // Metodo para pintar final
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameIsOver) {
      if (appData.gameIsWin) {
        drawGameOver(canvas, size, "Victoria"); // Se dibuja final de ganar
      } else {
        drawGameOver(canvas, size, "Derrota"); // Se dibuja final de perder
      }
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
