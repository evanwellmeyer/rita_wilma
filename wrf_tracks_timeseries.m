% wilma timeseries compare

clear all;

% import wrf data
norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

% import noaa data
hurdat = import_gulf_extract('rita_hurdat.txt');

% nested domain coordinates
lat2_n = 31.7356;
lat2_s = 10.678;
lon2_e = -70.614;
lon2_w = -98.8278;

% date
date = datetime(norm(:,1),norm(:,2),norm(:,3),norm(:,4),0,0);

%% Tracks

fig1 = figure;
fig1.Position = [182 271 1091 794];
gx = geoaxes;


geoplot(norm(:,5),norm(:,6),'k','LineWidth',2); hold on;
geoplot(noanm(:,5),noanm(:,6),'r','LineWidth',2);
geoplot(hurdat{10:27,8},hurdat{10:27,9},'k','LineStyle',':','LineWidth',2);

geoscatter(norm(:,5),norm(:,6),100,norm(:,8),'filled','markerEdgeColor','k');
geoscatter(noanm(:,5),noanm(:,6),100,noanm(:,8),'filled','markerEdgeColor','r');

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)

cb = colorbar;
cb.Location = 'eastoutside';
caxis([910 1000]);
colormap(flipud(turbo));
cb.Label.String = '\bf \fontsize{20} Minimum Pressure (hPa) ';

geobasemap none
geolimits([14 24],[-89 -78])

gx.FontSize = 15;
legend('Normal','No Anomaly','NOAA Obs.','location','northeast','FontSize',20)

title('Minimum Pressure Tracks for WRF Simulations','FontSize',20)
% print('wrf_tracks','-djpeg','-r200',fig1);

%% wind pressure DR


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(1,3)

nexttile
plot(date,norm(:,8),'k','LineWidth',1.5); hold on;
plot(date,noanm(:,8),'k','LineStyle','--','LineWidth',1.5);
ylabel('Min. Pressure (hPa)','FontSize',20)
ylim([910 1010])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,norm(:,7),'k','LineWidth',1.5); hold on;
plot(date,noanm(:,7),'k','LineStyle','--','LineWidth',1.5);
ylabel('Max Wind Speed (kts)','FontSize',20)
ylim([20 120])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,norm(:,9),'k','LineWidth',1.5); hold on;
plot(date,noanm(:,9),'k','LineStyle','--','LineWidth',1.5);
ylabel('DR (bergeron)','FontSize',20)
ylim([-1.5 2])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

legend('Normal','No Anomaly','location','northeast','FontSize',20)
% print('wrf_vals','-djpeg','-r200',fig1);

%% heat flux and rain


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(1,2)

nexttile
plot(date(2:end),norm(2:end,10),'k','LineWidth',1.5); hold on;
plot(date(2:end),noanm(2:end,10),'k','LineStyle','--','LineWidth',1.5);
ylabel('Max Total Surface Heat Flux (W m^{-2})','FontSize',20)
ylim([600 5500])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date(2:end),norm(2:end,11),'k','LineWidth',1.5); hold on;
plot(date(2:end),noanm(2:end,11),'k','LineStyle','--','LineWidth',1.5);
ylabel('Accum. Total Grid Scale Precip. (mm)','FontSize',20)
ylim([50 900])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;


legend('Normal','No Anomaly','location','northeast','FontSize',20)
% print('wrf_vals2','-djpeg','-r200',fig1);
