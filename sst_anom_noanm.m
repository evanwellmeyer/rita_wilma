clear all; %#ok<CLALL>

disp('Extracting file data...')

filename = 'sst_start.nc';
info = ncinfo(filename);
ncload(filename)

sst_st = SST;

filename = 'sst_noanm.nc';
info = ncinfo(filename);
ncload(filename)

sst_noanm = SST;

sst_diff = sst_st - sst_noanm;





Tq = interp2(lon,lat,ssta,XLONG,XLAT);

sst_noanom_mia = sst_st - Tq;

ssta_diff = sst_noanom_mia - sst_noanm;







filename = 'SSTA_OCT14_2005_00UTC.nc';
info = ncinfo(filename);
ncload(filename)

load coastlines
fig1 = figure;
fig1.Position = [182 271 1091 794]; 

hold on; 
worldmap('World')
worldmap([min(XLAT,[],'all') max(XLAT,[],'all')],[min(XLONG,[],'all') max(XLONG,[],'all')])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
%     contourm(lat,lon,msl(:,:,i)./100,'k','ShowText','on','LevelStep',2)
pcolorm(XLAT,XLONG,ssta_diff); shading interp; colormap(turbo); 
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 12;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([-1 1]);
% cb.Label.String = '\bf \fontsize{14} SST Anomaly (C) - 1985-2005 Mean ';
title('sst noanom mia - sst noanm','FontSize',20)

setm(gca,'MapLatLimit',[10 35],'MapLonLimit',[-102 -68])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)