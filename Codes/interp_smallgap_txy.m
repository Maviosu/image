function txy = interp_smallgap_txy(txy, thresh)
%INTERP_SMALLGAP_TXY
%   txy = INTERP_SMALLGAP_TXY(txy, thresh)
%
%   Input:
%       thresh(num) - number of frames
%   Output:
%        -
%
%   Notes: only interpolate small gaps
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2017-04-08.


if all(isnan(txy(:, 2)))
    txy = [];
    return;
end

%% find small gaps,

% idx = find(~isfinite(txy(:, 2)));
idx = find(~(isfinite(txy(:, 2)) & isfinite(txy(:, 3))));

% find big gaps, rm from the to be interped data
segidx = get_cont_block(idx, thresh, 'higher');

badidx = false(length(idx), 1);
for i = 1:size(segidx, 1)
    badidx(segidx(i,1):segidx(i, 2)) = true;
end
idx(badidx) = [];


goodidx = find(isfinite(txy(:, 2)) & isfinite(txy(:, 3)));
% interp x
xi = interp1(txy(goodidx, 1), txy(goodidx, 2), txy(idx, 1));
txy(idx, 2) = xi;

% interp y
yi = interp1(txy(goodidx, 1), txy(goodidx, 3), txy(idx, 1));
txy(idx, 3) = yi;


return;
