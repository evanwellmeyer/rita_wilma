% Analysis of monthly averaged variables from 1950 to 2021

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


%% cape

var = cape;
hu_cape = var(:,:,hurs_ind);
hu_mean_cape = mean(hu_cape,3);

all_mean_cape = mean(var,3);

anom_cape = hu_mean_cape - all_mean_cape;

%% msl

var = msl./100;

hu_msl = var(:,:,hurs_ind);
hu_mean_msl = mean(hu_msl,3);

all_mean_msl = mean(var,3);

anom_msl = hu_mean_msl - all_mean_msl;

%% si10

var = si10;

hu_si = var(:,:,hurs_ind);
hu_mean_si = mean(hu_si,3);

all_mean_si = mean(var,3);

anom_si = hu_mean_si - all_mean_si;

%% sst

var = sst - 273.15;

hu_sst = var(:,:,hurs_ind);
hu_mean_sst = mean(hu_sst,3);

all_mean_sst = mean(var,3);

anom_sst = hu_mean_sst - all_mean_sst;

%% uv100

var = sqrt(u100.^2 + v100.^2);

hu_uv = var(:,:,hurs_ind);
hu_mean_uv = mean(hu_uv,3);

all_mean_uv = mean(var,3);

anom_uv = hu_mean_uv - all_mean_uv;

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
fig1.Position = [10 10 1700 1300]; 
% fig1.Position = [1 41 3440 1323]; %full screen

tiledlayout(5,3);
% axes1 = axes('Parent',fig1);

%% cape

% Hurricane season mean 
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_cape); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 1600]);
cb.Label.String = '\bf \fontsize{10} CAPE (J kg^{-1}) ';
gridm('on');

% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,all_mean_cape); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 1600]);
cb.Label.String = '\bf \fontsize{10} CAPE (J kg^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,anom_cape); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-600 600]);
cb.Label.String = '\bf \fontsize{10} CAPE (J kg^{-1}) ';
gridm('on')

%% msl

% Hurricane season mean 
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_msl); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([1010 1025]);
cb.Label.String = '\bf \fontsize{10} Mean Sea Level Pressure (hPa) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,all_mean_msl); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([1010 1025]);
cb.Label.String = '\bf \fontsize{10} Mean Sea Level Pressure (hPa) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,anom_msl); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-2 2]);
cb.Label.String = '\bf \fontsize{10} Mean Sea Level Pressure (hPa) ';
gridm('on')




%% sst

% Hurricane season mean 
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_sst); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([18 32]);
cb.Label.String = '\bf \fontsize{10} SST (C) ';
gridm('on');

% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,all_mean_sst); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([18 32]);
cb.Label.String = '\bf \fontsize{10} SST (C) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,anom_sst); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-3 3]);
cb.Label.String = '\bf \fontsize{10} SST (C) ';
gridm('on')

%% si10

% Hurricane season mean 
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_si); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Wind Speed (m s^{-1}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,all_mean_si); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} Wind Speed (m s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','ParallelLabel','on')
pcolorm(lat,lon,anom_si); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-2.5 2.5]);
cb.Label.String = '\bf \fontsize{10} Wind Speed (m s^{-1}) ';
gridm('on')

%% uv100

% Hurricane season mean 
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_uv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} 100M Wind Speed (m s^{-1}) ';
gridm('on');

% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_uv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 10]);
cb.Label.String = '\bf \fontsize{10} 100M Wind Speed (m s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_uv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-2.5 2.5]);
cb.Label.String = '\bf \fontsize{10} 100M Wind Speed (m s^{-1}) ';
gridm('on')

print('normal_vars','-dpng','-r400',fig1);