function [sZ, amp] = getlfploc(lfp, Z, inc, thresh, isall)
%GETLFPLOC
%   [sZ, amp] = GETLFPLOC(lfp, Z, inc, thresh, isall)
%
%   Input:
%        -
%   Output:
%        -
%
%   Notes:
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2018-01-24.

% make sure the first timestamp of lfp is >= Z(1)
goodidx = lfp(:, 1) >= Z(1,1) & lfp(:, 1) < Z(end,1);
lfp = lfp(goodidx, :);

if ~exist('inc', 'var') || isempty(inc)
    inc = 0.032;
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

% <= x <
idx = findIntervalIdx(lfp(:, 1), [Z(:,1), Zup]);
% throw away 0
goodidx = idx ~= 0; amp = lfp(goodidx, 2);
sZ = Z(idx(goodidx), :);


return;
