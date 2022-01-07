
%% Lista de los nombres de los archivos de los cuantizadores
clc;
clear all;
ruta_files_cuant = 'CENT_HSV\';
extension = '_HSV.txt';
names_cuant = ["CENTROIDES_APPLE_JUICE_VECT","CENTROIDES_BLUE_BOWL_VECT"...
               "CENTROIDES_BLUE_LEGO_VECT","CENTROIDES_BLUE_MUG_VECT"...
               "CENTROIDES_BLUE_SPOON_VECT","CENTROIDES_CHOCOLATE_COOKIES_VECT"...
               "CENTROIDES_ORANGE_JUICE_VECT","CENTROIDES_ORANGE_KNIFE_VECT"...
               "CENTROIDES_RED_LEGO_VECT","CENTROIDES_RED_MUG_VECT"];
%Se leen las matrices de los archivos especificados
cuant_1 = readmatrix(strcat(ruta_files_cuant,names_cuant(1),extension));
cuant_2 = readmatrix(strcat(ruta_files_cuant,names_cuant(2),extension));
cuant_3 = readmatrix(strcat(ruta_files_cuant,names_cuant(3),extension));
cuant_4 = readmatrix(strcat(ruta_files_cuant,names_cuant(4),extension));
cuant_5 = readmatrix(strcat(ruta_files_cuant,names_cuant(5),extension));
cuant_6 = readmatrix(strcat(ruta_files_cuant,names_cuant(6),extension));
cuant_7 = readmatrix(strcat(ruta_files_cuant,names_cuant(7),extension));
cuant_8 = readmatrix(strcat(ruta_files_cuant,names_cuant(8),extension));
cuant_9 = readmatrix(strcat(ruta_files_cuant,names_cuant(9),extension));
cuant_10 = readmatrix(strcat(ruta_files_cuant,names_cuant(10),extension));

%% Para cada archivo de prueba se obtienen sus vectores RGB para ser
%comparados contras los 10 cuantizadores

%Se tienen los nombres de los archivos que seran probados
%para cada set de imagenes solo esta variable se cambia asi como
%la ruta de la imagen
lista_names_imgs =   ["blueBowl3BGR","blueBowl17BGR","blueBowl207BGR"...
             "blueBowl277BGR","blueBowl460BGR","blueBowl538BGR"...
             "blueBowl808BGR","blueBowl955BGR","blueBowl1026BGR"...
             "blueBowl1110BGR","blueBowl1236BGR","blueBowl1291BGR"...
             "blueBowl1338BGR","blueBowl1386BGR","blueBowl1470BGR"...
             "blueBowl1527BGR","blueBowl1584BGR","blueBowl1644BGR"...
             "blueBowl1728BGR","blueBowl1881BGR"];
rt_img = 'OBJ_SEG\blueBowl\';
ext_img = '.jpg';

