
%%combine video files for new miniscope software
% by Yeuqing 9/11/2020 yueqingzhou612@gmail.com

function combine_behav_videos_V4(p, sn)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
res = getvideofiles(p);

% system(['ffmpeg -r 30 -i "concat:', res, '" -r 30 -vcodec libx264 -crf 27 ', sn]);
system(['ffmpeg -r 30 -i "concat:', res, '" -r 30 -vcodec libx264 -crf 27 ', sn]);
end


function res = getvideofiles(p)
fns = sortdir(p, '*.avi');%fns = sortdir(p, 'behavCam*.avi');
% order files
idx = zeros(length(fns), 1);
for i = 1:length(fns)
    idx(i) = parsenumlist(basname(fns{i}));
end
[~, tmp] = sort(idx);
fns = fns(tmp);
res = [];
for i = 1:length(fns)
    res = [res, [basname(fns{i}),'.avi|']];
end
res(end) = [];
end