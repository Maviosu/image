function [sZ,timeidx, n] = getspkloc(spk, Z, inc, thresh, isall)
%GETSPKLOC Get the behavioral correlate of spk
%   [sZ, timeidx, n] = GETSPKLOC(spk, Z)
%
%   Input:
%       spk(cvec) - spk times
%       Z(nx3 or nx2 or nx4) - the first column is T;
%       n(vec) - spk count
%   Output:
%       sZ() - see Z, sZ is sorted, ascending order
%       timeidx(vec) - timeidx is sorted. idx of the first dimension
%
%   Notes: T denotes start and end of the behavioral correlate;
%   The algorithm based on histc has the problem that it tend to
%   count whatever in between two timestamps, even this physical
%   adjacency means nothing. So I change to the counting
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2012-08-21.
%   by Cheng Wang (cwchengwang@gmail.com), 2012-12-27. changed to
%   CountInIntervals

% $$$ n = histc(spk, Z(:, 1));
% $$$ nidx = find(n); nvalue = n(nidx);
% $$$ sZ = [];
% $$$ tmp = max(nvalue);
% $$$ for i = 1:tmp
% $$$     idx = nidx(nvalue>=i);
% $$$     sZ = [sZ; Z(idx, :)];
% $$$ end


% get a good increment. most of the increment has to be the
% immediate next timestamp, for those that are unreasonablely big,
% substiute with median value;
if ~exist('inc', 'var') || isempty(inc)
    inc = nanmedian(diff(Z(:,1)));
end
if ~exist('thresh', 'var') || isempty(thresh)
    thresh = 2;
end
if exist('isall', 'var')
    if isall
        thresh = ceil(max(diff(Z(:,1)))/inc);
    end
end


Zup = [Z(2:end,1); Z(end,1)+inc];
idx = (Zup-Z(:,1)) > thresh*inc;           % larger than thresh median
Zup(idx) = Z(idx,1)+inc;

% modified zugaro's countinintervals mex file to make the criterion
% <= x <
n = countinintervals(spk, [Z(:,1), Zup]);
nidx = find(n); nvalue = n(nidx);
sZ = []; timeidx = [];
tmp = max(nvalue);
for i = 1:tmp
    idx = nidx(nvalue>=i);
    sZ = [sZ; Z(idx, :)];
    timeidx = [timeidx; idx];
end 

% changed here 05/10/2013
% make it ascending order
if ~isempty(sZ)
    [~, idx] = sort(sZ(:,1));
    sZ = sZ(idx, :);
    timeidx = timeidx(idx);
end

return;
