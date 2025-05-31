% wilma era5 anomalies 

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

%% renaming wilma vars

cape_w = cape;
ie_w = ie;
msl_w = msl./100;
slhf_w = slhf;
sst_w = sst - 273.15;
tcw_w = tcw;
tcwv_w = tcwv;
u100_w = u100;
v100_w = v100;
uv100_w = sqrt(u100_w.^2 + v100_w.^2);
date_w = date;


%% import climatological average data

[file, path] = uigetfile('*.nc','Select the data file for analysis:');
filename = [path,file];

% Auto-extraction of variables

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


ii=1;
for i = 1:length(date)
    if month(date(i)) == 6 || month(date(i)) == 7 || month(date(i)) == 8 || month(date(i)) == 9 || month(date(i)) == 10 ||month(date(i)) == 11
        hurs_ind(ii) = i; %#ok
        ii = ii +1;
    end
end
clear i ii;


% cape

var = cape;
hu_cape = var(:,:,hurs_ind);
hu_mean_cape = mean(hu_cape,3);

all_mean_cape = mean(var,3);

% msl

var = msl./100;

hu_msl = var(:,:,hurs_ind);
hu_mean_msl = mean(hu_msl,3);

all_mean_msl = mean(var,3);

% sst

var = sst - 273.15;

hu_sst = var(:,:,hurs_ind);
hu_mean_sst = mean(hu_sst,3);

all_mean_sst = mean(var,3);

% uv100

var = sqrt(u100.^2 + v100.^2);

hu_uv = var(:,:,hurs_ind);
hu_mean_uv = mean(hu_uv,3);

all_mean_uv = mean(var,3);


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


clear F

filename1 = 'wilma_mslp_anom.mp4';

load coastlines
fig1 = figure;
% fig1.Position = [40 50 2250 700]; 
% % fig1.Position = [1 41 3440 1323]; %full screen
% 
% t = tiledlayout(1,2);
% axes1 = axes('Parent',fig1);

ii = 1;
start = 150;
END = size(msl_w,3);

for i = start:END
    
    clf;
    
    fig1.Position = [40 50 2250 700]; 
    % fig1.Position = [1 41 3440 1323]; %full screen

    t = tiledlayout(1,2);

    % Hurricane season mean ie
    t1 = nexttile;
    hold on; 
    worldmap('World')
    worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,uv100_w(:,:,i)); %shading interp;
    setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'k','LineWidth',0.5)
    title('\bf \fontsize{14} MSLP');
    cb = colorbar;
    colormap(t1,mymap);
    caxis([0 40]);
    cb.Label.String = '\bf \fontsize{13} MSLP (hPa) ';
    gridm('on');

    % total mean
    t2 = nexttile;
    hold on; 
    worldmap('World')
    worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,uv100_w(:,:,i)-hu_mean_uv); %shading interp;
    setm(gca,'MapLatLimit',[-30 50],'MapLonLimit',[-120 20])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'k','LineWidth',0.5)
    title('\bf \fontsize{14} MSLP Anomaly from H-Season Mean');
    cb = colorbar;
    colormap(t2,mymap);
    caxis([-20 20]);
    cb.Label.String = '\bf \fontsize{13} MSLP Anomaly (hPa) ';
    gridm('on')
    
    
    title(t, datestr(date_w(i),'mmmm dd, yyyy HH:MM') ,'FontSize',18,'FontWeight','bold');

    hold off;
    F(ii) = getframe(gcf);

    ii = ii + 1;
    
    if mod(i,20)==0
        disp(['Iteration: ',num2str(i)])
    end
end

% write frames to file
writerObj = VideoWriter(filename1,'MPEG-4');
writerObj.FrameRate = 2;
writerObj.Quality = 100;


open(writerObj);

for i=1:length(F)
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end

close(writerObj);

