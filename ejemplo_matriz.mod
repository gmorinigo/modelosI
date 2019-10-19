/* datos */
set CIUDADES := 0..47;

set DIST, dimen 2; # matriz distancias de la ciudad "i" a ciudad "j"
param DISTANCIAS {i in CIUDADES, j in CIUDADES}; 

table Distancias IN "CSV" "distancias_propias.csv":
DIST <- [CiudadOrigen,CiudadDestino], DISTANCIAS ~ Distancia;

printf "-----------------------\n";
printf "Distancias en la matriz\n";
printf "-----------------------\n";
printf DISTANCIAS[0,1];
printf "\n";
printf DISTANCIAS[2,2];
printf "\n";
printf "-----------------------\n";

end; 
