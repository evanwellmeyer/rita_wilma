%% WRF Hurricane track v3 - Wilma version

%% Track cyclone wrf output
%
% Author: Evan David Wellmeyer
% Date Created: Nov 28, 2023

% Variable Descripitions:
%   DateTime ?
%   SST     - sea surface temperature
%   T_2m    - 2 meter temperature
%   T_p     - air temperature
%   Td_p    - dew point temperature
%   Z_p     - geopotential
%   pp_p    - pressure perturbation
%   q_p     - specific humidity
%   r_v_p   - mixing ratio
%   rh_p    - relative humidity
%   theta_p - potential temperature
%   p_sfc   - surface pressure
%   slp     - sea level pressure


% variable testing %
% figure; axesm miller; pcolorm(lat,lon,squeeze(T_p(10,6,:,:))); colorbar;

clear all; %#ok<CLALL>

%% File Input

[file, path] = uigetfile('*.nc','Select the WRF .nc file for analysis:');
file_in = [path,file];

%%

disp('Extracting file data...')

info = ncinfo(file_in);
ncload(file_in)

clear path file file_in


%% Cleaning variables
disp('Cleaning variables...')

sst = SST; clear SST;

lat = squeeze(XLAT(1,:,:));
lon = squeeze(XLONG(1,:,:));
time = XTIME; clear XTIME;

flux =(HFX+LH);

UV = sqrt(U10.^2+V10.^2);  

%% make date 

date = datetime(2005,10,18,00,00,00) + hours(0:3:96);


%% Track cyclone
disp('Calculating cyclone track...')

%[km,nmi,mi] = haversine([lat(1,1) lon(1,1)], [lat(1,1) lon(10,10)]);
mask_rad = 15;
dt = length(time);
latitude_min = zeros(dt,1);
longitude_min = zeros(dt,1);

minimum_pressure = zeros(dt,1);
max_wind = zeros(dt,1);

% mask_surf = zeros(size(lat,1),size(lat,2));
mask = zeros(dt,size(lat,1),size(lat,2));

for t = 1:dt
    
%     mask = zeros(size(lat,1),size(lat,2));
    
    % squeeze matrices to time step
    SLP = squeeze(PSFC(t,:,:));
    U = squeeze(UV(t,:,:));
    
    if t <= 1
        LAT1 = lat > 14; LAT2 = lat < 18;
        LON1 = lon > -82; LON2 = lon < -78;
        xyLAT = LAT1.*LAT2; xyLON = LON1.*LON2;  
        
        % Confirm TC candidates
        xy_TC = xyLAT.*xyLON;
    end
    
    % create logical matrix for radius around minimum 
    % Only store values if there are 'confirmed' TC's in timeframe 
    if any(xy_TC==1,'all') && t <= 1
        SLP = SLP.*xy_TC;
    else
        SLP = SLP .* squeeze(mask(t-1,:,:));      
    end
    
    minimum = min(SLP(SLP>0),[],'all');
    
    [x,y] = find(SLP==minimum);
    x=x(1); y=y(1);
    latitude_min(t,1) = lat(x,y);
    longitude_min(t,1) = lon(x,y);

    mask(t,:,:) = mk_mask(x,y,lat,mask_rad);
    SLP = squeeze(PSFC(t,:,:)) .* squeeze(mask(t,:,:));
    

    U = U.*squeeze(mask(t,:,:));
    max_wind(t) = max(U,[],'all');
    minimum_pressure(t) = minimum;
        
end


% extract variables from within radius of tc position
rad2=20; % ~60km radius

uv_max = NaN(dt,1);
precip = NaN(dt,1);
flux_tt = NaN(dt,1);


for t = 1:dt
    
    tc = [latitude_min(t) longitude_min(t)];
    [x,y] = find(lat(:,:)==tc(1) & lon(:,:)==tc(2));
    
    msk = mk_mask(x,y,lat,rad2);
    
    % max wind
    U = squeeze(UV(t,:,:)).*msk;
    uv_max(t) = max(U,[],'all');
    
    % total Precipitation
    p = squeeze(RAINNC(t,:,:)).*msk;
    precip(t) = max(p,[],'all');
    
    % total flux
    f = squeeze(flux(t,:,:)).*msk;
    flux_tt(t) = max(f,[],'all');
    

end

f = squeeze(flux(t,:,:)).*squeeze(mask(t,:,:));
[x,y] = find(f==max(f,[],'all'));
lat(x,y)
lon(x,y)

%% ACE

[ace] = ace_index(max_wind);

%% DR

DR = get_bergeron_3hr(minimum_pressure./100,24);


%% Run figures?

if run_fig == 0
    return
end

%% Tracks Figures

fig = figure;
% tlo = tiledlayout(fig, 'flow','TileSpacing','compact');

% nexttile
geoplot(latitude_min(:,1),longitude_min(:,1),'k')
axesm miller
geolimits([10 35],[-100 -70]);
geobasemap colorterrain
linem([16.5489; 16.5489],[-99.6; -73])
linem([32.8 -99.6],[32.8 -73])
title('Surface')


%% domain

figure;
load coastlines
axesm miller
plotm(coastlat,coastlon,'k','LineWidth',0.1)
% geobasemap colorterrain
linem([16.55; 16.55],[-99.6; -73],'LineWidth',2)
linem([32.8; 32.8],[-99.6; -73],'LineWidth',2)
linem([16.55; 32.8],[-99.6; -99.6],'LineWidth',2)
linem([16.55; 32.8],[-73; -73],'LineWidth',2)
axesm('miller','Frame','on','Grid','on','MeridianLabel','on')
setm(gca,'MapLatLimit',[12 38],'MapLonLimit',[-105 -68])
framem on;
framem('FlineWidth',6)





%% figs test


fig1 = figure;
load coastlines
fig1.Position = [100 100 1000 800];

axes1 = axes('Parent',fig1);
hold on; 
axesm miller
VAR = squeeze( flux(1,:,:) );% .* squeeze(mask(i,:,:));
pcolorm(lat,lon,VAR); shading interp;
% setm(gca,'MapLatLimit',[14 18],'MapLonLimit',[-82 -78])
framem on;
framem('FlineWidth',9)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.1)

set(axes1,'CLim',[920 1020]);
cb = colorbar;
colormap(turbo);
cb.FontWeight = 'bold';
cb.FontSize = 12;
cb.Label.String = '\bf \fontsize{14} Sea Level Pressure (hPa) ';



   
    

%% File out

Y = year(date(:));
M = month(date(:));
D = day(date(:));
HH = hour(date(:));
lat = latitude_min(:);
lon = longitude_min(:);
kt = uv_max.*1.943844;
pres = minimum_pressure./100;



fileID=fopen('wilma_wrf_sst_noanm2.txt','w');

Fspec = '%4.0f %2.0f %2.0f %2.0f %3.1f %6.1f %3.0f %4.0f %5.2f %6.1f %5.1f \n';
fprintf(fileID,Fspec,[Y M D HH lat lon kt pres DR flux_tt precip]');
fclose(fileID);



%%



