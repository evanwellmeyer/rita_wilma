


clear all;

% import wrf data
norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

% info = ncinfo('wrfout_1800_d02_2005-10-20_21_00_00.nc');
% ncload('wrfout_1800_d02_2005-10-20_21_00_00.nc')
% level = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','C4F'));

lat = nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','XLAT');
lon = nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','XLONG');

vap = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','QVAPOR'));
vap_no = double(nc_varget('wrfout_noanm_1800_d02_2005-10-20_21_00_00.nc','QVAPOR'));

u = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','U'));
u_no = double(nc_varget('wrfout_noanm_1800_d02_2005-10-20_21_00_00.nc','U'));

u = u(:,:,1:975);
u_no = u_no(:,:,1:975); 

v = double(nc_varget('wrfout_1800_d02_2005-10-20_21_00_00.nc','V'));
v_no = double(nc_varget('wrfout_noanm_1800_d02_2005-10-20_21_00_00.nc','V'));

v = v(:,1:777,:);
v_no = v_no(:,1:777,:); 

uv = sqrt(u.^2 + v.^2);
uv_no = sqrt(u_no.^2 + v_no.^2);

level = 1:1:74;
long = mean(lon);
[x,y]=meshgrid(eta(1:end-1),long);



var = squeeze(uv(:,321,:))';
var_n = squeeze(uv_no(:,348,:))';


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
set(t1,'CLim',[0 90],'Layer','top','FontSize',12);
colormap(turbo);
% cb = colorbar;
ylim([0 1]);
xlim([-98 -71.5])
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
set(t2,'CLim',[0 90],'Layer','top','FontSize',12);
colormap(turbo);
cb = colorbar;
ylim([0 1]);
xlim([-98 -71.5])
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Color = [0 0 0];
cb.Box = 'on';
cb.LineWidth = 1;
cb.Label.String = '\bf \fontsize{16} Horizontal Wind (m s^{-1}) ';
title('No Anomaly')
