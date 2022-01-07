%% MUESTRA DE FUNCIONAMIENTO DE LAS FUNCIONES DEL FILTRO DE SOBEL
ruta = 'OBJ_SEG\redLego\';
nombre = 'red_lego17BGR.jpg';
nombre_img = strcat(ruta,nombre);
IM = imread(nombre_img);

%Llamado a las funciones de obtencion del filtro de Sobel
sobel_H = get_sob_hor(nombre_img);
sobel_V = get_sob_ver(nombre_img);

%Se muestran las imagenes resultantes
figure;
imshow(IM);
title("IMAGEN ORIGINAL");
figure;
imshow(sobel_H);
title("SOBEL HORIZONTAL");
figure;
imshow(sobel_V);
title("SOBEL VERTICAL");

%% OBTENCION DE LOS ARREGLOS DE VECTORES DE 9 ELEMENTOS QUE CONCATENAN
%LOS VALORES RGB O HSV CON LOS VECTORES VALORES DEL FILTRO DE SOBEL

%El valor de entrada son los nombres de los 15 archivos que se concatenaran
%para el entrenamiento

%Limpieza
clear all;
clc;

%Obtencion de los vectores para las 15 imagenes
ruta = 'OBJ_SEG\redMug\';
extension = '.jpg';
%Lista de nombre de los archivos
names_img = ["red_mug116BGR"];

%VECTOR QUE ALMACENARA EL CONJUNTO DE LOS VECTORES DE DIMENSION 9
%DE LAS 15 IMAGENES

vect_unidos = [];

%Mediante un ciclo for se pasa el nombre del archivo y se realiza
%el proceso necesario para generar los vectores de 9 elementos
%Si se desea primero pasar las imagenes de RGB a HSV se debe descomentar
%la linea 57
for x = 1:length(names_img)
    str_img = strcat(ruta,names_img(x),extension);
    %LECTURA DE LA IMAGEN ORIGINAL
    IMAGEN = imread(str_img);
    
    %PASO DE LA IMAGEN DE RGB A HSV SI ES NECESARIO
    %IMAGEN = rgb2hsv(IMAGEN);
    
    figure;
    imshow(IMAGEN);
    title("IMAGEN ORIGINAL HSV");
    
    %PRIMERO ES NECESARIO REDUCIR LA IMAGEN
    IMAGEN_RED = reducir_imagen(IMAGEN);
    figure;
    imshow(IMAGEN_RED);
    title("IMAGEN REDUCIDA");
    
    %SE OBTIENEN LAS MATRICES SOBEL DE LA IMAGEN REDUCIDA
    S_H = get_sob_hor(IMAGEN_RED);
    figure;
    imshow(S_H);
    title("SOBEL HORIZONTAL");
    S_V = get_sob_ver(IMAGEN_RED);
    figure;
    imshow(S_V);
    title("SOBEL VERTICAL");
    
    %CON LAS TRES IMAGENES, REDUCIDA, SOBEL_H Y SOBEL_V SE OBTIENEN
    %LOS VECTORES DE 9 ELEMENTOS DE CADA PIXEL Y SE ALMACENAN
    vect_sobel = get_sobel_vect(IMAGEN_RED,S_H,S_V);

    %El resultado de vectores de la imagen actual se concatena con 
    %los resultados previos para conseguir los vectores de las 15
    %imagenes
    vect_unidos = [vect_unidos;vect_sobel];
end

%% PASO DE LOS VECTORES UNIDOS A ARCHIVOS DE TEXTO
ruta_files = 'VECT_SOBEL_HSV/';
ext_file = '_VECT_SOBEL.txt';
name_file = 'RED_MUG';
file_n = strcat(ruta_files,name_file,ext_file);
%Se escribe el archivo
writematrix(vect_unidos,file_n,'Delimiter','tab');

%% FUNCIONES EMPLEADAS PARA LA APLICACION DEL FILTRO DE SOBEL

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
    sobel_H = uint8(H_JOIN);
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
    sobel_V = uint8(V_JOIN);
end

% FUNCIONES EMPLEADAS PARA LA REDUCCION DE UNA IMAGEN RECIBIDA
function IMG_H = reducir_imagen(IMG_F)
    %Tamaño de la imagen recibida
    full_size = size(IMG_F);
    %Imagen nueva que contendra a los datos de la imagen reducida
    IMG_H = zeros(1,1,3,'uint8');
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