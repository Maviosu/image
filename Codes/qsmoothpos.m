function pos = qsmoothpos(pos, win, stidx)
%QSMOOTHPOS Quickly smooth txy
%   pos = QSMOOTHPOS(pos, win)
%
%   Input:
%       pos(mat) - t x y
%       win(num) - optional, default to 4;
%       stidx(num) - default to 2, as the first column is time
%   Output:
%        -
%
%   Notes: boxcar filtering
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2014-03-11.


if ~exist('stidx', 'var')
    stidx = 2;
end

if ~exist('win', 'var')
    win = 4;
end
for i = stidx:size(pos, 2)-1
    b = ones(win, 1)/win;
    idx = isfinite(pos(:, i));
    pos(idx, i) = filtfilt(b, 1, pos(idx, i));
end
% $$$ idx = isfinite(pos(:, 3));
% $$$ pos(idx, 3) = filtfilt(b, 1, pos(idx, 3));

return;
