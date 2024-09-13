function [xdata, ydata] = plot_lfp_pos_raster(spos, amp, max_r)
%PLOT_LFP_POS_RASTER
%   [xdata, ydata] = PLOT_LFP_POS_RASTER(spos, amp, maxr_r)
%
%   Input:
%       spos(pos) - spike or calcium triggered pos
%       amp(vec) - corresponding amplitude
%       max_r(num) - optional, max radius
%   Output:
%       xdata(vec) - vec
%       ydata(vec) - vec
%   Notes:
%
%   See also
%
%   by Cheng Wang (cwchengwang@gmail.com), 2018-01-24.

% get trigger pos
if ~exist('max_r', 'var')
    max_r = 9;
end
amp = amp/max(amp)*max_r;

cens = transpose(spos(:, 2:3));
[xdata, ydata] = manyCircles(cens, amp');

return;
