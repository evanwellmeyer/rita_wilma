% Analysis of levels variables at rapid intensification

clear all;

%% File Selection

filename = 'wilma_levels_RI.nc';

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



%%

u_hs = u(:,:,:,hurs_ind);

uv = sqrt(u.^2 + v.^2);

u_av = mean(u,4);
u_hs_av = mean(u_hs,4);

u_av_lat = squeeze(mean(u_av,1));
u_hs_av_lat = squeeze(mean(u_hs_av,1));

[x,y]=meshgrid(level,longitude);

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


fig1 = figure;
fig1.Position = [10 10 1200 800];

tl = tiledlayout('flow');

i=48;
t1 = nexttile;
hold(t1,'on');
% pcolor(y,x,squeeze(t(18,:,:,i)-273.15)); shading interp;
contour(y,x,squeeze(w(18,:,:,i)),'k','ShowText','on','LevelStep',2)
ylabel('Pressure Level (hPa)')
xlabel('Longitude')
box(t1,'on');
axis(t1,'ij');
hold(t1,'off');

% set(t1,'CLim',[10 28],'Layer','top');
% colormap(turbo);
% cb = colorbar;
% cb.FontWeight = 'bold';
% cb.FontSize = 12;
% cb.Color = [0 0 0];
% cb.Box = 'on';
% cb.LineWidth = 1;
% cb.Label.String = '\bf \fontsize{12} Zonal Wind (m s^{-1}) ';

ylim([100 1000]);
xlim([-90 -78])

ttl = sprintf('%s - %s',datestr(date(i),'mmmm dd, yyyy HH:MM'),'Horizontal Wind');
title( ttl,'FontSize',20,'FontWeight','bold','Units', 'normalized')

% print('u_levels_lon_av','-dpng','-r400',fig1);










fig1 = figure;
fig1.Position = [10 10 1200 800];

tl = tiledlayout('flow');

i=19;
t1 = nexttile;
hold(t1,'on');
semilogy(squeeze(t(22,43,:,i)-273.15),level)
ylabel('Pressure Level (hPa)')
xlabel('Temperature')
box(t1,'on');
axis(t1,'ij');
hold(t1,'off');


% ylim([1 1000]);
% xlim([-90 -78])

ttl = sprintf('%s - %s',datestr(date(i),'mmmm dd, yyyy HH:MM'),'Horizontal Wind');
title( ttl,'FontSize',20,'FontWeight','bold','Units', 'normalized')



