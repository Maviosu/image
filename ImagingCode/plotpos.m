function h = plotpos(pos, varargin)
%PLOTPOS 
%   h = PLOTPOS(pos, varargin) 
%   
%   Input:
%       pos(nx3 mat) - [t x y];
%       varargin() - for function plot 
%   Output:
%       h(handle) - 
% 
%   Notes: 
% 
%   See also 
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2012-10-04.

h = plot(pos(:,2), pos(:,3), varargin{:});
hh = get(h, 'parent');
axis(hh, 'xy');

return;
