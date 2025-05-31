% track wilma era5
% compare with hurdat 

% Program for ERA5 data to track cyclones
%
% Author: Evan David Wellmeyer
% Date Created: April 4, 2022
%
% Description of variables:
% lsm - Land-sea mask
% msl - mean sea level pressure
% sst - sea surface temperature
% t2m - 2 meter temperature
% u100 - 100m u-component of wind
% v100 - 100m v-component of wind
% time - Hourly data from August to December 
% d - divergence  's**-1'
% z - geopotential 'm**2 s**-2'
% pv - potential vorticity 'K m**2 kg**-1 s**-1'
% r - relative humidity '%'
% s - specific humidity 'kg kg**-1'
% t - air temperature 'K'
% u,v,w - wind velocity 'm s**-1','m s**-1','Pa s**-1'
% vo - relative vorticity 's**-1'
% q - specific humidity   'kg kg**-1'
%
% kat Sub-region: -95W:-75W, 35N:20N

clear all;

%% File Selection

filename = 'wilma_surface_era5_2.nc';


%% Auto-extraction of variables

disp('Extracting surface file data...')

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
clear ncid i varname varid output_type scale_factor offset

%% Rename variables to not conflict with second data extraction




%% Extraction of vertical data
 
% disp('Extracting upper level data...')
% 
% filename = 'katrina_up.nc';
% 
% ncid = netcdf.open(filename);
% info = ncinfo(filename); %returns all the informations about the file.nc
% output_type= ('''double''');
% for i = 1:length(info.Variables)
%     varname = info.Variables(i).Name;
%     varid = netcdf.inqVarID(ncid,varname);
%     eval([varname ' = netcdf.getVar(ncid,varid,' output_type ');'])
%     eval([varname ' = pagetranspose(' varname ');']) % sets the order of variables as latitude, longitude, level
%     if i > length(info.Dimensions) % excluding latitude, longitude and time variables
%         scale_factor = ncreadatt(filename,varname,'scale_factor');
%         offset = ncreadatt(filename,varname,'add_offset');
%         eval([varname ' = ' varname '.*scale_factor + offset;']) % compute exact value of the variable
%     end
% end
% 
% % delete dummy variables
% clear ncid info i varname varid output_type scale_factor offset filename
% 
% 



%%  Variable renaming and restructuring
% % Convert hours to date
% % Needed to shift 2 days to compensate for conversion problem
% date = datetime((time/24)+2,'ConvertFrom','excel'); 

% wd = atan2(v100,u100)*57.32+180; % wind direction
U=sqrt(u100.^2+v100.^2);     % wind magnitude

msl = msl./100;

clear u10 v10

%% Look for cyclones and record info
% Cyclone existance conditions:
%       Low pressure, localized (<1010hPa)
%       High surface temperature (>293K)

date = datetime((time/24)+2,'ConvertFrom','excel');
dt = max(time) - min(time);
start = 67;

mask_rad = 5;


latitude_min = zeros(dt,9);
longitude_min = zeros(dt,9);
latitude_max = zeros(dt,9);
longitude_max = zeros(dt,9);

minimum_pressure = zeros(dt,1);
max_wind = zeros(dt,1);

wind_shear = zeros(dt,1);

min_t2m = zeros(dt,1);
max_tp = zeros(dt,1);

mask = zeros(length(latitude),length(longitude),dt);

[lon,lat]=meshgrid(longitude,latitude);

warn = warning('off','all');
disp('Initializing data analysis...')

for t = start:331
    
    
    % Reduce variables to 2D
    MSL = squeeze(msl(:,:,t));
    TEMP = squeeze(sst(:,:,t));
    UV = squeeze(U(:,:,t));
