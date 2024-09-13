function RGB_to_gray(RGBfile,Grayfile)
%convert RGB24.avi to Grayscale.avi
%12/31/2020 @ YueqingZhou



%--read obj
obj = VideoReader(RGBfile);
obj2 = VideoReader(RGBfile);
%--creat an objwriter
objWriter = VideoWriter(Grayfile, 'Grayscale AVI')
nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;
objWriter.FrameRate = obj.FrameRate
open(objWriter);

%process in each frame
for k = 1 : nFrames
    frame = readFrame(obj2)
    writeVideo(objWriter, rgb2gray(frame(:,:,:)))
   %writeVideo(objWriter, rgb2gray(frame(:,:,:))
  %frame(:,:,:,k) = rgb2gray(frame(:,:,:,k))
end
close(objWriter);
end
