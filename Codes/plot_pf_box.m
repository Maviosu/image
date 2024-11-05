cccc

file_path = 'D:\ImageData\r861\1_10_2020\H12_M18_S21_STD1\msDownRegist_source_extraction';
cd(file_path);
load('data_64_64_24.mat');
cd('D:\ImageData\r861\1_10_2020\H12_M18_S21_STD1');
load('pos'); load('matlab.mat');

vthresh =3;
lv = getvelocity(pos);
idx = lv(:, 2) > vthresh; 
vpos = pos(idx, :);
downsample1= 4;
msTime = msTime(1:downsample1:end);

x_bounds = [-33:3:33]; y_bounds = [-33:3:33]; % need to adjust
varargin = {'xbounds',x_bounds,'ybounds',x_bounds, 'occthresh', 0.3, 'sigma', 2,'framerate', 30};

d1 = neuron.options.d1;d2 = neuron.options.d2;




pf_path = fullfile(pwd,'pf'); mkdir(pf_path);
cd(pf_path);
% %
for c = 1: size(neuron.C,1)


CaF = detrend(neuron.C_raw(c,:)); 
%CaF = detrend_data(neuron.C_raw(c,:)); 
%CaF = neuron.C_raw(c,:); 

%[c_oasis, s_oasis, options] = deconvolveCa(CaF, 'ar1', 'thresholded');   
c_oasis=  neuron.C(c,:)';
s_oasis= full(neuron.S(c,:))';
othresh = 0;
CalE_idx  = find(s_oasis>othresh*std(s_oasis));CalE_amp = s_oasis(CalE_idx); %CalE_amp = full(CalE_amp);
CalE= [msTime(CalE_idx), CalE_amp];
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



figure('position',[   520   233   913   865])
subplot(3,3,1)
plot(vpos(:,2), vpos(:,3),'color',[0.7 0.7 0.7]); hold on; 
[xdata, ydata] = plot_lfp_pos_raster(vCalE_txy,  vCalE_amp);
plot(xdata, ydata, 'r','linewidth',1.5);
set(gca,'xlim',[-33 33], 'ylim', [-35 35]);
title(['spk plot(v>', num2str(vthresh),'cm/s)']);

subplot(3,3,4)
imnanshow(pfield);
set(gca,'xlim',[1 length(x_bounds)], 'ylim', [1 length(y_bounds)]); axis xy
title(['info = ', num2str(skag_info), '   p = ', num2str(skag_p)]);

subplot(3,3,7);
neruon_shape = reshape(neuron.A(:,c),d1,d2); 
imagesc(neruon_shape);
[~, maxpos]= max(neuron.A(:,c));
[y1,x1] = ind2sub([d1, d2], maxpos); hold on;
%set(gca,'xlim', [x1-50, x1+50], 'ylim', [y1-50, y1+50]);
title('shape of the neuron');

% 
msLength = min(length(neuron.C_raw(c,:)), length(msTime)); 
axes('position',[0.42 0.77 0.52 0.15])
plot(msTime(1:msLength),neuron.C_raw(c,(1:msLength))); hold on;
plot(msTime(1:msLength), c_oasis(1:msLength),'m');axis tight; box off;
title('CaF-denoise'); box off; set(gca,'tickdir','out');
%legend('raw(C raw)','dnoise(C)')

axes('position',[0.42 0.55 0.52 0.15])
[AX,H1,H2] = plotyy(msTime(1:msLength),c_oasis(1:msLength),msTime(1:msLength),s_oasis(1:msLength));
set(H1, 'color','m');set(H2, 'color','k');
set(AX,'xlim', [msTime(1) msTime(end)]);
title('deconv'); box off; set(gca,'tickdir','out');
%legend('dnoise(C)','deconv(S)')


axes('position',[0.42 0.33 0.52 0.15]);
plot(msTime(1:msLength),s_oasis(1:msLength),'k'); hold on;
plot(CalE(:,1), CalE(:,2),'ro');
axis tight; box off;  set(gca,'tickdir','out');
title('spk rate');

axes('position',[0.42 0.11 0.52 0.15])
plot(msTime(1:msLength),s_oasis(1:msLength),'k'); hold on;
plot(vCalE_txy(:,1), vCalE_amp,'linestyle','none','marker','o','markersize',5,'color','r');
axis tight; box off; set(gca,'tickdir','out');
xlabel('Time (sec)');
title('velocity filted spk rate');

suptitle(['cell',num2str(c)]);
set(gcf, 'paperpositionmode', 'auto');




%saveas(gcf,['cell',num2str(c)], 'png');


end
%save([res_name,'_anaNeuron'] ,'anaNeuron');

