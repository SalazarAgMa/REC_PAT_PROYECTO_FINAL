%% APERTURA DEL ARCHIVO QUE CONTIENE LOS VECTORES
%RGB, HSV, RGB+SOBEL O HSV+SOBEL

clear all;
clc;
ruta = 'CENT_HSV\CENTROIDES_';
ext = '_VECT_HSV.txt';
lista_names = ["APPLE_JUICE","BLUE_BOWL","BLUE_LEGO","BLUE_MUG"...
    "BLUE_SPOON","CHOCOLATE_COOKIES","ORANGE_JUICE","ORANGE_KNIFE"...
    "RED_LEGO","RED_MUG"];

%% INICIALIZACION DE LAS MATRICES DE VECTORES Y DE TARGETS
vect_inputs = [];
vect_target = []; 
arreglo_size = {};
%% PARA CADA UNO DE LOS ARCHIVOS SE TOMARA EL CONJUNTO DE VECTORES QUE TIENE
%ESTOS SE EMPLEARAN PARA GENERAR EL VECTOR DE TARGETS ASOCIADO A CADA
%TIPO DE IMAGEN Y DESPUES SE UNIRAN AL VECTOR DE TARGETS GLOBAL

for y = 1:length(lista_names)
    %Nombre del archivo que se leera
    full_file = strcat(ruta,lista_names(y),ext);
    %Los vectores leidos contienen el conjunto de vectores
    %generados de 15 imagenes y fueron obtenidos en la seccion
    %anterior del proyecto
    vect_img = readmatrix(full_file);
    %Los datos recibidos se deben transponer para su uso como
    %INPUT de la red neuronal
    vect_img = vect_img';
    
    %GENERACION DE LA MATRIZ DE TARGETS
    %Tamaño de los datos transpuestos para la generacion del vector
    %de TARGET
    size_vect = size(vect_img);
    size_vect_1 = size_vect(1);
    size_vect_2 = size_vect(2);
    arreglo_size{y} = size_vect;
    %Se genera el vector de TARGETS de tamaño size_vect_1 x size_vect_2
    %cuyos elementos seran las salidas en binario de cada imagen
    %Para la imagen 1 la salida de las 10 neuronas sera  [0 0 0 0 0 0 .. 0 1]
    %Para la imagen 2 la salida de las 10 neuronas sera  [0 0 0 0 0 0 .. 1 0]
    %Para la imagen 10 la salida de las 10 neuronas sera [1 0 0 0 0 0 .. 0 0]
    %target_img = zeros(10,size_vect_2);
    %Se inicializa la cadena binaria que representa la salida deseada
    target_img = [0;0;0;0;0;0;0;0;0;0];
    %val_bin = dec2bin(y,4);
    %for x = 1:4
    %    vect_salida(x) = str2num(val_bin(x));
    %end
    %Se asigna a todos los vectores target asociados a esta imagen el
    %valor esperado en binario
    %target_img(1,:) = vect_salida(1);
    %target_img(2,:) = vect_salida(2);
    %target_img(3,:) = vect_salida(3);
    %target_img(4,:) = vect_salida(4);
    target_img(y,1:size_vect_2) = 1;
    %Se concatenan los INPUTS y TARGETS
    vect_inputs = [vect_inputs vect_img];
    vect_target = [vect_target target_img];
end

%% ENTRENAMIENTO DE LA RED NEURONAL EMPLEANDO PATTERNET
%SE TIENEN 3 NEURONAS DE ENTRADAS(RGB)
%SE TIENEN 5 NEURONAS EN LA CAPA OCULTA
%EL ENTRENAMIENTO SE LLEVA A CABO CON EL ALGORITMO DE BACKPROPAGATION
red = patternnet(8,'trainlm');
%Numero de epocas maximas
red.trainParam.epochs=(1000);
%Verifica minimos locales posibles
red.trainParam.max_fail = 1000;
%Error maximo permitido
red.trainParam.min_grad = 1e-29;
%Factor de aprendizaje para modificar los pesos iniciales
red.trainParam.mu = 0.1;
%Factor de aprendizaje decreciente
red.trainParam.mu_inc = 5;
%Cambiar la funcion de activacion de las neuronas de la capa 1
%red.layers{1}.transferFcn= 'tansig';
%Cambiar la funcion de activacion de las neuronas de la capa 2
%red.layers{2}.transferFcn= 'tansig';

%Creacion de la red neuronal empleando los vectores de valores de
%INPUTS y TARGETS
configure(red,vect_inputs,vect_target);
%Definicion del porcentaje de datos empleado para el entrenamiento,
%validacion y pruebas del modelo
red.divideParam.trainRatio = 90/100;
red.divideParam.valRatio = 5/100;
red.divideParam.testRatio = 5/100;

%Entrenamiento de la red neuronal
%tr: Variable con valores de performance del entrenamiento
[red,tr] = train(red,vect_inputs,vect_target);

%% Se guardan los vectores de INPUTS y TARGETS en dos archivos de TEXTO
%CUIDADO: Este proceso de escritura puede ser tardado o en el peor de los
%casos detener el funcionamiento de MATLAB
%ruta_file = 'NN_FILES_RGB\';
%name_file = 'INPUTS_RGB.txt';
%writematrix(vect_inputs,name_file);
%name_file = 'TARGETS_RGB.txt';
%writematrix(vect_target,name_file);
