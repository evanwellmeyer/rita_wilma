% rita timeseries compare

clear all;

% import wrf data
CTL = load('rita_ctl.txt');
M1 = load('rita_M1.txt');
M2 = load('rita_M2.txt');
M3 = load('rita_M3.txt');
NOANM = load('rita_noanm.txt');
OML17 = load('rita_oml17.txt');
OML70 = load('rita_oml70.txt');
P1 = load('rita_P1.txt');
P2 = load('rita_P2.txt');
P3 = load('rita_P3.txt');

% import noaa data
hurdat = import_gulf_extract('rita_hurdat.txt');

% nested domain coordinates
lat2_n = 32.0553;
lat2_s = 10.6843;
lon2_e = -69.6862;
lon2_w = -100.0345;

% date
date = datetime(CTL(:,1),CTL(:,2),CTL(:,3),CTL(:,4),0,0);
dateHU = datetime(hurdat{11:31,2},hurdat{11:31,3},hurdat{11:31,4},hurdat{11:31,5},0,0);

% hurdat deepening
DR = get_bergeron_6hr(hurdat{11:31,11},24);

%% Tracks

% colors = distinguishable_colors(10,'k');
colors = turbo(10);


fig1 = figure;
fig1.Position = [182 271 1091 794];
gx = geoaxes;


geoplot(CTL(:,5),CTL(:,6),'Color',colors(1,:),'LineWidth',2); hold on;
geoplot(M1(:,5),M1(:,6),'Color',colors(2,:),'LineWidth',2);
geoplot(M2(:,5),M2(:,6),'Color',colors(3,:),'LineWidth',2);
geoplot(M3(:,5),M3(:,6),'Color',colors(4,:),'LineWidth',2);
geoplot(NOANM(:,5),NOANM(:,6),'Color',colors(5,:),'LineWidth',2);
geoplot(OML17(:,5),OML17(:,6),'Color',colors(6,:),'LineWidth',2);
geoplot(OML70(:,5),OML70(:,6),'Color',colors(7,:),'LineWidth',2);
geoplot(P1(:,5),P1(:,6),'Color',colors(8,:),'LineWidth',2);
geoplot(P2(:,5),P2(:,6),'Color',colors(9,:),'LineWidth',2);
geoplot(P3(:,5),P3(:,6),'Color',colors(10,:),'LineWidth',2);
geoplot(hurdat{11:31,8},hurdat{11:31,9},'k','LineStyle',':','LineWidth',2);

% geoscatter(norm(:,5),norm(:,6),100,norm(:,8),'filled','markerEdgeColor','k');
% geoscatter(noanm(:,5),noanm(:,6),100,noanm(:,8),'filled','markerEdgeColor','r');

% % domain 2
% geoplot([lat2_n lat2_n],[lon2_w lon2_e],'k','LineWidth',2);
% geoplot([lat2_s lat2_s],[lon2_w lon2_e],'k','LineWidth',2);
% geoplot([lat2_s lat2_n],[lon2_w lon2_w],'k','LineWidth',2);
% geoplot([lat2_s lat2_n],[lon2_e lon2_e],'k','LineWidth',2);

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)

% cb = colorbar;
% cb.Location = 'eastoutside';
% caxis([910 1000]);
% colormap(flipud(turbo));
% cb.Label.String = '\bf \fontsize{20} Minimum Pressure (hPa) ';

geobasemap none
geolimits([22 32],[-100 -78])

gx.FontSize = 15;
legend('CTL','M1','M2','M3','NOANM','OML17','OML70','P1','P2','P3'...
    ,'NOAA Obs.','location','northeast','FontSize',20)

title('Minimum Pressure Tracks for WRF Simulations - RITA','FontSize',20)
% print('wrf_tracks_rita','-djpeg','-r200',fig1);

%% wind pressure DR


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(1,3)

nexttile
plot(date,CTL(:,8),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date,M1(:,8),'Color',colors(2,:),'LineWidth',2);
plot(date,M2(:,8),'Color',colors(3,:),'LineWidth',2);
plot(date,M3(:,8),'Color',colors(4,:),'LineWidth',2);
plot(date,NOANM(:,8),'Color',colors(5,:),'LineWidth',2);
plot(date,OML17(:,8),'Color',colors(6,:),'LineWidth',2);
plot(date,OML70(:,8),'Color',colors(7,:),'LineWidth',2);
plot(date,P1(:,8),'Color',colors(8,:),'LineWidth',2);
plot(date,P2(:,8),'Color',colors(9,:),'LineWidth',2);
plot(date,P3(:,8),'Color',colors(10,:),'LineWidth',2);
plot(dateHU,hurdat{11:31,11},'k','LineStyle',':','LineWidth',2);
ylabel('Min. Pressure (hPa)','FontSize',20)
ylim([870 1000])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,CTL(:,7),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date,M1(:,7),'Color',colors(2,:),'LineWidth',2);
plot(date,M2(:,7),'Color',colors(3,:),'LineWidth',2);
plot(date,M3(:,7),'Color',colors(4,:),'LineWidth',2);
plot(date,NOANM(:,7),'Color',colors(5,:),'LineWidth',2);
plot(date,OML17(:,7),'Color',colors(6,:),'LineWidth',2);
plot(date,OML70(:,7),'Color',colors(7,:),'LineWidth',2);
plot(date,P1(:,7),'Color',colors(8,:),'LineWidth',2);
plot(date,P2(:,7),'Color',colors(9,:),'LineWidth',2);
plot(date,P3(:,7),'Color',colors(10,:),'LineWidth',2);
plot(dateHU,hurdat{11:31,10},'k','LineStyle',':','LineWidth',2);
ylabel('Max Wind Speed (kts)','FontSize',20)
ylim([10 160])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,CTL(:,9),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date,M1(:,9),'Color',colors(2,:),'LineWidth',2);
plot(date,M2(:,9),'Color',colors(3,:),'LineWidth',2);
plot(date,M3(:,9),'Color',colors(4,:),'LineWidth',2);
plot(date,NOANM(:,9),'Color',colors(5,:),'LineWidth',2);
plot(date,OML17(:,9),'Color',colors(6,:),'LineWidth',2);
plot(date,OML70(:,9),'Color',colors(7,:),'LineWidth',2);
plot(date,P1(:,9),'Color',colors(8,:),'LineWidth',2);
plot(date,P2(:,9),'Color',colors(9,:),'LineWidth',2);
plot(date,P3(:,9),'Color',colors(10,:),'LineWidth',2);
plot(dateHU,DR,'k','LineStyle',':','LineWidth',2);
ylabel('DR (bergeron)','FontSize',20)
ylim([-1.75 2])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

