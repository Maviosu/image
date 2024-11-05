function pos = prepro_pos(pos_raw, behavTime, centerxy, rotation_angle, convertion_factor,frame_thresh)

if ~exist('rotation_angle', 'var')    
    rotation_angle = 0;
end

%behavTime =  behavTime(1:size(pos_raw,1));
pos_raw = [behavTime, pos_raw];

pos = interp_smallgap_txy(pos_raw, frame_thresh);
pos = qsmoothpos(pos,5);

pos(:, 2) = (pos(:, 2)-centerxy(1))*convertion_factor;
pos(:, 3) = (pos(:, 3)-centerxy(2))*convertion_factor;
pos(:, 3) = -pos(:, 3);

m = rotationmatrix(deg2rad(rotation_angle));
pos_rota = (m*pos(:,2:3)')';  
pos = [behavTime,pos_rota];



