% tracking validation

clear all

% load wrf lat/long
lat = nc_varget('M3_d02_subset.nc','XLAT');
lon = nc_varget('M3_d02_subset.nc','XLONG');

lat = double(squeeze(lat(1,:,:)));
lon = double(squeeze(lon(1,:,:)));

% load wrf pressure
pres = double(nc_varget('M3_d02_subset.nc','PSFC'));

% wrf landmask
lsm = double(nc_varget('rita_lsm.nc','LANDMASK'));
lsm = lsm.*-1 + 1;

% load output file from tracking algorithm
cyc = load('rita_M3.txt');

% plot the pressure at each time step with center determined by tracking
% algorithm
load coastlines
fig1 = figure;
fig1.Position = [182 271 2188 965]; 

tl = tiledlayout('flow','TileSpacing','none','Padding','tight');
for i = 1:1:10

    nexttile
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller')
    pcolorm(lat,lon,squeeze(pres(i,:,:)./100).*lsm); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    scatterm(cyc(i,5),cyc(i,6),30,'x','k')
    scatterm(cyc(i,5),cyc(i,6),20,'x','r')
    caxis([980 1000]);
    setm(gca,'MapLatLimit',[cyc(i,5)-1 cyc(i,5)+1],'MapLonLimit',[cyc(i,6)-1 cyc(i,6)+1])
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

% cb.Label.String = '\bf \fontsize{20} 10m Wind Speed (m s^{-1})';
% title( 'Normal' ,'FontSize',20,'FontWeight','bold');