%     TP = squeeze(tp(:,:,t));
%     T2M = squeeze(t2m(:,:,t));

    % Logical matrix for points with pressure under threshold pressure
    xyPRES = MSL < 1008;

    % Logical matrix for points with sst above a threshold temperature
    xyTEMP = TEMP >= 295;
    
    % Logical for Latitude and Longitude window
    if t == start
        LAT1 = lat > 13; LAT2 = lat < 20;
        LON1 = lon > -90; LON2 = lon < -70;
        xyLAT = LAT1.*LAT2; xyLON = LON1.*LON2;
        
        % Confirm TC candidates
        xy_TC = xyPRES.*xyTEMP.*xyLAT.*xyLON;
        
%     elseif t >= 6
%         
%         % Confirm TC candidates
%         xy_TC = xyPRES.*xyTEMP;
    end

 
    
    % create logical matrix for 200 km radius around minimum 
    % Only store values if there are 'confirmed' TC's in timeframe 
    if any(xy_TC==1,'all') && t == start
        MSL = MSL.*xy_TC;
    else
        MSL = MSL .* squeeze(mask(:,:,t-1));      
    end
        
    % find minimum pressure location and store indices    
    minimum = min(min(MSL(MSL>0)));
    [x,y] = find(MSL==minimum);
    x=x(1); y=y(1);

    % create square "mask" around the pressure minimum
    mask(:,:,t) = mk_mask(x,y,lat,mask_rad);

    MSL =  squeeze(msl(:,:,t));

    % Remove non candidates from variables
    MSL = MSL.*squeeze( mask(:,:,t) );
    TEMP = TEMP.*squeeze( mask(:,:,t) ); %#ok<*NASGU>
    UV = UV.*squeeze( mask(:,:,t) );
%     TP = TP.*squeeze( mask(:,:,t) );

    % Find indices of minimum pressure level for tracks
    minimum = min(min(MSL(MSL>0)));
    maximum = max(max(MSL(MSL>0)));

    [x,y] = find(MSL==minimum);
    [rx,ry] = find(MSL==maximum);

    x=x(1); y=y(1);
    rx=rx(1); ry=ry(1);

    latitude_min(t,9) = lat(x,y);
    longitude_min(t,9) = lon(x,y);
    
    latitude_max(t,9) = lat(rx,ry);
    longitude_max(t,9) = lon(rx,ry);
    
    minimum_pressure(t,1) = minimum;
    max_wind(t,1) = max(max(UV));
    
%     min_t2m(t,1) = T2M(x,y);
%     max_tp(t,1) = sum(TP,'all');
    
end
%     
% for t = start:229
% 
%         % record upper level
%     for i = 1:length(level)
%             
%         msk = squeeze( mask(:,:,t) );
% % 
% %         pot_vort = squeeze(pv(:,:,i,t)).*msk;
% %         rel_vort = squeeze(vo(:,:,i,t)).*msk;
% %         spec_hum = squeeze(q(:,:,i,t)).*msk;
% %         rela_hum = squeeze(r(:,:,i,t)).*msk;
% %         temp_upp = squeeze(T(:,:,i,t)).*msk;
%         geopoten = squeeze(z(:,:,i,t)).*msk;
% %         diverg = squeeze(d(:,:,i,t)).*msk;
% %         u_wind = squeeze(u(:,:,i,t)).*msk;
% %         v_wind = squeeze(v(:,:,i,t)).*msk;
% %         w_wind = squeeze(w(:,:,i,t)).*msk;
% 
% %         uv_wind = sqrt(u_wind.^2+v_wind.^2);
% 
%         min_geo = min(min(geopoten(geopoten>0)));
%         max_geo = max(max(geopoten(geopoten>0)));
%         [gx,gy] = find(geopoten==min_geo);
%         [rx,ry] = find(geopoten==max_geo);
%         gx=gx(1); gy=gy(1);
%         rx=rx(1); ry=ry(1);
%         
%         latitude_min(t,i) = lat(gx,gy);
%         longitude_min(t,i) = lon(gx,gy);
% 
%         latitude_max(t,i) = lat(rx,ry);
%         longitude_max(t,i) = lon(rx,ry);
% 
%    
%     end 
%     
%     if mod(t,40)==0
%         disp(['Time step ' num2str(t) ' completed.'])
%     end
% 
% end
% toc


