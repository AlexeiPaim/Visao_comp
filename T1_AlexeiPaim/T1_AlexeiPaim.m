%%Trabalho 1 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
clear
clc
close all

img_arqv = dir();

for c= 5:1:12 %intervalo das imagens na pasta
    
        ax = img_arqv(c).name; %Atribui o nome do arquivo a uma varialvel auxiliar  

        I = imread(ax);% Realiza a leitura da imagem correspondente     
        
        fprintf(ax)
        fprintf(': \n')

        % Função que gaz o reconhecimeto dos pontos verdes e os ordena para a
        % homografia 
        [u,v] = f_pon_verde_ord(I,[120,180,106],0.1);

        % Cordenadas para Homografia
        u2 =[30;800;800;30];
        v2 = [25;25;340;340];

%         Função que realiza a homografia
       [I]=f_homografia(I,u,v,u2,v2);

       
  
        [ue,ve] = f_pon_verde_ord(I,[120,180,106],0.1);

        %Pontos para cortar a imagem 
        cor_maxu = round(max(ue));
        cor_minu = round(min(ue));
        cor_maxv = round(max(ve));
        cor_minv = round(min(ve));

        % corta a imagem passada pela homografia 
        I = I(cor_minv:cor_maxv,cor_minu:cor_maxu);

%     figure; imshow(I);
%          title('Imagem Cortada ');

        % Limiariza a imagem cortada
         L = 150; %limair 
         I = I < L ;

        %  Limpa as bordas brancas da imagem limiarizada
         I = imclearborder(I);
%        figure; imshow(I);
%        title('Limiarização e limpeza de borda ');

        %segmenta a imagem em linhas 
        [Linha,N,~] = f_seggmen(I,10,40); 

        for y = 1:1:N % Laço para segmentar as palavras de cada linha 
            
             Ix = cell2mat((Linha(1,y)));%transformado tipo cell para uint 8
             
             % segementa em palavras as linhas encontradas
             [Temp,N,] = f_seggmen(Ix,10,15); 
             
             pala{1,y} = Temp;% Salva cada palavra em uma posição
        end
        % I9 = pala{1,1}{1,1};
        % figure; imshow(I9)
        % title('1sdfghjkl')

        [~,b] =size(pala);% Tamanho da struct pala

        yy=1;

        for y = 1:1:b % Laço para segmentar  letra

            fprintf('\n')

            [Tr,TT] = size(pala{1,y});% Tamanho da poisção y da struct pala


             for m = 1:TT
                        %transformado tipo cell para uint 8
                        % pega a posição especifica da struct pala
                     Ix = pala{1,y}{1,m};

                     [Teletr,N,IO] = f_seggmen(Ix,1,1);% segmenta letra

                    [~,sx] = size(Teletr); %Tamanho da estruct que guarda as letras 

                    for e = 1:sx %Laço para pegar cada letra salava na struct Teletr

                      Iv = cell2mat(Teletr(1,e)) ;
                        
                      % função que redimensiona a o segmento encontrado, realiza as comparaçoes entre as letra do template 
                       % e printa a letra com a maior similaridade
                      [~]= f_trat_comp_print(Iv);

                    end
                    fprintf(' ') %espaço entre as palavras
             end

       end
        fprintf('\n\n')% pula linha para o loop de mais uma imagem
end

%% funçoes



function [h] = f_trat_comp_print(Ix)

[u6,v6] = size(Ix);

% Redimensiona a imagem usando homografia
v = [0; 0; u6; u6]; 
u = [0; v6; v6; 0] ;

v2 = [0; 0; 50; 50] ;
u2 = [0; 50; 50; 0] ;

[I10]=f_homografia(Ix,u,v,u2,v2);
 
Ic = zeros(50,51);
[u7,v7] = size(I10);

Ic(1:u7,1:v7)= I10;

% figure; imshow(I10)

h = 25;
aux =0;
%Comparação

