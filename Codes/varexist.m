function status = varexist(varname)
%VAREXIST Check the existence of variable
%   STATUS = VAREXIST(VARNAME) 
%   
%   Input:
%       VARNAME(str) - putative variable name
%   Output:
%       STATUS(bool) - 
% 
%   Notes: The variable must be in the caller's stack, so 
% 
%   See also FILEEXIST
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2011-06-24.

status = evalin('caller', ['exist(''',varname,''',''var'') == 1']);

return;
