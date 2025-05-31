% script to plot the horizontal pressure 


clear all;

lat = nc_varget('rita/CTL_d02_subset.nc','XLAT');
lon = nc_varget('rita/CTL_d02_subset.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

rita.ctl = load('rita_ctl.txt');
rita.m1 = load('rita_m1.txt');
rita.m2 = load('rita_m2.txt');
rita.m3 = load('rita_m3.txt');
rita.noanm = load('rita_noanm.txt');
rita.oml17 = load('rita_oml17.txt');
rita.oml70 = load('rita_oml70.txt');
rita.p1 = load('rita_p1.txt');
rita.p2 = load('rita_p2.txt');
rita.p3 = load('rita_p3.txt');

date = datetime(rita.ctl(:,1),rita.ctl(:,2),rita.ctl(:,3),rita.ctl(:,4),0,0);

landmask = double(nc_varget('rita_lsm.nc','LANDMASK'));
landmask = landmask.*-1 + 1;
lkm = double(nc_varget('lakemask.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

lm = landmask.*lkm; clear landmask lkm;


%% 

rita.p.ctl = double(nc_varget('rita/CTL_d02_subset.nc','PSFC'));
rita.p.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','PSFC'));
rita.p.m1 = double(nc_varget('rita/M1_d02_subset.nc','PSFC'));
rita.p.m2 = double(nc_varget('rita/M2_d02_subset.nc','PSFC'));
rita.p.m3 = double(nc_varget('rita/M3_d02_subset.nc','PSFC'));
rita.p.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','PSFC'));
rita.p.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','PSFC'));
rita.p.p1 = double(nc_varget('rita/P1_d02_subset.nc','PSFC'));
rita.p.p2 = double(nc_varget('rita/P2_d02_subset.nc','PSFC'));
rita.p.p3 = double(nc_varget('rita/P3_d02_subset.nc','PSFC'));

wilma.p.ctl = double(nc_varget('wilma/w_CTL.nc','PSFC'));
wilma.p.noanm = double(nc_varget('wilma/w_NOANM.nc','PSFC'));
wilma.p.m1 = double(nc_varget('wilma/w_M1.nc','PSFC'));
wilma.p.m2 = double(nc_varget('wilma/w_M2.nc','PSFC'));
wilma.p.m3 = double(nc_varget('wilma/w_M3.nc','PSFC'));
wilma.p.oml35 = double(nc_varget('wilma/w_OML35.nc','PSFC'));
wilma.p.oml100 = double(nc_varget('wilma/w_OML100.nc','PSFC'));
wilma.p.p1 = double(nc_varget('wilma/w_P1.nc','PSFC'));
wilma.p.p2 = double(nc_varget('wilma/w_P2.nc','PSFC'));
wilma.p.p3 = double(nc_varget('wilma/w_P3.nc','PSFC'));

%% take the pressure at the latitude of min CSLP
%
% couldnt reverse find the indices of min pressure
% ....manual input
% plot surface pressure for 300 km radius
% 


radi = 240;
mod = radi/3; 

% ...RITA...
% ctl (545,287)
cslp.r.ctl = squeeze(rita.p.ctl(21, 545, (287-mod):(287+mod)));
% m1 (583,246)
cslp.r.m1 = squeeze(rita.p.m1(24, 583, (246-mod):(246+mod)));
% m2 (575,234)
cslp.r.m2 = squeeze(rita.p.m2(24, 575, (234-mod):(234+mod)));
% m3 (636,155)
cslp.r.m3 = squeeze(rita.p.m3(29, 636, (155-mod):(155+mod)));
% noanm (548,279)
cslp.r.noanm = squeeze(rita.p.noanm(21, 548, (279-mod):(279+mod)));
% oml17 (552,292)
cslp.r.oml17 = squeeze(rita.p.oml17(21, 552, (292-mod):(292+mod)));
% oml70 (544,283)
cslp.r.oml70 = squeeze(rita.p.oml70(21, 544, (283-mod):(283+mod)));
% p1 (536,289)
cslp.r.p1 = squeeze(rita.p.p1(21, 536, (289-mod):(289+mod)));
% p2 (599,186)
cslp.r.p2 = squeeze(rita.p.p2(28, 599, (186-mod):(186+mod)));
% p3 (591,177)
cslp.r.p3 = squeeze(rita.p.p3(28, 591, (177-mod):(177+mod)));

% ...WILMA...
% ctl (321,458)
cslp.w.ctl = squeeze(wilma.p.ctl(24, 321, (458-mod):(458+mod)));
% m1 (357,483)
cslp.w.m1 = squeeze(wilma.p.m1(25, 357, (483-mod):(483+mod)));
% m2 (345,475)
cslp.w.m2 = squeeze(wilma.p.m2(25, 345, (475-mod):(475+mod)));
% m3 (359,439)
cslp.w.m3 = squeeze(wilma.p.m3(27, 359, (439-mod):(439+mod)));
% noanm (346,485)
cslp.w.noanm = squeeze(wilma.p.noanm(24, 346, (485-mod):(485+mod)));
% oml35 (318,474)
cslp.w.oml35 = squeeze(wilma.p.oml35(23, 318, (474-mod):(474+mod)));
% oml100 (360,458)
cslp.w.oml100 = squeeze(wilma.p.oml100(26, 360, (458-mod):(458+mod)));
% p1 (285,460)
cslp.w.p1 = squeeze(wilma.p.p1(21, 285, (460-mod):(460+mod)));
% p2 (303,437)
cslp.w.p2 = squeeze(wilma.p.p2(22, 303, (437-mod):(437+mod)));
% p3 (284,440)
cslp.w.p3 = squeeze(wilma.p.p3(21, 284, (440-mod):(440+mod)));

% ...RITA with full third-index range...
cslp_full.r.ctl = squeeze(rita.p.ctl(21, 545, 1:end));
cslp_full.r.m1  = squeeze(rita.p.m1(24, 583, 1:end));
cslp_full.r.m2  = squeeze(rita.p.m2(24, 575, 1:end));
cslp_full.r.m3  = squeeze(rita.p.m3(29, 636, 1:end));
cslp_full.r.noanm = squeeze(rita.p.noanm(21, 548, 1:end));
cslp_full.r.oml17 = squeeze(rita.p.oml17(21, 552, 1:end));
cslp_full.r.oml70 = squeeze(rita.p.oml70(21, 544, 1:end));
cslp_full.r.p1    = squeeze(rita.p.p1(21, 536, 1:end));
cslp_full.r.p2    = squeeze(rita.p.p2(28, 599, 1:end));
cslp_full.r.p3    = squeeze(rita.p.p3(28, 591, 1:end));

% ...WILMA with full third-index range...
cslp_full.w.ctl = squeeze(wilma.p.ctl(24, 321, 1:end));
cslp_full.w.m1  = squeeze(wilma.p.m1(25, 357, 1:end));
cslp_full.w.m2  = squeeze(wilma.p.m2(25, 345, 1:end));
cslp_full.w.m3  = squeeze(wilma.p.m3(27, 359, 1:end));
cslp_full.w.noanm = squeeze(wilma.p.noanm(24, 346, 1:end));
cslp_full.w.oml35 = squeeze(wilma.p.oml35(23, 318, 1:end));
cslp_full.w.oml100 = squeeze(wilma.p.oml100(26, 360, 1:end));
cslp_full.w.p1    = squeeze(wilma.p.p1(21, 285, 1:end));
cslp_full.w.p2    = squeeze(wilma.p.p2(22, 303, 1:end));
cslp_full.w.p3    = squeeze(wilma.p.p3(21, 284, 1:end));


%% plotting 

colors = distinguishable_colors(10,'k');

fig1 = figure;
fig1.Position = [182 271 1355 498];
rad = -radi:3:radi;

tiledlayout(1,2);

nexttile
plot(rad,cslp.r.ctl./100,'Color',colors(1,:),'LineWidth',2); hold on;
plot(rad,cslp.r.m1./100,'Color',colors(2,:),'LineWidth',2);
plot(rad,cslp.r.m2./100,'Color',colors(3,:),'LineWidth',2);
plot(rad,cslp.r.m3./100,'Color',colors(4,:),'LineWidth',2);
plot(rad,cslp.r.noanm./100,'Color',colors(5,:),'LineWidth',2);
plot(rad,cslp.r.oml17./100,'Color',colors(6,:),'LineWidth',2);
plot(rad,cslp.r.oml70./100,'Color',colors(7,:),'LineWidth',2);
plot(rad,cslp.r.p1./100,'Color',colors(8,:),'LineWidth',2);
plot(rad,cslp.r.p2./100,'Color',colors(9,:),'LineWidth',2);
plot(rad,cslp.r.p3./100,'Color',colors(10,:),'LineWidth',2);
ylim([840 1020])
xlim([-radi radi])
title('Hurricane Rita','FontSize',14)
ylabel('Surface Pressure (hPa)')
xlabel('Radial distance (km)')
legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',...
    ' OML17',' OML70',' +1\circC',' +2\circC',' +3\circC','location',...
    'southeast','FontSize',12)

nexttile
plot(rad,cslp.w.ctl./100,'Color',colors(1,:),'LineWidth',2); hold on;
plot(rad,cslp.w.m1./100,'Color',colors(2,:),'LineWidth',2);
plot(rad,cslp.w.m2./100,'Color',colors(3,:),'LineWidth',2);
plot(rad,cslp.w.m3./100,'Color',colors(4,:),'LineWidth',2);
plot(rad,cslp.w.noanm./100,'Color',colors(5,:),'LineWidth',2);
plot(rad,cslp.w.oml35./100,'Color',colors(6,:),'LineWidth',2);
plot(rad,cslp.w.oml100./100,'Color',colors(7,:),'LineWidth',2);
plot(rad,cslp.w.p1./100,'Color',colors(8,:),'LineWidth',2);
plot(rad,cslp.w.p2./100,'Color',colors(9,:),'LineWidth',2);
plot(rad,cslp.w.p3./100,'Color',colors(10,:),'LineWidth',2);
ylim([840 1020])
xlim([-radi radi])
title('Hurricane Wilma','FontSize',14)
ylabel('Surface Pressure (hPa)')
xlabel('Radial distance (km)')
legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',...
    ' OML35',' OML100',' +1\circC',' +2\circC',' +3\circC','location',...
    'southeast','FontSize',12)

print('PSFC_gradient','-djpeg','-r400',fig1);


% fig1 = figure;
% fig1.Position = [182 271 1355 498];
% 
% tiledlayout(1,2);
% 
% nexttile
% plot(cslp_full.r.ctl./100, 'Color', colors(1,:), 'LineWidth', 2); hold on;
% plot(cslp_full.r.m1./100,  'Color', colors(2,:), 'LineWidth', 2);
% plot(cslp_full.r.m2./100,  'Color', colors(3,:), 'LineWidth', 2);
% plot(cslp_full.r.m3./100,  'Color', colors(4,:), 'LineWidth', 2);
% plot(cslp_full.r.noanm./100,'Color', colors(5,:), 'LineWidth', 2);
% plot(cslp_full.r.oml17./100,'Color', colors(6,:), 'LineWidth', 2);
% plot(cslp_full.r.oml70./100,'Color', colors(7,:), 'LineWidth', 2);
% plot(cslp_full.r.p1./100,   'Color', colors(8,:), 'LineWidth', 2);
% plot(cslp_full.r.p2./100,   'Color', colors(9,:), 'LineWidth', 2);
% plot(cslp_full.r.p3./100,   'Color', colors(10,:),'LineWidth', 2);
% ylim([840 1020])
% title('Hurricane Rita','FontSize',14)
% ylabel('Surface Pressure (hPa)')
% xlabel('Index')
% legend('Control','-1\circC','-2\circC','-3\circC','No Anomaly',...
%     '1/2 OMLD','2*OMLD','+1\circC','+2\circC','+3\circC',...
%     'Location','southeast','FontSize',12)
% 
% nexttile
% plot(cslp_full.w.ctl./100, 'Color', colors(1,:), 'LineWidth', 2); hold on;
% plot(cslp_full.w.m1./100,  'Color', colors(2,:), 'LineWidth', 2);
% plot(cslp_full.w.m2./100,  'Color', colors(3,:), 'LineWidth', 2);
% plot(cslp_full.w.m3./100,  'Color', colors(4,:), 'LineWidth', 2);
% plot(cslp_full.w.noanm./100,'Color', colors(5,:), 'LineWidth', 2);
% plot(cslp_full.w.oml35./100,'Color', colors(6,:), 'LineWidth', 2);
% plot(cslp_full.w.oml100./100,'Color', colors(7,:), 'LineWidth', 2);
% plot(cslp_full.w.p1./100,   'Color', colors(8,:), 'LineWidth', 2);
% plot(cslp_full.w.p2./100,   'Color', colors(9,:), 'LineWidth', 2);
% plot(cslp_full.w.p3./100,   'Color', colors(10,:),'LineWidth', 2);
% ylim([840 1020])
% title('Hurricane Wilma','FontSize',14)
% ylabel('Surface Pressure (hPa)')
% xlabel('Index')
% legend('Control','-1\circC','-2\circC','-3\circC','No Anomaly',...
%     '1/2 OMLD','1.4*OMLD','+1\circC','+2\circC','+3\circC',...
%     'Location','southeast','FontSize',12)



