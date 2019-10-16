/* Constantes */
var M2TOTAL = 8000; # Espacio total en metros cuadrados del predio
var PMERCH = 800; # Costo por cada paquete de regalo
var PGOLD = 1500; # Precio por cada entrada Gold
var PSILVER = 700; # Precio por cada entrada Silver

/* Variables */
var EGOLD >= 0; # Indica cantidad de Entradas Gold
var ESILVER >= 0; # Indica cantidad de Entradas Silver
var MERCH >= 0; # Indica cantidad de personal Merchandising

/* Definicion del funcional */
maximize z: EGOLD * PGOLD - 102 * PGOLD + ESILVER * PSILVER - MERCH * PMERCH;

/* Restricciones */
s.t. procEq1: 1 * EGOLD + 0.5 * ESILVER <= M2TOTAL;
s.t. procEq2: 0.05 * EGOLD + 0.125 * ESILVER <= MERCH;
s.t. procEq3: EGOLD >= 100 + 2;
s.t. procEq4: ESILVER >= 500;
s.t. procEq5: MERCH <= 800;

end;