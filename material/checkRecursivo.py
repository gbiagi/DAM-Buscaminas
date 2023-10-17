#Creacion de matriz + dibujo
columnas = int (input("Numero de colmnas: "))
filas = int (input("Numero de filas: "))

matrizUsuario = []

def crearMatriz(matriz):
    for i in range(columnas) :
        matriz.append([])
        for j in range(filas):
            matriz[i].append(j)
    return matriz

def dibujarMatriz(matriz):
    dibujoMatriz = ""
    for i in range(len(matriz)):
        for j in range(len(matriz[i])):
            dibujoMatriz += "|".ljust(1) + str(matriz[i][j]).rjust(2) + "|".rjust(2)
        dibujoMatriz += "\n"
    return dibujoMatriz

matrizUsuario = crearMatriz(matrizUsuario)    
print(dibujarMatriz(matrizUsuario))

#Matriz manual para crear funcion recursiva

matrizManual = [["", "-", "", "", "", "-", "", "", "-"], 
                ["", "", "", "-", "", "", "-", "", "-"],
                ["", "", "-", "", "-", "", "-", "", ""],
                ["", "", "", "-", "-", "", "-", "", ""],
                ["", "", "", "-", "", "-", "", "-", ""],
                ["", "", "-", "", "", "", "-", "", "-"],
                ["-", "", "", "-", "", "", "", "-", ""],
                ["", "-", "", "", "-", "", "", "", "-"],
                ["", "-", "", "", "", "-", "", "-", ""]]

def comprobarBombas(matriz, row, col):    
    matriz[row][col] = 0
        
    for i in range(row - 1, row + 2):
        if i >= 0 and i <= len(matriz):
            for j in range(col - 1, col + 2):
                if not(row == i and col == j) and (j >= 0 and j <= len(matriz[i])):
                    if matriz[i][j] == "-":
                        matriz[row][col] += 1    
    
    if matriz[row][col] == 0:
        for i in range(row - 1, row + 2):
            if i >= 0 and i <= len(matriz):
                for j in range(col - 1, col + 2):
                    if not(row == i and col == j) and (j >= 0 and j <= len(matriz[i])):
                        if matriz[i][j] == "":
                            comprobarBombas(matriz, i, j)
        
    return dibujarMatriz(matriz)

print("Se ha creado una matriz de 9*9")
rowUsr = int(input("Escribe la fila de la casilla a revisar: "))
colUsr = int(input("Escribe la columna de la casilla a revisar: "))

if matrizManual[rowUsr][colUsr] != "-":
    print(comprobarBombas(matrizManual, rowUsr, colUsr))
else:
    print("Perdiste")
