ccc; cd 'G:\m25\8_17_2018';
v1 = 'G:\m25\8_17_2018\H20_M44_S56\msCam1.avi';
v2 = 'G:\m25\8_17_2018\msDownRegist.avi';

vreader = VideoReader(v1);
FrameRate = vreader.FrameRate;

frame1 = zeros(240, 376, 10, 'uint8'); count = 0;
for k = 1:4:40
    vreader.CurrentTime = (k-1)/FrameRate;
    frame = readFrame(vreader);
    count = count + 1;
    frame1(:, :, count) = frame(1:2:end, 1:2:end);
end

vreader2 = VideoReader(v2);
frame2 = zeros(240, 376, 10, 'uint8');
for k = 1:10
    frame = readFrame(vreader2);
    frame2(:, :, k) = frame;
end

%% compare
ccc; cd 'G:\m25\8_17_2018';
v1 = 'G:\m25\8_17_2018\H20_M44_S56\msCam1.avi';

vreader = VideoReader(v1);
FrameRate = vreader.FrameRate;

frame1 = zeros(240, 376, 10, 'uint8'); count = 0;
for k = 1:4:40
    vreader.CurrentTime = (k-1)/FrameRate;
    frame = readFrame(vreader);
    count = count + 1;
    frame1(:, :, count) = frame(1:2:end, 1:2:end);
end
cd 'G:\m25\8_17_2018';
save('skip-time-frame1.mat', 'frame1');
%% adf
ccc; cd 'G:\m25\8_17_2018';
v1 = 'G:\m25\8_17_2018\H20_M44_S56\msCam1.avi';

vreader = VideoReader(v1);
FrameRate = vreader.FrameRate;

frame2 = zeros(240, 376, 40, 'uint8'); count = 0;
for k = 1:40
    frame = readFrame(vreader);
    frame2(:, :, k) = frame(1:2:end, 1:2:end);
end
frame2 = frame2(:, :, 1:4:end);
cd 'G:\m25\8_17_2018';
fprintf('2')
save('normal-frame2.mat', 'frame2');

%% load and see
ccc;
load('skip-time-frame1.mat', 'frame1');
load('normal-frame2.mat', 'frame2');

min_max(frame1 - frame2)

%% move encoding
ccc;
load('skip-time-frame1.mat', 'frame1');
writeObj = VideoWriter('test-encoding.avi', 'Grayscale AVI');
writeObj.FrameRate = 30/4;
open(writeObj);
for k = 1:10
    writeVideo(writeObj, frame1(:, :, k))
end
close(writeObj);

%% load encoding test and cmp
ccc;
v1 = 'G:\m25\8_17_2018\test-encoding.avi';
vreader = VideoReader(v1);
enc = zeros(240, 376, 10, 'uint8'); count = 0;
for k = 1:10
    frame = readFrame(vreader);
    enc(:, :, k) = frame;
end
load('normal-frame2.mat', 'frame2');
min_max(enc - frame2)


%% rerun code dsample
ccc; p = 'G:\m25\8_17_2018\H20_M44_S56\';
sn = 'G:\m25\8_17_2018\msDownRegist2.avi';
avi_utils(p, sn);

%% compare the 2 verus first video
ccc; cd 'G:\m25\8_17_2018';
v1 = 'G:\m25\8_17_2018\H20_M44_S56\msCam1.avi';
v2 = 'G:\m25\8_17_2018\msDown.avi';

vreader = VideoReader(v1);
FrameRate = vreader.FrameRate;

frame1 = zeros(240, 376, 20, 'uint8'); count = 0;
for k = 1:4:80
    vreader.CurrentTime = (k-1)/FrameRate;
    frame = readFrame(vreader);
    count = count + 1;
    frame1(:, :, count) = frame(1:2:end, 1:2:end);
end

vreader2 = VideoReader(v2);
frame2 = zeros(240, 376, 20, 'uint8');
for k = 1:20
    frame = readFrame(vreader2);
    frame2(:, :, k) = frame;
end
min_max(frame1 - frame2);
