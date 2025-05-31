% ERA5 climatology analysis vs hurdat gulf 1940-2021
%
% This script compares era5 reanalysis variables when hurricanes are
% present in the gulf versus the average for the hurricane season from 1940
% to 2021.
%
% Stages:
%   1) Import ERA5 data during HU season 1940-2021 and create mean
%   2) Import ERA5 data for each HU, create mean and anomaly
%

clear all

% add path to data
addpath(genpath('ERA5'))

% retrieve info about nc file
filename = 'HU_season_vars_ERA5_1940-2021.nc';
info = ncinfo(filename);

% create list of variables
for i = 4:length(info.Variables)
    var_list(i-3,1) = string(info.Variables(i).Name);
end

% prompt to select variable(s) for extraction
[indx,tf] = listdlg('ListString',var_list);

if tf ==0
    error('At least one variable must be selected.')
end

selected_var = var_list(indx);

extract_vars = ['longitude';'latitude';'time';var_list(indx)];


%% Import ERA5 for mean

filename = 'HU_season_vars_ERA5_1940-2021.nc';

ncid = netcdf.open(filename);
info = ncinfo(filename); %returns all the informations about the file.nc
output_type= ('''double''');
for i = 1:length(extract_vars)
    varname = char(extract_vars(i));
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
clear ncid info i varname varid output_type scale_factor offset tf indx filename


%% Create ERA5 reference mean for selected variable(s)

regional_mean1 = mean(tcwv,3);
% regional_mean2 = mean(v100,3);

[lon,lat]=meshgrid(longitude(:),latitude(:));

fig1 = figure;
load coastlines
axesm miller
pcolorm(lat,lon,regional_mean1); shading interp;
% quiverm(lat,lon,regional_mean1,regional_mean2)
setm(gca,'MapLatLimit',[-5 35],'MapLonLimit',[-130 -30])
framem on;
framem('FlineWidth',9)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.1)
cb = colorbar;
colormap jet;
cb.Limits = [20 35];

%% Import Hurricane data and make means

% import data file
TCs = import_gulf_extract('hurdat_gulf_HU_24-30N_85-955W_1940-2021.txt');

% extract cyclone ID numbers 
IDs = string(unique(TCs{:,1},'stable'));

for j = 1:length(IDs)
    
    filename = sprintf('%s.nc',IDs(j));

    ncid = netcdf.open(filename);
    info = ncinfo(filename); %returns all the informations about the file.nc
    output_type= ('''double''');
    for i = 1:length(extract_vars)
        varname = char(extract_vars(i));
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
    clear ncid info i varname varid output_type scale_factor offset tf indx filename
    
    % to create individual variables for each hurricane
%     cycname = sprintf('h_%s',IDs(j));
%     eval([cycname ' = mean(tcwv,3);'])
    
    if j == 1
        sum1 = mean(tcwv,3);
%         sum2 = mean(v100,3);
    else
        sum1 = sum1 + mean(tcwv,3);
%         sum2 = sum2 + mean(v100,3);
    end

end

%% Anomaly analysis

h_mean1 = sum1./32;
% h_mean2 = sum2./32;

h_anom = h_mean1 - regional_mean1;


[lon,lat]=meshgrid(longitude(:),latitude(:));

fig1 = figure;
fig1.Position = [200 200 1400 700];
axes1 = axes('Parent',fig1);
load coastlines
axesm miller
pcolorm(lat,lon,h_anom); shading interp;
% quiverm(lat,lon,h_mean1,h_mean2)
setm(gca,'MapLatLimit',[-5 35],'MapLonLimit',[-130 -30])
framem on;
framem('FlineWidth',9)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.1)
cb = colorbar;
colormap jet;
set(axes1,'CLim',[-10 10]);
cb.Label.String = '\bf \fontsize{14} TCWV Anomaly (kg m^{-2}) ';

title('\bf \fontsize{18} Gulf Hurricane Mean Anomaly from Seasonal Mean 1940-2021')






