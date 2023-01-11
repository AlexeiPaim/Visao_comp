%%Trabalho 1 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% função de semgentação por cor
%seg_cor(I,Vrgb,L) 
% I = imagem a ser segmentada
% Vrgb = [ R, G, B]
% L valor do limiar em douuble

function M = f_seg_cor(I,Vrgb,L) 

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

end