% Busca as Letras do template
[comp] = f_templates_letras(0.5);

        for w = 1:h

             Ix2= comp{1,w};

            [ux,vy]=size(Ix2);
            x=0;
            x1=0;
            x2=0;

            for k = 1:vy
                for i = 1:ux

                    som = Ix2(i,k) * Ic(i,k);
                    x = x+som;

                    som1 = (Ix2(i,k))^2;
                    x1 = x1 +som1;

                    som2 = (Ic(i,k))^2;
                    x2 = x2+ som2;

                end
            end
            %calcula a similaridade usando NC

             mult =double(x1*x2);

             x =double(x);

             S = x/(sqrt(mult));

             if S > aux             
                 aux = S;   
                 impr = string(comp(2,w));
             end
       
        end  
%    Imprime a letra 
       fprintf(impr);
         aux = 0;
end

function [vc1,uc1] = f_ctod(Ix)
%% função que atraves dos momentos de imagem, calcula o centroide 
% centroide
m00 = f_mpq(Ix,0,0);
m10 = f_mpq(Ix,1,0);
m01 = f_mpq(Ix,0,1);


vc1 = m01/m00;
uc1 = m10/m00;
end

% CAlcular o perimetro e a circularidade
% Para assim saber qual dos quatro segemtos é o quadrado
function circu = f_per_circ(Ts)

[u,v] = f_pixels_of_edge(Ts);

N = numel(u);
perimetro = sqrt((u(N)-u(1))^2 + (v(N)-v(1))^2);

    for k =1:N-1
        distan = sqrt((u(k)-u(k+1))^2 + (v(k)-v(k+1))^2);
        perimetro = perimetro + distan;
    end

%% circularidade 
m00 = mpq(Ts,0,0);
circu = 4*pi*m00/(perimetro^2);

end


function[u,v]= f_pon_verde_ord(I,Vrgb,L)

% Is=f_seg_cor(I,[120,180,106],0.1); % realiza a segmentação baseada em cor

I = im2double(I);% converte para o tipo Double

conve = 0.00392166; % constante de coversão 

% Valor da cor nas camadas
rf = Vrgb(1,1)*conve;
gf = Vrgb(1,2)*conve;
bf = Vrgb(1,3)*conve;


R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

D = sqrt((R-rf).^2 + (G-gf).^2 + (B-bf).^2);

 %limiarizaçao 	
M = D < L;
%   figure; imshow(M);

[imLabel,N] = bwlabel(M);

%  figure; imshow(imLabel/N);
% 
% colormap jet;

% Salva cada um dos regioes encontrados em uma variavel
I1= (imLabel == 1); 
I2=(imLabel == 2); 
I3=(imLabel == 3); 
I4=(imLabel == 4);


% subplot(2,2,1);imshow(I1);
% subplot(2,2,2);imshow(I2);
% subplot(2,2,3);imshow(I3);
% subplot(2,2,4);imshow(I4);

qd = zeros(1,4);
%calcula as circularidades e insere em um vetor 
qd(1,1) = f_per_circ(I1);
qd(1,2) = f_per_circ(I2);
qd(1,3) = f_per_circ(I3);
qd(1,4) = f_per_circ(I4);    
    
[~,yi] = min(qd); % Pega o menor valor, referente ao quadrado

Ix=(imLabel == yi); 
[ctr_u,ctr_v] = f_ctod(Ix);% centroide do quadradro

% Ordenação dos pontos da homografia
if yi ==1
    [ux2,uy2]= f_ctod(I2);
    [ux3,uy3]= f_ctod(I3);
    [ux4,uy4]= f_ctod(I4);
    %ponto 2
     if ux2 < ux3 && ux2 < ux4
         pu2 = ux2; pv2 = uy2;
     end
    if ux3 < ux2 && ux3 < ux4
          pu2 = ux3; pv2 = uy3;
    end 
     if ux4 < ux2 && ux4 < ux3
         pu2 = ux4; pv2 = uy4;
     end
     %ponto 4
     if ux2 > ctr_u && uy2 < pv2
         pu4 = ux2; pv4 = uy2;
     end
    if uy3 < ctr_u && uy3 < pv2
          pu4 = ux3; pv4 = uy3;
    end 
     if uy4 < ctr_u && uy4 < pv2
         pu4 = ux4; pv4 = uy4;
     end
      %ponto 3
    if uy2 > ctr_u &&  ux2 > pv4 || uy2 > pv2
         pu3 = ux2; pv3 = uy2;
    end  
    if uy3 > ctr_u &&  ux3 > pv4 || uy3 > pv2
         pu3 = ux3; pv3 = uy3;
     end  
    if uy4 > ctr_u &&  ux4 > pv4|| uy4 > pv2
         pu3 = ux4; pv3 = uy4;
    end 
