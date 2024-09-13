function avi_utils_V4pyRGB(refined_path, sn, spatialbin, temporalbin)
% combine files, and downsample spatially and temporally
% avi_utils_V4grey(pwd, 'xxxx.avi';
%used for the video that been been processed by python
% by YueqingZhou, 4/6/2021;

if ~exist('spatialbin', 'var') || isempty(spatialbin)
    spatialbin = 2;
end
if ~exist('temporalbin', 'var') || isempty(temporalbin)
    temporalbin = 4;
end

%fns = getvideofiles(refined_path);
% set a video
fns = [refined_path,'\msDown.avi'];
writeObj = VideoWriter(sn, 'Grayscale AVI');
original_frm_rate = 30;
writeObj.FrameRate = original_frm_rate/temporalbin;
open(writeObj);

% for each file in the folder proess them
 
    tfn = fns;
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
   


close(writeObj);

end