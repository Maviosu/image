% Related to Figure 4v8
cccc
cd //mbi-jk-labserv.win.ad.jhu.edu/Yueqing/LVC
load 'rotate_field'
maxpeak_plat_degree                                 = circ_ang2rad( allrat_PRD_pfield');
maxpeak_obj_degree                                  = circ_ang2rad( allrat_LRD_pfieldab_circle2');
platformPeak                                        = allrat_PRD_pfield';
objectPeak                                          = allrat_LRD_pfieldab_circle2';
maxpeak_obj_binnumber                               = allrat_LRD_pfieldab_circle2_bin';
maxpeak_plat_binnumber                              = allrat_PRD_pfield_bin';

maxpeak_obj_binnumber(isnan(objectPeak))    = [];
objectPeak(isnan(objectPeak))               = [];
% plot figures
sz=32;
obj_s              = scatter(objectPeak,maxpeak_obj_binnumber,sz,'MarkerEdgeColor','#21ada5', 'MarkerFaceColor','#21ada5');
box off;
set(gca,'ylim',[0 700], 'yTick',[ 200 400 600],'xlim',[0 380],'xTick',[0 90 180 270 360], 'FontName','Arial','LineWidth',2,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
pbaspect([1 1 1])
alpha(obj_s, .5)

close all;
edges = 0:20:700;
obj_overlap_his = histogram(maxpeak_obj_binnumber,edges,'EdgeColor','#21ada5','FaceColor','#21ada5');
box off;
set(gca,'ylim',[0 100],'yTick',[50 100],'xlim',[0 700],'xTick',[0 200 400 600],  'FontName','Arial','LineWidth',2,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0])

close all;
o=circ_plot(circ_ang2rad(objectPeak),'hist',[],18,false,true,'linewidth',2,'color','r');
set(gca,'FontName','Arial','LineWidth',2,'FontSize',20)

[object_mean object_ul object_ll] =  circ_mean(circ_ang2rad(objectPeak));
object_mean = circ_rad2ang(object_mean);
object_ul   = circ_rad2ang(object_ul);
object_ll   =circ_rad2ang(object_ll);
upper = object_ul-object_mean;
object_rad = objectPeak;
object_stats      = circ_stats(object_rad);
object_std = circ_rad2ang(object_stats.std);
[pval_rayleigh_object, z_object,r_object] = circ_rtest(circ_ang2rad(objectPeak));
ray_r_object = r_object/size(objectPeak,1);
%--
binlength = 72; binsize = 5;
x = linspace(5 ,360 ,binlength);
geometery_r= geometeryCorr(objectPeak,binlength);
yy1 = smoothdata(geometery_r,'gaussian',10);
plot(x,yy1,'Color','#0366fc','LineWidth',2);box off;pbaspect([1 1 1]);
yticks([-0.3 0 0.3 0.6])
xticks([0 90 180 270 360])
% perform permutations
 binlength = 72; binsize = 5;
x = linspace(5 ,360 ,binlength);
geometery_r = geometeryCorr(objectPeak,binlength);
geometery_r_smooth = smoothdata(geometery_r,'gaussian',10);
plot(x,geometery_r_smooth,'Color','#0366fc','LineWidth',2);box off;pbaspect([1 1 1]);

highidx  = [18 36 54];%90;180;270
lowidx   = [9 27 45 63];%45,135,225,315
observed_geo_rotationScore =  min(geometery_r_smooth(highidx))-max(geometery_r_smooth(lowidx));%0.0724

permutations = 1000;
sample1_1 = objectPeak;
permutation.score_allpair = zeros(permutations,1);
for t = 1:permutations
    for i = 1:458
        randomsample2(i) = randperm(360,1)';
    end
    geometery_r_random = geometeryCorr(randomsample2,binlength);
    geometery_r_random_smooth = smoothdata(geometery_r_random,'gaussian',10);
    permutation.score_allpair(t) = min(geometery_r_random_smooth(highidx))-max(geometery_r_random_smooth(lowidx));
end
edges = -0.4:0.02:0.3;
close all
hh1 = histogram(permutation.score_allpair,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed_geo_rotationScore observed_geo_rotationScore],[0 160],'--','color','r','DisplayName',sprintf('Observed, p=0'));
pval_obj = length(find( permutation.score_allpair>observed_geo_rotationScore))/1000;% p = 0.031
xlabel('allLRD-geo-rotationScore')
ylabel('numberofcells')   
title(['pval=',num2str(pval_obj)])
set(gca,'ylim',[0 160], 'xlim', [-0.4 0.4], 'xTick',[-0.4 0 0.4],'yTick',[0 50 100 150],'FontName','Arial','LineWidth',1,'FontSize',12,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);
%%
cccc
addpath('D:\MatlabCode\gitlabsrc\domeanalysis\open_arena');
addpath('D:\MatlabCode\ImagingCode');
addpath('D:\MatlabCode\PlotplaceField\placefield2')
addpath('D:\MatlabCode\gitlabsrc\domeanalysis\packages')
addpath('D:\MatlabCode\gitlabsrc\domeanalysis\packages\CircStat2012a')
addpath('D:\MatlabCode\MyCode\Violinplot-Matlab-master')

load("LRDandPRD.mat")
xbounds_platform = 0:10:360;
ybounds_platform = 0:10:360;
maxpeak_plat_degree                                 = circ_ang2rad( allrat_plat_peak);
maxpeak_obj_degree                                  = circ_ang2rad( allrat_obj_peak);
platformPeak                                        = allrat_plat_peak;
objectPeak                                          = allrat_obj_peak;
maxpeak_obj_binnumber                               = allrat_obj_binc;
maxpeak_plat_binnumber                              = allrat_plat_binc;
%--
plat = platformPeak;
plat(isnan(plat)) = [];
binlength = 72;
x = linspace(5,360,binlength);
geometery_PRD_r = geometeryCorr(plat,binlength);
geometery_PRD_r_smooth = smoothdata(geometery_PRD_r,'gaussian',10);
highidx  = [18 36 54];%90;180;270
lowidx   = [9 27 45 63];%45,135,225,315
observed_geoRotationScore_PRD  = min(geometery_PRD_r_smooth(highidx))-max(geometery_PRD_r_smooth(lowidx));
plot(x,geometery_PRD_r_smooth,'Color','#0366fc','LineWidth',2)
box off;
yticks([-0.3 0 0.3 0.6])
xticks([0 90 180 270 360])
set(gca,'xlim',[0 360], 'ylim', [-0.4 0.7], 'FontName','Arial','LineWidth',2,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
pbaspect([1 1 1]);

%--perform permutations 4j
permutations = 1000;
sample1_1 = plat;
permutation.score_allpair = zeros(permutations,1);
for t = 1:permutations
    for i = 1:821
        randomsample2(i) = randperm(360,1)';
    end
    geometery_r_random = geometeryCorr(randomsample2,binlength);
    geometery_r_random_smooth = smoothdata(geometery_r_random,'gaussian',10);
    permutation.score_allpair(t) = min(geometery_r_random_smooth(highidx))-max(geometery_r_random_smooth(lowidx));
end
edges = [-0.4:0.02:0.3];
close all
hh1 = histogram(permutation.score_allpair,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed_geoRotationScore_PRD observed_geoRotationScore_PRD],[0 160],'--','color','r','DisplayName',sprintf('Observed, p=0'));
pval_obj = length(find( permutation.score_allpair>observed_geoRotationScore_PRD))/1000;% p = 0.031
xlabel('allLRD-geo-rotationScore')
ylabel('numberofcells')   
title(['pval=',num2str(pval_obj)])
set(gca,'ylim',[0 180], 'xlim', [-0.4 0.4],'xTick',[-0.4 0 0.4],'yTick',[0 50 100 150], 'FontName','Arial','LineWidth',1,'FontSize',12,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);