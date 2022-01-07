
%% Lista de los nombres de los archivos de los cuantizadores
clc;
clear all;
ruta_files_cuant = 'CENT_HSV_SOBEL\';
extension = '.txt';
names_cuant = ["CENTROIDES_APPLE_JUICE","CENTROIDES_BLUE_BOWL"...
               "CENTROIDES_BLUE_LEGO","CENTROIDES_BLUE_MUG"...
               "CENTROIDES_BLUE_SPOON","CENTROIDES_COOKIES"...
               "CENTROIDES_ORANGE_JUICE","CENTROIDES_ORANGE_KNIFE"...
               "CENTROIDES_RED_LEGO","CENTROIDES_RED_MUG"];
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

%% Para cada imagen de prueba se obtienen sus vectores RGB para ser
%comparados contras los 10 cuantizadores asi como sus valores
%del filtro de Sobel

%Se tienen los nombres de los archivos que seran probados
%para cada set de imagenes solo esta variable se cambia asi como
%la ruta de la imagen
lista_names_imgs = ["red_mug116BGR","red_mug150BGR","red_mug197BGR"...
             "red_mug239BGR","red_mug293BGR","red_mug311BGR"...
             "red_mug335BGR","red_mug353BGR","red_mug374BGR"...
             "red_mug395BGR","red_mug410BGR","red_mug431BGR"...
             "red_mug446BGR","red_mug464BGR","red_mug483BGR"...
             "red_mug507BGR","red_mug523BGR","red_mug554BGR"...
             "red_mug578BGR","red_mug617BGR"];

rt_img = 'OBJ_SEG\redMug\';
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
    %Se obtienen los vectores RGB + SOBEL de la imagen actual
    imagen_prueba = strcat(rt_img,lista_names_imgs(x),ext_img);

    %VECTOR QUE ALMACENARA EL CONJUNTO DE LOS VECTORES DE DIMENSION 9
    %DE LAS 20 IMAGENES PROBADAS
    vect_unidos = [];
    %Mediante un ciclo for se pasa el nombre del archivo y se realiza
    %el proceso necesario para generar los vectores de 9 elementos
    
    IMAGEN = imread(imagen_prueba);
    
    %SI SE DESEA HACER LA COMPARACION CON LOS VECTORES DE HSV+SOBEL
    %SE DEBE DESCOMENTAR LA SIGUIENTE LINEA
    IMAGEN = rgb2hsv(IMAGEN);

    %PRIMERO ES NECESARIO REDUCIR LA IMAGEN 
    IMAGEN_RED = reducir_imagen(IMAGEN);
        
    %SE OBTIENEN LAS MATRICES SOBEL DE LA IMAGEN REDUCIDA
    S_H = get_sob_hor(IMAGEN_RED);
    S_V = get_sob_ver(IMAGEN_RED);
        
    %CON LAS TRES IMAGENES, REDUCIDA, SOBEL_H Y SOBEL_V SE OBTIENEN
    %LOS VECTORES DE 9 ELEMENTOS DE CADA PIXEL Y SE ALMACENAN
    vect_sobel = get_sobel_vect(IMAGEN_RED,S_H,S_V);

    %====================================================================
    texto = strcat("SE HAN OBTENIDO LOS DATOS DE LA IMAGEN: ",...
        lista_names_imgs(x),"\n");
    fprintf(texto);
    %Se obtiene el mini-cuantizador de cada imagen individual, asi no 
    %se comparan los cientos de miles de pixeles de cada imagen
    %sino sus vectores representativos
    [idx,cent_rgb_prueba] = kmeans(vect_sobel,32);
    idx2Region = kmeans(vect_sobel,32,'MaxIter',1000,'Start',cent_rgb_prueba);
    %Se obtiene el vector de distancias acumuladas de la imagen actual
    %con respecto a los 10 cuantizadores
    % Comparacion de la imagen probada contra los cuantizadores
    table_dist{x,1} = comparacion_vector(cent_rgb_prueba,cuant_1);
    table_dist{x,2} = comparacion_vector(cent_rgb_prueba,cuant_2);
    table_dist{x,3} = comparacion_vector(cent_rgb_prueba,cuant_3);
    table_dist{x,4} = comparacion_vector(cent_rgb_prueba,cuant_4);
    table_dist{x,5} = comparacion_vector(cent_rgb_prueba,cuant_5);
    table_dist{x,6} = comparacion_vector(cent_rgb_prueba,cuant_6);
    table_dist{x,7} = comparacion_vector(cent_rgb_prueba,cuant_7);
    table_dist{x,8} = comparacion_vector(cent_rgb_prueba,cuant_8);
    table_dist{x,9} = comparacion_vector(cent_rgb_prueba,cuant_9);
    table_dist{x,10} = comparacion_vector(cent_rgb_prueba,cuant_10);
    %array_dist(x,:) = dist_min(:);
end

%% SE GUARDAN LOS DATOS DEL ARREGLO DE DISTANCIAS EN UN ARCHIVO
%de texto para no tener que recalcular estos valores
ruta = 'RESULT_FILES_HSV_SOBEL\HSV_SOBEL_DIST_';
name_file = 'RED_MUG';
ext_file = '_TABLE.txt';
file_full = strcat(ruta,name_file,ext_file);
writetable(table_dist,file_full,'Delimiter','tab');

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

