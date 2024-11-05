close all; clear all;
addpath('D:\MatlabCode\gitlabsrc\domeanalysis\open_arena');
% add circ package
addpath('D:\MatlabCode\gitlabsrc\domeanalysis\packages\CircStat2012a')
load ('LRD_and_PRD.mat');
difference_range1                               =  [-15,15];
difference_range2                               =  [-30,30];
difference_range3                               =  [-45;45];
difference_range4                               =  [-60;60];
for i = 1: size(objectPeak,1)
    if isnan(objectPeak(i))||isnan(platformPeak(i))
        objectPeak(i)   = nan;
        platformPeak(i) = nan;
    end
end

radobjectPeak                                   = circ_ang2rad(objectPeak);
radplatformPeak                                 = circ_ang2rad(platformPeak);
difference_allpair = zeros(size(objectPeak,1),1);
for i = 1:size(objectPeak,1)    
    difference_allpair(i) = (circ_rad2ang(circ_dist2(radplatformPeak(i) , radobjectPeak(i))));
end
%mm = hist(difference_allpair,edges)
permutations = 1000;
sample1_1                       =  circ_ang2rad(platformPeak);
sample2_1                       =  circ_ang2rad(objectPeak);
%--
observed.probability_allpair1   =  size(find( difference_allpair>difference_range1(1)&difference_allpair<difference_range1(2)),1)/size(objectPeak,1);
observed.probability_allpair2   =  size(find( difference_allpair>difference_range2(1)&difference_allpair<difference_range2(2)),1)/size(objectPeak,1);
observed.probability_allpair3   =  size(find( difference_allpair>difference_range3(1)&difference_allpair<difference_range3(2)),1)/size(objectPeak,1);
observed.probability_allpair4   =  size(find( difference_allpair>difference_range4(1)&difference_allpair<difference_range4(2)),1)/size(objectPeak,1);
permutation.difference_allpair = cell(size(objectPeak,1),1);
permutation.probability_allpair = zeros(permutations,1);
permutation.difference_allpairsum = [];
for i=1:permutations
    randomsample1 = sample1_1;
    permutationidx{i} = randperm(length(randomsample1));
    randomsample2 = sample2_1(permutationidx{i});
    permutation.difference_allpair{i} = zeros(size(randomsample1,1),1);
   
    for n = 1:size(randomsample2,1)
        permutation.difference_allpair{i}(n) = (circ_rad2ang(circ_dist2(randomsample1(n) , randomsample2(n))));
    end
    permutation.difference_allpairsum = [permutation.difference_allpairsum permutation.difference_allpair{i}];
    permutation.allpair_probability1(i) = size(find( permutation.difference_allpair{i}>difference_range1(1)&permutation.difference_allpair{i}<difference_range1(2)),1)/size(randomsample2,1);
    permutation.allpair_probability2(i) = size(find( permutation.difference_allpair{i}>difference_range2(1)&permutation.difference_allpair{i}<difference_range2(2)),1)/size(randomsample2,1);
    permutation.allpair_probability3(i) = size(find( permutation.difference_allpair{i}>difference_range3(1)&permutation.difference_allpair{i}<difference_range3(2)),1)/size(randomsample2,1);
    permutation.allpair_probability4(i) = size(find( permutation.difference_allpair{i}>difference_range4(1)&permutation.difference_allpair{i}<difference_range4(2)),1)/size(randomsample2,1);
end
permutation.pval_allpair1       = (length(find(permutation.allpair_probability1>observed.probability_allpair1))+1)/(permutations+1);
permutation.pval_allpair2       = (length(find(permutation.allpair_probability2>observed.probability_allpair2))+1)/(permutations+1);
permutation.pval_allpair3       = (length(find(permutation.allpair_probability3>observed.probability_allpair3))+1)/(permutations+1);
permutation.pval_allpair4       = (length(find(permutation.allpair_probability4>observed.probability_allpair4))+1)/(permutations+1);

