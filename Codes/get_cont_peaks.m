function segidx = get_cont_peaks(peakidx,gapthresh, contthresh)
%GET_CONT_PEAKS 
%   segidx = GET_CONT_PEAKS(peakidx,threshdis) 
%   
%   Input:
%       peakidx(vec) - local peaks
%       gapthresh(num) - threshold distance between peaks
%       contthresh(num) - how many consecutive peaks there must be
%           in order to be a candidate event. 
%   Output:
%       segidx(vec) - 
% 
%   Notes: gapthresh is is tolerance of peaks within a putative
%   epoch. Less than this is good, larger than this is considered
%   separate epochs. 
% 
%   See also GET_CONT_BLOCK
% 
%   by Cheng Wang (cwchengwang@gmail.com), 2011-07-22.

peakidx = peakidx(:);
fakeidx = ceil(peakidx/gapthresh);
segidx = get_cont_block(fakeidx, contthresh, 'higher');
segidx = peakidx(segidx);

return;
