A = readmatrix('Btimestamps.csv');  
B = readmatrix('Mtimestamps.csv');
behavTime = A(:,2)/1000; behavTime (1,1) = 0; 
msTime = B(:,2)/1000; msTime (1,1) = 0; 

% msTime = Time1;
% behavTime = Time0(1:36000);

tmp = find(diff(behavTime)==0);
for i = 1 : length(tmp)
    behavTime(tmp(i)) = behavTime(tmp(i)-1)+ mean(diff(behavTime));
end