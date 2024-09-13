function [pfield, pmax, smap, occmap] = continuous_field(pos, ts, data, varargin)
%CONTINUOUS_FIELD Get continuous field
%   [pfield, pmax, smap, occmap] = CONTINUOUS_FIELD(pos, ts, data, varargin)
%
%   Input:
%       pos() -
%       ts() -
%       data() -
%       varargin
%   Output:
%       pfield -
%       pmax()
%       smap
%       occmap
%
%   Notes: ts is not continuously sampled, this co
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2014-01-25.


idx = ts > pos(1,1) & ts < pos(end, 1);
ts = ts(idx);
data = data(idx);

[xbounds,varargin] = updateparam(varargin, 'xbounds', [-76:2:76]);
[ybounds,varargin] = updateparam(varargin, 'ybounds', [-76:2:76]);
[framerate,varargin] = updateparam(varargin, 'framerate', 30);
[occthresh, varargin] = updateparam(varargin, 'occthresh', 0.5);
[ifcirc, varargin] = updateparam(varargin, 'ifcirc', false);
[sigma, varargin] = updateparam(varargin, 'sigma', 2);

% occmap
occmap = getoccupmap(pos, xbounds, ybounds);                                                                                                     

% spkmap
% HERE
spos = getspkloc(ts, pos, [], [], 'all');
% $$$ [spos, timeidx] = getspkloc(ts, pos);
% $$$ ts = ts(timeidx); data = data(timeidx);
if ~isempty(spos)
    xidx = quantize_cw(spos(:, 2), xbounds); xidx = quantize_cw(spos(:, 2), xbounds); 

  %%%% xj change here; ori: xidx = quantize(spos(:, 2), xbounds)+1;
    if size(spos, 2) >= 3
        yidx = quantize_cw(spos(:, 3), ybounds)+1;
        smap = accumarray([yidx, xidx], data,[length(ybounds)-1, length(xbounds)-1]);
    else
    % yidx = ones(size(xidx));
    smap = accumarray(xidx, data);
    smap = [smap(:); zeros(length(xbounds) - 1 - length(smap), 1)];
    end
else
    smap = [];
end

% $$$
% $$$ [pfield, pmax] = field_helper(smap, occmap, framerate, occthresh);
% $$$
% $$$ return;

[pfield, pmax] = field_helper2(smap, occmap, framerate, occthresh, ifcirc, sigma);

return;

function [pfield, pmax] = field_helper2(spkmap,occmap,framerate,occthresh, ifcirc, sigma)
if ~exist('ifcirc', 'var');
    ifcirc = false;
end

if ~exist('sigma', 'var')
    sigma = 2;
end

if isempty(occmap) && isempty(spkmap)
    pfield = nan;
    pmax = nan;
    return;
end

if isempty(spkmap)
    spkmap = zeros(size(occmap));
end

% throw away spikes from undersampled positions before smoothing?
occthresh = occthresh*framerate;        % change to number of frames
badidx = occmap < occthresh;
spkmap(badidx) = 0;
occmap(badidx) = 0;

% image processing toolbox
h = fspecial('gaussian', ceil(5*sigma), sigma);
if min(size(spkmap)) == 1
    if size(spkmap, 1) == 1
        h = h(1, :);
    else
        h = h(:, 1);
    end
end
h = h ./ sum(h(:));

if ~ifcirc
% $$$     s_spkmap = imfilter(spkmap, h, 'symmetric', 'same');
% $$$     s_occmap = imfilter(occmap, h, 'symmetric', 'same');
    tmp = spkmap./occmap; tmp(isnan(tmp)) = 0;
    pfield = imfilter(tmp, h, 'symmetric', 'same');
else
% $$$     s_spkmap = imfilter(spkmap, h, 'circular', 'same');
% $$$     s_occmap = imfilter(occmap, h, 'circular', 'same');
% $$$     tmp = s_spkmap(:)./s_occmap(:); tmp(isnan(tmp)) = 0;
% $$$     pfield = imfilter(tmp, h, 'circular', 'same');
% ============================================================
% $$$  here
    tmp = spkmap(:)./occmap(:); tmp(isnan(tmp)) = 0;
    pfield = imfilter(tmp, h, 'circular', 'same');
end

pfield = pfield*framerate;
pfield(badidx) = nan;
pmax = nanmax(pfield(:));

return;
