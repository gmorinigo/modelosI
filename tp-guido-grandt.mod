/* ********************************** */
/* datos */
/* ********************************** */
set JUGADORES; #Jugadores del gran dt
set JUGADORES4;
set JUGADORES5;

set PUESTOS := 1..4; # hay 4 puestos (ARQ, DEF, VOL, DEL)
set EQUIPOS := 0..29; # hay 30 equipos en total
set FECHAS := 0..14; # hay 15 fechas del gran dt
set PUNTAJE, dimen 2; # puntos de jugador por fecha
set ESTRATEGIAS := 0..2; # hay 3 tipos de estrategia disponibles para elegir

param COSTO {i in JUGADORES}; 
param EQUIPO {i in JUGADORES}; 
param PUESTO {i in JUGADORES}; 
param PUNTOS {i in JUGADORES, j in FECHAS}; 

param EQ1 {i in JUGADORES}; 
param EQ2 {i in JUGADORES}; 
param EQ3 {i in JUGADORES}; 
param EQ4 {i in JUGADORES}; 
param EQ5 {i in JUGADORES}; 
param EQ6 {i in JUGADORES}; 
param EQ7 {i in JUGADORES}; 
param EQ8 {i in JUGADORES}; 
param EQ9 {i in JUGADORES}; 
param EQ10 {i in JUGADORES}; 
param EQ11 {i in JUGADORES}; 
param EQ12 {i in JUGADORES}; 
param EQ13 {i in JUGADORES}; 
param EQ14 {i in JUGADORES}; 
param EQ15 {i in JUGADORES}; 
param EQ16 {i in JUGADORES}; 
param EQ17 {i in JUGADORES}; 
param EQ18 {i in JUGADORES}; 
param EQ19 {i in JUGADORES}; 
param EQ20 {i in JUGADORES}; 
param EQ21 {i in JUGADORES}; 
param EQ22 {i in JUGADORES}; 
param EQ23 {i in JUGADORES}; 
param EQ24 {i in JUGADORES}; 
param EQ25 {i in JUGADORES}; 
param EQ26 {i in JUGADORES}; 
param EQ27 {i in JUGADORES}; 
param EQ28 {i in JUGADORES}; 
param EQ29 {i in JUGADORES}; 
param EQ30 {i in JUGADORES}; 

param ARQ {i in JUGADORES}; 
param DEF {i in JUGADORES}; 
param VOL {i in JUGADORES}; 
param DEL {i in JUGADORES}; 

table Cotizaciones IN "CSV" "./datos/Cotizacion.csv" :
JUGADORES <- [Jugador], COSTO ~ Cotizacion;

table Puntos IN "CSV" "./datos/Puntos.csv" :
PUNTAJE <- [Jugador,Fecha], PUNTOS ~ Puntos;

table Equipo2 IN "CSV" "./datos/Equipo2.csv" :
JUGADORES4 <- [Jugador], EQ1~E1, EQ2~E2, EQ3~E3, EQ4~E4, EQ5~E5, EQ6~E6, EQ7~E7, EQ8~E8, EQ9~E9, EQ10~E10, EQ11~E11, EQ12~E12, EQ13~E13, EQ14~E14, EQ15~E15, EQ16~E16, EQ17~E17, EQ18~E18, EQ19~E19, EQ20~E20, EQ21~E21, EQ22~E22, EQ23~E23, EQ24~E24, EQ25~E25, EQ26~E26, EQ27~E27, EQ28~E28, EQ29~E29, EQ30~E30;

table Puestos2 IN "CSV" "./datos/Puesto2.csv" :
JUGADORES5 <- [Jugador], ARQ~Arq, DEF~Def, VOL~Vol, DEL~Del;


/* ********************************** */
/* Declaracion de constantes */
/* ********************************** */
var LIMITE_JUGADORES_TOTALES = 11;
var LIMITE_PRESUPUESTO=58800000;
var LIMITE_JUGADORES_POR_EQUIPO = 3;


/* ********************************** */
/* Declaracion de variables */
/* ********************************** */
var YMisJug{i in JUGADORES} binary; #jugador i en mi equipo
var YCapt{i in JUGADORES, j in FECHAS} binary; # jugador i capitan en fecha j
var YEstr{i in ESTRATEGIAS} binary;

var YMisJugEst{i in JUGADORES, j in ESTRATEGIAS} binary;


/* ********************************** */
/* Restricciones */
/* ********************************** */