%%
%--5c
close all
sz=22;
edges = -180:16:180;
edges_probaility = 0:0.01:1;
scatter(platformPeak,objectPeak,sz,'MarkerEdgeColor','#27c2a8', 'MarkerFaceColor','#27c2a8');
box on;
xlabel('PRD');ylabel('LRD');
set(gca, 'ylim',[0 400], 'xlim', [0 400],'FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
box off;pbaspect([1 1 1]);
yticks([0 90 180 270 360])
xticks([0 90 180 270 360])
%--
close all;
edges = 0:20:360;
hh1 = histogram(platformPeak,edges,'EdgeColor','k','FaceColor','#87898c');
box off;
yticks([0 100 200])
xticks([0 90 180 270 360])
set(gca,'ylim',[0 200],'xlim',[0 400],  'FontName','Arial','LineWidth',2,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
%--
close all;
hh2 = histogram(objectPeak,edges,'EdgeColor','k','FaceColor','#87898c');
box off;
yticks([0 50 100])
xticks([0 90 180 270 360])
set(gca,'ylim',[0 100],'xlim',[0 400],'FontName','Arial','LineWidth',2,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
%--
%5d
close all;
edges = [-180:15:180];
hh1 = histogram(difference_allpair,edges,'EdgeColor','#27c2a8','FaceColor','#27c2a8');
%xlabel('PRD-LRD');ylabel('Number of cells');
set(gca, 'ylim',[0 50], 'xlim', [-180 180], 'FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);
xticks([-90 0 90])
yticks([0 25 50])
box off;pbaspect([1 1 1]);

%%5e
close all;
sz=22;edges = [0:0.01:0.25];
edges_probaility = [0:0.01:1];
hh1 = histogram( permutation.allpair_probability1,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed.probability_allpair1 observed.probability_allpair1],[0 200],'--','color','r','DisplayName',sprintf(' '));
set(gca,'ylim',[0 300], 'xlim', [0 0.5], 'TickDir','in','FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);
yticks([ 100 200 300])
xticks([0 0.2 0.4])

title(['p=',num2str(permutation.pval_allpair1 )])
%--
close all
edges = [0:0.01:0.5];
hh2 = histogram( permutation.allpair_probability2,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed.probability_allpair2 observed.probability_allpair2],[0 300],'--','color','r','DisplayName',sprintf(' '));
set(gca,'ylim',[0 300], 'xlim', [0 0.5], 'TickDir','in','FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);
yticks([ 100 200 300])
xticks([0 0.2 0.4])
title(['p=',num2str(permutation.pval_allpair2)])
%---
close all
edges = [0:0.01:0.5];
hh2 = histogram( permutation.allpair_probability3,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed.probability_allpair3 observed.probability_allpair3],[0 300],'--','color','r','DisplayName',sprintf(' '));
set(gca,'ylim',[0 300], 'xlim', [0 0.5], 'TickDir','in','FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);
yticks([ 100 200 300])
xticks([0 0.2 0.4])
title(['p=',num2str(permutation.pval_allpair3)])
close all
edges = [0:0.01:0.5];
hh2 = histogram( permutation.allpair_probability4,edges,'EdgeColor','k','FaceColor','#87898c','DisplayName','Shuffled');hold on
pp = plot([observed.probability_allpair4 observed.probability_allpair4],[0 300],'--','color','r','DisplayName',sprintf(' '));
set(gca,'ylim',[0 300], 'xlim', [0 0.5], 'TickDir','in','FontName','Arial','LineWidth',1,'FontSize',20,'XColor',[0,0,0],'YColor',[0,0,0]);leg.FontSize = 18;
box off;pbaspect([1 1 1]);
yticks([ 100 200 300])
xticks([0 0.2 0.4])
title(['p=',num2str(permutation.pval_allpair4)])
%%