%% Se inicializa una matriz que tendra los valores de distancia minima de
%cada imagen
array_dist = zeros(20,10);
table_dist = table([0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
                   [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0],...
    'VariableNames',{'APPLE_JUICE' 'BLUE_BOWL' 'BLUE_LEGO' 'BLUE_MUG'...
    'BLUE_SPOON' 'COOKIES' 'ORANGE_JUICE' 'ORANGE_KNIFE' 'RED_LGO'...
    'RED_MUG'},...
    'RowNames',{'IMG_1' 'IMG_2' 'IMG_3' 'IMG_4' 'IMG_5' 'IMG_6'...
    'IMG_7' 'IMG_8' 'IMG_9' 'IMG_10' 'IMG_11' 'IMG_12' 'IMG_13'...
    'IMG_14' 'IMG_15' 'IMG_16' 'IMG_17' 'IMG_18' 'IMG_19' 'IMG_20'});


%%
for x = 1:length(lista_names_imgs)
    %Se inicializa un vector de para almacenar la distancia minima
    %acumulada de la imagen con respecto a cada cuantizador
    dist_min = [];
    %Se obtienen los vectores RGB de la imagen actual
    imagen_prueba = strcat(rt_img,lista_names_imgs(x),ext_img);
    hsv_prueba = get_vect_hsv(imagen_prueba);
    texto = strcat("SE HAN OBTENIDO LOS DATOS DE LA IMAGEN: ",...
        lista_names_imgs(x),"\n");
    fprintf(texto);
    %Se obtiene el mini-cuantizador de cada imagen individual, asi no 
    %se comparan los cientos de miles de pixeles de cada imagen
    %sino sus vectores representativos
    [idx,cent_hsv_prueba] = kmeans(hsv_prueba,32);
    idx2Region = kmeans(hsv_prueba,32,'MaxIter',1000,'Start',cent_hsv_prueba);
    %Se obtiene el vector de distancias acumuladas de la imagen actual
    %con respecto a los 10 cuantizadores
    % Comparacion de la imagen probada contra los cuantizadores
    table_dist{x,1} = comparacion_vector(cent_hsv_prueba,cuant_1);
    table_dist{x,2} = comparacion_vector(cent_hsv_prueba,cuant_2);
    table_dist{x,3} = comparacion_vector(cent_hsv_prueba,cuant_3);
    table_dist{x,4} = comparacion_vector(cent_hsv_prueba,cuant_4);
    table_dist{x,5} = comparacion_vector(cent_hsv_prueba,cuant_5);
    table_dist{x,6} = comparacion_vector(cent_hsv_prueba,cuant_6);
    table_dist{x,7} = comparacion_vector(cent_hsv_prueba,cuant_7);
    table_dist{x,8} = comparacion_vector(cent_hsv_prueba,cuant_8);
    table_dist{x,9} = comparacion_vector(cent_hsv_prueba,cuant_9);
    table_dist{x,10} = comparacion_vector(cent_hsv_prueba,cuant_10);
    %array_dist(x,:) = dist_min(:);
end

%% SE GUARDAN LOS DATOS DEL ARREGLO DE DISTANCIAS EN UN ARCHIVO
%de texto para no tener que recalcular estos valores
writetable(table_dist,'RESULT_FILES_HSV\HSV_DIST_BLUE_BOWL_TABLE.txt','Delimiter','tab');


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

%% FUNCIONES EMPLEADAS PARA LA COMPARACION DE VECTORES Y CUANTIZADORES
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Funcion comparacion_vector:
%Recibe un conjunto de vectores de una imagen cada vector representa 
%a un pixel de la imagen se compara para cada uno con respecto a cada
%cuantizador. Se devuelve el acumulado de las distancias minimas

function dist_minima = comparacion_vector(vectores,centroides)
    
    %Numero de vectores recibidos   
    n = size(vectores);
    n = n(1);
    %Numeo de centroides recibidos
    m = size(centroides);
    m = m(1);
    %Se declara un array que almacenara los valores de distancias
    %minimas asociados a cada vector
    dist_minimas = [];
    
    %Para cada vector de se obtiene la distancia euclidiana
    %minima con respecto a los vectores de los centroides
    for x = 1:n
        %Se toman los valores del vector x
        vect_actual = vectores(x,:);
        %Se inicializa la distancia minima del vector probado con una 
        %distancia respecto al primer centroide 
        dist_minimas(x)= pdist2(vect_actual,centroides(1,:));
        
        %Obtencion de distancia minima con respecto al CUANTIZADOR
        for y = 2:m
            cent_actual = centroides(y,:);
            %Se obtiene la distancia minima del vector comparado
            %contra el vector y-iesimo del cuantizador
            dist_actual = pdist2(vect_actual,cent_actual);
            %Se compara la distancia actual con la minima almacenada
            %para el vector probado
            if dist_actual < dist_minimas(x)
                %Si la distancia actual es menor se actualiza el valor
                dist_minimas(x) = dist_actual;
            end
        end
    end
    %Se obtiene el acumulado de las distancias minimas obtenidas
    dist_minima = dist_acumulada(dist_minimas);
end

%Funcion dist_acumulada:
%Recibe los vectores de distorciones minimas de 10 elementos y calcula un 
%solo vector de distorciones acumuladas

function distancia_acumulada = dist_acumulada(vectores_dist)
    distancia_acumulada = 0;
    for x = 1:length(vectores_dist)
        %Se suma cada componente x del vector al vector que acumula
        %las distancias
        distancia_acumulada = distancia_acumulada+vectores_dist(x);
    end
end

%Funcion get_vect_rgb: Recibe como entrada el nombre de una imagen
%y obtiene un vector de Nx3 que representa los valores RGB de cada pixel
%de la imagen deseada.
function vect_hsv = get_vect_hsv(nombre_img)
    %Apertura de la imagen indicada por nombre_img
    IMG = imread(nombre_img);
    IMG = rgb2hsv(IMG);
    %Obtencion de la dimension de la imagen
    vect_size = size(IMG);
    size_y = vect_size(1);
    size_x = vect_size(2);
    dimension = size_y*size_x;
    %fprintf("EL ALTO DE LA IMAGEN ES DE: %d\n",size_y);
    %fprintf("EL ANCHO DE LA IMAGEN ES DE: %d\n",size_x);
    %fprintf("TAMAÑO DEL VECTOR RGB: %d\n",dimension);
    %Ciclo para obtener un solo vector de 3 dimensiones a partir de la imagen
    %Se inicializa un vector de 0's de tamaño: dimension x 3
    vect_hsv = zeros(dimension,3);
    %Variable que recorre los elementos de vect_rgb
    index = 1;
    for i = 1:size_y
        for j = 1:size_x
            %Se obtiene el valor R del pixel IMG(i,j)
            vect_hsv(index,1) = IMG(i,j,1);
            %Se obtiene el valor G del pixel IMG(i,j)
            vect_hsv(index,2) = IMG(i,j,2);
            %Se obtiene el valor B del pixel IMG(i,j)
            vect_hsv(index,3) = IMG(i,j,3);
            %Se incrementa el indice del vector RGB
            index = index+1;
        end
    end
end