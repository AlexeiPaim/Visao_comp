
function [new_cols, new_rows] = f_interpolation(u,v,num)

x = 1:numel(u);
xi = linspace(1,numel(u),num);

new_rows = interp1(x,v,xi,'linear','extrap');
new_cols = interp1(x,u,xi,'linear','extrap');


