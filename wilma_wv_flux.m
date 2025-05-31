% wilma era5 levels 

clear all;

%% File Selection

filename = 'wilma_wv_flux.nc';


%% Auto-extraction of variables

disp('Extracting surface file data...')

ncid = netcdf.open(filename);
info = ncinfo(filename); %returns all the informations about the file.nc
output_type= ('''double''');
for i = 1:3
    varname = info.Variables(i).Name;
    varid = netcdf.inqVarID(ncid,varname);
    eval([varname ' = netcdf.getVar(ncid,varid,' output_type ');'])
    eval([varname ' = pagetranspose(' varname ');']) % sets the order of variables as latitude, longitude, level
end

i = 4; 
varname = info.Variables(i).Name;
varid = netcdf.inqVarID(ncid,varname);
east_flux = netcdf.getVar(ncid,varid,'double');
east_flux = pagetranspose(east_flux);
scale_factor = ncreadatt(filename,varname,'scale_factor');
offset = ncreadatt(filename,varname,'add_offset');
east_flux = east_flux.*scale_factor + offset;

i = 5; 
varname = info.Variables(i).Name;
varid = netcdf.inqVarID(ncid,varname);
north_flux = netcdf.getVar(ncid,varid,'double');
north_flux = pagetranspose(north_flux);
scale_factor = ncreadatt(filename,varname,'scale_factor');
offset = ncreadatt(filename,varname,'add_offset');
north_flux = north_flux.*scale_factor + offset;

wv_flux = sqrt(north_flux.^2 + east_flux.^2);

% delete dummy variables
clear ncid i varname varid output_type scale_factor offset

date = datetime((time/24)+2,'ConvertFrom','excel');


longitude = longitude(41:341);
latitude = latitude(21:241);

east_flux = east_flux(21:241,41:341,:);
north_flux = north_flux(21:241,41:341,:);
wv_flux = wv_flux(21:241,41:341,:);

%%

era5 = load('wilma_era5.txt');

%%

[lon,lat]=meshgrid(longitude,latitude);
[qlon,qlat]=meshgrid(longitude(1:4:end),latitude(1:4:end));

for i = 1:6:174
    
    load coastlines
    fig1 = figure;
    fig1.Position = [182 271 1091 794]; 

    hold on; 
    worldmap('World')
    worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(turbo); 
    cb = colorbar;
    cb.FontWeight = 'bold';
    cb.FontSize = 12;
    cb.Box = 'on';
    cb.LineWidth = 1;
    caxis([0 1000]);
    cb.Label.String = '\bf \fontsize{14} Vertically Intigrated Water Vapor Flux (kg m^{-1} s^{-1}) ';

    quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
    
    if i >= 67
        plotm(era5(i-66,5),era5(i-66,6),'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
        plotm(era5(i-66,5),era5(i-66,6),'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
    end
    
    setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'w','LineWidth',0.5)
    title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
            'FontWeight','bold','Units', 'normalized');
        
    fileout = ['wv_flux_',datestr(date(i),'mmddHHMM')]; 
    print(fileout,'-dpng','-r200',fig1);
    close(fig1);
    
end
    
    
% 14th 0000
i = 25;
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(jet); colorbar;
quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
        'FontWeight','bold','Units', 'normalized');
   
% 15th 0000
i = 49;
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(jet); colorbar;
quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
        'FontWeight','bold','Units', 'normalized');
    
% 15th 0600
i = 55;
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(jet); colorbar;
quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
        'FontWeight','bold','Units', 'normalized');
    
% 15th 1200
i = 61;
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(jet); colorbar;
quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
        'FontWeight','bold','Units', 'normalized');
    
i = 67;
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,wv_flux(:,:,i)); shading interp; colormap(jet); colorbar;
quiverm(qlat,qlon,north_flux(1:4:end,1:4:end,i),east_flux(1:4:end,1:4:end,i),'k',2);
plotm(era5(i-66,5),era5(i-66,6),'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(era5(i-66,5),era5(i-66,6),'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
        'FontWeight','bold','Units', 'normalized');




















