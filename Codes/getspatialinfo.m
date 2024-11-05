function info = getspatialinfo(pfield)
%GETSPATIALINFO Spatial Information
%   info = GETSPATIALINFO(pfield) 
%   
%   Input:
%       pfield(mat) - 
%   Output:
%       info(num) - information score
% 
%   Notes: Based on my derivation the Skaggs definition of spatial
%   information is KL distance between a map between uniform
%   distribution
% 
%   See also 
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2012-10-05.

% $$$ % unoccupied pixels are nan;
% $$$ pfield(isnan(pfield)) = [];
% $$$ pfield = pfield/sum(pfield(:));            % make it a distribution
% $$$ udistribution = ones(size(pfield))/length(pfield);
% $$$ info = pfield .* log2(pfield./udistribution);
% $$$ info = info(:);
% $$$ info(isinf(info)) = [];                 % get rid of inf caused by log2(0)
% $$$ info(isnan(info)) = [];
% $$$ info = sum(info);
% $$$ 
% $$$ 
% $$$ return;
% $$$ 
% $$$ pfield = pfield(:);
% $$$ 
% $$$ info = 0;
% $$$ if max(max(pfield))>=0
% $$$     rocc = pfield(pfield>=0); %firing rates in occupied pixels
% $$$     p_i = 1/length(rocc) %when each pixel assigned equal occupancy probability, 1/npixels is the occupancy probabilty for each pixel. sac /16/10 renamed variable from pi to p_i too remove confusion with pi ~= 3.14
% $$$     meanrate = mean(rocc) %since each pixel is to be assigned eqal occupancy, mean rate is mean of firing rates in all pixels
% $$$     for i = 1:length(rocc)
% $$$         if rocc(i) > 0.0001 %this threshold is used in Jim's program & oiginal Skaggs c program- you need to avoid pixels with rates = 0, since log(0) is undefined, but using 0.0001 as threshold instead of > 0 doesn't really hurt the info score significantly
% $$$             info = info + (p_i*(rocc(i)/meanrate)*log2(rocc(i)/meanrate));
% $$$         end
% $$$     end
% $$$ end
% $$$ info
% get meanrate
% pfield = pfield(:);
pfield = pfield(pfield >= 0);
m_rate = mean(pfield);
p_i = 1/length(pfield);
idx = pfield > 0.0001;
info = sum(p_i*(pfield(idx)/m_rate) .* log2(pfield(idx)/m_rate));