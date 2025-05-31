% wilma era5 levels 

clear all;

%% File Selection

filename = 'wilma_levels.nc';


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

% v = v(1:2:end,1:2:end,:);
% u = u(1:2:end,1:2:end,:);
% 
% longitude = longitude(1:2:end);
% latitude = latitude(1:2:end);

uv = sqrt(u.^2 + v.^2);

shear = squeeze( sqrt( (u(:,:,1,:) - u(:,:,3,:)).^2 + (v(:,:,1,:) - v(:,:,3,:)).^2) );

LR = (squeeze(t(:,:,1,:)) - squeeze(t(:,:,4,:)))./(squeeze(z(:,:,1,:)./9.81)./1000 - squeeze(z(:,:,4,:)./9.81)./1000);

vort = squeeze(vo(:,:,3,:) + vo(:,:,4,:))./2;

rr = squeeze(r(:,:,1,:) + r(:,:,2,:) + r(:,:,3,:) + r(:,:,4,:))./4;

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

for i = 1:4:60
    
    load coastlines
    fig1 = figure;
    fig1.Position = [182 271 1091 794]; 

    hold on; 
    worldmap('World')
    worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
    axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
    pcolorm(lat,lon,t(:,:,i)-273.15); shading interp; colormap(turbo); 
    cb = colorbar;
    cb.FontWeight = 'bold';
    cb.FontSize = 12;
    cb.Box = 'on';
    cb.LineWidth = 1;
    caxis([10 21]);
    cb.Label.String = '\bf \fontsize{14} 850 hPa Temperature (C)';


%     quiverm(qlat,qlon,v(1:4:end,1:4:end,3,i),u(1:4:end,1:4:end,3,i),'k',2);
    
%     if i >= 67
%         plotm(era5(i-66,5),era5(i-66,6),'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
%         plotm(era5(i-66,5),era5(i-66,6),'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
%     end
    
    setm(gca,'MapLatLimit',[-10 45],'MapLonLimit',[-110 -35])
    framem on;
    framem('FlineWidth',3)
    tightmap;
    plotm(coastlat,coastlon,'w','LineWidth',0.5)
    
    [c,h] = contourm(lat,lon,msl(:,:,i)./100,'k','ShowText','on','LevelList',[998,1002,1006,1008,1010,1012,1014,1016]);
    clabelm(c,h,'manual')
    
    ttl = sprintf('%s - %s',datestr(date(i),'mmmm dd, yyyy HH:MM'),'Mean Sea Level Pressure (hPa)');
    title( ttl,'FontSize',20,'FontWeight','bold','Units', 'normalized')
%     xlabel( datestr(date(i),'mmmm dd, yyyy HH:MM') ,'FontSize',20,...
%             'FontWeight','bold','Units', 'normalized');
        
    fileout = ['msl_t_850_',datestr(date(i),'mmddHHMM')]; 
    print(fileout,'-djpeg','-r200',fig1);
    close(fig1);
    
end

%%
[lon,lat]=meshgrid(longitude,latitude);

load coastlines
fig1 = figure;
fig1.Position = [10 10 1855 1345]; 
% fig1.Position = [1 41 3440 1323]; %full screen

tl = tiledlayout('flow');

% 1000 hpa
nexttile
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
% pcolorm(lat,lon,w(:,:,9)); shading interp;
quiverm(lat,lon,v(:,:,5),u(:,:,5),'k',3); hold on;
plotm(16.8,-81.8,'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(16.8,-81.8,'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)
setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 1000 hPa');
cb = colorbar;
colormap(mymap);
caxis([-.5 .5]);
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
% print('wilma_w_levels','-dpng','-r400',fig1);