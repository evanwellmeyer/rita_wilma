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

%% plot wind fields

hfx = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','HFX'));
hfx_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','HFX'));

LH = double(nc_varget('wrfout_1800_SSTHR_subset2.nc','LH'));
LH_no = double(nc_varget('wrfout_1800_SST_NOANM_subset2.nc','LH'));

flux = hfx+LH;
flux_no = hfx_no + LH_no;

load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tiledlayout(1,2)

nexttile
hold on; 
worldmap('World')
worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
axm = axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-88:1:-82],'ParallelLabel','on','PLabelLocation',[16:1:22],'FontSize',12);
pcolorm(lat,lon,squeeze(flux(24,:,:))); shading interp; colormap(turbo); 
caxis([100 4000]);

% setm(gca,'MapLatLimit',[17 23],'MapLonLimit',[-88.5 -82.5])
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
    [-87.5:1:-81.5],'ParallelLabel','on','PLabelLocation',[17:1:23],'FontSize',12);
pcolorm(lat,lon,squeeze(flux_no(24,:,:))); shading interp; colormap(turbo); 
% quiverm(lat,lon,squeeze(v_no(22,:,:)),squeeze(u_no(22,:,:)),'k',2);
cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([100 4000]);
cb.Label.String = '\bf \fontsize{20} Max Total Surface Heat Flux (W m^{-2})';

% setm(gca,'MapLatLimit',[17.5 23.5],'MapLonLimit',[-88 -82])
setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.5])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'w','LineWidth',0.5)
title( 'No Anomaly' ,'FontSize',20,'FontWeight','bold');



print('wrf_flux','-dpng','-r200',fig1);

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
    pcolorm(lat,lon,squeeze(flux(i,:,:))); shading interp; colormap(turbo); 
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
