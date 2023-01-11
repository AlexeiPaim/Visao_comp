
% Laboratorio 4 da Disciplina de Visao Computacional para Robotica
% Aléxei Felipe Paim
% 20250264
% Função de obtenção da imagem de disparidade 
% [Is] = f_disparidade(I1,I2,dmin,dmax,wind)
% Retorna a imagem de disparidade
% I1=imagen esquerda
% I2=imagen direita
% dmin = ditsnacia minima de percurso
% dmin = ditsnacia maxima de percurso
% wind = tamanho da janela de comparação( tamanho completo/ valor Impar)

function [Is] = f_disparidade(I1,I2,dmin,dmax,wind)

jan =  floor(wind/2);
meio = round(wind/2);

[u,v] = size(I1);

Is = NaN(u,v);  

%inicia as comparaçoes no canto superior direito

for i = meio:1:u-jan % percorre linhas
   
    for k = v-jan:-1:meio % percorre colunas

     max = 0; % Inicia variavel
    
     Il = I1(i-jan:i+jan,k-jan:k+jan);% imagem de janela Imegem esquerda 

  
        if k < (meio+dmax) % condicional para percorrer a imagem ao todo, variando o percurso de comparação  
            
        
            limf = k- meio ; %Auxililar para tamanho do percurso 
            
            
                 for l = dmin:1:limf %  Percurso dmin dmax para a borda direita
            
                            Id =I2(i-jan:i+jan,k-jan-l:k+jan-l);% imagem de janela Imegem direita

                            comp = ZNCC(Il, Id); % Calculo da similaridade ZNCC

                           if comp > max %salva o maior valor obtidoo

                               Is(i,k) = (l+dmin); % Na matriz de saida imprime o valor de disparidade 
                               max = comp;

                           end      

                 end

        else %caso contrario para o concional, atende quase aiagem toda
            
                 for l = dmin:1:dmax %  Percurso dmin dmax para maior parte da imagem  

                        Id =I2(i-jan:i+jan,k-jan-l:k+jan-l);% imagem de janela Imegem direita


                        comp =ZNCC(Il, Id);% chama a função que calcula o similaridade por ZNCC

                        if comp > max %salva o maior valor obtidoo

                                Is(i,k) = (l+dmin);% Na matriz de saida imprime o valor de disparidade 

                                 max = comp;

                        end
                       
                 end
                 
        end

    end

end

        % Função que calcula a disparidade por ZNCC
        function [ret] = ZNCC(IL, ID)

            IL = IL - mean(IL(:));% Subtrai a media   
            ID = ID - mean(ID(:));% Subtrai a media

            denom = sqrt( sum(sum(IL.^2))*sum(sum(ID.^2)) );

                if denom < 1e-10 % otmização 
                    ret = 0;
                else
                ret = sum(sum((IL.*ID))) / denom;
                end
        end
end