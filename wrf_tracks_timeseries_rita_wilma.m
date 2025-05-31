% rita timeseries compare

clear all;

rita = struct();
wilma = struct();

% import wrf data
rita.ctl = load('rita_ctl.txt');
rita.m1 = load('rita_M1.txt');
rita.m2 = load('rita_M2.txt');
rita.m3 = load('rita_M3.txt');
rita.noanm = load('rita_noanm.txt');
rita.oml17 = load('rita_oml17.txt');
rita.oml70 = load('rita_oml70.txt');
rita.p1 = load('rita_P1.txt');
rita.p2 = load('rita_P2.txt');
rita.p3 = load('rita_P3.txt');

wilma.ctl = load('wilma_ctl.txt');
wilma.m1 = load('wilma_m1.txt');
wilma.m2 = load('wilma_m2.txt');
wilma.m3 = load('wilma_m3.txt');
wilma.noanm = load('wilma_noanm.txt');
wilma.oml35 = load('wilma_oml35.txt');
wilma.oml100 = load('wilma_oml100.txt');
wilma.p1 = load('wilma_p1.txt');
wilma.p2 = load('wilma_p2.txt');
wilma.p3 = load('wilma_p3.txt');

% import noaa data
rita.hurdat = import_gulf_extract('rita_hurdat.txt');
wilma.hurdat = import_gulf_extract('wilma_hurdat.txt');

%% define domains

% % rita nested domain coordinates
% rlat2_n = 32.0553;
% rlat2_s = 10.6843;
% rlon2_e = -69.6862;
% rlon2_w = -100.0345;
% 
% % rita outer domain coordinates
% rlat1_n = 35.4238;
% rlat1_s = 6.0253;
% rlon1_e = -63.5416;
% rlon1_w = -105.9005;

% % wilma nested domain coordinates
% lat2_n = 31.7356;
% lat2_s = 10.678;
% lon2_e = -70.614;
% lon2_w = -98.8278;

%% make dates

% date
rita.date = datetime(rita.ctl(:,1),rita.ctl(:,2),rita.ctl(:,3),rita.ctl(:,4),0,0);
rita.dateHU = datetime(rita.hurdat{11:31,2},rita.hurdat{11:31,3},rita.hurdat{11:31,4},rita.hurdat{11:31,5},0,0);

wilma.date = datetime(wilma.ctl(:,1),wilma.ctl(:,2),wilma.ctl(:,3),wilma.ctl(:,4),0,0);
wilma.dateHU = datetime(wilma.hurdat{10:27,2},wilma.hurdat{10:27,3},wilma.hurdat{10:27,4},wilma.hurdat{10:27,5},0,0);

% hurdat deepening
rita.hurDR = get_bergeron_6hr(rita.hurdat{11:31,11},24);
wilma.hurDR = get_bergeron_6hr(wilma.hurdat{10:27,11},24);


%% Tracks plotting

colors = distinguishable_colors(10,'k');
% colors = turbo(10);

latlim = [10.7 32.1];
lonlim = [-100 -70];

fig1 = figure(1);
fig1.Position = [182 271 800 700];
gx = geoaxes;

geoplot(rita.ctl(1:35,5),rita.ctl(1:35,6),'Color',colors(1,:),'LineWidth',2); hold on;
geoplot(rita.m1(1:34,5),rita.m1(1:34,6),'Color',colors(2,:),'LineWidth',2);
geoplot(rita.m2(1:34,5),rita.m2(1:34,6),'Color',colors(3,:),'LineWidth',2);
geoplot(rita.m3(1:35,5),rita.m3(1:35,6),'Color',colors(4,:),'LineWidth',2);
geoplot(rita.noanm(1:34,5),rita.noanm(1:34,6),'Color',colors(5,:),'LineWidth',2);
geoplot(rita.oml17(1:34,5),rita.oml17(1:34,6),'Color',colors(6,:),'LineWidth',2);
geoplot(rita.oml70(:,5),rita.oml70(:,6),'Color',colors(7,:),'LineWidth',2);
geoplot(rita.p1(:,5),rita.p1(:,6),'Color',colors(8,:),'LineWidth',2);
geoplot(rita.p2(:,5),rita.p2(:,6),'Color',colors(9,:),'LineWidth',2);
geoplot(rita.p3(:,5),rita.p3(:,6),'Color',colors(10,:),'LineWidth',2);
geoplot(rita.hurdat{11:29,8},rita.hurdat{11:29,9},'k','LineStyle',':','LineWidth',2);


