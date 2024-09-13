function nframe = avi_utils_helper(p, sn, spatialbin, temporalbin, frame_sub)
% combine files, and downsample spatially and temporally
% avi_utils(pwd, 'xxxx.avi';
% by Cheng, 2018/10/04;

if ~exist('spatialbin', 'var') || isempty(spatialbin)
    spatialbin = 2;
end
if ~exist('temporalbin', 'var') || isempty(temporalbin)
    temporalbin = 4;
end

fns = getvideofiles(p);
nframe = 0;
for f = 1:(length(fns)-1)
    tfn = fns{f};
    vreader = VideoReader(tfn);
    FrameRate = vreader.FrameRate;
    nfrm = vreader.Duration * FrameRate;
    k = 1:temporalbin:nfrm;
    nframe = nframe  + length(k);
end

    tfn = fns{end};
    vreader = VideoReader(tfn);
    FrameRate = vreader.FrameRate;
    nfrm = vreader.Duration * FrameRate;
    k = 1:temporalbin:nfrm-frame_sub;
    nframe = nframe  + length(k);

end


function fns = getvideofiles(p)
fns = sortdir(p, 'msCam*.avi');
% order files
idx = zeros(length(fns), 1);
for i = 1:length(fns)
    idx(i) = parsenumlist(basname(fns{i}));
end
[~, tmp] = sort(idx);
fns = fns(tmp);
end