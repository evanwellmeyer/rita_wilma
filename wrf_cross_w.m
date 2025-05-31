

clear all;

% import wrf data
norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

% info = ncinfo('wrfout_1800_d02_2005-10-20_21_00_00.nc');
% ncload('wrfout_1800_d02_2005-10-20_21_00_00.nc')
eta = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','ZNW'));

lat = nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','XLAT');
lon = nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','XLONG');

w = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','W'));
w_no = double(nc_varget('wrfout_noanm_1800_d02_2005-10-20_21_00_00.nc','W'));

w = w(:,:,1:975);
w_no = w_no(:,:,1:975); 

level = 1:1:74;
long = mean(lon);
[x,y]=meshgrid(eta(1:end-1),long);



var = squeeze(w(1:74,321,:))';
var_n = squeeze(w_no(1:74,348,:))';


%%


mymap = [0 0 1
    0.05 0.05 1
    0.1 0.1 1
    0.15 0.15 1
    0.2 0.2 1
    0.25 0.25 1
    0.3 0.3 1
    0.35 0.35 1
    0.4 0.4 1
    0.45 0.45 1
    0.5 0.5 1
    0.55 0.55 1
    0.6 0.6 1
    0.65 0.65 1
    0.7 0.7 1
    0.75 0.75 1
    0.8 0.8 1
    0.85 0.85 1
    0.9 0.9 1
    0.95 0.95 1
    1 1 1
    1 0.95 0.95
    1 0.9 0.9
    1 0.85 0.85
    1 0.8 0.8
    1 0.75 0.75
    1 0.7 0.7
    1 0.65 0.65
    1 0.6 0.6
    1 0.55 0.55
    1 0.5 0.5
    1 0.45 0.45
    1 0.4 0.4
    1 0.35 0.35
    1 0.3 0.3
    1 0.25 0.25
    1 0.2 0.2
    1 0.15 0.15
    1 0.1 0.1
    1 0.05 0.05
    1 0 0];

%%


fig1 = figure;
fig1.Position = [100 100 1600 700];

t = tiledlayout(1,2);

t1 = nexttile;
hold(t1,'on');
pcolor(y,x,var); shading interp;
ylabel('Vertical Level')
xlabel('Longitude')
box(t1,'on');
axis(t1,'ij');
hold(t1,'off');
set(t1,'CLim',[-8 8],'Layer','top','FontSize',12);
colormap(mymap);
% cb = colorbar;
ylim([0 1]);
xlim([-87.25 -84.25])
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Color = [0 0 0];
% cb.Box = 'on';
% cb.LineWidth = 1;
% cb.Label.String = '\bf \fontsize{16} Horizontal Wind (m s^{-1}) ';
title('Normal')

t2 = nexttile;
hold(t2,'on');
pcolor(y,x,var_n); shading interp;
% ylabel('Vertical Level')
xlabel('Longitude')
box(t2,'on');
axis(t2,'ij');
hold(t2,'off');
set(t2,'CLim',[-8 8],'Layer','top','FontSize',12);
colormap(mymap);
cb = colorbar;
ylim([0 1]);
xlim([-86.5 -83.5])
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Color = [0 0 0];
cb.Box = 'on';
cb.LineWidth = 1;
cb.Label.String = '\bf \fontsize{16} Vertical Velocity (m s^{-1}) ';
title('No Anomaly')