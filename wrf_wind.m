% variable fields

clear all;

norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

lat = nc_varget('wrfout_1800_SSTHR_subset2.nc','XLAT');
lon = nc_varget('wrfout_1800_SSTHR_subset2.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

lat2_n = 31.7356;
lat2_s = 10.678;
lon2_e = -70.614;
lon2_w = -98.8278;

%% plot wind fields

u = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','U10'));
u_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','U10'));

v = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','V10'));
v_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','V10'));

uv = sqrt(u.^2 + v.^2);
uv_no = sqrt(u_no.^2 + v_no.^2);

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
pcolorm(lat,lon,squeeze(uv(24,:,:))); shading interp; colormap(turbo); 
% quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
% cb = colorbar;
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Box = 'on';
% cb.LineWidth = 1;
caxis([5 60]);
% cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.5])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'Normal' ,'FontSize',20,'FontWeight','bold');
    
nexttile
hold on; 
worldmap('World')
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-98:4:-72],'ParallelLabel','on','PLabelLocation',[12:4:30],'FontSize',12);
pcolorm(lat,lon,squeeze(uv_no(24,:,:))); shading interp; colormap(turbo); 
% quiverm(lat,lon,squeeze(v_no(22,:,:)),squeeze(u_no(22,:,:)),'k',2);
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([5 60]);
cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.5])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'No Anomaly' ,'FontSize',20,'FontWeight','bold');


fileout = ['ssta_',datestr(date(47),'mmddHHMM')]; 
print('wrf_rain','-dpng','-r200',fig1);

%% eye following

file_out = 'wrf_sst_wind_large.gif';

load coastlines
fig1 = figure;
fig1.Position = [182 271 1000 600]; 
ii=1;
for i = 2:1:33
    clf;
    fig1.Position = [182 271 1000 800];
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,squeeze(uv(i,:,:))); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([10 60]);
%     setm(gca,'MapLatLimit',[noanm(i,5)-10 noanm(i,5)+10],'MapLonLimit',[noanm(i,6)-10 noanm(i,6)+10])
    setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.5])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'w','LineWidth',0.5)

    drawnow limitrate nocallbacks
    
    frame = getframe(gca);
    im{i} = frame2im(frame);
    
    [imind,cm] = rgb2ind(im{i},256);
    
    if i == 2
        imwrite(imind,cm,file_out,'gif','Loopcount',inf,'DelayTime',0.2);       
    elseif i <= 33       
        imwrite(imind,cm,file_out,'gif','WriteMode','append','DelayTime',0.2);
    end
end

% cb = colorbar;
% cb.Layout.Tile = 'east';
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Box = 'on';
% cb.LineWidth = 1;
% 
% cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';
% title( 'Normal' ,'FontSize',20,'FontWeight','bold');

writerObj = VideoWriter(file_out,'MPEG-4');
writerObj.FrameRate = 6;
writerObj.Quality = 100;

open(writerObj);

for i=1:length(F)
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end

close(writerObj);

%%


load coastlines
fig1 = figure;
fig1.Position = [182 271 2188 965]; 

tl = tiledlayout('flow','TileSpacing','none','Padding','tight');
for i = 2:1:33

    nexttile
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller')
    pcolorm(lat,lon,squeeze(uv_no(i,:,:))); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([10 60]);
    setm(gca,'MapLatLimit',[noanm(i,5)-1 noanm(i,5)+1],'MapLonLimit',[noanm(i,6)-1 noanm(i,6)+1])
    framem on;
    framem('FlineWidth',3)
    tightmap;
%     plotm(coastlat,coastlon,'w','LineWidth',0.5)
    disp(i)
end