%Funcion: get_sobel_vect, recibe la imagen(IMG), la imagen con el filtro
%Sobel Horizontal aplicado (SOB_H) y la imagen con el filtro
%Sobel Vertical aplicado (SOB_V), devuelve una matriz que contiene los
%vectores de 9 elementos concatenando los datos de cada pixel
function vector_sobel = get_sobel_vect(IMG,SOB_H,SOB_V)
    %Obtencion de la dimension de la imagen
    vect_size = size(IMG);
    size_y = vect_size(1);
    size_x = vect_size(2);
    dimension = size_y*size_x;
    %fprintf("EL ALTO DE LA IMAGEN ES DE: %d\n",size_y);
    %fprintf("EL ANCHO DE LA IMAGEN ES DE: %d\n",size_x);
    %fprintf("TAMAÑO DEL VECTOR RGB: %d\n",dimension);
    %Ciclo para obtener un solo vector de 9 dimensiones a partir de la imagen
    %Se inicializa un vector de 0's de tamaño: dimension x 9
    vector_sobel = zeros(dimension,9);
    %Variable que recorre los elementos de vect_rgb
    index = 1;
    for i = 1:size_y
        for j = 1:size_x
            %Se obtiene el valor R o H del pixel IMG(i,j)
            vector_sobel(index,1) = IMG(i,j,1);
            %Se obtiene el valor G o S del pixel IMG(i,j)
            vector_sobel(index,2) = IMG(i,j,2);
            %Se obtiene el valor B o V del pixel IMG(i,j)
            vector_sobel(index,3) = IMG(i,j,3);
            %Se obtienen los valores del filtro Sobel del pixel SOB_H(i,j)
            vector_sobel(index,4) = SOB_H(i,j,1);
            vector_sobel(index,5) = SOB_H(i,j,2);
            vector_sobel(index,6) = SOB_H(i,j,3);
            %Se obtienen los valores del filtro Sobel del pixel SOB_V(i,j)
            vector_sobel(index,7) = SOB_V(i,j,1);
            vector_sobel(index,8) = SOB_V(i,j,2);
            vector_sobel(index,9) = SOB_V(i,j,3);
            %Se incrementa el indice del arreglo de vectores
            index = index+1;
        end
    end
end 

%Funcion: get_sob_hor. Recibe una imagen de MxNx3 en 
%formato RGB o HSV aplica el filtro de Sobel Horizontal, devuelve 
%la imagen con el filtro Sobel horizontal aplicado a ella.
function sobel_H = get_sob_hor(IMG)
    %Paso de la imagen de RGB uint8 a double
    IMG = double(IMG);
    %Se obtienen los tres canales de la imagen
    IMG_R = IMG(:,:,1);
    IMG_G = IMG(:,:,2);
    IMG_B = IMG(:,:,3);

    %Obtencion del Sobel Horizontal
    h = [-1,-2,-1;0,0,0;1,2,1];
    H_R = conv2(IMG_R,h);
    H_G = conv2(IMG_G,h);
    H_B = conv2(IMG_B,h);
    H_JOIN = [];
    H_JOIN(:,:,1) = H_R;
    H_JOIN(:,:,2) = H_G;
    H_JOIN(:,:,3) = H_B;
    sobel_H = H_JOIN;
end

%Funcion: get_sob_ver. Recibe una imagen de MxNx3 en 
%formato RGB o HSV aplica el filtro de Sobel Vertical, devuelve 
%la imagen con el filtro Sobel vertical aplicado a ella.
function sobel_V = get_sob_ver(IMG)
    %Paso de la imagen de RGB uint8 a double
    IMG = double(IMG);
    %Se obtienen los tres canales de la imagen
    IMG_R = IMG(:,:,1);
    IMG_G = IMG(:,:,2);
    IMG_B = IMG(:,:,3);
    
    %Obtencion del Sobel Vertical
    v = [-1,0,1;0-2,0,0;-1,1,1];
    V_R = conv2(IMG_R,v);
    V_G = conv2(IMG_G,v);
    V_B = conv2(IMG_B,v);
    V_JOIN = [];
    V_JOIN(:,:,1) = V_R;
    V_JOIN(:,:,2) = V_G;
    V_JOIN(:,:,3) = V_B;
    sobel_V = V_JOIN;
end

% FUNCIONES EMPLEADAS PARA LA REDUCCION DE UNA IMAGEN RECIBIDA
function IMG_H = reducir_imagen(IMG_F)
    %Tamaño de la imagen recibida
    full_size = size(IMG_F);
    %Imagen nueva que contendra a los datos de la imagen reducida
    IMG_H = zeros(1,1,3);
    i = 1;
    %Se realiza la toma de cada 2 pixeles, saltando un renglon
    for y = 1:2:full_size(1)-1
        j = 1;
        for x = 1:2:full_size(2)-1
            IMG_H(i,j,1:3) = IMG_F(y,x,1:3);
            j = j+1;
        end
        i = i+1;    
    end
end