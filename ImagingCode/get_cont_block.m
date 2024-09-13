function segidx = get_cont_block(idx, threshlen, idxlevel)
%GET_CONT_BLOCK Eliminate the discontinuous block
%   SEGIDX = GET_CONT_BLOCK(idx, threshlen,idxlevel)  >=
%   
%   Input:
%       idx(vec) - idx, not logical
%       threshlen(num) - 
%       idxlevel(str) - ['same'], 'higher'
%   Output:
%       segidx(mat) - n x 2 
% 
%   Notes: segidx are the same level of index as idx by default
%       scenario: you have constinuous trace, you want to find the
%       continous segement that is larger than a threshold, then
%       this is the function to use. the threshlen is 
%       [1 2 3    7 8 9   20 21 22], if the threshlen is set to 3
%       then the segidx will have three segments
% 
%   See also 
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2011-07-21.

if isa(idx, 'logical')
    idx = find(idx);
end

if ~issorted(idx)
    error('This is not sorted');
end
if islogical(idx)
    idx = find(idx);
end
idx = idx(:);
if ~varexist('idxlevel')
    idxlevel = 'same';
end
% ============================================================
sep = [0; find(diff(idx) > 1); length(idx)];% NaN gap >1
st_idx = sep(1:end-1)+1;
end_idx = sep(2:end);
jj = find(diff(sep) >= threshlen);
segidx = zeros(length(jj), 2);
if strcmp(idxlevel, 'same')
    for i = 1:length(jj)
        segidx(i, 1) = idx(st_idx(jj(i)));
        segidx(i, 2) = idx(end_idx(jj(i)));
    end
elseif strcmp(idxlevel, 'higher');
    for i = 1:length(jj)
        segidx(i, 1) = st_idx(jj(i));
        segidx(i, 2) = end_idx(jj(i));
    end
end

return;
