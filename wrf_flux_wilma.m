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

wilma.hfx.ctl = double(nc_varget('wilma/w_CTL.nc','HFX'));
wilma.lh.ctl = double(nc_varget('wilma/w_CTL.nc','LH'));
wilma.flux.ctl = wilma.hfx.ctl + wilma.lh.ctl;

wilma.hfx.noanm = double(nc_varget('wilma/w_NOANM.nc','HFX'));
wilma.lh.noanm = double(nc_varget('wilma/w_NOANM.nc','LH'));
wilma.flux.noanm = wilma.hfx.noanm + wilma.lh.noanm;

wilma.hfx.m1 = double(nc_varget('wilma/w_M1.nc','HFX'));
wilma.lh.m1 = double(nc_varget('wilma/w_M1.nc','LH'));
wilma.flux.m1 = wilma.hfx.m1 + wilma.lh.m1;

wilma.hfx.m2 = double(nc_varget('wilma/w_M2.nc','HFX'));
wilma.lh.m2 = double(nc_varget('wilma/w_M2.nc','LH'));
wilma.flux.m2 = wilma.hfx.m2 + wilma.lh.m2;

wilma.hfx.m3 = double(nc_varget('wilma/w_M3.nc','HFX'));
wilma.lh.m3 = double(nc_varget('wilma/w_M3.nc','LH'));
wilma.flux.m3 = wilma.hfx.m3 + wilma.lh.m3;

wilma.hfx.oml35 = double(nc_varget('wilma/w_OML35.nc','HFX'));
wilma.lh.oml35 = double(nc_varget('wilma/w_OML35.nc','LH'));
wilma.flux.oml35 = wilma.hfx.oml35 + wilma.lh.oml35;

wilma.hfx.oml100 = double(nc_varget('wilma/w_OML100.nc','HFX'));
wilma.lh.oml100 = double(nc_varget('wilma/w_OML100.nc','LH'));
wilma.flux.oml100 = wilma.hfx.oml100 + wilma.lh.oml100;

wilma.hfx.p1 = double(nc_varget('wilma/w_P1.nc','HFX'));
wilma.lh.p1 = double(nc_varget('wilma/w_P1.nc','LH'));
wilma.flux.p1 = wilma.hfx.p1 + wilma.lh.p1;

wilma.hfx.p2 = double(nc_varget('wilma/w_P2.nc','HFX'));
wilma.lh.p2 = double(nc_varget('wilma/w_P2.nc','LH'));
wilma.flux.p2 = wilma.hfx.p2 + wilma.lh.p2;

wilma.hfx.p3 = double(nc_varget('wilma/w_P3.nc','HFX'));
wilma.lh.p3 = double(nc_varget('wilma/w_P3.nc','LH'));
wilma.flux.p3 = wilma.hfx.p3 + wilma.lh.p3;

%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 4;
step = 21;

mn = 350;
mx = 5000;

[km_top, ~, ~] = haversine([wilma.ctl(step,5)+rad wilma.ctl(step,6)-rad], [wilma.ctl(step,5)+rad wilma.ctl(step,6)+rad]);
[km_mid, ~, ~] = haversine([wilma.ctl(step,5) wilma.ctl(step,6)-rad], [wilma.ctl(step,5) wilma.ctl(step,6)+rad]);
[km_bot, ~, ~] = haversine([wilma.ctl(step,5)-rad wilma.ctl(step,6)-rad], [wilma.ctl(step,5)-rad wilma.ctl(step,6)+rad]);

disp(['Top - ',num2str(km_top),' km E-W'])
disp(['Middle - ',num2str(km_mid),' km E-W'])
disp(['Bottom - ',num2str(km_bot),' km E-W'])

theta = linspace(0,2*pi);

for step = 2:1:33
load coastlines
fig1 = figure;
fig1.Position = [713 430 1409 600]; 

tld = tiledlayout(2,5,'TileSpacing','none');

