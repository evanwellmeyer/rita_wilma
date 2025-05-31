% Analysis of monthly averaged variables from 1940 to 2021

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


%% instantaneous moisture flux

var = ie;
hu_ie = var(:,:,hurs_ind);
hu_mean_ie = mean(hu_ie,3);

all_mean_ie = mean(var,3);

anom_ie = hu_mean_ie - all_mean_ie;

%% total column rain water

var = tcrw;

hu_tcrw = var(:,:,hurs_ind);
hu_mean_tcrw = mean(hu_tcrw,3);

all_mean_tcrw = mean(var,3);

anom_tcrw = hu_mean_tcrw - all_mean_tcrw;

%% total column water vapor

var = tcwv;

hu_tcwv = var(:,:,hurs_ind);
hu_mean_tcwv = mean(hu_tcwv,3);

all_mean_tcwv = mean(var,3);

anom_tcwv = hu_mean_tcwv - all_mean_tcwv;

%% total precipitation

var = tp;

hu_tp = var(:,:,hurs_ind);
hu_mean_tp = mean(hu_tp,3);

all_mean_tp = mean(var,3);

anom_tp = hu_mean_tp - all_mean_tp;

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

tiledlayout(4,3);
% axes1 = axes('Parent',fig1);

%% ie

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_ie); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([-.00009 0]);
cb.Label.String = '\bf \fontsize{10} Instantaneous Moisture Flux (kg m^{-2} s^{-1}) ';
gridm('on');

% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_ie); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([-.00009 0]);
cb.Label.String = '\bf \fontsize{10} Instantaneous Moisture Flux (kg m^{-2} s^{-1}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_ie); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-.000015 .000015]);
cb.Label.String = '\bf \fontsize{10} Instantaneous Moisture Flux (kg m^{-2} s^{-1}) ';
gridm('on')

%% tcrw

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_tcrw); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 0.05]);
cb.Label.String = '\bf \fontsize{10} Total Column Rain Water (kg m^{-2}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_tcrw); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 0.05]);
cb.Label.String = '\bf \fontsize{10} Total Column Rain Water (kg m^{-2}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_tcrw); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-.05 .05]);
cb.Label.String = '\bf \fontsize{10} Total Column Rain Water (kg m^{-2}) ';
gridm('on')

%% tcwv

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_tcwv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 60]);
cb.Label.String = '\bf \fontsize{10} Total Column Water Vapor (kg m^{-2}) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_tcwv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 60]);
cb.Label.String = '\bf \fontsize{10} Total Column Water Vapor (kg m^{-2}) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_tcwv); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-13 13]);
cb.Label.String = '\bf \fontsize{10} Total Column Water Vapor (kg m^{-2}) ';
gridm('on')


%% tp

% Hurricane season mean ie
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,hu_mean_tp); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Mean');
cb = colorbar;
colormap(mymap);
caxis([0 .015]);
cb.Label.String = '\bf \fontsize{10} Total Precipitation (m) ';
gridm('on');


% total mean
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,all_mean_tp); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Mean');
cb = colorbar;
colormap(mymap);
caxis([0 .015]);
cb.Label.String = '\bf \fontsize{10} Total Precipitation (m) ';
gridm('on')

% Hurricane season anomaly
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,anom_tp); %shading interp;
setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} Hurricane Season Anomaly');
cb = colorbar;
colormap(mymap);
caxis([-.01 .01]);
cb.Label.String = '\bf \fontsize{10} Total Precipitation (m) ';
gridm('on')

print('water_vars','-dpng','-r400',fig1);