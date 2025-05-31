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

%% colormap


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

%% plot wind fields

lsm = double(nc_varget('wrfout_noanm_1800_d02_2005-10-20_21_00_00.nc','LANDMASK'));
lsm = lsm.*-1 + 1;

% Tq = interp2(lsm,lon,lat,'nearest',0);

sst = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','SST'))-273.15;
sst_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','SST'))-273.15;

tsk = double(nc_varget('wrfout_1800_SSTHR_tsk.nc','TSK'))-273.15;
tsk_no = double(nc_varget('wrfout_1800_SST_NOANM_tsk.nc','TSK'))-273.15;

ssta = squeeze(tsk(33,:,:)-tsk(2,:,:));
ssta_no = squeeze(tsk_no(33,:,:)-tsk_no(2,:,:));


load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tiledlayout(1,2)

nexttile
hold on; 
worldmap('World')
worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-98:4:-72],'ParallelLabel','on','PLabelLocation',[12:4:30],'FontSize',12);
pcolorm(lat,lon,(ssta-0.2).*lsm); shading interp; colormap(mymap); 
% quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
% cb = colorbar;
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Box = 'on';
% cb.LineWidth = 1;
caxis([-2 2]);
% cb.Label.String = '\bf \fontsize{20} Max Total Surface Heat Flux (W m^{-2})';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.4])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5); hold on;
title( 'Normal' ,'FontSize',20,'FontWeight','bold');
    
nexttile
hold on; 
worldmap('World')
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-98:4:-72],'ParallelLabel','on','PLabelLocation',[12:4:30],'FontSize',12);
pcolorm(lat,lon,(ssta_no-0.2).*lsm); shading interp; colormap(mymap); 
% quiverm(lat,lon,squeeze(v_no(22,:,:)),squeeze(u_no(22,:,:)),'k',2);
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([-2 2]);
cb.Label.String = '\bf \fontsize{20} SSTA (C)';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.4])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( 'No Anomaly' ,'FontSize',20,'FontWeight','bold');


print('wrf_sst','-dpng','-r200',fig1);

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
    pcolorm(lat,lon,squeeze(hml(i,:,:))); shading interp; colormap(turbo); 
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
