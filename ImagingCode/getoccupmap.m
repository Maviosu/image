function [occmap,code] = getoccupmap(txy, xbounds, ybounds)
%GETOCCUPMAP
%   [occmap,code] = GETOCCUPMAP(txy, xbounds, ybounds) 
%   
%   Input:
%       txy(mat) - [t x y] or [t x];
%       xbounds(vec) - edges for x
%       ybounds(vec) - edges for y
%   Output:
%       occmap(mat|vec) - depends on whether its [t x y] or [t x]
%       code(struct) - contains xcode, ycode or just xcode
% 
%   Notes: 
% 
%   See also 
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2012-04-09.

if isempty(txy)
    occmap = [];
    return;
end

if size(txy, 2) >= 3
    [occmap, code.xcode, code.ycode] = get2Dmap(txy(:,2), txy(:,3), ...
                                                          xbounds,ybounds);
else
    [occmap, code.xcode] = get1Dmap(txy(:,2), xbounds);
end

return;