geoplot(wilma.ctl(:,5),wilma.ctl(:,6),'Color',colors(1,:),'LineWidth',2); hold on;
geoplot(wilma.m1(:,5),wilma.m1(:,6),'Color',colors(2,:),'LineWidth',2);
geoplot(wilma.m2(:,5),wilma.m2(:,6),'Color',colors(3,:),'LineWidth',2);
geoplot(wilma.m3(:,5),wilma.m3(:,6),'Color',colors(4,:),'LineWidth',2);
geoplot(wilma.noanm(:,5),wilma.noanm(:,6),'Color',colors(5,:),'LineWidth',2);
geoplot(wilma.oml35(:,5),wilma.oml35(:,6),'Color',colors(6,:),'LineWidth',2);
geoplot(wilma.oml100(:,5),wilma.oml100(:,6),'Color',colors(7,:),'LineWidth',2);
geoplot(wilma.p1(:,5),wilma.p1(:,6),'Color',colors(8,:),'LineWidth',2);
geoplot(wilma.p2(:,5),wilma.p2(:,6),'Color',colors(9,:),'LineWidth',2);
geoplot(wilma.p3(:,5),wilma.p3(:,6),'Color',colors(10,:),'LineWidth',2);
geoplot(wilma.hurdat{10:27,8},wilma.hurdat{10:27,9},'k','LineStyle',':','LineWidth',2);

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)

geobasemap none


legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',' 1/2 OMLD',' 2*OMLD',' +1\circC',' +2\circC',' +3\circC'...
    ,' NOAA Obs.','location','northeast','FontSize',14)
gx.FontSize = 15;

geolimits([10.7 32.1],[-100 -70])

% Create annotation text boxes for mean track errors

% Rita error strings
ritaErrors = { ...
    'Rita Mean Errors:', ...
    'Control: 92.30 km', ...
    '-1°C: 80.64 km', ...
    '-2°C: 98.76 km', ...
    '-3°C: 114.67 km', ...
    'No Anomaly: 104.31 km', ...
    '1/2 OMLD: 91.11 km', ...
    '2*OMLD: 91.13 km', ...
    '+1°C: 102.66 km', ...
    '+2°C: 117.00 km', ...
    '+3°C: 128.93 km' ...
};

% Wilma error strings
wilmaErrors = { ...
    'Wilma Mean Errors:', ...
    'Control: 64.79 km', ...
    '-1°C: 120.13 km', ...
    '-2°C: 97.61 km', ...
    '-3°C: 76.10 km', ...
    'No Anomaly: 118.42 km', ...
    '1/2 OMLD: 81.03 km', ...
    '2*OMLD: 91.12 km', ...
    '+1°C: 78.70 km', ...
    '+2°C: 91.26 km', ...
    '+3°C: 101.64 km' ...
};

% Create annotation boxes at desired positions
% Adjust the position values [x y width height] as needed
annotation('textbox',[0.02, 0.02, 0.3, 0.3], ...
    'String', ritaErrors, ...
    'FitBoxToText', 'on', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black', ...
    'FontSize', 10);

annotation('textbox',[0.65, 0.02, 0.3, 0.3], ...
    'String', wilmaErrors, ...
    'FitBoxToText', 'on', ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black', ...
    'FontSize', 10);


% print('tracks2','-djpeg','-r200',fig1);

%% Rita


fig3 = figure(3);
fig3.Position = [182 271 1500 800];

tld = tiledlayout(2,3);

% ....rita......
nexttile
plot(rita.date(1:34),rita.ctl(1:34,8),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:34),rita.m1(1:34,8),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:34),rita.m2(1:34,8),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:34),rita.m3(1:34,8),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:34),rita.noanm(1:34,8),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml17(1:34,8),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml70(1:34,8),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:34),rita.p1(1:34,8),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:34),rita.p2(1:34,8),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:34),rita.p3(1:34,8),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-1),rita.hurdat{11:30,11},'k','LineStyle',':','LineWidth',2);
ylabel('Min. Pressure (hPa)','FontSize',14)
ylim([870 1000])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

