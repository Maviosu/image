function A = rotationmatrix(theta)
%ROTATIONMATRIX Give the rotation matrix
%   A = ROTATEMATRIX(theta) 
%   
%   Input:
%       theta(num) - radian
%   Output:
%       A(mat) - rotation matrix
% 
%   Notes: 
% 
%   See also 
% 
%   by Cheng Wang (chengwang@ion.ac.cn), 2010-11-09.
 
A = [cos(theta), -sin(theta);
     sin(theta), cos(theta)];


return;
