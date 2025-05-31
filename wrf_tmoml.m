clear all;

lat = nc_varget('wrfout_1800_SSTHR_TMOML.nc','XLAT');
lon = nc_varget('wrfout_1800_SSTHR_TMOML.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

lat2_n = 31.7356;
lat2_s = 10.678;
lon2_e = -70.614;
lon2_w = -98.8278;

%% plot wind fields

tmoml = double(nc_varget('wrfout_1800_SSTHR_TML.nc','TML'))-273.15;
tmoml_no = double(nc_varget('wrfout_1800_SST_NOANM_TMOML.nc','TMOML'))-273.15;


load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tiledlayout(1,2)

nexttile
hold on; 
worldmap('World')
worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-94:4:-74],'ParallelLabel','on','PLabelLocation',[12:4:26],'FontSize',12);
pcolorm(lat,lon,squeeze(tmoml(33,:,:))); shading interp; colormap(turbo); 

caxis([20 30]);

setm(gca,'MapLatLimit',[12 26],'MapLonLimit',[-94 -74])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'Normal' ,'FontSize',20,'FontWeight','bold');
    
nexttile
hold on; 
worldmap('World')
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-94:4:-74],'ParallelLabel','on','PLabelLocation',[12:4:26],'FontSize',12);
pcolorm(lat,lon,squeeze(tmoml_no(5,:,:))); shading interp; colormap(turbo); 
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([20 30]);
cb.Label.String = '\bf \fontsize{20} OMLD (m)';

setm(gca,'MapLatLimit',[12 26],'MapLonLimit',[-94 -74])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'No Anomaly' ,'FontSize',20,'FontWeight','bold');


print('wrf_omld','-djpeg','-r200',fig1);

%% eye following

load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tl = tiledlayout('flow');
for i = 2:2:33

    nexttile
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,squeeze(tmoml(i,:,:))); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([70 100]);
    setm(gca,'MapLatLimit',[norm(i,5)-2 norm(i,5)+2],'MapLonLimit',[norm(i,6)-2 norm(i,6)+2])
    framem on;
    framem('FlineWidth',3)
    tightmap;
%     plotm(coastlat,coastlon,'w','LineWidth',0.5)
    
end

cb = colorbar;
cb.Layout.Tile = 'east';
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;

cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';
title( 'Normal' ,'FontSize',20,'FontWeight','bold');
