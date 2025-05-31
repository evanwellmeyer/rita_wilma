% wrf_wind_wilma

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

wilma.u10.ctl = double(nc_varget('wilma/w_CTL.nc','U10'));
wilma.v10.ctl = double(nc_varget('wilma/w_CTL.nc','V10'));
wilma.uv.ctl = sqrt(wilma.u10.ctl.^2 + wilma.v10.ctl.^2);

wilma.u10.noanm = double(nc_varget('wilma/w_NOANM.nc','U10'));
wilma.v10.noanm = double(nc_varget('wilma/w_NOANM.nc','V10'));
wilma.uv.noanm = sqrt(wilma.u10.noanm.^2 + wilma.v10.noanm.^2);

wilma.u10.m1 = double(nc_varget('wilma/w_M1.nc','U10'));
wilma.v10.m1 = double(nc_varget('wilma/w_M1.nc','V10'));
wilma.uv.m1 = sqrt(wilma.u10.m1.^2 + wilma.v10.m1.^2);

wilma.u10.m2 = double(nc_varget('wilma/w_M2.nc','U10'));
wilma.v10.m2 = double(nc_varget('wilma/w_M2.nc','V10'));
wilma.uv.m2 = sqrt(wilma.u10.m2.^2 + wilma.v10.m2.^2);

wilma.u10.m3 = double(nc_varget('wilma/w_M3.nc','U10'));
wilma.v10.m3 = double(nc_varget('wilma/w_M3.nc','V10'));
wilma.uv.m3 = sqrt(wilma.u10.m3.^2 + wilma.v10.m3.^2);

wilma.u10.oml35 = double(nc_varget('wilma/w_OML35.nc','U10'));
wilma.v10.oml35 = double(nc_varget('wilma/w_OML35.nc','V10'));
wilma.uv.oml35 = sqrt(wilma.u10.oml35.^2 + wilma.v10.oml35.^2);

wilma.u10.oml100 = double(nc_varget('wilma/w_OML100.nc','U10'));
wilma.v10.oml100 = double(nc_varget('wilma/w_OML100.nc','V10'));
wilma.uv.oml100 = sqrt(wilma.u10.oml100.^2 + wilma.v10.oml100.^2);

wilma.u10.p1 = double(nc_varget('wilma/w_P1.nc','U10'));
wilma.v10.p1 = double(nc_varget('wilma/w_P1.nc','V10'));
wilma.uv.p1 = sqrt(wilma.u10.p1.^2 + wilma.v10.p1.^2);

wilma.u10.p2 = double(nc_varget('wilma/w_P2.nc','U10'));
wilma.v10.p2 = double(nc_varget('wilma/w_P2.nc','V10'));
wilma.uv.p2 = sqrt(wilma.u10.p2.^2 + wilma.v10.p2.^2);

wilma.u10.p3 = double(nc_varget('wilma/w_P3.nc','U10'));
wilma.v10.p3 = double(nc_varget('wilma/w_P3.nc','V10'));
wilma.uv.p3 = sqrt(wilma.u10.p3.^2 + wilma.v10.p3.^2);


%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 4;
step = 15;

%for step=2:37

mn = 18;
mx = 70;

[km_top, ~, ~] = haversine([wilma.ctl(step,5)+rad wilma.ctl(step,6)-rad], [wilma.ctl(step,5)+rad wilma.ctl(step,6)+rad]);
[km_mid, ~, ~] = haversine([wilma.ctl(step,5) wilma.ctl(step,6)-rad], [wilma.ctl(step,5) wilma.ctl(step,6)+rad]);
[km_bot, ~, ~] = haversine([wilma.ctl(step,5)-rad wilma.ctl(step,6)-rad], [wilma.ctl(step,5)-rad wilma.ctl(step,6)+rad]);

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
pcolorm(lat,lon,squeeze(wilma.uv.ctl(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.ctl(step,5)-rad wilma.ctl(step,5)+rad],'MapLonLimit',[wilma.ctl(step,6)-rad wilma.ctl(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'CTL' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.12, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% oml100
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.oml100(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.oml100(step,5)-rad wilma.oml100(step,5)+rad],'MapLonLimit',[wilma.oml100(step,6)-rad wilma.oml100(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML100' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.2, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.p1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p1(step,5)-rad wilma.p1(step,5)+rad],'MapLonLimit',[wilma.p1(step,6)-rad wilma.p1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.p2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p2(step,5)-rad wilma.p2(step,5)+rad],'MapLonLimit',[wilma.p2(step,6)-rad wilma.p2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% p3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.p3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p3(step,5)-rad wilma.p3(step,5)+rad],'MapLonLimit',[wilma.p3(step,6)-rad wilma.p3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% noanm
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.noanm(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.noanm(step,5)-rad wilma.noanm(step,5)+rad],'MapLonLimit',[wilma.noanm(step,6)-rad wilma.noanm(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.22, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)


% oml35
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.oml35(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.oml35(step,5)-rad wilma.oml35(step,5)+rad],'MapLonLimit',[wilma.oml35(step,6)-rad wilma.oml35(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML35' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.2, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.m1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m1(step,5)-rad wilma.m1(step,5)+rad],'MapLonLimit',[wilma.m1(step,6)-rad wilma.m1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.m2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m2(step,5)-rad wilma.m2(step,5)+rad],'MapLonLimit',[wilma.m2(step,6)-rad wilma.m2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.10, .88, 0]);
plotm(coastlat,coastlon,'k','LineWidth',0.5)

% m3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.uv.m3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m3(step,5)-rad wilma.m3(step,5)+rad],'MapLonLimit',[wilma.m3(step,6)-rad wilma.m3(step,6)+rad])
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

ttl_str = ['Wilma - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
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
