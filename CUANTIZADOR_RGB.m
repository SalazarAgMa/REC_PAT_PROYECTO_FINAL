%% APLICACION DEL ALGORITMO LBG PARA LAS IMAGENES DESEADAS

clc;
clear all;
nombre = 'RED_MUG_VECT.txt';    
%Obtencion de los vectores RGB de las imagenes desde el archivo
datos = readmatrix(nombre);
data = datos;
%Se etiquetan los vectores como una componente extra de los vectores
datos(:,4) = 0;

%% Se aplica el proceso de obtencion del cuantizador para el 
%archivo de vectores especificado en la seccion anterior
cuantizador = get_cuantizador(datos);

%% Se transforma el arreglo de centroides en una matriz para
%escribirla en el archivo que contiene los datos de los centroides
elem_cuantizador = [];
for x = 1:length(cuantizador)
    elem_cuantizador(x,1:3) = cuantizador{x}(1:3);
end
%Se almacenan los centroides en un archivo de texto para evitar
%realizar este proceso mas veces
file_salida = strcat('CENTROIDES\CENTROIDES_',nombre);
writematrix(elem_cuantizador,file_salida,'Delimiter','tab')
fprintf("SE HAN ESCRITO LOS CENTROIDES EN EL ARCHIVO\n");

%% FUNCIONES EMPLEADAS PARA LA OBTENCION DEL CUANTIZDOR RGB
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

%Funcion get_cuantizador:
%Recibe los vectores de correlacion para un conjunto de audios
%devuelve los coeficientes ai de los n centroides que definen los modelos
%de cuantizacion
function centroides_rgb = get_cuantizador(vect_tagged)
    %Se aplica el algoritmo LBG sobre los vectores RGB 
    %dimension 3 para la combinacion de los vectores de 15 
    %archivos de imagen de entrenamiento

    %Para cada centroide se almacenan solo los valores de RGB

    %Este arreglo es el principal de los centroides
    %Tiene 4 elementos, [R,G,B] + un tag
    centroides_rgb = {};

    %Calculo del primer centroide este se inicializa con 4 elementos
    %de RGB y un tag que permitira identificar a cada
    %centroide
    temp_cent = [0,0,0,1];
    %Se emplean las componentes j de cada vector i para el calculo de 
    %la componente j del primer centroide
    for i=1:length(vect_tagged)
        %El numero de componentes tomados de los vectores R,G y B
        for j=1:3
            temp_cent(j) = temp_cent(j) + vect_tagged(i,j);
        end
    end
    %Se divide cada componente entre el numero de vectores
    temp_cent(1:3)= temp_cent(1:3)/length(vect_tagged);
    %Se almacenan los valores RGB del primer centroide
    centroides_rgb{1} = temp_cent;
    fprintf("\nPRIMER CENTROIDE:\n");
    centroides_rgb{1}

    %Se declaran los epsilon que seran empleados
    epsilon_1 =[];
    epsilon_1(1:3) = 0.1;
    epsilon_1(4) = 0;
    epsilon_2 =[];
    epsilon_2(1:3) = -0.1;
    epsilon_2(4) = 0;

    %Variable empleada para determinar el numero de ciclos que generaran los
    %centroides, por ejemplo, para 8 centroides se necesitan 3 ciclos
    potencia_n = 3; 

    %Ciclo empleado para generar los n centroides
    for n = 1:potencia_n

        %Se declaran los valores de distancia global actual y anterior
        dist_global_act = 0;
        dist_global_ant = 100;
        iteraciones = 0;
        %A partir del conjunto de centroides se genera un nuevo conjunto
        %considerando los valores de epsilon
        centroides_rgb  = new_centroides(centroides_rgb,epsilon_1,epsilon_2);
        fprintf("\nSE HAN GENERADO LOS NUEVOS CENTROIDES\n");

        %Ciclo mediante el cual se estabilizaran los centroides
        %Se declara el valor de epsilon que se desea para estabilizar los
        %centroides
        %epsilon = 0.000000001;
        epsilon = 0.01;

        while(abs(dist_global_act-dist_global_ant)>= epsilon)


            %Se lleva a cabo el proceso de etiquetado de los vectores RGB
            %Para llevar a cabo la comparacion entre vectores y centroides se emplea
            %la distancia euclidiana entre los centroides comparados contra 
            %los valores RGB de cada vector
            vect_tagged = vect_tag(centroides_rgb,vect_tagged);
            %fprintf("\nSE HAN ETIQUETADO LOS VECTORES\n");

            %Se lleva a cabo el proceso de recalculo de los centroides empleando
            %los vectores etiquetados, se almacena un nuevo conjunto de valores
            %de correlacion para 
            centroides_rgb = rec_centroides(centroides_rgb,vect_tagged);
            %fprintf("\nSE HAN RECALCULADO LOS CENTROIDES\n");

            %fprintf("\nDISTANCIA GLOBAL ANTERIOR:%d\n",dist_global_ant);
            dist_global_ant = dist_global_act;
            %fprintf("\nDISTANCIA GLOBAL ANTERIOR NUEVA:%d\n",dist_global_ant);
            %Se calcula la distancia global con ayuda de los centroides y los
            %vectores
            %fprintf("\nDISTANCIA GLOBAL ACTUAL:%d\n",dist_global_act);
            %dist_global_act = dist_global_act+dist_min(centroides_rgb,vect_tagged);
            dist_global_act = dist_min(centroides_rgb,vect_tagged);
            %fprintf("\nDISTANCIA GLOBAL ACTUAL NUEVA:%d\n",dist_global_act);
            iteraciones = iteraciones + 1;

        end

        fprintf("\nSE HAN REALIZADO %d ITERACIONES\n",iteraciones);

    end

    fprintf("\n\nPARA LOS %d CENTROIDES DE LA IMAGEN:\n",length(centroides_rgb));
    fprintf("SE OBTUVIERON %d VECTORES DE COEFICIENTES\n",length(centroides_rgb));
    fprintf("CADA UNO CON %d VALORES\n\n",length(centroides_rgb{1}));
