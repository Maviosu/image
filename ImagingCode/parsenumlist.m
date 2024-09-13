function numarray = parsenumlist(numlist)
%PARSENUMLIST 
%   NUMARRAY = PARSENUMLIST(numlist) 
%   
%   input:
%       NUMLIST(str) - string
%   Output:
%       NUMARRAY(vec) - vector
% 
%   Notes: 
% 
%   See also 
% 
%   by Cheng Wang (chengwang@ion.ac.cn), 2010-04-26.

[start_idx1, end_idx1] = regexp(numlist, '[0-9]*');
[start_idx2, end_idx2] = regexp(numlist, '[0-9]*\.[0-9]*');
% take out those in the range of 2
rm_idx = zeros(1,length(start_idx1));
for i = 1:length(start_idx1)
    if any(start_idx2 <= start_idx1(i) & end_idx2 >= ...
           end_idx1(i))
        rm_idx(i) = 1;
    end
end
rm_idx = logical(rm_idx);
start_idx1(rm_idx) = [];
end_idx1(rm_idx) = [];

start_idx = sort([start_idx1, start_idx2]);
end_idx = sort([end_idx1, end_idx2]);

numarray = zeros(length(start_idx), 1);
for i = 1:length(start_idx)
    tmp = str2double(numlist(start_idx(i):end_idx(i)));
    if start_idx(i) > 1 && strcmp(numlist(start_idx(i) - 1), '-')
        tmp = -tmp;
    end
    numarray(i) = tmp;
end


return;
