printf "----------- INICIO ----------\n";

/* datos */
set CIUDADES := 0..5;
#set CIUDADES := 0..7;
#set CIUDADES := 0..10;
#set CIUDADES := 0..21;
#set CIUDADES := 0..31;
#set CIUDADES := 0..48;

set DIST, dimen 2; # matriz distancias de la ciudad "i" a ciudad "j"
param DISTANCIAS {i in CIUDADES, j in CIUDADES}; 

#table TDist IN "CSV" "./datos/distancias_formato_3_columnas.csv":
table TDist IN "CSV" "./datos/5_ciudades.csv":
#table TDist IN "CSV" "./datos/7_ciudades.csv":
#table TDist IN "CSV" "./datos/10_ciudades.csv":
#table TDist IN "CSV" "./datos/21_ciudades.csv":
#table TDist IN "CSV" "./datos/31_ciudades.csv":
#table TDist IN "CSV" "./datos/48_ciudades.csv": # POSTA DE 48, son 49 con una de inicio en 0
DIST <- [CiudadOrigen,CiudadDestino], DISTANCIAS ~ Distancia;

/* Constantes */
param TOTAL_CIUDADES := card(CIUDADES)-1;      #0..48 --> (49 - 1) = 48
param VALKM := 2;
param DIAHOTEL := 50;
param m_m := 0.0000001;
param M_M := 1000000000;

