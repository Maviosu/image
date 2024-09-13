function combine_behav_videos(p, sn)
%UNTITLED2 Summary of this function goes here
res = getvideofiles_V4(p);
% system(['ffmpeg -r 30 -i "concat:', res, '" -r 30 -vcodec libx264 -crf 27 ', sn]);
%by YueqingZhou yueqingzhou612@gmail.com 11/10/2020
system(['ffmpeg -r 30 -i "concat:', res, '" -r 30 -vcodec libx264 -crf 27 ', sn]);
end


function res = getvideofiles_V4(p)
fns = sortdir(p, 'behavCam*.avi');% modify here is your original with different name%fns = sortdir(p, 'behavCam*.avi');
% order files
idx = zeros(length(fns), 1);
for i = 1:length(fns)
    idx(i) = parsenumlist(basname(fns{i}));
end
[~, tmp] = sort(idx);
fns = fns(tmp);
res = [];
for i = 1:length(fns)
    res = [res, [basname(fns{i}),'.avi|']];% modify here if you original video file is not avi
end
res(end) = [];
end