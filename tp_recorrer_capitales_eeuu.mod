printf "Hola Mundo \n";

/* datos */
# set CIUDADES := 1..48;
set CIUDADES;   # distancias de ciudad a ciudad

param DistanciaEnKm1 {i in CIUDADES}; 
param DistanciaEnKm2 {i in CIUDADES}; 
param DistanciaEnKm3 {i in CIUDADES}; 
param DistanciaEnKm4 {i in CIUDADES}; 
param DistanciaEnKm5 {i in CIUDADES}; 
param DistanciaEnKm6 {i in CIUDADES}; 
param DistanciaEnKm7 {i in CIUDADES}; 
param DistanciaEnKm8 {i in CIUDADES}; 
param DistanciaEnKm9 {i in CIUDADES}; 
param DistanciaEnKm10 {i in CIUDADES}; 
param DistanciaEnKm11 {i in CIUDADES}; 
param DistanciaEnKm12 {i in CIUDADES}; 
param DistanciaEnKm13 {i in CIUDADES}; 
param DistanciaEnKm14 {i in CIUDADES}; 
param DistanciaEnKm15 {i in CIUDADES}; 
param DistanciaEnKm16 {i in CIUDADES}; 
param DistanciaEnKm17 {i in CIUDADES}; 
param DistanciaEnKm18 {i in CIUDADES}; 
param DistanciaEnKm19 {i in CIUDADES}; 
param DistanciaEnKm20 {i in CIUDADES}; 
param DistanciaEnKm21 {i in CIUDADES}; 
param DistanciaEnKm22 {i in CIUDADES}; 
param DistanciaEnKm23 {i in CIUDADES}; 
param DistanciaEnKm24 {i in CIUDADES}; 
param DistanciaEnKm25 {i in CIUDADES}; 
param DistanciaEnKm26 {i in CIUDADES}; 
param DistanciaEnKm27 {i in CIUDADES}; 
param DistanciaEnKm28 {i in CIUDADES}; 
param DistanciaEnKm29 {i in CIUDADES}; 
param DistanciaEnKm30 {i in CIUDADES};
param DistanciaEnKm31 {i in CIUDADES}; 
param DistanciaEnKm32 {i in CIUDADES}; 
param DistanciaEnKm33 {i in CIUDADES}; 
param DistanciaEnKm34 {i in CIUDADES}; 
param DistanciaEnKm35 {i in CIUDADES}; 
param DistanciaEnKm36 {i in CIUDADES}; 
param DistanciaEnKm37 {i in CIUDADES}; 
param DistanciaEnKm38 {i in CIUDADES}; 
param DistanciaEnKm39 {i in CIUDADES}; 
param DistanciaEnKm40 {i in CIUDADES}; 
param DistanciaEnKm41 {i in CIUDADES}; 
param DistanciaEnKm42 {i in CIUDADES}; 
param DistanciaEnKm43 {i in CIUDADES}; 
param DistanciaEnKm44 {i in CIUDADES}; 
param DistanciaEnKm45 {i in CIUDADES}; 
param DistanciaEnKm46 {i in CIUDADES}; 
param DistanciaEnKm47 {i in CIUDADES}; 
param DistanciaEnKm48 {i in CIUDADES};


/* Constantes */
param MAX_CIUDADES = 48;
param VALKM = 2;
param DIAHOTEL = 50;
param DISTANCIA {MAX_CIUDADES}; 