%%

% latitude_min = nonzeros(latitude_min);
% latitude_min = reshape(latitude_min,[],9);
% 
% longitude_min = nonzeros(longitude_min);
% longitude_min = reshape(longitude_min,[],9);
% 
% latitude_max = nonzeros(latitude_max);
% latitude_max = reshape(latitude_max,[],9);
% 
% longitude_max = nonzeros(longitude_max);
% longitude_max = reshape(longitude_max,[],9);

minimum_pressure = nonzeros(minimum_pressure);
max_wind = nonzeros(max_wind);


%% Vertical Profile
% radial displacement from center of minimum at levels
% dt = size(longitude_min,1);
% profile_minmin = zeros(dt,length(level));
% 
% for t = 1:dt
%     for i = 9:-1:2
% 
%         lat1 = latitude_min(t,i);
%         lon1 = longitude_min(t,i);
%         lat2 = latitude_min(t,i-1);
%         lon2 = longitude_min(t,i-1);
% 
%         [profile_minmin(t,10-i),~,~]=haversine([lat1,lon1],[lat2,lon2]);
% 
%     end
% end
% 
% % profile_minmin = profile_minmin(145:229,1:8);
% 
% %% Vertical profile
% % distance between minimum and maximum geopotential height
% 
% profile_minmax = zeros(dt,length(level)+1);
% 
% for t = 1:dt
%     for i = 9:-1:1
% 
%         lat1 = latitude_min(t,i);
%         lon1 = longitude_min(t,i);
%         lat2 = latitude_max(t,i);
%         lon2 = longitude_max(t,i);
% 
%         [profile_minmax(t,10-i),~,~]=haversine([lat1,lon1],[lat2,lon2]);
% 
%     end
% end
% 
% %  profile_minmax = profile_minmax(145:229,:);
% 
% disp('Clearing zero values...')


%% noaa time

ii = 0;
for i = 1:109
   if mod(ii,6)==0 
       noaatime(i) = time(i);
   end
   ii=ii+1;
end

noaatime = nonzeros(noaatime);


%% clear unneeded variables by section 
clear pot_vort rel_vort spec_hum rela_hum temp_upp geopoten diverg u_wind v_wind w_wind uv_wind
clear MSL TEMP UV TP LON1 LON2 LAT1 LAT2 xy_TC xyPRES xyTEMP xyLAT xyLON
% clear lsm msl sst t2m tp U longitude latitude warn
% clear d pv q r T u v vo w z
clear gx gy min_geo minimum x y t dt max_geo
clear R rr rx ry



%% ACE

[ace] = ace_index(max_wind);

%% Figures ?

% run_fig = inputdlg('Enter 1 to compile figures, or 0 to return at script end:');
% run_fig = str2num(run_fig{1}); %#ok<ST2NM>
% 
% if run_fig == 0
%     return
% end


%% Vertical profile Figures
% 
% xx = 1:1:9;
% 
% figure;
% 
% tiledlayout(1,4);
% 
% nexttile
% i = 5;
% plot(profile_minmax(i,:),xx)
% title(['Ida Vertical Profile: August ', num2str(day(i)) ,', hr:', num2str(hour(i)) ])
% xlim([0 200])
% yticks([1 2 3 4 5 6 7 8 9 10])
% yticklabels({'Surf','925','850','750','500','300','250','200','100'});
% 
% nexttile
% i = 30;
% plot(profile_minmax(i,:),xx)
% title(['Ida Vertical Profile: August ', num2str(day(i)) ,', hr:', num2str(hour(i)) ])
% xlim([0 200])
% yticks([1 2 3 4 5 6 7 8 9 10])
% yticklabels({'Surf','925','850','750','500','300','250','200','100'});
% 
% nexttile
% i = 60;
% plot(profile_minmax(i,:),xx)
% title(['Ida Vertical Profile: August ', num2str(day(i)) ,', hr:', num2str(hour(i)) ])
% xlim([0 200])
% yticks([1 2 3 4 5 6 7 8 9 10])
% yticklabels({'Surf','925','850','750','500','300','250','200','100'});
% 
% nexttile
% i = 80;
% plot(profile_minmax(i,:),xx)
% title(['Ida Vertical Profile: August ', num2str(day(i)) ,', hr:', num2str(hour(i)) ])
% xlim([0 200])
% yticks([1 2 3 4 5 6 7 8 9 10])
% yticklabels({'Surf','925','850','750','500','300','250','200','100'});
% 
% clear xx