/* Variables */
# bivalente que vale 1 si va desde la ciudad i hasta la j (i != j)
var YViaje{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;
var U{1..TOTAL_CIUDADES} >=0, integer; # Numero de secuencia en la cual la ciudad i es visitada

# bivalente, 1 si el viaje de la ciudad i a la j es largo (>=250 Kms)
# indica si entre las 2 ciudades se queda una NOCHE ADICIONAL
var YNA{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# indica si en la ciudad i, fue una ciudad de noche adicional.
var YNA_i{i in CIUDADES} >= 0, binary;

# indica si en la ciudad i, fue una ciudad de noche adicional, perteneciente a cada segmento.
var YNA_0k10k{i in CIUDADES} >= 0, binary;
var YNA_10k20k{i in CIUDADES} >= 0, binary;
var YNA_20k30k{i in CIUDADES} >= 0, binary;
var YNA_30kmask{i in CIUDADES} >= 0, binary;


# 1 si la ciudad i fue visitada despues de X km
var Ymas10K {i in CIUDADES} >= 0, binary;
var Ymas20K {i in CIUDADES} >= 0, binary;
var Ymas30K {i in CIUDADES} >= 0, binary;
var Ymas40K {i in CIUDADES} >= 0, binary;
var CantCiudadesMas10k >= 0;
var CantCiudadesMas20k >= 0;
var CantCiudadesMas30k >= 0;
var CantCiudadesMas40k >= 0;
var TotalNA_0k10k >= 0;
var TotalNA_10k20k >= 0;
var TotalNA_20k30k >= 0;
var TotalNA_30kmask >= 0;

# 1 si se compra la heladera portatil
var YH >= 0, binary; 

var KmViaje >= 0;

var NOCHES_NORMALES >= 0;
var NOCHES_ADICIONALES >= 0;
var NOCHES_TOTALES >= 0;


var ESTADIA >= 0; # Total de plata gastada en estadia
var NAFTA >= 0; # Total de plata gastada en nafta
var COMIDA >= 0; # Total de plata gastada en comida
var COMIDA_NOCHES1 >= 0; # Total de plata gastada en comidas en la primer noche
var COMIDA_NOCHES2 >= 0; # Total de plata gastada en comidas en la segunda noche (noche adicional)

var AGUA >= 0; # Total de plata gastada en agua
var CANTDesc >= 0; #Cantidad de paradas para descanso
var CANTHidra >= 0; # Cantidad de paradas para hidrataci�n
var AGUA_SIN_H >= 0; # Total de plata gastada si NO compramos la heladera
var AGUA_CON_H >= 0; # Total de plata gastada si compramos la heladera
var YH1 >= 0, binary;
var YH2 >= 0, binary;

var Yi_a_j{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary; # Indica si la ciudad i fue visitada antes que la ciudad j
var YANDijk{i in CIUDADES, j in CIUDADES, k in CIUDADES} >= 0, binary;
var KmAcumulados {i in CIUDADES} >= 0;




/* ----------------------------- RESTRICCIONES ----------------------------- */

############ RESTRICCION BASICA DEL VIAJANTE ############
# Salidas
s.t. voyI{i in CIUDADES}: sum{j in CIUDADES: i<>j} YViaje[i,j] = 1;

# Llegadas 
s.t. llegoJ{j in CIUDADES}: sum{i in CIUDADES: i<>j} YViaje[i,j] = 1;

# Elimina subtours 
s.t. maxorden{i in 1..TOTAL_CIUDADES}: U[i] <= TOTAL_CIUDADES;
s.t. minorden{i in 1..TOTAL_CIUDADES}: U[i] >= 1;
s.t. orden{i in 1..TOTAL_CIUDADES, j in 1..TOTAL_CIUDADES: i<>j}: U[i] - U[j] + TOTAL_CIUDADES * YViaje[i,j] <= TOTAL_CIUDADES - 1;






############ RESTRICCION DE NAFTA ############
s.t. KmViajados: KmViaje = sum{i in CIUDADES, j in CIUDADES: i<>j} DISTANCIAS[i,j] * YViaje[i,j];
s.t. TotalNafta: NAFTA = KmViaje * VALKM;






############ RESTRICCION DE ALOJAMIENTO ############
s.t. NochesNormales: NOCHES_NORMALES = sum{i in CIUDADES, j in CIUDADES: i<>j} YViaje[i,j] - 1;

s.t. YNA_1{i in CIUDADES, j in CIUDADES: i<>j}: (250 * YNA[i,j]) <= DISTANCIAS[i,j] * YViaje[i,j];
s.t. YNA_2{i in CIUDADES, j in CIUDADES: i<>j}: DISTANCIAS[i,j] * YViaje[i,j] <= 250 + (YNA[i,j] * M_M);
s.t. YNA_3{i in CIUDADES, j in CIUDADES: i<>j}: YNA[i,j] <= YViaje[i,j];

s.t. NochesAdicionales: NOCHES_ADICIONALES = sum{i in CIUDADES, j in CIUDADES: i<>j} YNA[i,j];
s.t. NochesTotales: NOCHES_TOTALES = NOCHES_NORMALES + NOCHES_ADICIONALES;
s.t. TotalEstadia: ESTADIA = NOCHES_TOTALES * DIAHOTEL;




############ RESTRICCION DE AGUA ############
s.t. CantidadParadasDescanso: CANTDesc = KmViaje/100;
s.t. CantidadParadasHidratacion: CANTHidra = CANTDesc/2;
s.t. PrecioAguaConHeladera: AGUA_CON_H = 60 + (CANTHidra*2);
s.t. PrecioAguaSinHeladera: AGUA_SIN_H = CANTHidra*3;

s.t. TotalAgua11: (-M_M * YH1) + AGUA_CON_H <= AGUA;
s.t. TotalAgua12: AGUA <= AGUA_CON_H;
s.t. TotalAgua21: (-M_M * YH2) + AGUA_SIN_H <= AGUA;
s.t. TotalAgua22: AGUA <= AGUA_SIN_H;
s.t. soloUnaOpcionDeAgua: YH1 + YH2 = 1;




############ RESTRICCION DE COMIDA ############

s.t. VisiteCiudadIAntesdeJ_1{i in 1..TOTAL_CIUDADES, j in 1..TOTAL_CIUDADES: i<>j}: -M_M * (1 - Yi_a_j[i,j]) <= (U[j] - U[i]);
s.t. VisiteCiudadIAntesdeJ_2{i in 1..TOTAL_CIUDADES, j in 1..TOTAL_CIUDADES: i<>j}: (U[j] - U[i]) <= M_M * (Yi_a_j[i,j]);

## Ands entre las YViaje y Yi_a_j (indicadora si se visita I antes que J)
## Esto da una matriz de 3 dimesiones, que es la que despues sirve para multiplicar por la matriz de distancias
s.t. ANDijk_1{i in 1..TOTAL_CIUDADES, j in 1..TOTAL_CIUDADES, k in 1..TOTAL_CIUDADES: i<>j and i<>k}: 2 * YANDijk[i,j,k] <= YViaje[i,j] + Yi_a_j[i,k];
s.t. ANDijk_2{i in 1..TOTAL_CIUDADES, j in 1..TOTAL_CIUDADES, k in 1..TOTAL_CIUDADES: i<>j and i<>k}: YViaje[i,j] + Yi_a_j[i,k] <= YANDijk[i,j,k] + 1;

## aca esta la acumulacion, usando la matriz de 3 dimensiones.
s.t. KmAcumuladosHastaK{k in 1..TOTAL_CIUDADES}: KmAcumulados[k] = sum{i in 1..TOTAL_CIUDADES,j in 1..TOTAL_CIUDADES: i<>j} YANDijk[i,j,k] * DISTANCIAS[i,j];

# restriccion adicional que no deberia ser necesaria
s.t. KmAcumuladosHastaK_2{j in CIUDADES: j>0}: KmAcumulados[j] <= KmViaje;


s.t. CiudadISupera10k_1{j in CIUDADES: j>0}: 10000 * (Ymas10K[j]) <= KmAcumulados[j];
s.t. CiudadISupera10k_2{j in CIUDADES: j>0}: KmAcumulados[j] <= 10000 + (Ymas10K[j] * M_M);
s.t. fixed_1: Ymas10K[0] = 0;
s.t. CantCiudadesMas10k_0: CantCiudadesMas10k <= TOTAL_CIUDADES;
s.t. CantCiudadesMas10k_1: CantCiudadesMas10k = sum{i in CIUDADES} Ymas10K[i];


s.t. CiudadISupera20k_1{j in CIUDADES: j>0}: 20000 * (Ymas20K[j]) <= KmAcumulados[j];
s.t. CiudadISupera20k_2{j in CIUDADES: j>0}: KmAcumulados[j] <= 20000 + (Ymas20K[j] * M_M);
s.t. fixed_2: Ymas20K[0] = 0;
s.t. CantCiudadesMas20k_0: CantCiudadesMas20k <= TOTAL_CIUDADES;
s.t. CantCiudadesMas20k_1: CantCiudadesMas20k = sum{i in CIUDADES} Ymas20K[i];


s.t. CiudadISupera30k_1{j in CIUDADES: j>0}: 30000 * (Ymas30K[j]) <= KmAcumulados[j];
s.t. CiudadISupera30k_2{j in CIUDADES: j>0}: KmAcumulados[j] <= 30000 + (Ymas30K[j] * M_M);
s.t. fixed_3: Ymas30K[0] = 0;
s.t. CantCiudadesMas30k_0: CantCiudadesMas30k <= TOTAL_CIUDADES;
s.t. CantCiudadesMas30k_1: CantCiudadesMas30k = sum{i in CIUDADES} Ymas30K[i];


#s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*TOTAL_CIUDADES)-(5*CantCiudadesMas10k)-(5*CantCiudadesMas20k)-(5*CantCiudadesMas30k)-(5*CantCiudadesMas40k);
#s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*TOTAL_CIUDADES)-(5*CantCiudadesMas10k)-(5*CantCiudadesMas20k)-(5*CantCiudadesMas30k);
#s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*TOTAL_CIUDADES)-(5*CantCiudadesMas10k)-(5*CantCiudadesMas20k);
#s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*TOTAL_CIUDADES)-(5*CantCiudadesMas10k);
s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*TOTAL_CIUDADES);




/*#Inicio conteo para noches adicionales, separadas por los segmentos de kilometros...
s.t. YNAi{i in CIUDADES}: YNA_i[i] = sum{j in CIUDADES: i<>j} YNA[i,j];


s.t. YiNA_0k10k_1{i in CIUDADES}: YNA_0k10k[i] * 4 <= YNA_i[i] + (1-Ymas10K[i])+ (1-Ymas20K[i]) +(1-Ymas30K[i]);
s.t. YiNA_0k10k_2{i in CIUDADES}: YNA_i[i] + (1-Ymas10K[i])+ (1-Ymas20K[i]) +(1-Ymas30K[i]) <= YNA_0k10k[i] + 3;
s.t. TotalAdicionales0k10k: TotalNA_0k10k = sum{i in CIUDADES} YNA_0k10k[i];

s.t. YiNA_10k20k_1{i in CIUDADES}: YNA_10k20k[i] * 4 <= YNA_i[i] + (Ymas10K[i])+ (1-Ymas20K[i]) +(1-Ymas30K[i]);
s.t. YiNA_10k20k_2{i in CIUDADES}: YNA_i[i] + (Ymas10K[i])+ (1-Ymas20K[i]) +(1-Ymas30K[i]) <= YNA_10k20k[i] + 3;
s.t. TotalAdicionales10k20k: TotalNA_10k20k = sum{i in CIUDADES} YNA_10k20k[i];

s.t. YiNA_20k30k_1{i in CIUDADES}: YNA_20k30k[i] * 4 <= YNA_i[i] + (Ymas10K[i])+ (Ymas20K[i]) +(1-Ymas30K[i]);
s.t. YiNA_20k30k_2{i in CIUDADES}: YNA_i[i] + (Ymas10K[i])+ (Ymas20K[i]) +(1-Ymas30K[i]) <= YNA_20k30k[i] + 3;
s.t. TotalAdicionales20k30k: TotalNA_20k30k = sum{i in CIUDADES} YNA_20k30k[i];

s.t. YiNA_30kmask_1{i in CIUDADES}: YNA_30kmask[i] * 4 <= YNA_i[i] + (Ymas10K[i])+ (Ymas20K[i]) +(Ymas30K[i]);
s.t. YiNA_30kmask_2{i in CIUDADES}: YNA_i[i] + (Ymas10K[i])+ (Ymas20K[i]) +(Ymas30K[i]) <= YNA_30kmask[i] + 3;
s.t. TotalAdicionales30kmask: TotalNA_30kmask = sum{i in CIUDADES} YNA_30kmask[i];


s.t. ComidaNochesAdicionales: COMIDA_NOCHES2 = (30 * TotalNA_0k10k) + (25 * TotalNA_10k20k) + (20 * TotalNA_20k30k) + (15 * TotalNA_30kmask);*/


s.t. SumaComidas: COMIDA = COMIDA_NOCHES1 + COMIDA_NOCHES2;

/* ------------------------ FIN DE RESTRICCIONES ----------------------------- */



/* Funcional */ 
minimize z: NAFTA + ESTADIA + AGUA + COMIDA;



printf "----------- FIN ----------\n";
solve;
/* ------------------------ FIN DE MODELO ----------------------------- */







printf "----------- INFORMACION DE VARIABLES  // DEBUG ----------\n";

printf "-- NAFTA ----------------\n";
printf "KmViaje: %.2f\n", KmViaje;
printf "NAFTA: %.2f\n", NAFTA;
printf "--\n";

printf "-- ESTADIA ----------------\n";
printf "NOCHES_NORMALES: %.2f\n", NOCHES_NORMALES;
printf "NOCHES_ADICIONALES: %.2f\n", NOCHES_ADICIONALES;
printf "NOCHES_TOTALES: %.2f\n", NOCHES_TOTALES;
printf "ESTADIA: %.2f\n", ESTADIA;
printf "--\n";

printf "-- AGUA ----------------\n";
printf "AGUA_CON_H: %.2f\n", AGUA_CON_H;
printf "AGUA_SIN_H: %.2f\n", AGUA_SIN_H;
printf "AGUA: %.2f\n", AGUA;

printf "--\n";

printf "-- COMIDA ----------------\n";
printf "COMIDA: %.2f\n", COMIDA;
printf "CantCiudadesMas10k: %.2f\n", CantCiudadesMas10k;
printf "CantCiudadesMas20k: %.2f\n", CantCiudadesMas20k;
printf "CantCiudadesMas30k: %.2f\n", CantCiudadesMas30k;
#printf "CantCiudadesMas40k: %.2f\n", CantCiudadesMas40k;
printf "TotalNA_0k10k: %.2f\n", TotalNA_0k10k;
printf "TotalNA_10k20k: %.2f\n", TotalNA_10k20k;
printf "TotalNA_20k30k: %.2f\n", TotalNA_20k30k;
printf "TotalNA_30kmask: %.2f\n", TotalNA_30kmask;
printf "--\n";

printf "-- OTROS DATOS ----------------\n";
printf "card(CIUDADES): %.2f\n", card(CIUDADES);
printf "card(DIST): %.2f\n", card(DIST);
printf "TOTAL_CIUDADES: %.2f\n", TOTAL_CIUDADES;

printf "--VIAJES ----------------\n";
printf "YViaje[0,4] %.2f\n", YViaje[0,4];
printf "YViaje[4,2] %.2f\n", YViaje[4,2];
printf "YViaje[2,5] %.2f\n", YViaje[2,5];
printf "YViaje[5,3] %.2f\n", YViaje[5,3];
printf "YViaje[3,1] %.2f\n", YViaje[3,1];
#printf "YViaje[1,7] %.2f\n", YViaje[1,7];
#printf "YViaje[7,6] %.2f\n", YViaje[7,6];
#printf "YViaje[6,0] %.2f\n", YViaje[6,0];

printf "--DISTANCIAS ----------------\n";
#printf "DISTANCIAS[0,6] %.2f\n", DISTANCIAS[0,6];
#printf "DISTANCIAS[6,7] %.2f\n", DISTANCIAS[6,7];
#printf "DISTANCIAS[7,1] %.2f\n", DISTANCIAS[7,1];
printf "DISTANCIAS[1,3] %.2f\n", DISTANCIAS[1,3];
printf "DISTANCIAS[3,5] %.2f\n", DISTANCIAS[3,5];
printf "DISTANCIAS[5,2] %.2f\n", DISTANCIAS[5,2];
printf "DISTANCIAS[2,4] %.2f\n", DISTANCIAS[2,4];
printf "DISTANCIAS[4,0] %.2f\n", DISTANCIAS[4,0];

printf "--VIAJES Km Acumulados hasta ----------------\n";
printf "KmAcumulados[4] %.2f\n", KmAcumulados[4];
printf "KmAcumulados[2] %.2f\n", KmAcumulados[2];
printf "KmAcumulados[5] %.2f\n", KmAcumulados[5];
printf "KmAcumulados[3] %.2f\n", KmAcumulados[3];
printf "KmAcumulados[1] %.2f\n", KmAcumulados[1];
#printf "KmAcumulados[7] %.2f\n", KmAcumulados[7];
#printf "KmAcumulados[6] %.2f\n", KmAcumulados[6];

printf "--CIUDADES A MAS DE 10k ----------------\n";
printf "Ymas10K[0] %.2f\n", Ymas10K[0];
printf "Ymas10K[1] %.2f\n", Ymas10K[1];
printf "Ymas10K[2] %.2f\n", Ymas10K[2];
printf "Ymas10K[3] %.2f\n", Ymas10K[3];
printf "Ymas10K[4] %.2f\n", Ymas10K[4];
printf "Ymas10K[5] %.2f\n", Ymas10K[5];
#printf "Ymas10K[6] %.2f\n", Ymas10K[6];
#printf "Ymas10K[7] %.2f\n", Ymas10K[7];

printf "--CANT CIUDADES A MAS DE X km ----------------\n";
printf "CantCiudadesMas10k %.2f\n", CantCiudadesMas10k;
printf "CantCiudadesMas20k %.2f\n", CantCiudadesMas20k;
printf "CantCiudadesMas30k %.2f\n", CantCiudadesMas30k;

printf "--VIAJES ORDEN ----------------\n";
printf "U[1] %.2f\n", U[1];
printf "U[2] %.2f\n", U[2];
printf "U[3] %.2f\n", U[3];
printf "U[4] %.2f\n", U[4];
printf "U[5] %.2f\n", U[5];
#printf "U[6] %.2f\n", U[6];
#printf "U[7] %.2f\n", U[7];

printf "--Noche adicional ----------------\n";
printf "YNA_i[0]: %.2f\n", YNA_i[0];
printf "YNA_i[1]: %.2f\n", YNA_i[1];
printf "YNA_i[2]: %.2f\n", YNA_i[2];
printf "YNA_i[3]: %.2f\n", YNA_i[3];
printf "YNA_i[4]: %.2f\n", YNA_i[4];
printf "--\n";

end; 
