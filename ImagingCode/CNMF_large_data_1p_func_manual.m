function CNMF_large_data_1p_func_manual(input_path)
%% clear the workspace and select data
cd(input_path);
load matlab.mat;

%% add a manual intervention and run the whole procedure for a second time
neuron.options.spatial_algorithm = 'nnls';
if with_manual_intervention
    show_merge =false;
    neuron.orderROIs('snr');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity'}
    neuron.viewNeurons([], neuron.C_raw);
    
    % merge closeby neurons
    neuron.merge_close_neighbors(false, dmin_only);
    
    % delete neurons
    tags = neuron.tag_neurons_parallel();  % find neurons with fewer nonzero pixels than min_pixel and silent calcium transients
    ids = find(tags>0); 
    if ~isempty(ids)
        neuron.viewNeurons(ids, neuron.C_raw);
    end
end
%% run more iterations
neuron.update_background_parallel(use_parallel);
neuron.update_spatial_parallel(use_parallel);
neuron.update_temporal_parallel(use_parallel);

K = size(neuron.A,2);
tags = neuron.tag_neurons_parallel();  % find neurons with fewer nonzero pixels than min_pixel and silent calcium transients
neuron.remove_false_positives();
neuron.merge_neurons_dist_corr(show_merge);
neuron.merge_high_corr(show_merge, merge_thr_spatial);

if K~=size(neuron.A,2)
    neuron.update_spatial_parallel(use_parallel);
    neuron.update_temporal_parallel(use_parallel);
    neuron.remove_false_positives();
end

% % save the workspace for future analysis
neuron.orderROIs('snr');
cnmfe_path = neuron.save_workspace();

% % show neuron contours
Coor = neuron.show_contours(0.6);


% % create a video for displaying the
% amp_ac = 140;
% range_ac = 5+[0, amp_ac];
% multi_factor = 10;
% range_Y = 1300+[0, amp_ac*multi_factor];
% 
% avi_filename = neuron.show_demixed_video(save_demixed, kt, [], amp_ac, range_ac, range_Y, multi_factor);

% % save neurons shapes
neuron.save_neurons();


















