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

rita.hfx.ctl = double(nc_varget('rita/CTL_d02_subset.nc','HFX'));
rita.lh.ctl = double(nc_varget('rita/CTL_d02_subset.nc','LH'));
rita.flux.ctl = rita.hfx.ctl + rita.lh.ctl;

rita.hfx.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','HFX'));
rita.lh.noanm = double(nc_varget('rita/NOANM_d02_subset.nc','LH'));
rita.flux.noanm = rita.hfx.noanm + rita.lh.noanm;

rita.hfx.m1 = double(nc_varget('rita/M1_d02_subset.nc','HFX'));
rita.lh.m1 = double(nc_varget('rita/M1_d02_subset.nc','LH'));
rita.flux.m1 = rita.hfx.m1 + rita.lh.m1;

rita.hfx.m2 = double(nc_varget('rita/M2_d02_subset.nc','HFX'));
rita.lh.m2 = double(nc_varget('rita/M2_d02_subset.nc','LH'));
rita.flux.m2 = rita.hfx.m2 + rita.lh.m2;

rita.hfx.m3 = double(nc_varget('rita/M3_d02_subset.nc','HFX'));
rita.lh.m3 = double(nc_varget('rita/M3_d02_subset.nc','LH'));
rita.flux.m3 = rita.hfx.m3 + rita.lh.m3;

rita.hfx.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','HFX'));
rita.lh.oml17 = double(nc_varget('rita/OML17_d02_subset.nc','LH'));
rita.flux.oml17 = rita.hfx.oml17 + rita.lh.oml17;

rita.hfx.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','HFX'));
rita.lh.oml70 = double(nc_varget('rita/OML70_d02_subset.nc','LH'));
rita.flux.oml70 = rita.hfx.oml70 + rita.lh.oml70;

rita.hfx.p1 = double(nc_varget('rita/P1_d02_subset.nc','HFX'));
rita.lh.p1 = double(nc_varget('rita/P1_d02_subset.nc','LH'));
rita.flux.p1 = rita.hfx.p1 + rita.lh.p1;

rita.hfx.p2 = double(nc_varget('rita/P2_d02_subset.nc','HFX'));
rita.lh.p2 = double(nc_varget('rita/P2_d02_subset.nc','LH'));
rita.flux.p2 = rita.hfx.p2 + rita.lh.p2;

rita.hfx.p3 = double(nc_varget('rita/P3_d02_subset.nc','HFX'));
rita.lh.p3 = double(nc_varget('rita/P3_d02_subset.nc','LH'));
rita.flux.p3 = rita.hfx.p3 + rita.lh.p3;

%%
% ctl    oml70 p1 p2 p3
% noanm  oml17 m1 m2 m3

% change axis to radius from center

rad = 4;
step = 21;

for step = 2:35

mn = 350;
mx = 5000;

[km_top, ~, ~] = haversine([rita.ctl(step,5)+rad rita.ctl(step,6)-rad], [rita.ctl(step,5)+rad rita.ctl(step,6)+rad]);
[km_mid, ~, ~] = haversine([rita.ctl(step,5) rita.ctl(step,6)-rad], [rita.ctl(step,5) rita.ctl(step,6)+rad]);
[km_bot, ~, ~] = haversine([rita.ctl(step,5)-rad rita.ctl(step,6)-rad], [rita.ctl(step,5)-rad rita.ctl(step,6)+rad]);

disp(['Top - ',num2str(km_top),' km E-W'])
disp(['Middle - ',num2str(km_mid),' km E-W'])
disp(['Bottom - ',num2str(km_bot),' km E-W'])


 
theta = linspace(0,2*pi);



load coastlines
fig1 = figure;
fig1.Position = [713 428 1385 600]; 

tld = tiledlayout(2,5,'TileSpacing','none');

