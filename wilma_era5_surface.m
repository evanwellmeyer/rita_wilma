% wilma era5 surface 

clear all;

%% File Selection

filename = 'msl_sst.nc';


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

date = datetime((time/24)+2,'ConvertFrom','excel');

%% variable manipulation

sst14 = sst(:,:,5)-273.15;
sst15 = sst(:,:,9)-273.15;
sst18 = sst(:,:,24)-273.15;
sst22 = sst(:,:,37)-273.15;
sst24 = sst(:,:,45)-273.15;
sst25 = sst(:,:,47)-273.15;
sst26 = sst(:,:,53)-273.15;

sstm = mean(sst(:,:,17:36),3)-273.15;
for i = 1:221
    for j = 1:301
        if sst14(i,j) < 5.83
            sst14(i,j) = 0;
        end
        
        if sstm(i,j)==6.998525741265439
            sstm(i,j) = 0;
        end
    end
end


ssta = sst14 - sstm;
ssta18 = sst18 - sstm;
ssta22 = sst22 - sstm;
ssta24 = sst24 - sstm;
ssta25 = sst25 - sstm;
ssta26 = sst26 - sstm;
% v = v(1:2:end,1:2:end,:);
% u = u(1:2:end,1:2:end,:);
% 
% longitude = longitude(1:2:end);
% latitude = latitude(1:2:end);

zh = z./9.80665;

vo = vo.*3600; % 1/hr
t = t - 273.15;

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
[qlon,qlat]=meshgrid(longitude(1:4:end),latitude(1:4:end));

for i = 1:6:174
    
    load coastlines
    fig1 = figure;
    fig1.Position = [182 271 1091 794]; 

    hold on; 
    worldmap('World')
    worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
%     contourm(lat,lon,msl(:,:,i)./100,'k','ShowText','on','LevelStep',2)
    pcolorm(lat,lon,sst14); shading interp; colormap(turbo); 
    cb = colorbar;
    cb.FontWeight = 'bold';
    cb.FontSize = 12;
    cb.Box = 'on';
    cb.LineWidth = 1;
%     caxis([-2 2]);
    cb.Label.String = '\bf \fontsize{14} SST (C)';

%     quiverm(qlat,qlon,v(1:4:end,1:4:end,4,i),u(1:4:end,1:4:end,4,i),'k',2);
    

%      t=plotm(hurdat{:,8},hurdat{:,9},'Color','k','MarkerSize',13,'LineWidth',2);
%      plotm(hurdat{39,8},hurdat{39,9},'Color','k','Marker','o','MarkerSize',12,'LineWidth',3);
%      x=plotm(hurdat{39,8},hurdat{39,9},'Color','r','Marker','o','MarkerSize',12,'LineWidth',2);

    
    setm(gca,'MapLatLimit',[10 45],'MapLonLimit',[-100 -55])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'k','LineWidth',0.5)
    title( datestr(date(5),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
            'FontWeight','bold','Units', 'normalized');
    legend([t x],{'Hurricane Wilma Track','Position at Time'},'location','northwest','FontSize',20)
% title('October 15 to 26 SST Difference','FontSize',20,'FontWeight','bold')
        
    fileout = ['ssta_',datestr(date(47),'mmddHHMM')]; 
    print(fileout,'-dpng','-r200',fig1);
    pause(.1)
    close(fig1);
    
end

%%

[lon,lat]=meshgrid(longitude,latitude);

load coastlines
fig1 = figure;
fig1.Position = [182 271 1091 794];  
% fig1.Position = [1 41 3440 1323]; %full screen

tl = tiledlayout('flow');

% 1000 hpa
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,sst(:,:,220)); shading interp;

plotm(hurdat{:,8},hurdat{:,9},'Color','k','MarkerSize',13,'LineWidth',1)

plotm(hurdat{12,8},hurdat{12,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{12,8},hurdat{12,9},'Color','g','Marker','x','MarkerSize',12,'LineWidth',2)

plotm(hurdat{13,8},hurdat{13,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{13,8},hurdat{13,9},'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)

plotm(hurdat{14,8},hurdat{14,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{14,8},hurdat{14,9},'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)

% quiverm(lat,lon,v(:,:,5),u(:,:,5),'k',3); hold on;
% plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
% plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 1000 hPa');
cb = colorbar;
colormap(turbo);
caxis([26 30]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on');

% 900 hpa
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,8)); shading interp;
% quiverm(lat,lon,v(:,:,8),u(:,:,8),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 900 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

% 800
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,7)); shading interp;
% quiverm(lat,lon,v(:,:,7),u(:,:,7),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 800 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

% 700 hpa
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,6)); shading interp;
% quiverm(lat,lon,v(:,:,6),u(:,:,6),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 700 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on');


% 600
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,5)); shading interp;
% quiverm(lat,lon,v(:,:,5),u(:,:,5),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 600 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

% 500
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,4)); shading interp;
% quiverm(lat,lon,v(:,:,4),u(:,:,4),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 500 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

% 400 hpa
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,3)); shading interp;
% quiverm(lat,lon,v(:,:,3),u(:,:,3),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 400 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on');


% 300
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,2)); shading interp;
% quiverm(lat,lon,v(:,:,2),u(:,:,2),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 300 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

% 200
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,w(:,:,1)); shading interp;
% quiverm(lat,lon,v(:,:,1),u(:,:,1),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 200 hPa');
cb = colorbar;
colormap(mymap);
caxis([-1 1]);
cb.Label.String = '\bf \fontsize{10} Vertical Velocity (m s^{-1}) ';
gridm('on')

title(tl,'\bf \fontsize{20} Hurricane Wilma October 19 00UTC')
% print('wilma_track','-dpng','-r400',fig1);






[lat,lon]=meshgrid(latitude,longitude);

for i = 1:221
   lat14(:,i) = lat(:,222-i);
end




%% Write combined netCDF

disp('Writing netCDF file...')

file_out = 'SSTA_flip.nc';

% create netCDF file with variables
nccreate(file_out,'SSTA','Dimensions',{'lon',301,'lat', 221});
nccreate(file_out,'latitude','Dimensions',{'lon',301,'lat', 221});
nccreate(file_out,'longitude','Dimensions',{'lon',301,'lat', 221});


% write matlab variables to netCDF variables
ncwrite(file_out,'SSTA',ssta14)
ncwrite(file_out,'latitude',lat14)
ncwrite(file_out,'longitude',lon)

