% wrf_rain_wilma

% variable fields

clear all;

lat = nc_varget('w_CTL.nc','XLAT');
lon = nc_varget('w_CTL.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

wilma.ctl = load('wilma_ctl.txt');
wilma.m1 = load('wilma_M1.txt');
wilma.m2 = load('wilma_M2.txt');
wilma.m3 = load('wilma_M3.txt');
wilma.noanm = load('wilma_noanm.txt');
wilma.oml35 = load('wilma_oml35.txt');
wilma.oml100 = load('wilma_oml100.txt');
wilma.p1 = load('wilma_P1.txt');
wilma.p2 = load('wilma_P2.txt');
wilma.p3 = load('wilma_P3.txt');

date = datetime(wilma.ctl(:,1),wilma.ctl(:,2),wilma.ctl(:,3),wilma.ctl(:,4),0,0);

landmask = double(nc_varget('wilma_masks.nc','LANDMASK'));
landmask = landmask.*-1 + 1;
lkm = double(nc_varget('wilma_masks.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

lm = landmask.*lkm; clear landmask lkm;


%% 

wilma.rain.ctl = double(nc_varget('wilma/w_CTL.nc','RAINNC'));
wilma.rain.noanm = double(nc_varget('wilma/w_NOANM.nc','RAINNC'));
wilma.rain.m1 = double(nc_varget('wilma/w_M1.nc','RAINNC'));
wilma.rain.m2 = double(nc_varget('wilma/w_M2.nc','RAINNC'));
wilma.rain.m3 = double(nc_varget('wilma/w_M3.nc','RAINNC'));
wilma.rain.oml35 = double(nc_varget('wilma/w_OML35.nc','RAINNC'));
wilma.rain.oml100 = double(nc_varget('wilma/w_OML100.nc','RAINNC'));
wilma.rain.p1 = double(nc_varget('wilma/w_P1.nc','RAINNC'));
wilma.rain.p2 = double(nc_varget('wilma/w_P2.nc','RAINNC'));
wilma.rain.p3 = double(nc_varget('wilma/w_P3.nc','RAINNC'));


%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 10;
step = 33;

%for step=2:37

mn = 20;
mx = 1000;

[km_top, ~, ~] = haversine([27 -93], [27 -77]);
[km_mid, ~, ~] = haversine([19 -93], [19 -77]);
[km_bot, ~, ~] = haversine([11 -93], [11 -77]);


disp('Dimensions of figure in East-West direction:')
disp(['Top - ',num2str(km_top),' km'])
disp(['Middle - ',num2str(km_mid),' km'])
disp(['Bottom - ',num2str(km_bot),' km'])


load coastlines
fig1 = figure;
fig1.Position = [713 430 1409 600]; 

tld = tiledlayout(2,5,'TileSpacing','none');

% ctl
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.ctl(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'CTL' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% oml100
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.oml100(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'OML100' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.3, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p1
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.p1(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'P1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p2
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.p2(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'P2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p3
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.p3(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% noanm
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.noanm(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.3, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% oml35
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.oml35(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'OML35' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.25, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m1
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.m1(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'M1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.12, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m2
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.m2(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'M2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.12, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m3
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[11 27],'MapLonLimit',[-93 -77]);
pcolorm(lat,lon,squeeze(wilma.rain.m3(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'M3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.12, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([mn mx]);
cb.Label.String = '\bf \fontsize{16} Accumulate Total Grid Scale Precipitation (mm)';
cb.Location = 'eastoutside';
cb.Position = [0.92 0.12 0.012 0.80];

ttl_str = ['Wilma - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
title(tld,ttl_str,'FontSize',20,'FontWeight','bold');

% print_string = ['wilma_rain_',datestr(date(step),'mmmm-dd-HH'),'00UTC'];
% print(print_string,'-djpeg','-r400',fig1);
% close(fig1)
% end

%% eye following

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
    pcolorm(lat,lon,squeeze(flux(i,:,:))); shading interp; colormap(mymap); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([500 4500]);
    setm(gca,'MapLatLimit',[norm(i,5)-1 norm(i,5)+1],'MapLonLimit',[norm(i,6)-1 norm(i,6)+1])
    framem on;
    framem('FlineWidth',3)
    tightmap;
%     plotm(coastlat,coastlon,'w','LineWidth',0.5)
    disp(i)
end

cb = colorbar;
cb.Layout.Tile = 'east';
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;

cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';
title( 'Normal' ,'FontSize',20,'FontWeight','bold');

%%

file_out = 'wrf_sst_flux.gif';

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
    pcolorm(lat,lon,squeeze(flux(i,:,:))); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([500 4200]);
    setm(gca,'MapLatLimit',[norm(i,5)-4 norm(i,5)+4],'MapLonLimit',[norm(i,6)-4 norm(i,6)+4])
    framem on;
    framem('FlineWidth',3)
    tightmap;
%     plotm(coastlat,coastlon,'w','LineWidth',0.5)

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