% ctl
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.ctl(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.ctl(step,5)-rad rita.ctl(step,5)+rad],'MapLonLimit',[rita.ctl(step,6)-rad rita.ctl(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'CTL' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.ctl(step,5),3*sin(theta) + rita.ctl(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.ctl(step,5),3*sin(theta) + rita.ctl(step,6),'k','LineWidth',1)

% oml70
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.oml70(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.oml70(step,5)-rad rita.oml70(step,5)+rad],'MapLonLimit',[rita.oml70(step,6)-rad rita.oml70(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML70' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.25, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.oml70(step,5),3*sin(theta) + rita.oml70(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.oml70(step,5),3*sin(theta) + rita.oml70(step,6),'k','LineWidth',1)

% p1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.p1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p1(step,5)-rad rita.p1(step,5)+rad],'MapLonLimit',[rita.p1(step,6)-rad rita.p1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.p1(step,5),3*sin(theta) + rita.p1(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.p1(step,5),3*sin(theta) + rita.p1(step,6),'k','LineWidth',1)

% p2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.p2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p2(step,5)-rad rita.p2(step,5)+rad],'MapLonLimit',[rita.p2(step,6)-rad rita.p2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.p2(step,5),3*sin(theta) + rita.p2(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.p2(step,5),3*sin(theta) + rita.p2(step,6),'k','LineWidth',1)

% p3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.p3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.p3(step,5)-rad rita.p3(step,5)+rad],'MapLonLimit',[rita.p3(step,6)-rad rita.p3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.p3(step,5),3*sin(theta) + rita.p3(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.p3(step,5),3*sin(theta) + rita.p3(step,6),'k','LineWidth',1)

% noanm
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.noanm(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.noanm(step,5)-rad rita.noanm(step,5)+rad],'MapLonLimit',[rita.noanm(step,6)-rad rita.noanm(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'NOANM' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.3, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.noanm(step,5),3*sin(theta) + rita.noanm(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.noanm(step,5),3*sin(theta) + rita.noanm(step,6),'k','LineWidth',1)


% oml17
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.oml17(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.oml17(step,5)-rad rita.oml17(step,5)+rad],'MapLonLimit',[rita.oml17(step,6)-rad rita.oml17(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'OML17' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.25, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.oml17(step,5),3*sin(theta) + rita.oml17(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.oml17(step,5),3*sin(theta) + rita.oml17(step,6),'k','LineWidth',1)

% m1
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.m1(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m1(step,5)-rad rita.m1(step,5)+rad],'MapLonLimit',[rita.m1(step,6)-rad rita.m1(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M1' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.m1(step,5),3*sin(theta) + rita.m1(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.m1(step,5),3*sin(theta) + rita.m1(step,6),'k','LineWidth',1)

% m2
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.m2(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m2(step,5)-rad rita.m2(step,5)+rad],'MapLonLimit',[rita.m2(step,6)-rad rita.m2(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M2' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.m2(step,5),3*sin(theta) + rita.m2(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.m2(step,5),3*sin(theta) + rita.m2(step,6),'k','LineWidth',1)

% m3
nexttile
hold on; 
axm = axesm('miller');
pcolorm(lat,lon,squeeze(rita.flux.m3(step,:,:)).*lm); 
shading interp; colormap(mymap); caxis([mn mx]);
setm(axm,'MapLatLimit',[rita.m3(step,5)-rad rita.m3(step,5)+rad],'MapLonLimit',[rita.m3(step,6)-rad rita.m3(step,6)+rad])
framem on; framem('FlineWidth',3); tightmap;
title( 'M3' ,'FontSize',20,'FontWeight','bold','Units',...
    'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
plotm(coastlat,coastlon,'k','LineWidth',0.5)
plotm(3*cos(theta) + rita.m3(step,5),3*sin(theta) + rita.m3(step,6),'w','LineWidth',2.5)
plotm(3*cos(theta) + rita.m3(step,5),3*sin(theta) + rita.m3(step,6),'k','LineWidth',1)

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([mn mx]);
cb.Label.String = '\bf \fontsize{18} Total Surface Heat Flux (W m^{-2})';
cb.Location = 'eastoutside';
cb.Position = [0.92 0.12 0.012 0.80];

ttl_str = ['Rita - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
title(tld,ttl_str,'FontSize',20,'FontWeight','bold');

print_string = ['rita_flux_',datestr(date(step),'mmmm-dd-HH'),'00UTC'];
print(print_string,'-djpeg','-r400',fig1);
close(fig1)
end

%% eye following

load coastlines
fig1 = figure;
fig1.Position = [182 271 2188 965]; 

tl = tiledlayout('flow','TileSpacing','none','Padding','tight');
for step = 5:1:26

    nexttile
    hold on; 
    axm = axesm('miller');
    pcolorm(lat,lon,squeeze(rita.flux.p3(step,:,:)).*lm); 
    shading interp; colormap(mymap); caxis([mn mx]);
    setm(axm,'MapLatLimit',[rita.p3(step,5)-rad rita.p3(step,5)+rad],'MapLonLimit',[rita.p3(step,6)-rad rita.p3(step,6)+rad])
    framem on; framem('FlineWidth',3); tightmap;
%     title( 'P3' ,'FontSize',20,'FontWeight','bold','Units',...
%         'normalized', 'Position', [0.15, .85, 0],'Color','r','FontName','Arial Black');
    % plotm(coastlat,coastlon,'k','LineWidth',0.5)
    disp(step)
end

% cb = colorbar;
% cb.Layout.Tile = 'east';
% cb.FontWeight = 'bold';
% cb.FontSize = 16;
% cb.Box = 'on';
% cb.LineWidth = 1;

% cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';
% title( 'Normal' ,'FontSize',20,'FontWeight','bold');

%%

file_out = 'wrf_flux_rita2.gif';

rad = 9;
mn = 350;
mx = 4000;
    
load coastlines
fig1 = figure;
fig1.Position = [713 428 1385 600]; 
ii=1;
for step = 2:1:35
    clf;

%     load coastlines
%     fig1 = figure;
%     fig1.Position = [713 428 1385 602]; 

    tld = tiledlayout(2,5,'TileSpacing','none');

    % ctl
    nexttile
    hold on; 
    axm = axesm('miller');
    pcolorm(lat,lon,squeeze(rita.flux.ctl(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.oml70(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.p1(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.p2(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.p3(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.noanm(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.oml17(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.m1(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.m2(step,:,:)).*lm); 
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
    pcolorm(lat,lon,squeeze(rita.flux.m3(step,:,:)).*lm); 
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
    cb.Label.String = '\bf \fontsize{18} Total Surface Heat Flux (W m^{-2})';
    cb.Location = 'eastoutside';
    cb.Position = [0.92 0.12 0.012 0.80];

    ttl_str = ['Rita - ',datestr(date(step),'mmmm dd, yyyy HH:MM')];
    title(tld,ttl_str,'FontSize',20,'FontWeight','bold');

    drawnow limitrate nocallbacks
    
    frame = getframe(gcf);
    im{step} = frame2im(frame);
    
    [imind,cm] = rgb2ind(im{step},256);
    
    if step == 2
        imwrite(imind,cm,file_out,'gif','Loopcount',inf,'DelayTime',0.3);       
    elseif step <= 35       
        imwrite(imind,cm,file_out,'gif','WriteMode','append','DelayTime',0.3);
    end
end