% ctl
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.ctl(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.ctl(step,5)-rad wilma.ctl(step,5)+rad],'MapLonLimit',[wilma.ctl(step,6)-rad wilma.ctl(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'CTL' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.ctl(step,5),3*sin(theta) + wilma.ctl(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.ctl(step,5),3*sin(theta) + wilma.ctl(step,6),'k','LineWidth',1)

% oml100
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.oml100(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.oml100(step,5)-rad wilma.oml100(step,5)+rad],'MapLonLimit',[wilma.oml100(step,6)-rad wilma.oml100(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML100' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.3, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.oml100(step,5),3*sin(theta) + wilma.oml100(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.oml100(step,5),3*sin(theta) + wilma.oml100(step,6),'k','LineWidth',1)

% p1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.p1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p1(step,5)-rad wilma.p1(step,5)+rad],'MapLonLimit',[wilma.p1(step,6)-rad wilma.p1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.p1(step,5),3*sin(theta) + wilma.p1(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.p1(step,5),3*sin(theta) + wilma.p1(step,6),'k','LineWidth',1)

% p2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.p2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p2(step,5)-rad wilma.p2(step,5)+rad],'MapLonLimit',[wilma.p2(step,6)-rad wilma.p2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.p2(step,5),3*sin(theta) + wilma.p2(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.p2(step,5),3*sin(theta) + wilma.p2(step,6),'k','LineWidth',1)

% p3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.p3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.p3(step,5)-rad wilma.p3(step,5)+rad],'MapLonLimit',[wilma.p3(step,6)-rad wilma.p3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.p3(step,5),3*sin(theta) + wilma.p3(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.p3(step,5),3*sin(theta) + wilma.p3(step,6),'k','LineWidth',1)

% noanm
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.noanm(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.noanm(step,5)-rad wilma.noanm(step,5)+rad],'MapLonLimit',[wilma.noanm(step,6)-rad wilma.noanm(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.3, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.noanm(step,5),3*sin(theta) + wilma.noanm(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.noanm(step,5),3*sin(theta) + wilma.noanm(step,6),'k','LineWidth',1)


% oml35
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.oml35(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.oml35(step,5)-rad wilma.oml35(step,5)+rad],'MapLonLimit',[wilma.oml35(step,6)-rad wilma.oml35(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML35' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.25, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.oml35(step,5),3*sin(theta) + wilma.oml35(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.oml35(step,5),3*sin(theta) + wilma.oml35(step,6),'k','LineWidth',1)

% m1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.m1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m1(step,5)-rad wilma.m1(step,5)+rad],'MapLonLimit',[wilma.m1(step,6)-rad wilma.m1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.m1(step,5),3*sin(theta) + wilma.m1(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.m1(step,5),3*sin(theta) + wilma.m1(step,6),'k','LineWidth',1)

% m2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.m2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m2(step,5)-rad wilma.m2(step,5)+rad],'MapLonLimit',[wilma.m2(step,6)-rad wilma.m2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.m2(step,5),3*sin(theta) + wilma.m2(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.m2(step,5),3*sin(theta) + wilma.m2(step,6),'k','LineWidth',1)

% m3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(wilma.flux.m3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[wilma.m3(step,5)-rad wilma.m3(step,5)+rad],'MapLonLimit',[wilma.m3(step,6)-rad wilma.m3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + wilma.m3(step,5),3*sin(theta) + wilma.m3(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + wilma.m3(step,5),3*sin(theta) + wilma.m3(step,6),'k','LineWidth',1)

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([mn mx]);
cb.Label.String = '\bf \fontsize{18} Total Surface Heat Flux (W m^{-2})';
cb.Location = 'eastoutside';
cb.Position = [0.92 0.12 0.012 0.80];

ttl_str = ['Wilma - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
title(tld,ttl_str,'FontSize',20,'FontWeight','bold');


print_string = ['wilma_flux_',datestr(date(step),'mmmm-dd-HH'),'00UTC'];
print(print_string,'-djpeg','-r400',fig1);
close(fig1)
end


%% eye following

load coastlines
fig1 = figure;
fig1.Position = [182 271 2188 965]; 

tl = tiledlayout('flow','TileSpacing','none','Padding','tight');
for step = 2:1:33

    nexttile
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller')
    pcolorm(lat,lon,squeeze(flux(step,:,:))); shading interp; colormap(mymap); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    
    caxis([500 4500]);
    setm(gca,'MapLatLimit',[norm(step,5)-1 norm(step,5)+1],'MapLonLimit',[norm(step,6)-1 norm(step,6)+1])
    framem on;
    framem('FlineWidth',3)
    tightmap;
%     plotm(coastlat,coastlon,'w','LineWidth',0.5)
    disp(step)
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

file_out = 'wrf_flux_wilma.gif';

rad = 9;
step = 15;
mn = 350;
mx = 4000;

load coastlines
fig1 = figure;
fig1.Position = [713 430 1409 600];
ii=1;
for step = 2:1:33
    clf;

    tld = tiledlayout(2,5,'TileSpacing','none');

    % ctl
    nexttile
    hold on; 
    axm = axesm('miller');
    pcolorm(lat,lon,squeeze(wilma.flux.ctl(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.oml100(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.p1(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.p2(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.p3(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.noanm(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.oml35(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.m1(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.m2(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(wilma.flux.m3(step,:,:)).*lm); 
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
    cb.Label.String = '\bf \fontsize{18} Total Surface Heat Flux (W m^{-2})';
    cb.Location = 'eastoutside';
    cb.Position = [0.92 0.12 0.012 0.80];

    ttl_str = ['Wilma - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
    title(tld,ttl_str,'FontSize',20,'FontWeight','bold');

    drawnow limitrate nocallbacks
    
    frame = getframe(gcf);
    im{step} = frame2im(frame);
    
    [imind,cm] = rgb2ind(im{step},256);
    
    if step == 2
        imwrite(imind,cm,file_out,'gif','Loopcount',inf,'DelayTime',0.3);       
    elseif step <= 33       
        imwrite(imind,cm,file_out,'gif','WriteMode','append','DelayTime',0.3);
    end
end
