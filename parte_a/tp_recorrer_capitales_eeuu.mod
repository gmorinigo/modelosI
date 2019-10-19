printf "----------- INICIO ----------\n";

/* datos */
set CIUDADES := 0..47;

set DIST, dimen 2; # matriz distancias de la ciudad "i" a ciudad "j"
param DISTANCIAS {i in CIUDADES, j in CIUDADES}; 

table TDist IN "CSV" "./datos/distancias_formato_3_columnas.csv":
DIST <- [CiudadOrigen,CiudadDestino], DISTANCIAS ~ Distancia;

/* Constantes */
param MAX_CIUDADES = 48;
param VALKM := 2;
param DIAHOTEL = 50;

/* Variables */
#Yij, bivalente que vale 1 si va desde la ciudad i hasta la j (i != j)
var YViaje{i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# 1 si el viaje de la ciudad i a la j es largo (>=250 Kms)
var YNA {i in CIUDADES, j in CIUDADES: i<>j} >= 0, binary;

# 1 si la ciudad i fue visitada despu�s de X km
var Ymas10K {i in CIUDADES} >= 0, binary;
var Ymas20K {i in CIUDADES} >= 0, binary;
var Ymas30K {i in CIUDADES} >= 0, binary;
var Ymas40K {i in CIUDADES} >= 0, binary;

# 1 si se compra la heladera portatil
var YH >= 0, binary; 

var KmViaje >= 0;

var NOCHES_NORMALES >= 0;
var NOCHES_ADICIONALES >= 0;
var NOCHES_TOTALES >= 0;


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






/* RESTRICCIONES */






/* RESTRICCION BASICA DEL VIAJANTE */
# Salidas
s.t. voyI{i in CIUDADES}: sum{j in CIUDADES: i<>j} YViaje[i,j] = 1;

# Llegadas 
s.t. llegoJ{j in CIUDADES}: sum{i in CIUDADES: i<>j} YViaje[i,j] = 1;

# Elimina subtours 
s.t. orden{i in CIUDADES, j in CIUDADES: i<>j}: U[i] - U[j] + card(CIUDADES) * YViaje[i,j] <= card(CIUDADES) - 1;








/* RESTRICCION DE NAFTA */
s.t. KmViajados: KmViaje = sum{i in CIUDADES, j in CIUDADES: i<>j} DISTANCIAS[i,j] * YViaje[i,j];
s.t. TotalNafta: NAFTA = KmViaje * VALKM;






/* RESTRICCION DE ALOJAMIENTO */
s.t. NochesNormales: NOCHES_NORMALES = sum{i in CIUDADES, j in CIUDADES: i<>j} YViaje[i,j];
s.t. NochesAdicionales: NOCHES_ADICIONALES = 1; #falta seguir aca aun!
s.t. NochesTotales: NOCHES_TOTALES = NOCHES_NORMALES + NOCHES_ADICIONALES;
s.t. TotalEstadia: ESTADIA = NOCHES_TOTALES;





/* Funcional */ 
minimize z: NAFTA + ESTADIA + AGUA + COMIDA;


printf "----------- FIN ----------\n";
solve;




printf "-- NAFTA ----------------\n";
printf NAFTA;
printf "\n--\n";

printf "-- ESTADIA ----------------\n";
printf ESTADIA;
printf "\n--\n";

printf "-- AGUA ----------------\n";
printf AGUA;
printf "\n--\n";

printf "-- COMIDA ----------------\n";
printf COMIDA;
printf "\n--\n";

end; 