nexttile
plot(rita.date(1:34),rita.ctl(1:34,7),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:34),rita.m1(1:34,7),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:34),rita.m2(1:34,7),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:34),rita.m3(1:34,7),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:34),rita.noanm(1:34,7),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml17(1:34,7),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml70(1:34,7),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:34),rita.p1(1:34,7),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:34),rita.p2(1:34,7),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:34),rita.p3(1:34,7),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-1),rita.hurdat{11:30,10}.*.5144,'k','LineStyle',':','LineWidth',2);
ylabel('Max Wind Speed (m s^{-1})','FontSize',14)
ylim([15 82])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

nexttile
plot(rita.date(1:31),rita.ctl(1:31,9),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:31),rita.m1(1:31,9),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:31),rita.m2(1:31,9),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:31),rita.m3(1:31,9),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:31),rita.noanm(1:31,9),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:31),rita.oml17(1:31,9),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:31),rita.oml70(1:31,9),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:31),rita.p1(1:31,9),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:31),rita.p2(1:31,9),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:31),rita.p3(1:31,9),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-4),rita.hurDR(1:end-4),'k','LineStyle',':','LineWidth',2);
ylabel('DR (bergeron)','FontSize',14)
ylim([-1.75 2])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

% legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',' 1/2 OMLD',' 2*OMLD',' +1\circC',' +2\circC',' +3\circC'...
%     ,' NOAA Obs.','location','northeast','FontSize',16)

nexttile
plot(rita.date(2:34),rita.ctl(2:34,10),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(2:34),rita.m1(2:34,10),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(2:34),rita.m2(2:34,10),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(2:34),rita.m3(2:34,10),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(2:34),rita.noanm(2:34,10),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml17(2:34,10),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml70(2:34,10),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(2:34),rita.p1(2:34,10),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(2:34),rita.p2(2:34,10),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(2:34),rita.p3(2:34,10),'Color',colors(10,:),'LineWidth',2);
ylabel('Max Surface Heat Flux (W m^{-2})','FontSize',14)
ylim([0 8000])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

nexttile
plot(rita.date(2:34),rita.ctl(2:34,12),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(2:34),rita.m1(2:34,12),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(2:34),rita.m2(2:34,12),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(2:34),rita.m3(2:34,12),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(2:34),rita.noanm(2:34,12),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml17(2:34,12),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml70(2:34,12),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(2:34),rita.p1(2:34,12),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(2:34),rita.p2(2:34,12),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(2:34),rita.p3(2:34,12),'Color',colors(10,:),'LineWidth',2);
ylabel('330km Surface Heat (10^{12}W)','FontSize',14)
ylim([0 800])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

nexttile
plot(rita.date(2:34),rita.ctl(2:34,11),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(2:34),rita.m1(2:34,11),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(2:34),rita.m2(2:34,11),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(2:34),rita.m3(2:34,11),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(2:34),rita.noanm(2:34,11),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml17(2:34,11),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(2:34),rita.oml70(2:34,11),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(2:34),rita.p1(2:34,11),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(2:34),rita.p2(2:34,11),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(2:34),rita.p3(2:34,11),'Color',colors(10,:),'LineWidth',2);
ylabel('Accum. Grid Scale Precip. (mm)','FontSize',14)
ylim([50 1200])
% xlim([rita.date(1) rita.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 14;

% title(tld,'\bf WRF Simulation Results - Rita','FontSize',16)
% print('wrf_vals_rita','-dpng','-r1200',fig3);

%% wilma


fig4 = figure(4);
fig4.Position = [182 271 1500 800];

tld = tiledlayout(2,3);

nexttile
plot(wilma.date,wilma.ctl(:,8),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,8),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,8),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,8),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,8),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,8),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,8),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,8),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,8),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,8),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU,wilma.hurdat{10:27,11},'k','LineStyle',':','LineWidth',2);
ylabel('Min. Pressure (hPa)','FontSize',16)
ylim([850 1000])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(wilma.date,wilma.ctl(:,7),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,7),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,7),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,7),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,7),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,7),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,7),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,7),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,7),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,7),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU,wilma.hurdat{10:27,10}.*.5144,'k','LineStyle',':','LineWidth',2);
ylabel('Max Wind Speed (m s^{-1})','FontSize',16)
ylim([15 82])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(wilma.date,wilma.ctl(:,9),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,9),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,9),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,9),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,9),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,9),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,9),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,9),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,9),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,9),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU(3:15),wilma.hurDR(3:15),'k','LineStyle',':','LineWidth',2);
ylabel('DR (bergeron)','FontSize',16)
ylim([-1.75 3])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

% legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',' 1/2 OMLD',' 2*OMLD',' +1\circC',' +2\circC',' +3\circC'...
%     ,' NOAA Obs.','location','northeast','FontSize',16)

nexttile
plot(wilma.date(2:end),wilma.ctl(2:end,10),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date(2:end),wilma.m1(2:end,10),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m2(2:end,10),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m3(2:end,10),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.noanm(2:end,10),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml35(2:end,10),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml100(2:end,10),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p1(2:end,10),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p2(2:end,10),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p3(2:end,10),'Color',colors(10,:),'LineWidth',2);
ylabel('Max Surface Heat Flux (W m^{-2})','FontSize',16)
ylim([0 10600])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(wilma.date(2:end),wilma.ctl(2:end,12),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date(2:end),wilma.m1(2:end,12),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m2(2:end,12),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m3(2:end,12),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.noanm(2:end,12),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml35(2:end,12),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml100(2:end,12),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p1(2:end,12),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p2(2:end,12),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p3(2:end,12),'Color',colors(10,:),'LineWidth',2);
ylabel('330km Surface Heat (10^{12}W)','FontSize',16)
ylim([0 800])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(wilma.date(2:end),wilma.ctl(2:end,11),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date(2:end),wilma.m1(2:end,11),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m2(2:end,11),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.m3(2:end,11),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.noanm(2:end,11),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml35(2:end,11),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.oml100(2:end,11),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p1(2:end,11),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p2(2:end,11),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date(2:end),wilma.p3(2:end,11),'Color',colors(10,:),'LineWidth',2);
ylabel('Accum. Grid Scale Precip. (mm)','FontSize',16)
ylim([50 1500])
% xlim([wilma.date(1) wilma.date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

% title(tld,'WRF Simulation Results - Wilma','FontSize',16)

% print('wrf_vals_wilma','-dpng','-r1200',fig4);

%% Rita and Wilma


fig5 = figure(5);
fig5.Position = [182 271 1500 800];

tld = tiledlayout(2,3);



% ....rita......
nexttile
plot(rita.date(1:34),rita.ctl(1:34,8),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:34),rita.m1(1:34,8),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:34),rita.m2(1:34,8),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:34),rita.m3(1:34,8),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:34),rita.noanm(1:34,8),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml17(1:34,8),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml70(1:34,8),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:34),rita.p1(1:34,8),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:34),rita.p2(1:34,8),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:34),rita.p3(1:34,8),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-1),rita.hurdat{11:30,11},'k','LineStyle',':','LineWidth',2);
ylabel('Min. Pressure (hPa)','FontSize',14)
ylim([850 1000])
datetick('x',6)
xlim([rita.date(1) rita.date(end-3)])
grid on;
ax = gca;
ax.FontSize = 14;

nexttile
plot(rita.date(1:34),rita.ctl(1:34,7),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:34),rita.m1(1:34,7),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:34),rita.m2(1:34,7),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:34),rita.m3(1:34,7),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:34),rita.noanm(1:34,7),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml17(1:34,7),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:34),rita.oml70(1:34,7),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:34),rita.p1(1:34,7),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:34),rita.p2(1:34,7),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:34),rita.p3(1:34,7),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-1),rita.hurdat{11:30,10}.*.5144,'k','LineStyle',':','LineWidth',2);
ylabel('Max Wind Speed (m s^{-1})','FontSize',14)
ylim([15 82])
datetick('x',6)
xlim([rita.date(1) rita.date(end-3)])
grid on;
ax = gca;
ax.FontSize = 14;
title('Hurricane Rita', 'FontSize', 24, 'FontWeight', 'bold')

