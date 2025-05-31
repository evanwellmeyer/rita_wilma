% ocean variables


clear all;

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
%     if i > length(info.Dimensions) % excluding latitude, longitude and time variables
%         scale_factor = ncreadatt(filename,varname,'scale_factor');
%         offset = ncreadatt(filename,varname,'add_offset');
%         eval([varname ' = ' varname '.*scale_factor + offset;']) % compute exact value of the variable
%     end
end

% delete dummy variables
clear ncid i varname varid output_type scale_factor offset file path filename




% [lon,lat]=meshgrid(nav_lon,nav_lat);

load coastlines
fig1 = figure;
fig1.Position = [182 271 1091 794];  
% fig1.Position = [1 41 3440 1323]; %full screen

tl = tiledlayout('flow');

% 1000 hpa
nexttile
hold on; 
worldmap('World')
% worldmap([min(nav_lat,'all') max(nav_lat,'all')],[min(nav_lon,'all') max(nav_lon,'all')])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(nav_lat,nav_lon,sohtc300(:,:)./10^9); shading interp;


plotm(hurdat{:,8},hurdat{:,9},'Color','k','MarkerSize',13,'LineWidth',1)

plotm(hurdat{12,8},hurdat{12,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{12,8},hurdat{12,9},'Color','g','Marker','x','MarkerSize',12,'LineWidth',2)

plotm(hurdat{13,8},hurdat{13,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{13,8},hurdat{13,9},'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)

plotm(hurdat{14,8},hurdat{14,9},'Color','k','Marker','x','MarkerSize',13,'LineWidth',3)
plotm(hurdat{14,8},hurdat{14,9},'Color','r','Marker','x','MarkerSize',12,'LineWidth',2)


setm(gca,'MapLatLimit',[3 30],'MapLonLimit',[-100 -60])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{14} 1000 hPa');
cb = colorbar;
colormap(turbo);
caxis([1 30]);
cb.Label.String = '\bf \fontsize{10} 300m Ocean Heat Content (MJ m^{-2}) ';
gridm('on');