end

%FUNCIONES EMPLEADAS PARA LA APLICACION DEL ALGORITMO LBG ADAPTADAS
%PARA VECTORES DE TAMAÑOS DIFERENTES A 2

%Funcion new_centroides:
%Recibe un arreglo que contiene los vectores de los centroides
%junto con dos vectores que representan las epsilon
%Permite obtener un arreglo de centroides con el doble de centroides
%que el arreglo recibido
function array_new_cent = new_centroides(cent_actuales,epsilon_1,epsilon_2)
    %Se obtiene el numero de centroides
    n = length(cent_actuales);
    %Se inicializan las etiquetas a 0
    %La etiqueta es el 4to elemento del vector
    %for x = 1:n
    %    cent_actuales{x}(4) = 0;
    %end
    %Arreglo vacio que almacenara los nuevos centroides generados
    %Se inicializa con 0's para poder almacenarlos de forma sencilla
    %tambien se les agrega una etiqueta que representa el numero
    %de centroide
    for x = 1:2*n
        array_new_cent{x} = [0,0,0,x];
    end
    %Se calcula el siguiente par de centroides usando las epsilon
    fprintf("\nSE HAN RECIBIDO %d CENTROIDES\n",n);
    fprintf("SE CALCULARAN %d NUEVOS CENTROIDES",2*n);
    %Por cada centroide se crean dos centroides nuevos sumando epsilon_1
    %y epsilon_2 a cada centroide;
    for x = 1:n
        %fprintf("\nCENTROIDE\n");
        %Se obtiene el centroide actual con elementos [R,G,B]
        var_cent = cent_actuales{x};
        %fprintf("\nCENTROIDE + EPSILON 1\n");
        %Se le suma la primer epsilon
        var_cent_1 = var_cent + epsilon_1;
        %fprintf("\nCENTROIDE + EPSILON 2\n")
        %Se le suma la segunda epsilon
        var_cent_2 = var_cent + epsilon_2;
        array_new_cent{x} = array_new_cent{x}+var_cent_1;
        array_new_cent{x+n} = array_new_cent{x+n}+var_cent_2;
    end
end

