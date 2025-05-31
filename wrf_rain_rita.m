% wrf_rain_rita

% variable fields

clear all;

lat = nc_varget('CTL_d02_subset.nc','XLAT');
lon = nc_varget('CTL_d02_subset.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

rita.ctl = load('rita_ctl.txt');
rita.m1 = load('rita_M1.txt');
rita.m2 = load('rita_M2.txt');
rita.m3 = load('rita_M3.txt');
rita.noanm = load('rita_noanm.txt');
rita.oml17 = load('rita_oml17.txt');
rita.oml70 = load('rita_oml70.txt');
rita.p1 = load('rita_P1.txt');
rita.p2 = load('rita_P2.txt');
rita.p3 = load('rita_P3.txt');

date = datetime(rita.ctl(:,1),rita.ctl(:,2),rita.ctl(:,3),rita.ctl(:,4),0,0);

landmask = double(nc_varget('rita_lsm.nc','LANDMASK'));
landmask = landmask.*-1 + 1;
lkm = double(nc_varget('lakemask.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

lm = landmask.*lkm; clear landmask lkm;


%% 

rita.rain.ctl = double(nc_varget('rita/CTL_d02_subset.nc','RAINNC'));
rita.rain.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','RAINNC'));
rita.rain.m1 = double(nc_varget('rita/M1_d02_subset.nc','RAINNC'));
rita.rain.m2 = double(nc_varget('rita/M2_d02_subset.nc','RAINNC'));
rita.rain.m3 = double(nc_varget('rita/M3_d02_subset.nc','RAINNC'));
rita.rain.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','RAINNC'));
rita.rain.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','RAINNC'));
rita.rain.p1 = double(nc_varget('rita/P1_d02_subset.nc','RAINNC'));
rita.rain.p2 = double(nc_varget('rita/P2_d02_subset.nc','RAINNC'));
rita.rain.p3 = double(nc_varget('rita/P3_d02_subset.nc','RAINNC'));


%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 4;
step = 37;

%for step=2:37

mn = 0;
mx = 800;

[km_top, ~, ~] = haversine([35 -99], [35 -79]);
[km_mid, ~, ~] = haversine([25 -99], [25 -79]);
[km_bot, ~, ~] = haversine([15 -99], [15 -79]);

disp('Dimensions of figure in East-West direction:')
disp(['Top - ',num2str(km_top),' km'])
disp(['Middle - ',num2str(km_mid),' km'])
disp(['Bottom - ',num2str(km_bot),' km'])


load coastlines
fig1 = figure;
fig1.Position = [515 654 1409 520]; 

tld = tiledlayout(2,5,'TileSpacing','none');

% ctl
nexttile
hold on; 
axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.ctl(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'Ctl' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)


% oml70
nexttile
hold on; 
axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.oml70(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'OML70' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.76, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p1
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.p1(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '+1\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p2
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.p2(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '+2\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p3
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.p3(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '+3\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% noanm
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.noanm(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.73, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% oml17
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.oml17(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( 'OML17' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.76, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m1
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.m1(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '-1\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m2
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.m2(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '-2\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m3
nexttile
hold on; 
axm = axesm('miller','MapLatLimit',[15 32],'MapLonLimit',[-99 -79]);
pcolorm(lat,lon,squeeze(rita.rain.m3(step,:,:))); 
shading interp; colormap(mymap); caxis([mn mx]);
framem on; framem('FlineWidth',3); tightmap;
title( '-3\circC' ,'FontSize',20,'FontWeight','bold','Units','normalized',...
    'Position', [0.85, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 14;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([mn mx]);
cb.Label.String = '\bf \fontsize{14} Accumulate Total Grid Scale Precipitation (mm)';
cb.Location = 'eastoutside';
cb.Position = [0.92 0.12 0.012 0.78];

ttl_str = ['Hurricane Rita: ',datestr(date(1),'mmmm dd, yyyy HH:MM'),' - ',...
    datestr(date(step),'mmmm dd, yyyy HH:MM')];
title(tld,ttl_str,'FontSize',18,'FontWeight','bold');

% print_string = ['rita_rain_',datestr(date(step),'mmmm-dd-HH'),'00UTC'];
% print('rita_rain','-djpeg','-r400',fig1);
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
