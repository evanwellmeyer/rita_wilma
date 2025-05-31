%% WRF Hurricane track v3 - Wilma version

%% Track cyclone wrf output
%
% Author: Evan David Wellmeyer
% Date Created: Nov 28, 2023
% Modified: March 08, 2024



clear all; %#ok<CLALL>

%% File Input

[file, path] = uigetfile('*.nc','Select the WRF .nc file for analysis:');
file_in = [path,file];

%%

disp('Extracting file data...')

info = ncinfo(file_in);
ncload(file_in)

clear path file file_in

lsm = double(nc_varget('rita_lsm.nc','LANDMASK'));
lsm = lsm.*-1 + 1;

lkm = double(nc_varget('lakemask.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

lm = lsm.*lkm;


%% Cleaning variables
disp('Cleaning variables...')

lat = squeeze(XLAT(1,:,:)); clear XLAT;
lon = squeeze(XLONG(1,:,:)); clear XLON;

flux =(HFX+LH);

UV = sqrt(U10.^2+V10.^2);  

%% make date 

date = datetime(2005,09,20,12,00,00) + hours(0:3:110);
date = date';


%% Track cyclone
disp('Calculating cyclone track...')

%[km,nmi,mi] = haversine([lat(1,1) lon(1,1)], [lat(90,90) lon(90,90)]);
mask_rad = 30;
dt = length(date);
latitude_min = zeros(dt,1);
longitude_min = zeros(dt,1);

minimum_pressure = zeros(dt,1);
max_wind = zeros(dt,1);

% mask_surf = zeros(size(lat,1),size(lat,2));
mask = zeros(dt,size(lat,1),size(lat,2));

for t = 1:22
    
%     mask = zeros(size(lat,1),size(lat,2));
    
    % squeeze matrices to time step
    if t <= 15
        SLP = squeeze(PSFC(t,:,:)).*lm;
    else
        SLP = squeeze(PSFC(t,:,:));
    end
    
    U = squeeze(UV(t,:,:));
    
    if t <= 1
        LAT1 = lat > 23; LAT2 = lat < 25;
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
rad2=50; % ~60km radius

uv_max = NaN(dt,1);
precip = NaN(dt,1);
flux_tt = NaN(dt,1);
h_ttl = NaN(dt,1);

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
    f = squeeze(flux(t,:,:)).*msk.*lm;
    flux_tt(t) = max(f,[],'all');
    
    % total heat
    msk = mk_mask(x,y,lat,95);
    f_mskd = squeeze(flux(t,:,:)).*msk.*lm;
    h_ttl(t) = mean(f_mskd(f_mskd>0),'all').*(3.3623*10^11).*10^(-12);
    

end

% f = squeeze(flux(t,:,:)).*squeeze(mask(t,:,:));
% [x,y] = find(f==max(f,[],'all'));
% lat(x,y)
% lon(x,y)

%% ACE

[ace] = ace_index3(max_wind.*1.943844);

%% DR

DR = get_bergeron_3hr(minimum_pressure./100,24);

%%
return;
% plot the pressure at each time step with center determined by tracking
% algorithm
load coastlines %#ok
fig1 = figure;
fig1.Position = [182 271 2188 965]; 

tl = tiledlayout('flow','TileSpacing','none','Padding','tight');
for i = 1:1:35

    nexttile
    hold on; 
    worldmap('World')
    worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
    axesm('miller')
    pcolorm(lat,lon,squeeze(PSFC(i,:,:)./100)); shading interp; colormap(turbo); 
    % quiverm(lat,lon,squeeze(v(22,:,:)),squeeze(u(22,:,:)),'k',2);
    scatterm(latitude_min(i),longitude_min(i),30,'x','k')
    scatterm(latitude_min(i),longitude_min(i),20,'x','r')
    caxis([880 1000]);
    setm(gca,'MapLatLimit',[latitude_min(i)-2 latitude_min(i)+2],...
        'MapLonLimit',[longitude_min(i)-2 longitude_min(i)+2])
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



%% Tracks Figures


figure;
geoplot(latitude_min(:,1),longitude_min(:,1),'k')
geolimits([10 35],[-100 -70]);
geobasemap colorterrain

figure;
plot(minimum_pressure)



% %% domain
% 
% figure;
% load coastlines
% axesm miller
% plotm(coastlat,coastlon,'k','LineWidth',0.1)
% % geobasemap colorterrain
% linem([16.55; 16.55],[-99.6; -73],'LineWidth',2)
% linem([32.8; 32.8],[-99.6; -73],'LineWidth',2)
% linem([16.55; 32.8],[-99.6; -99.6],'LineWidth',2)
% linem([16.55; 32.8],[-73; -73],'LineWidth',2)
% axesm('miller','Frame','on','Grid','on','MeridianLabel','on')
% setm(gca,'MapLatLimit',[12 38],'MapLonLimit',[-105 -68])
% framem on;
% framem('FlineWidth',6)
% 
% 
% 
% 
% 
% %% figs test
% 
% 
% fig1 = figure;
% load coastlines
% fig1.Position = [100 100 1000 800];
% 
% axes1 = axes('Parent',fig1);
% hold on; 
% axesm miller
% VAR = squeeze( PSFC(3,:,:) );% .* squeeze(mask(i,:,:));
% pcolorm(lat,lon,(VAR./100).*lsm); shading interp;
% setm(gca,'MapLatLimit',[20 32],'MapLonLimit',[-99 -78])
% framem on;
% framem('FlineWidth',9)
% tightmap;
% plotm(coastlat,coastlon,'k','LineWidth',0.1)
% 
% set(axes1,'CLim',[980 1000]);
% cb = colorbar;
% colormap(turbo);
% cb.FontWeight = 'bold';
% cb.FontSize = 12;
% cb.Label.String = '\bf \fontsize{14} Sea Level Pressure (hPa) ';

latitude_min(36:37) = NaN;
longitude_min(36:37) = NaN;
uv_max(36:37) = NaN;
minimum_pressure(36:37) = NaN;
DR(32:33) = NaN;
    

%% File out

Y = year(date(:));
M = month(date(:));
D = day(date(:));
HH = hour(date(:));
lats = latitude_min(:);
lons = longitude_min(:);
kt = uv_max.*1.943844;
pres = minimum_pressure./100;



fileID=fopen('rita_p3.txt','w');

Fspec = '%4.0f %2.0f %2.0f %02.0f %7.4f %7.4f %4.1f %4.0f %5.2f %6.1f %5.1f %5.1f \n';
fprintf(fileID,Fspec,[Y M D HH lats lons uv_max pres DR flux_tt precip h_ttl]');
fclose(fileID);
