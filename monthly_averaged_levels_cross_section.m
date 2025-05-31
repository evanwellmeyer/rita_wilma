% Analysis of monthly averaged levels variables from 1960 to 2021

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

%%

u_hs = u(:,:,:,hurs_ind);


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
fig1.Position = [10 10 1600 400];

t = tiledlayout(1,3);

t1 = nexttile;
hold(t1,'on');
pcolor(y,x,u_hs_av_lat); shading interp;
ylabel('Pressure Level (hPa)')
xlabel('Longitude')
box(t1,'on');
axis(t1,'ij');
hold(t1,'off');
set(t1,'CLim',[-12 12],'Layer','top');
colormap(mymap);
cb = colorbar;
ylim([50 1000]);
cb.FontWeight = 'bold';
cb.FontSize = 12;
cb.Color = [0 0 0];
cb.Box = 'on';
cb.LineWidth = 1;
cb.Label.String = '\bf \fontsize{12} Zonal Wind (m s^{-1}) ';
title('HS Mean')

t2 = nexttile;
hold(t2,'on');
pcolor(y,x,u_av_lat); shading interp;
ylabel('Pressure Level (hPa)')
xlabel('Longitude')
box(t2,'on');
axis(t2,'ij');
hold(t2,'off');
set(t2,'CLim',[-12 12],'Layer','top');
colormap(mymap);
cb = colorbar;
ylim([50 1000]);
cb.FontWeight = 'bold';
cb.FontSize = 12;
cb.Color = [0 0 0];
cb.Box = 'on';
cb.LineWidth = 1;
cb.Label.String = '\bf \fontsize{12} Zonal Wind (m s^{-1}) ';
title('Mean')

t3 = nexttile;
hold(t3,'on');
pcolor(y,x,u_hs_av_lat-u_av_lat); shading interp;
ylabel('Pressure Level (hPa)')
xlabel('Longitude')
box(t3,'on');
axis(t3,'ij');
hold(t3,'off');
set(t3,'CLim',[-12 12],'Layer','top');
colormap(mymap);
cb = colorbar;
ylim([50 1000]);
cb.FontWeight = 'bold';
cb.FontSize = 12;
cb.Color = [0 0 0];
cb.Box = 'on';
cb.LineWidth = 1;
cb.Label.String = '\bf \fontsize{12} Zonal Wind (m s^{-1}) ';
title('HS Anomaly')

title(t,'\bf \fontsize{14} Longitudinal Variation of Mean Zonal Wind Averaged 10S-30N 1960-2021');

% print('u_levels_lon_av','-dpng','-r400',fig1);









