%% INICIALIZACION DE LA MATRIZ DE CONFUSION
matriz_conf = table([0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],...
    [0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],...
    [0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],...
    [0;0;0;0;0;0;0;0;0;0],[0;0;0;0;0;0;0;0;0;0],...
    'VariableNames',{'APPLE_JUICE' 'BLUE_BOWL' 'BLUE_LEGO' 'BLUE_MUG'...
    'BLUE_SPOON' 'COOKIES' 'ORANGE_JUICE' 'ORANGE_KNIFE' 'RED_LGO'...
    'RED_MUG'},...
    'RowNames',{'APPLE_JUICE' 'BLUE_BOWL' 'BLUE_LEGO' 'BLUE_MUG'...
    'BLUE_SPOON' 'COOKIES' 'ORANGE_JUICE' 'ORANGE_KNIFE' 'RED_LGO'...
    'RED_MUG'});

%% LECTURA DE LOS ARCHIVOS QUE CONTIENEN LAS DISTANCIAS MINIMAS
archivos = ["DIST_APPLE_JUICE" "DIST_BLUE_BOWL"...
            "DIST_BLUE_LEGO" "DIST_BLUE_MUG"...
            "DIST_BLUE_SPOON" "DIST_COOKIES"...
            "DIST_ORANGE_JUICE" "DIST_ORANGE_KNIFE" ...
            "DIST_RED_LEGO" "DIST_RED_MUG"];
ext = '_TABLE.txt';
ruta = 'RESULT_FILES_HSV_SOBEL\HSV_SOBEL_';
for x = 1:length(archivos)
    %Archivo que se abrira
    file_name = strcat(ruta,archivos(x),ext);
    %Se abre la tabla desde el archivo
    T = readtable(file_name);
    %Para cada renglon del archivo se toma el vector
    for y = 1:20
        vect_dist = T{y,:};
        %Se obtiene el indice del cuantizador con menor distancia
        indice = get_indice(vect_dist);
        matriz_conf{x,indice} = matriz_conf{x,indice}+1;
    end
end

%% FUNCION PARA EVALUAR LA DISTANCIA MINIMA DEL CONJUNTO
function indice = get_indice(vector)
    minimo = vector(1);
    indice = 1;
    for x = 2:length(vector)
        if vector(x)< minimo
            minimo = vector(x);
            indice = x;
        end    
    end
end