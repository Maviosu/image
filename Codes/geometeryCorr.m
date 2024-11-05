function geometery_r = geometeryCorr(data,binlength)
    %input:
    %   data        -- data need to process
    %   binlength   -- data sorted in different bins, rotation angles each
    %   time
    binsize = 360/binlength;
    x = linspace(binsize,360,binlength);
    g = size(data,2);
    if g>1%check the formate of input data
        y = hist(data,x)';
    else
        y = hist(data,x)';
    end
    %--
    rotation_r  = zeros(binlength,1);
    geometery_r = zeros(binlength,1);
    for i = 1:binlength
        rate_data = zeros(binlength,1);
        rate_data((i+1):binlength) = y(1:(binlength-i));
        rate_data(1:i) = y((binlength-i+1):binlength);
        %r = corrcoef(y, rate_data);
        r = corr(y,rate_data,'Type','Pearson');
        rotation_r(i) = r;
    end

    geometery_r      = rotation_r;
  
    return


