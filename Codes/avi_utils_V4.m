function avi_utils_V4(original_path, sn, spatialbin, temporalbin)
% combine files, and downsample spatially and temporally
% avi_utils(pwd, 'xxxx.avi';
% by Yueqing, 2020/10/04;

if ~exist('spatialbin', 'var') || isempty(spatialbin)
    spatialbin = 1;
end
if ~exist('temporalbin', 'var') || isempty(temporalbin)
    temporalbin = 1;
end

fns = getvideofiles(original_path);
% set a video
writeObj = VideoWriter(sn, 'Uncompressed AVI');%ori:Grayscale AVI;Uncompressed AVI
original_frm_rate = 30;
writeObj.FrameRate = original_frm_rate/temporalbin;
open(writeObj);

% for each file in the folder proess them
for f = 1:(length(fns))
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
        writeVideo(writeObj, frame(1:spatialbin:end, 1:spatialbin:end,1:3:end));
        % mod(counter)
    end 
end

close(writeObj);

end


function fns = getvideofiles(p)
fns = sortdir(p, '*.avi');
% order files
idx = zeros(length(fns), 1);
for i = 1:length(fns)
    idx(i) = parsenumlist(basname(fns{i}));
end
[~, tmp] = sort(idx);
fns = fns(tmp);
end
