function avi_utils2(p, sn, spatialbin, temporalbin,frame_sub)
% combine files, and downsample spatially and temporally
% avi_utils(pwd, 'xxxx.avi';
% by Cheng, 2018/10/04;
% modified by Yueqing

if ~exist('spatialbin', 'var') || isempty(spatialbin)
    spatialbin = 2;
end
if ~exist('temporalbin', 'var') || isempty(temporalbin)
    temporalbin = 4;
end

fns = getvideofiles(p);
% set a video
writeObj = VideoWriter(sn, 'Grayscale AVI');
original_frm_rate = 30;
writeObj.FrameRate = original_frm_rate/temporalbin;
open(writeObj);

% for each file in the folder proess them
for f = 1:(length(fns)-1)
    tfn = fns{f};
    vreader = VideoReader(tfn);
    FrameRate = vreader.FrameRate;
    nfrm = vreader.Duration * FrameRate; 
% % % %     if mod(nfrm, temporalbin) ~= 0 && f ~= length(fns)
% % % %         error(['this middle file cannot be divisible by temporalbin: ', tfn]);
% % % %     end
    % counter = 0;
    for k = 1:temporalbin:nfrm
        vreader.CurrentTime = (k-1)/FrameRate;
        frame = readFrame(vreader);
        writeVideo(writeObj, frame(1:spatialbin:end, 1:spatialbin:end));
        % mod(counter)
    end 
end

% ==================================================
% deal with the last video, which occasionally could cause problems to CNMF
tfn = fns{end};
vreader = VideoReader(tfn);
FrameRate = vreader.FrameRate;
nfrm = vreader.Duration * FrameRate;  
for k = 1:temporalbin:nfrm-frame_sub
    vreader.CurrentTime = (k-1)/FrameRate;
    frame = readFrame(vreader);
    writeVideo(writeObj, frame(1:spatialbin:end, 1:spatialbin:end));
end
%% ==================================================


close(writeObj);

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
