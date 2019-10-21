printf "----------- INICIO ----------\n";

/* datos */
set CIUDADES := 0..5;
#set CIUDADES := 0..10;
#set CIUDADES := 0..21;
#set CIUDADES := 0..31;
#set CIUDADES := 0..48;

set DIST, dimen 2; # matriz distancias de la ciudad "i" a ciudad "j"
param DISTANCIAS {i in CIUDADES, j in CIUDADES}; 

#table TDist IN "CSV" "./datos/distancias_formato_3_columnas.csv":
table TDist IN "CSV" "./datos/5_ciudades.csv":
#table TDist IN "CSV" "./datos/10_ciudades.csv":
#table TDist IN "CSV" "./datos/21_ciudades.csv":
#table TDist IN "CSV" "./datos/31_ciudades.csv":
#table TDist IN "CSV" "./datos/48_ciudades.csv": # POSTA DE 48, son 49 con una de inicio en 0
DIST <- [CiudadOrigen,CiudadDestino], DISTANCIAS ~ Distancia;

/* Constantes */
param MAX_CIUDADES := card(CIUDADES)-1;      #0..48 --> (49 - 1) = 48
param VALKM := 2;
param DIAHOTEL := 50;
param m_m := 0.0000001;
param M_M := 1000000000;

/* Variables */
# bivalente que vale 1 si va desde la ciudad i hasta la j (i != j)
var YViaje{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;
var U{i in CIUDADES} >=0, integer; # N�mero de secuencia en la cual la ciudad i es visitada

# bivalente, 1 si el viaje de la ciudad i a la j es largo (>=250 Kms)
# indica si entre las 2 ciudades se queda una NOCHE ADICIONAL
var YNA{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# 1 si la ciudad i fue visitada despues de X km
var Ymas10K {i in CIUDADES} >= 0, binary;
var Ymas20K {i in CIUDADES} >= 0, binary;
var Ymas30K {i in CIUDADES} >= 0, binary;
var Ymas40K {i in CIUDADES} >= 0, binary;
var CantCiudadesMas10k >= 0;
var CantCiudadesMas20k >= 0;
var CantCiudadesMas30k >= 0;
var CantCiudadesMas40k >= 0;

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

var Yj_antesde_i{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;
var KmAcumulados {i in CIUDADES} >= 0;




/* ----------------------------- RESTRICCIONES ----------------------------- */


############ RESTRICCION BASICA DEL VIAJANTE ############
# Salidas
s.t. voyI{i in CIUDADES}: sum{j in CIUDADES: i<>j} YViaje[i,j] = 1;

# Llegadas 
s.t. llegoJ{j in CIUDADES}: sum{i in CIUDADES: i<>j} YViaje[i,j] = 1;

# Elimina subtours 
s.t. maxorden{i in CIUDADES: i>=1}: U[i] <= card(CIUDADES) - 1;
s.t. minorden{i in CIUDADES: i>=1}: U[i] >= 1;
s.t. orden{i in 1..card(CIUDADES)-1, j in 1..card(CIUDADES)-1: i<>j}: U[i] - U[j] + card(CIUDADES) * YViaje[i,j] <= card(CIUDADES) - 1;








############ RESTRICCION DE NAFTA ############
s.t. KmViajados: KmViaje = sum{i in CIUDADES, j in CIUDADES: i<>j} DISTANCIAS[i,j] * YViaje[i,j];
s.t. TotalNafta: NAFTA = KmViaje * VALKM;










############ RESTRICCION DE ALOJAMIENTO ############
s.t. NochesNormales: NOCHES_NORMALES = sum{i in CIUDADES, j in CIUDADES: i<>j} YViaje[i,j];

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
s.t. VisiteCiudadJAntesdeI_1{i in CIUDADES, j in CIUDADES: i<>j}: -M_M * (1 - Yj_antesde_i[i,j]) <= (U[i] - U[j]);
s.t. VisiteCiudadJAntesdeI_2{i in CIUDADES, j in CIUDADES: i<>j}: (U[i] - U[j]) <= M_M * (Yj_antesde_i[i,j]);
s.t. KmAcumuladosHastaCiudadI{j in CIUDADES}: KmAcumulados[j] = sum{i in CIUDADES: i<>j} Yj_antesde_i[i,j] * DISTANCIAS[i,j];

s.t. CiudadISupera10k_1{j in CIUDADES}: 10000 * (Ymas10K[j]) <= KmAcumulados[j];
s.t. CiudadISupera10k_2{j in CIUDADES}: KmAcumulados[j] <= 10000 + (Ymas10K[j] * M_M);
s.t. CiudadISupera20k_1{j in CIUDADES}: 20000 * (Ymas20K[j]) <= KmAcumulados[j];
s.t. CiudadISupera20k_2{j in CIUDADES}: KmAcumulados[j] <= 20000 + (Ymas20K[j] * M_M);
s.t. CiudadISupera30k_1{j in CIUDADES}: 30000 * (Ymas30K[j]) <= KmAcumulados[j];
s.t. CiudadISupera30k_2{j in CIUDADES}: KmAcumulados[j] <= 30000 + (Ymas30K[j] * M_M);
s.t. CiudadISupera40k_1{j in CIUDADES}: 40000 * (Ymas40K[j]) <= KmAcumulados[j];
s.t. CiudadISupera40k_2{j in CIUDADES}: KmAcumulados[j] <= 40000 + (Ymas40K[j] * M_M);

s.t. CantCiudadesMas10k_1: CantCiudadesMas10k = sum{i in CIUDADES} Ymas10K[i];
s.t. CantCiudadesMas20k_2: CantCiudadesMas20k = sum{i in CIUDADES} Ymas20K[i];
s.t. CantCiudadesMas30k_3: CantCiudadesMas30k = sum{i in CIUDADES} Ymas30K[i];
s.t. CantCiudadesMas40k_4: CantCiudadesMas40k = sum{i in CIUDADES} Ymas40K[i];

s.t. ComidaNochesNormales: COMIDA_NOCHES1 = (30*MAX_CIUDADES)-(5*CantCiudadesMas10k)-(5*CantCiudadesMas20k)-(5*CantCiudadesMas30k)-(5*CantCiudadesMas40k);


## COMIDA_NOCHES2 ## Aun falta pasar el calculo de COMIDA_NOCHES2

s.t. SumaComidas: COMIDA = COMIDA_NOCHES1 + COMIDA_NOCHES2;









/* Funcional */ 
minimize z: NAFTA + ESTADIA + AGUA + COMIDA;


printf "----------- FIN ----------\n";
solve;












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
printf "--\n";

printf "-- OTROS DATOS ----------------\n";
printf "card(CIUDADES): %.2f\n", card(CIUDADES);
printf "card(DIST): %.2f\n", card(DIST);
printf "\n--\n";

end; 
