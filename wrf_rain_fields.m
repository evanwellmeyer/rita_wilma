% variable fields

clear all;

lat = nc_varget('wrfout_1800_SSTHR_subset2.nc','XLAT');
lon = nc_varget('wrfout_1800_SSTHR_subset2.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

lat2_n = 31.7356;
lat2_s = 10.678;
lon2_e = -70.614;
lon2_w = -98.8278;

%% plot rain fields

rain = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','RAINNC'));
rain_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','RAINNC'));

load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tiledlayout(1,2)

nexttile
hold on; 
worldmap('World')
worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
axm = axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-94:4:-74],'ParallelLabel','on','PLabelLocation',[12:3:27],'FontSize',12);
pcolorm(lat,lon,squeeze(rain(33,:,:))); shading interp; colormap(turbo); 
% cb = colorbar;
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Box = 'on';
% cb.LineWidth = 1;
caxis([0 750]);
% cb.Label.String = '\bf \fontsize{20} Accum. Total Grid Scale Precip. (mm)';

setm(gca,'MapLatLimit',[12 27],'MapLonLimit',[-94 -74])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'Normal' ,'FontSize',20,'FontWeight','bold');
    
nexttile
hold on; 
worldmap('World')
axm = axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-94:4:-74],'ParallelLabel','on','PLabelLocation',[12:3:27],'FontSize',12);
pcolorm(lat,lon,squeeze(rain_no(33,:,:))); shading interp; colormap(turbo); hold on;
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([0 750]);
cb.Label.String = '\bf \fontsize{20} Accum. Total Grid Scale Precip. (mm)';

setm(gca,'MapLatLimit',[12 27],'MapLonLimit',[-94 -74])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'No Anomaly' ,'FontSize',20,'FontWeight','bold');


fileout = ['ssta_',datestr(date(47),'mmddHHMM')]; 
print('wrf_rain','-djpeg','-r200',fig1);