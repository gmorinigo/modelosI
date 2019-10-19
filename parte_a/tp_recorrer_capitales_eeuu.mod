printf "Hola Mundo \n";

/* datos */
set CIUDADES := 0..47;

set DIST, dimen 2; # matriz distancias de la ciudad "i" a ciudad "j"
param DISTANCIAS {i in CIUDADES, j in CIUDADES}; 

table Distancias IN "CSV" "./datos/distancias_formato_3_columnas.csv":
DIST <- [CiudadOrigen,CiudadDestino], DISTANCIAS ~ Distancia;

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