legend('CTL','-1C','-2C','-3C','NOANM','OML17','OML70','+1C','+2C','+3C'...
    ,'NOAA Obs.','location','northeast','FontSize',16)
% print('wrf_vals_rita','-djpeg','-r200',fig1);

%% heat flux and rain


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(1,3)

nexttile
plot(date(2:end),CTL(2:end,10),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date(2:end),M1(2:end,10),'Color',colors(2,:),'LineWidth',2);
plot(date(2:end),M2(2:end,10),'Color',colors(3,:),'LineWidth',2);
plot(date(2:end),M3(2:end,10),'Color',colors(4,:),'LineWidth',2);
plot(date(2:end),NOANM(2:end,10),'Color',colors(5,:),'LineWidth',2);
plot(date(2:end),OML17(2:end,10),'Color',colors(6,:),'LineWidth',2);
plot(date(2:end),OML70(2:end,10),'Color',colors(7,:),'LineWidth',2);
plot(date(2:end),P1(2:end,10),'Color',colors(8,:),'LineWidth',2);
plot(date(2:end),P2(2:end,10),'Color',colors(9,:),'LineWidth',2);
plot(date(2:end),P3(2:end,10),'Color',colors(10,:),'LineWidth',2);
ylabel('Max Total Surface Heat Flux (W m^{-2})','FontSize',20)
ylim([0 8000])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date(2:end),CTL(2:end,12),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date(2:end),M1(2:end,12),'Color',colors(2,:),'LineWidth',2);
plot(date(2:end),M2(2:end,12),'Color',colors(3,:),'LineWidth',2);
plot(date(2:end),M3(2:end,12),'Color',colors(4,:),'LineWidth',2);
plot(date(2:end),NOANM(2:end,12),'Color',colors(5,:),'LineWidth',2);
plot(date(2:end),OML17(2:end,12),'Color',colors(6,:),'LineWidth',2);
plot(date(2:end),OML70(2:end,12),'Color',colors(7,:),'LineWidth',2);
plot(date(2:end),P1(2:end,12),'Color',colors(8,:),'LineWidth',2);
plot(date(2:end),P2(2:end,12),'Color',colors(9,:),'LineWidth',2);
plot(date(2:end),P3(2:end,12),'Color',colors(10,:),'LineWidth',2);
ylabel('330km Surface Heat (10^{12}W)','FontSize',20)
ylim([0 800])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date(2:end),CTL(2:end,11),'Color',colors(1,:),'LineWidth',2); hold on;
plot(date(2:end),M1(2:end,11),'Color',colors(2,:),'LineWidth',2);
plot(date(2:end),M2(2:end,11),'Color',colors(3,:),'LineWidth',2);
plot(date(2:end),M3(2:end,11),'Color',colors(4,:),'LineWidth',2);
plot(date(2:end),NOANM(2:end,11),'Color',colors(5,:),'LineWidth',2);
plot(date(2:end),OML17(2:end,11),'Color',colors(6,:),'LineWidth',2);
plot(date(2:end),OML70(2:end,11),'Color',colors(7,:),'LineWidth',2);
plot(date(2:end),P1(2:end,11),'Color',colors(8,:),'LineWidth',2);
plot(date(2:end),P2(2:end,11),'Color',colors(9,:),'LineWidth',2);
plot(date(2:end),P3(2:end,11),'Color',colors(10,:),'LineWidth',2);
ylabel('Accum. Total Grid Scale Precip. (mm)','FontSize',20)
ylim([50 1000])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;


legend('CTL','-1C','-2C','-3C','NOANM','OML17','OML70','+1C','+2C','+3C'...
    ,'location','northeast','FontSize',16)
% print('wrf_vals2_rita','-djpeg','-r200',fig1);


%% max DR and min press vs temp

MI = [-3 971;-2 957;-1 946;0 929;1 915;2 891;3 871];
DR = [-3 0.25;-2 0.49;-1 0.61;0 0.89;1 1.29;2 1.54;3 1.88];

figure;


yyaxis left
plot(MI(:,1),MI(:,2)); hold on;
scatter(MI(:,1),MI(:,2));

yyaxis right
plot(DR(:,1),DR(:,2)); hold on;
scatter(DR(:,1),DR(:,2));



