function [fname ftime] = sortdir(path2sort, nameclue, bytime, bynum)
%SORTDIR Sorted file list of a dir, can also sort by
%    time. 
%   [fname ftime] = SORTDIR(path2sort, nameclue, [bytime]) 
%   
%   Input:
%       PATH2SORT(str) - 
%       NAMECLUE(str) - e.x. '*.mat' 
%       BYTIME(bool) - true is sort by time
%       BYNUM(bool) - true, is by number in file name
%   Output:
%       FNAME(cell) - 
%       FTIME(cell) - 
% 
%   Notes: think about whether to use lower before sort
% 
%   See also 
% 
%   by Cheng Wang (chengwang@ion.ac.cn), 2010-06-01.

if ~exist('bytime', 'var')
    bytime = false;
end
if ~exist('bynum', 'var')
    bynum = false;
end

tfname = dir(fullfile(path2sort, nameclue));

if bynum
    fname = sortrows({tfname.name}');
    res = cellfun(@parse_num_list, fname);
    [~,idx] = sort(res);
    fname = fname(idx);
    fname = cellfun(@(x)(fullfile(path2sort,x)), fname, 'UniformOutput',false);
    return;
end


if ~bytime
    fname = sortrows({tfname.name}');
    fname = cellfun(@(x)(fullfile(path2sort,x)), fname, 'UniformOutput',false);
else
    ftime = cell2mat(cellfun(@datevec, {tfname.date}', 'UniformOutput', ...
                    false));
    fname = {tfname.name}';
    [ftime,idx] = sortrows(ftime);
    fname = cellfun(@(x)(fullfile(path2sort,x)), fname(idx), 'UniformOutput',false);
    % fname = fname(idx); previous
end

return;