s.t. MaxJugadores: sum{i in JUGADORES} YMisJug[i] = LIMITE_JUGADORES_TOTALES; 
s.t. LimDinero: sum{i in JUGADORES} COSTO[i] * YMisJug[i] <= LIMITE_PRESUPUESTO;

# YEstr[0] es la 4.4.2
# YEstr[1] es la 4.3.3
# YEstr[2] es la 3.4.3
s.t. ElegirAlgunaEstr: YEstr[0] + YEstr[1] + YEstr[2] = 1;

# Estrategias
s.t. LimiteEstrategiaArq: sum{i in JUGADORES} ARQ[i] * YMisJug[i] = 1 * YEstr[0] + 1 * YEstr[1] + 1 * YEstr[2];
s.t. LimiteEstrategiaDef: sum{i in JUGADORES} DEF[i] * YMisJug[i] = 4 * YEstr[0] + 4 * YEstr[1] + 3 * YEstr[2];
s.t. LimiteEstrategiaVol: sum{i in JUGADORES} VOL[i] * YMisJug[i] = 4 * YEstr[0] + 3 * YEstr[1] + 4 * YEstr[2];
s.t. LimiteEstrategiaDel: sum{i in JUGADORES} DEL[i] * YMisJug[i] = 2 * YEstr[0] + 3 * YEstr[1] + 3 * YEstr[2];

# Capitan
s.t. CantidadCap: sum{i in JUGADORES, j in FECHAS} YCapt[i,j] = 15;
s.t. CapFecha{j in FECHAS}: sum{i in JUGADORES} YCapt[i,j] = 1;
s.t. SeleccionCap{j in FECHAS, i in JUGADORES}: YCapt[i,j] <= YMisJug[i];

# Limites de jugadores por equipo
s.t. LimJugXEq1: sum{i in JUGADORES} YMisJug[i] * EQ1[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq2: sum{i in JUGADORES} YMisJug[i] * EQ2[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq3: sum{i in JUGADORES} YMisJug[i] * EQ3[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq4: sum{i in JUGADORES} YMisJug[i] * EQ4[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq5: sum{i in JUGADORES} YMisJug[i] * EQ5[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq6: sum{i in JUGADORES} YMisJug[i] * EQ6[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq7: sum{i in JUGADORES} YMisJug[i] * EQ7[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq8: sum{i in JUGADORES} YMisJug[i] * EQ8[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq9: sum{i in JUGADORES} YMisJug[i] * EQ9[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq10: sum{i in JUGADORES} YMisJug[i] * EQ10[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq11: sum{i in JUGADORES} YMisJug[i] * EQ11[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq12: sum{i in JUGADORES} YMisJug[i] * EQ12[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq13: sum{i in JUGADORES} YMisJug[i] * EQ13[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq14: sum{i in JUGADORES} YMisJug[i] * EQ14[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq15: sum{i in JUGADORES} YMisJug[i] * EQ15[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq16: sum{i in JUGADORES} YMisJug[i] * EQ16[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq17: sum{i in JUGADORES} YMisJug[i] * EQ17[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq18: sum{i in JUGADORES} YMisJug[i] * EQ18[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq19: sum{i in JUGADORES} YMisJug[i] * EQ19[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq20: sum{i in JUGADORES} YMisJug[i] * EQ20[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq21: sum{i in JUGADORES} YMisJug[i] * EQ21[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq22: sum{i in JUGADORES} YMisJug[i] * EQ22[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq23: sum{i in JUGADORES} YMisJug[i] * EQ23[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq24: sum{i in JUGADORES} YMisJug[i] * EQ24[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq25: sum{i in JUGADORES} YMisJug[i] * EQ25[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq26: sum{i in JUGADORES} YMisJug[i] * EQ26[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq27: sum{i in JUGADORES} YMisJug[i] * EQ27[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq28: sum{i in JUGADORES} YMisJug[i] * EQ28[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq29: sum{i in JUGADORES} YMisJug[i] * EQ29[i] <= LIMITE_JUGADORES_POR_EQUIPO;
s.t. LimJugXEq30: sum{i in JUGADORES} YMisJug[i] * EQ30[i] <= LIMITE_JUGADORES_POR_EQUIPO;

/* ********************************** */
/* FUNCIONAL */
/* ********************************** */
maximize z: sum{i in JUGADORES,j in FECHAS} PUNTOS[i,j] * YMisJug[i] + sum{i in JUGADORES,j in FECHAS} PUNTOS[i,j] * YCapt[i,j];

end;
