function bas = basname(fname)
%BASNAME Get the base name of a file
%   BAS = BASNAME(fname) 
%   
%   Input:
%       FNAME(str) - file name
%   Output:
%       BAS(str) - base file name
% 
%   Notes: 
% 
%   See also EXTNAME
% 
%   by Cheng Wang (chengwang@ion.ac.cn), 2010-06-20.

[~,bas] = fileparts(fname);

return;
