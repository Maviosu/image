%dot product of the 
function dotProduct_r = dotproduct(data,binlength)


    binsize = 360/binlength;
    x = linspace(binsize, 360, binlength);
    g = size(data,1);
   if g>1%check the formate of input data
        y = hist(data,x)';
    else
        y = hist(data,x);
   end

    rotation_r  = zeros(binlength,1);
    dotProduct_r = zeros(binlength,1);
    for i = 1: binlength
        rotate_data = zeros(binlength,1);
        rotate_data((i+1):binlength) = y(1:(binlength-i));
        rotate_data(1:i) = y(((binlength-i+1):binlength));
        r = dot(y,rotate_data);
        rotation_r(i) = r;
    end

dotProduct_r  = rotation_r;
% close all;
% plot(x,dotProduct_r,'Color','#0366fc','LineWidth',2)
return