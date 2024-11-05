A = importdata('timestamp.dat');  
Time0 = A.data(A.data(:,1) == 0, 3)/1000; Time0 (1,1) = 0; 
Time1 = A.data(A.data(:,1) == 1, 3)/1000; Time1 (1,1) = 0; 
if length(Time0)== behav_frameNum
    behavTime = Time0;
    msTime = Time1;
elseif length(Time1)== behav_frameNum
    behavTime = Time1;
    msTime = Time0;
end

% msTime = Time1;
% behavTime = Time0(1:36000);

tmp = find(diff(behavTime)==0);
for i = 1 : length(tmp)
    behavTime(tmp(i)) = behavTime(tmp(i)-1)+ mean(diff(behavTime));
end





% % % cd C:\Users\xjchen\papers\Miniscope\mydata\M19\20180412\H22_M6_S3_R1P1;  
% % % behav = msGenerateVideoObj(pwd,'behavCam'); % combine behavcam1...n togeter and name it bahavCam.avi
% % % numFrames = behav.numFrames;
% % % 
% % % %%
% % % 
% % % A = importdata('timestamp.dat');  
% % % abs_Time0 = A.data(A.data(:,1) == 0, 3); abs_Time0(2:end) = abs_Time0(2:end)+abs_Time0(1);   % absolute time in original time 
% % % abs_Time1 = A.data(A.data(:,1) == 1, 3); abs_Time1(2:end) = abs_Time1(2:end)+abs_Time1(1);
% % % 
% % % Time0 = abs_Time0-min(abs_Time0(1), abs_Time1(1)); Time0 = Time0/1000;
% % % Time1 = abs_Time1-min(abs_Time0(1), abs_Time1(1)); Time1 = Time1/1000;
% % % 
% % % 
% % % if length(Time0)== length(behav.frameNum)
% % %     behavTime = Time0;
% % %     msTime = Time1;
% % % elseif length(Time1)== length(behav.frameNum)
% % %     behavTime = Time1;
% % %     msTime = Time0;
% % % end
