% wrf_wind_rita

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

rita.u10.ctl = double(nc_varget('rita/CTL_d02_subset.nc','U10'));
rita.v10.ctl = double(nc_varget('rita/CTL_d02_subset.nc','V10'));
rita.uv.ctl = sqrt(rita.u10.ctl.^2 + rita.v10.ctl.^2);

rita.u10.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','U10'));
rita.v10.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','V10'));
rita.uv.noanm = sqrt(rita.u10.noanm.^2 + rita.v10.noanm.^2);

rita.u10.m1 = double(nc_varget('rita/M1_d02_subset.nc','U10'));
rita.v10.m1 = double(nc_varget('rita/M1_d02_subset.nc','V10'));
rita.uv.m1 = sqrt(rita.u10.m1.^2 + rita.v10.m1.^2);

rita.u10.m2 = double(nc_varget('rita/M2_d02_subset.nc','U10'));
rita.v10.m2 = double(nc_varget('rita/M2_d02_subset.nc','V10'));
rita.uv.m2 = sqrt(rita.u10.m2.^2 + rita.v10.m2.^2);

rita.u10.m3 = double(nc_varget('rita/M3_d02_subset.nc','U10'));
rita.v10.m3 = double(nc_varget('rita/M3_d02_subset.nc','V10'));
rita.uv.m3 = sqrt(rita.u10.m3.^2 + rita.v10.m3.^2);

rita.u10.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','U10'));
rita.v10.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','V10'));
rita.uv.oml17 = sqrt(rita.u10.oml17.^2 + rita.v10.oml17.^2);

rita.u10.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','U10'));
rita.v10.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','V10'));
rita.uv.oml70 = sqrt(rita.u10.oml70.^2 + rita.v10.oml70.^2);

rita.u10.p1 = double(nc_varget('rita/P1_d02_subset.nc','U10'));
rita.v10.p1 = double(nc_varget('rita/P1_d02_subset.nc','V10'));
rita.uv.p1 = sqrt(rita.u10.p1.^2 + rita.v10.p1.^2);

rita.u10.p2 = double(nc_varget('rita/P2_d02_subset.nc','U10'));
rita.v10.p2 = double(nc_varget('rita/P2_d02_subset.nc','V10'));
rita.uv.p2 = sqrt(rita.u10.p2.^2 + rita.v10.p2.^2);

rita.u10.p3 = double(nc_varget('rita/P3_d02_subset.nc','U10'));
rita.v10.p3 = double(nc_varget('rita/P3_d02_subset.nc','V10'));
rita.uv.p3 = sqrt(rita.u10.p3.^2 + rita.v10.p3.^2);

%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 4;
step = 15;

%for step=2:37

mn = 18;
mx = 70;

[km_top, ~, ~] = haversine([rita.ctl(step,5)+rad rita.ctl(step,6)-rad], [rita.ctl(step,5)+rad rita.ctl(step,6)+rad]);
[km_mid, ~, ~] = haversine([rita.ctl(step,5) rita.ctl(step,6)-rad], [rita.ctl(step,5) rita.ctl(step,6)+rad]);
[km_bot, ~, ~] = haversine([rita.ctl(step,5)-rad rita.ctl(step,6)-rad], [rita.ctl(step,5)-rad rita.ctl(step,6)+rad]);

disp(['Top - ',num2str(km_top),' km E-W'])
disp(['Middle - ',num2str(km_mid),' km E-W'])
disp(['Bottom - ',num2str(km_bot),' km E-W'])


load coastlines
fig1 = figure;
fig1.Position = [713 430 1409 600]; 

tld = tiledlayout(2,5,'TileSpacing','none');

% ctl
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.ctl(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.ctl(step,5)-rad rita.ctl(step,5)+rad],'MapLonLimit',[rita.ctl(step,6)-rad rita.ctl(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'CTL' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.12, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% oml70
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.oml70(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.oml70(step,5)-rad rita.oml70(step,5)+rad],'MapLonLimit',[rita.oml70(step,6)-rad rita.oml70(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML70' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.2, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.p1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p1(step,5)-rad rita.p1(step,5)+rad],'MapLonLimit',[rita.p1(step,6)-rad rita.p1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.p2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p2(step,5)-rad rita.p2(step,5)+rad],'MapLonLimit',[rita.p2(step,6)-rad rita.p2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.p3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p3(step,5)-rad rita.p3(step,5)+rad],'MapLonLimit',[rita.p3(step,6)-rad rita.p3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% noanm
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.noanm(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.noanm(step,5)-rad rita.noanm(step,5)+rad],'MapLonLimit',[rita.noanm(step,6)-rad rita.noanm(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.22, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)


% oml17
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.oml17(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.oml17(step,5)-rad rita.oml17(step,5)+rad],'MapLonLimit',[rita.oml17(step,6)-rad rita.oml17(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML17' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.2, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.m1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m1(step,5)-rad rita.m1(step,5)+rad],'MapLonLimit',[rita.m1(step,6)-rad rita.m1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.m2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m2(step,5)-rad rita.m2(step,5)+rad],'MapLonLimit',[rita.m2(step,6)-rad rita.m2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.uv.m3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m3(step,5)-rad rita.m3(step,5)+rad],'MapLonLimit',[rita.m3(step,6)-rad rita.m3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([mn mx]);
cb.Label.String = '\bf \fontsize{20} Wind Speed (m s^{-1})';
cb.Location = 'eastoutside';
cb.Position = [0.92 0.12 0.012 0.80];

ttl_str = ['Rita - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
title(tld,ttl_str,'FontSize',20,'FontWeight','bold');

% print_string = ['rita_wind_',datestr(date(step),'mmmm-dd-HH'),'00UTC'];
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