%% Animation

clear F

file_out = 'kat_era5_msl_tracking.mp4';
fig1 = figure;
load coastlines



ii=1;
for i = 86
    
    clf;
    fig1.Position = [100 100 1000 800];
    fig1.Color = [0 0 0];
    axes1 = axes('Parent',fig1);
    hold on; 
    
%     PRES = squeeze( z(:,:,7,i) ) .* squeeze(mask(:,:,i));
    PRES = squeeze( msl(:,:,i) ) .* squeeze(mask(:,:,i));
%     SST = squeeze( sst(:,:,i) );
%     VAR = squeeze( tp(:,:,i) );% .* squeeze(mask(:,:,i));

    axesm miller
    pcolorm(lat,lon,PRES(:,:)); shading interp;
    setm(gca,'MapLatLimit',[20 33],'MapLonLimit',[-94 -76])
    framem on;
    framem('FlineWidth',9)
    tightmap;
    plotm(coastlat,coastlon,'k','LineWidth',0.1)

    box(axes1,'on');
    hold(axes1,'off');
    cb = colorbar(axes1);
    cb.AxisLocation = 'in';
    colormap(flipud(hot));
    set(axes1,'CLim',[920 1020]);
    cb.Location = 'south';
    cb.Position = [0.21 0.1600 0.614 0.022];
    cb.Color = [0.1 0.1 0.1];
    cb.FontWeight = 'bold';
    cb.FontSize = 12;
    cb.Label.String = '\bf \fontsize{14} Sea Level Pressure (hPa) ';
    
    title('Hurricane Katrina - ERA5 w/ Tracking','FontSize',16,'Units', 'normalized', 'Position', [0.5, .92, 0],'Color',[0.1 0.1 0.1]);
    
    F(ii) = getframe(gca);
    
    drawnow limitrate nocallbacks
    
    ii = ii+1;

end

% write frames to file
writerObj = VideoWriter(file_out,'MPEG-4');
writerObj.FrameRate = 10;
writerObj.Quality = 100;

open(writerObj);

for i=1:length(F)
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end

close(writerObj);


%% Date format for output to txt file
% 
% lat_min = [latitude_min(:,9) latitude_min(:,7) latitude_min(:,6) latitude_min(:,5) latitude_min(:,4) latitude_min(:,3) latitude_min(:,2) latitude_min(:,1)];
% lon_min = [longitude_min(:,9) longitude_min(:,7) longitude_min(:,6) longitude_min(:,5) longitude_min(:,4) longitude_min(:,3) longitude_min(:,2) longitude_min(:,1)];

lat_min = [latitude_min(1:109,9)];
lon_min = [longitude_min(1:109,9)];