nexttile
plot(rita.date(1:31),rita.ctl(1:31,9),'Color',colors(1,:),'LineWidth',2); hold on;
plot(rita.date(1:31),rita.m1(1:31,9),'Color',colors(2,:),'LineWidth',2);
plot(rita.date(1:31),rita.m2(1:31,9),'Color',colors(3,:),'LineWidth',2);
plot(rita.date(1:31),rita.m3(1:31,9),'Color',colors(4,:),'LineWidth',2);
plot(rita.date(1:31),rita.noanm(1:31,9),'Color',colors(5,:),'LineWidth',2);
plot(rita.date(1:31),rita.oml17(1:31,9),'Color',colors(6,:),'LineWidth',2);
plot(rita.date(1:31),rita.oml70(1:31,9),'Color',colors(7,:),'LineWidth',2);
plot(rita.date(1:31),rita.p1(1:31,9),'Color',colors(8,:),'LineWidth',2);
plot(rita.date(1:31),rita.p2(1:31,9),'Color',colors(9,:),'LineWidth',2);
plot(rita.date(1:31),rita.p3(1:31,9),'Color',colors(10,:),'LineWidth',2);
plot(rita.dateHU(1:end-4),rita.hurDR(1:end-4),'k','LineStyle',':','LineWidth',2);
ylabel('DR (bergeron)','FontSize',14)
ylim([-1.75 3])
datetick('x',6)
xlim([rita.date(1) rita.date(end-3)])
grid on;
ax = gca;
ax.FontSize = 14;
legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',...
    ' 1/2 OMLD',' 2*OMLD',' +1\circC',' +2\circC',' +3\circC'...
    ,' NOAA Obs.','location','northeast','FontSize',15)



nexttile
plot(wilma.date,wilma.ctl(:,8),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,8),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,8),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,8),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,8),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,8),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,8),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,8),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,8),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,8),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU,wilma.hurdat{10:27,11},'k','LineStyle',':','LineWidth',2);
ylabel('Min. Pressure (hPa)','FontSize',16)
ylim([850 1000])
datetick('x',6)
xlim([wilma.date(1) wilma.date(end)])
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(wilma.date,wilma.ctl(:,7),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,7),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,7),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,7),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,7),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,7),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,7),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,7),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,7),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,7),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU,wilma.hurdat{10:27,10}.*.5144,'k','LineStyle',':','LineWidth',2);
ylabel('Max Wind Speed (m s^{-1})','FontSize',16)
ylim([15 82])
datetick('x',6)
xlim([wilma.date(1) wilma.date(end)])
grid on;
ax = gca;
ax.FontSize = 15;
title('Hurricane Wilma', 'FontSize', 24, 'FontWeight', 'bold')


nexttile
plot(wilma.date,wilma.ctl(:,9),'Color',colors(1,:),'LineWidth',2); hold on;
plot(wilma.date,wilma.m1(:,9),'Color',colors(2,:),'LineWidth',2);
plot(wilma.date,wilma.m2(:,9),'Color',colors(3,:),'LineWidth',2);
plot(wilma.date,wilma.m3(:,9),'Color',colors(4,:),'LineWidth',2);
plot(wilma.date,wilma.noanm(:,9),'Color',colors(5,:),'LineWidth',2);
plot(wilma.date,wilma.oml35(:,9),'Color',colors(6,:),'LineWidth',2);
plot(wilma.date,wilma.oml100(:,9),'Color',colors(7,:),'LineWidth',2);
plot(wilma.date,wilma.p1(:,9),'Color',colors(8,:),'LineWidth',2);
plot(wilma.date,wilma.p2(:,9),'Color',colors(9,:),'LineWidth',2);
plot(wilma.date,wilma.p3(:,9),'Color',colors(10,:),'LineWidth',2);
plot(wilma.dateHU(3:15),wilma.hurDR(3:15),'k','LineStyle',':','LineWidth',2);
ylabel('DR (bergeron)','FontSize',16)
ylim([-1.75 3])
datetick('x',6)
xlim([wilma.date(1) wilma.date(end)])
grid on;
ax = gca;
ax.FontSize = 15;