function vectores_eti = vect_tag(cent_actuales,vect_tagged)
    %Se reciben los vectores etiquetados
    vectores_eti = vect_tagged;
    %Para cada vector se calculara la distancia con respecto a cada
    %centroide esto con el fin de etiquetarlos
    %Solo se consideran las primeras tres componentes de los vectores
    for j = 1:length(vect_tagged)
        %Se toma el vector j para llevar a cabo la comparacion con los 
        %vectores de los centroides 
        vector_probado = vect_tagged(j,1:3);
        %Se inicializa la distancia minima con respecto al primer centroide
        centroide = cent_actuales{1}(1:3);
        
        %Se emplea la distancia euclidiana para comparar los vectores
        dist_minima_vector = pdist2(vector_probado,centroide);
                        
        %Igualmente se inicializa la etiqueta que se le asignara al vector
        %tras las comparaciones
        tag_actual = 1; 
        %Ciclo para calcular la distancia de este vector al centroide k
        %Desde el segundo hasta el ultimo centroide
        for k = 2:length(cent_actuales)
            %Se toman las coordenadas del nuevo centroide
            centroide = cent_actuales{k}(1:3);
            %Se toma la distancia euclidiana
            dist_cent_actual =  pdist2(vector_probado,centroide);            
            
            %Si la distancia calculada con respecto al vector actual
            %es menor que la anterior se actualiza tanto la distancia
            %minima como la etiqueta para el vector
            if dist_cent_actual < dist_minima_vector
                dist_minima_vector = dist_cent_actual;
                %Se toma la etiqueta asociada al centroide
                tag_actual = k;
            end
        end
        %Se le asigna el tag_actual al vector dentro de v_n_s tagged
        vectores_eti(j,4)= tag_actual; 
    end
end

function centroid_recalc = rec_centroides(cent_actuales,vectores_tag)
    %Se inicializa un arreglo donde se llevara a cabo la suma de los
    %valores para cada centroide, se mantienen la etiqueta
    centroid_recalc = {};
    sum_cent = {};
    for x = 1:length(cent_actuales)
        %Se inicializan los nuevos centroides solo conservando la etiqueta
        centroid_recalc{x} = [0 0 0 x];
        %Se inicializan los valores para las sumas en 0, la ultima variable
        %lleva la cuenta de los vectores asociados a cada tag
        sum_cent{x} = [0 0 0 0];
    end
    %Mediante los vectores ya etiquetados se recalculan los centroides
    for y = 1:length(vectores_tag)
        %Se obtiene la etiqueta del vector actual
        tag_cent = vectores_tag(y,4);
        %A la celda tag_cent se le suman los valores de las componentes
        %de cada vector
        for j=1:3
            sum_cent{tag_cent}(j) = sum_cent{tag_cent}(j) + vectores_tag(y,j);
        end
        %Se incrementa el numero de vectores asociados al centroide
        sum_cent{tag_cent}(4) = sum_cent{tag_cent}(4) + 1;
    end
    %Se divide el total de la suma entre el numero de vectores asociados
    for k = 1:length(centroid_recalc)
        %Se obtiene el numero de vectores asociados al centroide
        num_vect = sum_cent{k}(4);
        %Se dividen los valores acumulados entre el numero de centroides
        val_new_cent = sum_cent{k}(1:3)/num_vect;
        %Se asigna al centroide los valores de sus componentes sin
        %modificar su etiqueta
        centroid_recalc{k}(1:3) = val_new_cent;
    end
end

function distancia_minima = dist_min(cent_actuales,vectores_tag) 
    %Para cada centroide se calcula la distancia minima de entre todos los
    %vectores que estan representados por el
    %Se declara un arreglo que almacenara la distancia minima respecto a
    %cada centroide,se declara una distancia minima de 100000 para realizar
    %la comparacion inicial
    distancias_minimas = [];
    for x = 1:length(cent_actuales)
        distancias_minimas(x) = 1000000;
    end
    %Para cada vector se calcula la distancia con respecto a su
    %centroide y se verifica si esta es menor que la anterior
    for y = 1:length(vectores_tag)
        %Se calcula la distancia de este vector con respecto a su
        %centroide empleando la etiqueta
        tag_vector = vectores_tag(y,4);
        %Se obtienen las coordenadas del centroide con ayuda del tag
        cent_coor = cent_actuales{tag_vector}(1:3);
        %Se obtienen las coordenadas del vector
        vect_coor = vectores_tag(y,1:3);
        dist_cent_actual = pdist2(vect_coor,cent_coor);
        %Se verifica si la distancia calculada es menor a la almacenada
        %para este centroide
        if dist_cent_actual < distancias_minimas(tag_vector)
            distancias_minimas(tag_vector)= dist_cent_actual;
        end
    end
    %Una vez que se han verificado todos los vectores se tiene un vector
    %que contiene las distancias minimas con respecto a cada centroide
    %Se realiza la comparacion de estos valores y se devuelve la minima
    %distancia
    distancia_minima = distancias_minimas(1);
    for x = 2:length(distancias_minimas)
        if distancias_minimas(x)<distancia_minima
            distancia_minima = distancias_minimas(x);
        end
    end
end