/* Variables */
#Yij, bivalente que vale 1 si va desde la ciudad i hasta la j (i != j)
var Y{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# Contiene las distancias entre ciudades
#param KM {i in CIUDADES, j in CIUDADES: i<>j} >= 0;
param KM {i in CIUDADES} >= 0;


table data IN "CSV" "distancia_ciudad_a_ciudad_2.csv":
CIUDADES <- [ID_Ciudad], DistanciaEnKm1~Distancia1,
DistanciaEnKm2~Distancia2,
DistanciaEnKm3~Distancia3,
DistanciaEnKm4~Distancia4,
DistanciaEnKm5~Distancia5,
DistanciaEnKm6~Distancia6,
DistanciaEnKm7~Distancia7,
DistanciaEnKm8~Distancia8,
DistanciaEnKm9~Distancia9,
DistanciaEnKm10~Distancia10,
DistanciaEnKm11~Distancia11,
DistanciaEnKm12~Distancia12,
DistanciaEnKm13~Distancia13,
DistanciaEnKm14~Distancia14,
DistanciaEnKm15~Distancia15,
DistanciaEnKm16~Distancia16,
DistanciaEnKm17~Distancia17,
DistanciaEnKm18~Distancia18,
DistanciaEnKm19~Distancia19,
DistanciaEnKm20~Distancia20,
DistanciaEnKm21~Distancia21,
DistanciaEnKm22~Distancia22,
DistanciaEnKm23~Distancia23,
DistanciaEnKm24~Distancia24,
DistanciaEnKm25~Distancia25,
DistanciaEnKm26~Distancia26,
DistanciaEnKm27~Distancia27,
DistanciaEnKm28~Distancia28,
DistanciaEnKm29~Distancia29,
DistanciaEnKm30~Distancia30,
DistanciaEnKm31~Distancia31,
DistanciaEnKm32~Distancia32,
DistanciaEnKm33~Distancia33,
DistanciaEnKm34~Distancia34,
DistanciaEnKm35~Distancia35,
DistanciaEnKm36~Distancia36,
DistanciaEnKm37~Distancia37,
DistanciaEnKm38~Distancia38,
DistanciaEnKm39~Distancia39,
DistanciaEnKm40~Distancia40,
DistanciaEnKm41~Distancia41,
DistanciaEnKm42~Distancia42,
DistanciaEnKm43~Distancia43,
DistanciaEnKm44~Distancia44,
DistanciaEnKm45~Distancia45,
DistanciaEnKm46~Distancia46,
DistanciaEnKm47~Distancia47,
DistanciaEnKm48~Distancia48;

# 1 si el viaje de la ciudad i a la j es largo (>=250 Kms)
var YNA {i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# 1 si la ciudad i fue visitada despu�s de X km
var Ymas10K {i in CIUDADES} >= 0, binary;
var Ymas20K {i in CIUDADES} >= 0, binary;
var Ymas30K {i in CIUDADES} >= 0, binary;
var Ymas40K {i in CIUDADES} >= 0, binary;

# 1 si se compra la heladera portatil
var YH >= 0, binary; 

#var KmViaje >= 0;
var ESTADIA >= 0; # Total de plata gastada en estadia
var NAFTA >= 0; # Total de plata gastada en nafta
var COMIDA >= 0; # Total de plata gastada en comida
var AGUA >= 0; # Total de plata gastada en agua

var CANTDesc >= 0; #Cantidad de paradas para descanso
var CANTHidra >= 0; # Cantidad de paradas para hidrataci�n

var AGUASH >= 0; # Total de plata gastada si NO compramos la heladera
var AGUACH >= 0; # Total de plata gastada si compramos la heladera
var EXC_SH >= 0; # Indica el exceso de plata gastada si NO compramos la heladera
var EXC_CH >= 0; # Indica el exceso de plata gastada si compramos la heladera

var U{i in CIUDADES} >=0, integer; # N�mero de secuencia en la cual la ciudad i es visitada

/* Funcional */ 
minimize z: ESTADIA + NAFTA + AGUA + COMIDA;

/* RESTRICCIONES */
# Salidas
s.t. voyI{i in CIUDADES}: sum{j in CIUDADES: i<>j} Y[i,j] = 1;

# Llegadas 
s.t. llegoJ{j in CIUDADES}: sum{i in CIUDADES: i<>j} Y[i,j] = 1;

# Elimina subtours 
s.t. orden{i in CIUDADES, j in CIUDADES: i<>j}: U[i] - U[j] + card(CIUDADES) * Y[i,j] <= card(CIUDADES) - 1;

# Restricci�n de nafta
#var KmViaje = sum{i in CIUDADES, j in CIUDADES} KM[i,j] * Y[i,j];

# Restricci�n de alojamiento
#var nochesnormales = sum{i in CIUDADES, j in CIUDADES} Y[i,j];

solve;

#data;


end; 