% yyyy = num2str(year(IDA_surface.Date));
% mm = num2str(month(IDA_surface.Date),'%02.f');
% dd = num2str(day(IDA_surface.Date),'%02.f');
% hh = num2str(hour(IDA_surface.Date),'%02.f');
% 
% date_out = str2num([yyyy mm dd hh]);
% 
% fileID=fopen('IDA_press.txt','w');
% fprintf(fileID,'%4.f %.2f %.2f %4.0f \n',[date_out IDA_surface.Latitude IDA_surface.Longitude hPa]');
% fclose(fileID);

%% write gulf tcs to file

Y = year(date(67:331));
M = month(date(67:331));
D = day(date(67:331));
HH = hour(date(67:331));
lat = latitude_min(67:331,9);
lon = longitude_min(67:331,9);
kt = max_wind.*1.943844;
pres = minimum_pressure;


fileID=fopen('wilma_era5.txt','w');

Fspec = '%4.0f %2.0f %2.0f %2.0f %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[Y' M' D' HH' lat' lon' kt' pres']');
fclose(fileID);

%%
fileID=fopen('kat_era5_latlon.txt','w');
fprintf(fileID,'%2.4f %2.4f \n',[lat_min lon_min]');
fclose(fileID);

fileID=fopen('kat_era5_lon.txt','w');
fprintf(fileID,'%2.4f \n',[lon_min]');
fclose(fileID);

fileID=fopen('kat_era5_pres.txt','w');
fprintf(fileID,'%4.2f \n',[minimum_pressure(1:109)]');
fclose(fileID);

fileID=fopen('kat_era5_time.txt','w');
fprintf(fileID,'%4.2f \n',[time(1:109)]');
fclose(fileID);

fileID=fopen('kat_era5_wind.txt','w');
fprintf(fileID,'%2.3f \n',[max_wind(1:109)]');
fclose(fileID);

fileID=fopen('IDA_era5_profile_minmin.txt','w');
fprintf(fileID,'%3.4f %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f \n',[profile_minmin]');
fclose(fileID);

fileID=fopen('IDA_era5_profile_minmax.txt','w');
fprintf(fileID,'%3.4f %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f %3.4f \n',[profile_minmax]');
fclose(fileID);

fileID=fopen('kat_noaa_time.txt','w');
fprintf(fileID,'%7.0f \n',[noaatime]');
fclose(fileID);

fileID=fopen('kat_era5_t2m.txt','w');
fprintf(fileID,'%3.2f \n',[min_t2m]');
fclose(fileID);

fileID=fopen('kat_era5_tp_sum.txt','w');
fprintf(fileID,'%1.4f \n',[max_tp]');
fclose(fileID);

function [mask] = mk_mask(x,y,lat,mask_rad)

    mask = zeros(size(lat,1),size(lat,2));
        
    if x+mask_rad <= size(lat,1) && x-mask_rad >= 1 && y+mask_rad <= size(lat,2) && y-mask_rad >= 1
        mask( x-mask_rad:x+mask_rad , y-mask_rad:y+mask_rad ) = 1;
    elseif x+mask_rad >= size(lat,1) && y+mask_rad >= size(lat,2)
        mask( x-mask_rad:size(lat,1) , y-mask_rad:size(lat,2) ) = 1;
    elseif x+mask_rad >= size(lat,1)
        mask( x-mask_rad:size(lat,1) , y-mask_rad:y+mask_rad ) = 1;
    elseif x-mask_rad <= 1
        mask( 1:x+mask_rad , y-mask_rad:y+mask_rad ) = 1;
    elseif y+mask_rad >= size(lat,2)
        mask( x-mask_rad:x+mask_rad , y-mask_rad:size(lat,2) ) = 1;
    elseif y-mask_rad <= 1
        mask( x-mask_rad:x+mask_rad , 1:y+mask_rad ) = 1;
    end
    
end

function [ace] = ace_index(max_wind)

    clear ace

    knots = max_wind.*1.943844;

    knots35 = knots > 35;
    kts = knots.*knots35;
    knots = nonzeros(kts);

    knots2 = knots.^2;

    i = 1;
    while i < length(knots2)

        if i+6 <= length(knots2)
            ace(i,1) = mean(knots2(i:i+6));
        end

        i = i+6;

    end

    ace = nonzeros(ace);

    ace = sum(ace)./10^4;

end
