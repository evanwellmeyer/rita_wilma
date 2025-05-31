% Analysis of monthly averaged levels variables from 1940 to 2021

clear all;

%% File Selection

[file, path] = uigetfile('*.nc','Select the data file for analysis:');
filename = [path,file];

%% Auto-extraction of variables

disp('Extracting file data...')

ncid = netcdf.open(filename);
info = ncinfo(filename); %returns all the informations about the file.nc
output_type= ('''double''');
for i = 1:length(info.Variables)
    varname = info.Variables(i).Name;
    varid = netcdf.inqVarID(ncid,varname);
    eval([varname ' = netcdf.getVar(ncid,varid,' output_type ');'])
    eval([varname ' = pagetranspose(' varname ');']) % sets the order of variables as latitude, longitude, level
    if i > length(info.Dimensions) % excluding latitude, longitude and time variables
        scale_factor = ncreadatt(filename,varname,'scale_factor');
        offset = ncreadatt(filename,varname,'add_offset');
        eval([varname ' = ' varname '.*scale_factor + offset;']) % compute exact value of the variable
    end
end

% delete dummy variables
clear ncid i varname varid output_type scale_factor offset file path filename

date = datetime((time/24)+2,'ConvertFrom','excel');

%% sort season

ii=1;
for i = 1:length(date)
    if month(date(i)) == 6 || month(date(i)) == 7 || month(date(i)) == 8 || month(date(i)) == 9 || month(date(i)) == 10 ||month(date(i)) == 11
        hurs_ind(ii) = i; %#ok
        ii = ii +1;
    end
end
clear i ii;


%% 1000 hpa

var = squeeze(sqrt(u(:,:,4,:).^2 + v(:,:,4,:).^2));

hu_1000 = var(:,:,hurs_ind);
hu_mean_1000 = mean(hu_1000,3);

all_mean_1000 = mean(var,3);

anom_1000 = hu_mean_1000 - all_mean_1000;

%% 750 hpa

var = squeeze(sqrt(u(:,:,3,:).^2 + v(:,:,3,:).^2));

hu_750 = var(:,:,hurs_ind);
hu_mean_750 = mean(hu_750,3);

all_mean_750 = mean(var,3);

anom_750 = hu_mean_750 - all_mean_750;

%% 500 hpa

var = squeeze(sqrt(u(:,:,2,:).^2 + v(:,:,2,:).^2));

hu_500 = var(:,:,hurs_ind);
hu_mean_500 = mean(hu_500,3);

all_mean_500 = mean(var,3);

anom_500 = hu_mean_500 - all_mean_500;

%% 250 hpa

var = squeeze(sqrt(u(:,:,1,:).^2 + v(:,:,1,:).^2));

hu_250 = var(:,:,hurs_ind);
hu_mean_250 = mean(hu_250,3);

all_mean_250 = mean(var,3);

anom_250 = hu_mean_250 - all_mean_250;

%% colormap

    
mymap = [0 0 1
    0.05 0.05 1
    0.1 0.1 1
    0.15 0.15 1
    0.2 0.2 1
    0.25 0.25 1
    0.3 0.3 1
    0.35 0.35 1
    0.4 0.4 1
    0.45 0.45 1
    0.5 0.5 1
    0.55 0.55 1
    0.6 0.6 1
    0.65 0.65 1
    0.7 0.7 1
    0.75 0.75 1
    0.8 0.8 1
    0.85 0.85 1
    0.9 0.9 1
    0.95 0.95 1
    1 1 1
    1 0.95 0.95
    1 0.9 0.9
    1 0.85 0.85
    1 0.8 0.8
    1 0.75 0.75
    1 0.7 0.7
    1 0.65 0.65
    1 0.6 0.6
    1 0.55 0.55
    1 0.5 0.5
    1 0.45 0.45
    1 0.4 0.4
    1 0.35 0.35
    1 0.3 0.3
    1 0.25 0.25
    1 0.2 0.2
    1 0.15 0.15
    1 0.1 0.1
    1 0.05 0.05
    1 0 0];


%% plotting

[lon,lat]=meshgrid(longitude,latitude);

load coastlines
fig1 = figure;
fig1.Position = [10 10 1700 1345]; 
% fig1.Position = [1 41 3440 1323]; %full screen

tiledlayout(4,3);
% axes1 = axes('Parent',fig1);

%% 1000 hpa

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_1000); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean - 1000 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on');

% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_1000); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean - 1000 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_1000); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly - 1000 hPa');
cb = colorbar;
colormap(mymap);
caxis([-4 4]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

%% 750 hpa

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_750); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean - 750 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_750); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean - 750 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_750); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly - 750 hPa');
cb = colorbar;
colormap(mymap);
caxis([-4 4]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

%% 500 hpa

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_500); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean - 500 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 18]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_500); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean - 500 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 18]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_500); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly - 500 hPa');
cb = colorbar;
colormap(mymap);
caxis([-6 6]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')


%% 250 hpa

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_250); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean - 250 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 30]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_250); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean - 250 hPa');
cb = colorbar;
colormap(mymap);
caxis([0 30]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_250); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly - 250 hPa');
cb = colorbar;
colormap(mymap);
caxis([-10 10]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (Pa s^{-1}) ';
gridm('on')

% print('vert_velo_levels','-dpng','-r400',fig1);