% generate Place field
cccc
file_path = 'DataFolder\msDownRegist_source_extraction';
cd (file_path);
load ('data_64_64_20.mat');
cd DataFolder\msDownRegist_source_extraction\frames_1_7391\LOGS_30-Mar_12_38_50
load 31-Mar_00_33_49.mat

cd('DataFolder')
load('pos')
res_name = 'ratID_data_session';
pf_path = fullfile(pwd,'pf1'); mkdir(pf_path);
Pixel_convert_factor = 3; %depend on real data
vthresh =3 *Pixel_convert_factor;
lv = getvelocity(pos);
idx = lv(:, 2) > vthresh; 
downsample1= 4;
msTime = msTime(1:downsample1:end);
x_bounds = 0:10:1200; y_bounds = 0:10:1200;
varargin = {'xbounds',x_bounds,'ybounds',x_bounds, 'occthresh', 0.1, 'sigma', 2,'framerate', 30};
d1 = neuron.options.d1;d2 = neuron.options.d2;

cd(pf_path);
for c =1: size(neuron.C,1)
CaF = detrend(neuron.C_raw(c,:)); 

c_oasis=  neuron.C(c,:)';
s_oasis= full(neuron.S(c,:))';
othresh = 0;
CalE_idx  = find(s_oasis>othresh*std(s_oasis));CalE_amp = s_oasis(CalE_idx); %CalE_amp = full(CalE_amp);
CalE= [msTime(CalE_idx), CalE_amp];
%---get pfield without the filtering
anaNeuron.CalE_noVfilt{c} = CalE;
[CalE_txy, CalE_amp] = getlfploc(CalE, pos);
badidx1 =isnan(CalE_txy(:,2));CalE_txy(badidx1,:) =[];CalE_amp(badidx1) = [];
[pfield_noVfilt, pmax_noVfilt, smap_noVfilt, occmap_noVfilt] = continuous_field(pos, CalE_txy(:,1), CalE_amp,varargin{:});
skag_info_noVfilt = getspatialinfo(pfield_noVfilt);
lfp = CalE; st_t= pos(1,1);ed_t = pos(end,1);nrep = 1000;init_offset  = 50; % sec
[slfp_noVfilt] = shufflelfp(lfp, st_t, ed_t, nrep, init_offset);
infos_noVfilt = zeros(nrep, 1)+nan;

for i = 1:nrep
    try
    m_noVfilt = continuous_field(pos, slfp_noVfilt{i}(:,1), slfp_noVfilt{i}(:,2),varargin{:});
    infos_noVfilt(i) = getspatialinfo(m_noVfilt);
   catch
end
end
skag_p_noVfilt = sum(infos_noVfilt > skag_info_noVfilt)/nrep;
%---
CalE_v = getspkloc(CalE(:, 1), lv);
goodidx = CalE_v(:,2)>vthresh;
CalE = CalE(goodidx,:);
anaNeuron.framerate(c) = size(CalE,1)/msTime(end);
%---
[vCalE_txy, vCalE_amp] = getlfploc(CalE, vpos);

[pfield, pmax, smap, occmap] = continuous_field(vpos, vCalE_txy(:,1), vCalE_amp,varargin{:});
skag_info = getspatialinfo(pfield);

lfp = CalE; st_t= vpos(1,1);ed_t = vpos(end,1);nrep = 1000;init_offset  = 50; % sec
[slfp] = shufflelfp(lfp, st_t, ed_t, nrep, init_offset);
infos = zeros(nrep, 1)+nan;
for i = 1:nrep
    try
    m = continuous_field(vpos, slfp{i}(:,1), slfp{i}(:,2),varargin{:});
    infos(i) = getspatialinfo(m);
   catch
end
end
skag_p = sum(infos > skag_info )/nrep;

anaNeuron.c(c,:)= c_oasis;
anaNeuron.s(c,:)= s_oasis;
anaNeuron.CalE{c} = CalE;
anaNeuron.pfield{c} = pfield;
anaNeuron.pfield_noVfilt{c} = pfield_noVfilt;
anaNeuron.pmax(c) = pmax;
anaNeuron.pmax_noVfilt(c) = pmax_noVfilt;
anaNeuron.neuron_shape{c} = neruon_shape;
anaNeuron.cellpos(c,:)= [x1,y1];
anaNeuron.skag_info(c) = skag_info;
anaNeuron.skag_info_noVfilt(c) = skag_info_noVfilt;
anaNeuron.skag_p(c) = skag_p;
anaNeuron.skag_p_noVfilt(c) = skag_p_noVfilt;

saveas(gcf,['cell',num2str(c)], 'png');
end
save([res_name,'_anaNeuron'] ,'anaNeuron');