end

if yi ==2
        [ux1,uy1]= f_ctod(I1);
        [ux3,uy3]= f_ctod(I3);
        [ux4,uy4]= f_ctod(I4);
        %ponto 2
        if ux1 < ux3 && ux1 < ux4
             pu2 = ux1; pv2 = uy1;
        end

        if ux3 < ux1 && ux3 < ux4
              pu2 = ux3; pv2 = uy3;
        end

         if ux4 < ux3 && ux4 < ux1
             pu2 = ux4; pv2 = uy4;
         end
         %ponto 4
        if uy1 < uy3 && uy1 < uy4
             pu4 = ux1; pv4 = uy1;
        end

        if uy3 < uy1 && uy3 < uy4
              pu4 = ux3; pv4 = uy3;
        end

        if uy4 < uy3 && uy4 < uy1
             pu4 = ux4; pv4 = uy4;
        end

         %ponto 3
        if uy1 > pu2 &&  ux1 > pv4
             pu3 = ux1; pv3 = uy1;
        end  
        if uy3 > pu2 &&  ux3 > pv4
             pu3 = ux3; pv3 = uy3;
        end  
        if uy4 > pu2 &&  ux4 > pv4
             pu3 = ux4; pv3 = uy4;
        end
end

if yi ==3
        [ux1,uy1]= f_ctod(I1);
        [ux2,uy2]= f_ctod(I2);
        [ux4,uy4]= f_ctod(I4);
        %ponto 2
        if ux1 < ux2 && ux1 < ux4
             pu2 = ux1; pv2 = uy1;
        end

        if ux2 < ux1 && ux2 < ux4
              pu2 = ux2; pv2 = uy2;
        end

         if ux4 < ux2 && ux4 < ux1
             pu2 = ux4; pv2 = uy4;
         end
         %ponto 4
        if uy1 < uy2 && uy1 < uy4
             pu4 = ux1; pv4 = uy1;
        end

        if uy2 < uy1 && uy2 < uy4
              pu4 = ux2; pv4 = uy2;
        end

         if uy4 < uy2 && uy4 < uy1
             pu4 = ux4; pv4 = uy4;
         end
         %ponto 3
        if uy1 > pu2 &&  ux1 > pv4
             pu3 = ux1; pv3 = uy1;
        end
        if uy2 > pu2 &&  ux2 > pv4
             pu3 = ux2; pv3 = uy2;
        end
        if uy4 > pu2 &&  ux4 > pv4
             pu3 = ux4; pv3 = uy4;

        end
end

if yi ==3
        [ux1,uy1]= f_ctod(I1);
        [ux2,uy2]= f_ctod(I2);
        [ux3,uy3]= f_ctod(I3);
        %ponto 2
        if ux1 < ux2 && ux1 < ux3
             pu2 = ux1; pv2 = uy1;
        end
        if ux2 < ux1 && ux2 < ux3
              pu2 = ux2; pv2 = uy2;
        end
         if ux3 < ux2 && ux3 < ux1
             pu2 = ux3;  pv2 = uy3;
         end

         %ponto 4
        if uy1 < uy2 && uy1 < uy3
             pu4 = ux1; pv4 = uy1;
        end
        if uy2 < uy1 && uy2 < uy3
              pu4 = ux2; pv4 = uy2;
        end
         if uy3 < uy2 && uy3 < uy1
             pu4 = ux3;  pv4 = uy3;
         end
         %ponto 3
        if uy1 > pu2 &&  ux1 > pv4
             pu3 = ux1; pv3 = uy1;
        end  
        if uy2 > pu2 &&  ux2 > pv4
             pu3 = ux2; pv3 = uy2;
        end
        if uy3 > pu2 &&  ux3 > pv4
             pu3 = ux3; pv3 = uy3;
        end
end

% Retorna os pontos de forma ordenada para a homografia 
v = [ctr_u; pu2;pu3;pu4];
u = [ctr_v; pv2;pv3;pv4];

end