%%

% Earth radius in kilometers for the haversine formula
R = 6371; 

%% Mean Track Errors for Hurricane Rita
% Earth radius in kilometers for the haversine formula
R = 6371; 

%% Mean Track Errors for Hurricane Rita
% Define rows to use for Rita observations, skipping rows 18 and 28
% Earth radius and other constants are no longer needed here since haversine handles distance computation

%% Mean Track Errors for Hurricane Rita
% Define rows to use for Rita observations, skipping rows 18 and 28
obsRowsR = [11:17, 19:27, 29];
obsLon = table2array(rita.hurdat(obsRowsR,9));  % Longitude values, skipping 18 and 28
obsLat = table2array(rita.hurdat(obsRowsR,8));  % Latitude values, skipping 18 and 28
nObs = length(obsLat);

% List of simulation field names to compare for Rita
simNames = {'ctl','m1','m2','m3','noanm','oml17','oml70','p1','p2','p3'};

fprintf('Mean Track Errors for Hurricane Rita:\n');
for k = 1:length(simNames)
    field = simNames{k};
    simData = rita.(field);

    % Check if simulation data has enough points for 6-hourly comparison
    if size(simData,1) < 2*nObs
        fprintf('Simulation %s has fewer than %d points for 6-hourly comparison. Skipping.\n', field, 2*nObs);
        continue;
    end

    % Select every second simulation point to match the 6-hourly intervals
    indices = 1:2:(2*nObs);
    simLon = simData(indices,6);  
    simLat = simData(indices,5);  

    % Calculate distances using the haversine function for each time step
    distances = zeros(nObs,1);
    for i = 1:nObs
        distances(i) = haversine([obsLat(i), obsLon(i)], [simLat(i), simLon(i)]);
    end

    % Calculate and display mean track error for this simulation
    meanError = mean(distances);
    fprintf('Mean track error for simulation %s: %.2f km\n', field, meanError);
end

%% Mean Track Errors for Hurricane Wilma
% Define rows to use for Wilma observations, skipping rows 26 and 28 as specified
obsRowsW = [10:25];  % skipping row 26 (and 28 if outside range)
obsLonW = table2array(wilma.hurdat(obsRowsW,9));
obsLatW = table2array(wilma.hurdat(obsRowsW,8));
nObsW = length(obsLatW);

% List of simulation field names for Wilma
simNamesW = {'ctl','m1','m2','m3','noanm','oml35','oml100','p1','p2','p3'};

fprintf('\nMean Track Errors for Hurricane Wilma:\n');
for k = 1:length(simNamesW)
    field = simNamesW{k};
    simData = wilma.(field);

    % Check if simulation data has enough points for 6-hourly comparison
    if size(simData,1) < 2*nObsW
        fprintf('Simulation %s has fewer than %d points for 6-hourly comparison. Skipping.\n', field, 2*nObsW);
        continue;
    end

    % Select every second simulation point for Wilma
    indicesW = 1:2:(2*nObsW);
    simLon = simData(indicesW,6);  
    simLat = simData(indicesW,5);  

    % Calculate distances using haversine for each time step
    distances = zeros(nObsW,1);
    for i = 1:nObsW
        distances(i) = haversine([obsLatW(i), obsLonW(i)], [simLat(i), simLon(i)]);
    end

    % Calculate and display mean track error for this simulation
    meanError = mean(distances);
    fprintf('Mean track error for simulation %s: %.2f km\n', field, meanError);
end


%% track error figure

% Define rows to use for Rita observations, skipping rows 18 and 28
obsRowsR = [11:17, 19:27, 29];
obsLon = table2array(rita.hurdat(obsRowsR,9));  % Longitude values, skipping 18 and 28
obsLat = table2array(rita.hurdat(obsRowsR,8));  % Latitude values, skipping 18 and 28
nObs = length(obsLat);

% List of simulation field names to compare for Rita
simNames = {'ctl','m1','m2','m3','noanm','oml17','oml70','p1','p2','p3'};

% Initialize matrix to store time series of track errors for each simulation
timeseriesErrorsR = zeros(nObs, length(simNames));

