clear 
clc


I = [ 0 0 0 0 0 0 0 0 0 0 ;
      0 0 0 0 1 1 0 0 0 0 ;
      0 0 0 1 1 1 1 0 0 0 ;
      0 0 0 1 1 1 1 1 0 0 ;
      0 0 0 0 0 1 1 0 0 0 ;
      0 0 0 0 0 0 0 0 0 0 ];
  
  % u linha
  %v coluna
  
%  [u,v] = find(I)


[x,y] = size(I);
h=1;

for k = 1:x
    for i = 1:y  
    if I(k,i)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
       flag = 1;
       break;
    end 
    end
  if flag ==1
          break;
  end
end


I(u,v-1)


    if I(u+1,v)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
    end
       
      if I(u+1,v-1)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
      end
    
      if I(u+1,v)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
      end
    
       if I(u+1,v+1)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
       end

    if I(u,v+1)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
    end
    
    if I(u-1,v+1)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
    end
    
    if I(u_1,v)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
    end
    
      if I(u_1,v-1)== 1 
        u(h,1) = k;
        v(h,1) = i;
        h=h+1;
        break;
    end












