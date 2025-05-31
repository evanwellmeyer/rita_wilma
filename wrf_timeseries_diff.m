% wilma timeseries compare

clear all;

% import wrf data
norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

% import noaa data
hurdat = import_gulf_extract('wilma_hurdat.txt');

% nested domain coordinates
lat2_n = 31.7356;
lat2_s = 10.678;
lon2_e = -70.614;
lon2_w = -98.8278;

% date
date = datetime(norm(:,1),norm(:,2),norm(:,3),norm(:,4),0,0);

%% percent diff calculations

% pressure
p_diff = abs((998-noanm(:,8))-(998-norm(:,8)))./(998-noanm(:,8)).*100;

% wind
u_diff = ((norm(:,7)-noanm(:,7))./noanm(:,7)).*100;

% dr
dr_diff = ((norm(:,9)-noanm(:,9))./(noanm(:,9))).*100;

% heat
f_diff = ((norm(:,10)-noanm(:,10))./(noanm(:,10))).*100;
h_diff = ((h_ttl-h_no_ttl)./h_no_ttl).*100;

% rain
rain_diff = ((norm(:,11)-noanm(:,11))./(noanm(:,11))).*100;

%% wind pressure DR


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(3,2)

nexttile
plot(date,p_diff,'k','LineWidth',1.5); hold on;
ylabel('Min. Pressure Difference (%)','FontSize',20)
ylim([-10 60])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,u_diff,'k','LineWidth',1.5); hold on;
ylabel('Max Wind Speed Difference (%)','FontSize',20)
ylim([-15 30])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,dr_diff,'k','LineWidth',1.5); hold on;
ylabel('DR Difference (%)','FontSize',20)
ylim([-350 100])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,f_diff,'k','LineWidth',1.5); hold on;
ylabel('Surface Heat Flux Difference (%)','FontSize',20)
ylim([-20 90])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,rain_diff,'k','LineWidth',1.5); hold on;
ylabel('Accumulated Precip. Difference (%)','FontSize',20)
ylim([-60 100])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;

nexttile
plot(date,h_diff,'k','LineWidth',1.5); hold on;
ylabel('330km Radius Heat Difference (%)','FontSize',20)
ylim([-10 35])
xlim([date(1) date(end)])
datetick('x',6)
grid on;
ax = gca;
ax.FontSize = 15;



legend('Normal','No Anomaly','location','northeast','FontSize',20)
% print('wrf_diff','-djpeg','-r200',fig1);

%% heat flux and rain


fig1 = figure;
fig1.Position = [182 271 1500 600];

tiledlayout(1,2)

nexttile
plot(date(2:end),norm(2:end,10),'k','LineWidth',1.5); hold on;
plot(date(2:end),noanm(2:end,10),'k','LineStyle','--','LineWidth',1.5);
ylabel('Max Total Surface Heat Flux (W m^{-2})','FontSize',20)
ylim([600 5000])
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