for k = 1:length(simNames)
    field = simNames{k};
    simData = rita.(field);

    % Check if simulation data has enough points for 6-hourly comparison
    if size(simData,1) < 2*nObs
        fprintf('Simulation %s has fewer than %d points for 6-hourly comparison. Skipping.\n', field, 2*nObs);
        continue;
    end

    % Select every second simulation point to match the 6-hourly intervals
    indices = 1:2:(2*nObs);
    simLon = simData(indices,6);  % Assuming column 5 is longitude
    simLat = simData(indices,5);  % Assuming column 6 is latitude

    % Calculate distances for each time step using haversine
    distances = zeros(nObs,1);
    for i = 1:nObs
        distances(i) = haversine([obsLat(i), obsLon(i)], [simLat(i), simLon(i)]);
    end
    
    % Store the time series for this simulation
    timeseriesErrorsR(:, k) = distances;
end

% Plot time series of track errors for Hurricane Rita
fige = figure;
fige.Position = [182 271 879 637];
tiledlayout(2,1)

nexttile
hold on;
timeIndex = 1:nObs;  % Time steps corresponding to each 6-hour interval
for k = 1:length(simNames)
    if all(timeseriesErrorsR(:,k)==0)  % skip if data wasn't computed
        continue;
    end
    plot(timeIndex, timeseriesErrorsR(:,k),'Color',colors(k,:), 'DisplayName', simNames{k}, 'LineWidth',1.5);
end
xlabel('Observation Index (6-hour intervals)');
ylabel('Track Error (km)');
ylim([0 450])
title('Track Errors for Hurricane Rita');
grid on; box on;
set(gca,'FontSize',14);
hold off;

% Define rows to use for Wilma observations, skipping row 26 as specified
obsRowsW = [10:25];
obsLonW = table2array(wilma.hurdat(obsRowsW,9));
obsLatW = table2array(wilma.hurdat(obsRowsW,8));
nObsW = length(obsLatW);

% List of simulation field names for Wilma
simNamesW = {'ctl','m1','m2','m3','noanm','oml35','oml100','p1','p2','p3'};

% Initialize matrix to store time series of track errors for each simulation
timeseriesErrorsW = zeros(nObsW, length(simNamesW));

for k = 1:length(simNamesW)
    field = simNamesW{k};
    simData = wilma.(field);

    % Check if simulation data has enough points for 6-hourly comparison
    if size(simData,1) < 2*nObsW
        fprintf('Simulation %s has fewer than %d points for 6-hourly comparison. Skipping.\n', field, 2*nObsW);
        continue;
    end

    % Select every second simulation point for Wilma
    indicesW = 1:2:(2*nObsW);
    simLon = simData(indicesW,6);  % Assuming column 5 is longitude
    simLat = simData(indicesW,5);  % Assuming column 6 is latitude

    % Calculate distances for each time step using haversine for Wilma
    distances = zeros(nObsW,1);
    for i = 1:nObsW
        distances(i) = haversine([obsLatW(i), obsLonW(i)], [simLat(i), simLon(i)]);
    end
    
    % Store the time series for this simulation
    timeseriesErrorsW(:, k) = distances;
end

% Plot time series of track errors for Hurricane Wilma
nexttile
hold on;
timeIndexW = 1:nObsW;  % Time steps corresponding to each 6-hour interval for Wilma
for k = 1:length(simNamesW)
    if all(timeseriesErrorsW(:,k)==0)
        continue;
    end
    plot(timeIndexW, timeseriesErrorsW(:,k),'Color',colors(k,:),'DisplayName', simNamesW{k}, 'LineWidth',1.5);
end
legend('Location','best');
xlabel('Observation Index (6-hour intervals)');
ylabel('Track Error (km)');
ylim([0 450])
title('Track Errors for Hurricane Wilma');
grid on; box on;
set(gca,'FontSize',14);
hold off;

lg = legend(' Control',' -1\circC',' -2\circC',' -3\circC',' No Anomaly',' 1/2 OMLD',' 2*OMLD',' +1\circC',' +2\circC',' +3\circC'...
    ,'location','northwest','FontSize',14);

lg.Position = [0.83617747440273,0.374501569858713,0.138225255972696,0.277080062794349];

% print('track_error','-djpeg','-r300',fige);

