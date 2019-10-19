printf "Hola Mundo \n";

/* Constantes */
param M2TOTAL := 8000; # Espacio total en metros cuadrados del predio
param PMERCH := 800; # Costo por cada paquete de regalo
param PGOLD := 1500; # Precio por cada entrada Gold
param PSILVER := 700; # Precio por cada entrada Silver

/* Variables */
var EGOLD >= 0; # Indica cantidad de Entradas Gold
var ESILVER >= 0; # Indica cantidad de Entradas Silver
var MERCH >= 0; # Indica cantidad de personal Merchandising


/* Restricciones */
s.t. procEq1: 1 * EGOLD + 0.5 * ESILVER <= M2TOTAL;
s.t. procEq2: 0.05 * EGOLD + 0.125 * ESILVER <= MERCH;
s.t. procEq3: EGOLD >= 100 + 2;
s.t. procEq4: ESILVER >= 500;
s.t. procEq5: MERCH <= 800;


/* Definicion del funcional */
maximize z: (EGOLD * 1500) - (102 * 1500) + (ESILVER * 700) - (MERCH * 800);


end;
