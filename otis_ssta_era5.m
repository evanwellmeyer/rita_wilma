% Otis SST anomaly 


%% import climate file 

filename = 'sst_september_1985-2005.nc';

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
clear ncid info i varname varid output_type scale_factor offset tf indx filename

sst_mean = mean(sst,3);

%% import otis file 

filename = 'sst_sep20_2005.nc';

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
clear ncid info i varname varid output_type scale_factor offset tf indx filename


sst = sst-273.15;
sstm = sst_mean - 273.15;

for i = 1:721
    for j = 1:1440
        if sst(i,j) <= -1.69
            sst(i,j) = 0;
        end
        
        if sstm(i,j) <= -1.68
            sstm(i,j) = 0;
        end
    end
end

ssta = (sst - sstm);
%%

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


[lon,lat]=meshgrid(longitude,latitude);

load coastlines
hold on; 
worldmap('World')
worldmap([min(latitude) max(latitude)],[min(longitude) max(longitude)])
axesm('miller','MeridianLabel','on','MLabelParallel','south','ParallelLabel','on')
pcolorm(lat,lon,ssta); shading interp;
setm(gca,'MapLatLimit',[2 50],'MapLonLimit',[-150 -40])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title('\bf \fontsize{16} September 20, 2005');
cb = colorbar;
colormap(mymap);
caxis([-2.5 2.5]);
cb.Label.String = '\bf \fontsize{16} SSTA (C) - 1985-2005 reference (ERA5) ';
gridm('on')


%% Write combined netCDF

% adjust boundaries 'Latitude',[2 50],'Longitude',[-150 -40]
xlat = 50:-0.25:2;
xlon = -150:0.25:-40;
SSTA = ssta(161:353,841:1281);

% matrices for lat lon
[XLON,XLAT] = meshgrid(xlon,xlat);

% flip matrices
SSTA = flipud(SSTA)';
XLAT = flipud(XLAT)';
XLON = flipud(XLON)';

% test
% axesm('miller'); pcolorm(XLAT,XLON,SSTA); load coastlines;
% plotm(coastlat,coastlon,'k','LineWidth',0.5);

file_out = 'SSTA_sep20_2005.nc';

% create netCDF file with variables
nccreate(file_out,'SSTA','Dimensions',{'lon',441,'lat', 193});
nccreate(file_out,'latitude','Dimensions',{'lon',441,'lat', 193});
nccreate(file_out,'longitude','Dimensions',{'lon',441,'lat', 193});

% write matlab variables to netCDF variables
ncwrite(file_out,'SSTA',SSTA)
ncwrite(file_out,'latitude',XLAT)
ncwrite(file_out,'longitude',XLON)

