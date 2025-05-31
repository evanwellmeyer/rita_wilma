% variable fields

clear all;

lat = double(nc_varget('rita/CTL_SST.nc','XLAT'));
lon = double(nc_varget('rita/CTL_SST.nc','XLONG'));



%% Auto-extraction of variables

filename = 'sst_september_1985-2005.nc';

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

sstm = mean(sst,3)-273.15;

%% Auto-extraction of variables

filename = 'sst_sep20_2005.nc';

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

lam = -10;
laM = 45;
lom = 360-110;
loM = 360-35;

lat_min = find(latitude==lam);
lat_max = find(latitude==laM);
lon_min = find(longitude==lom);
lon_max = find(longitude==loM);

sst = sst(lat_max:lat_min,lon_min:lon_max) - 273.15;

longitude = longitude(lon_min:lon_max);
latitude = latitude(lat_max:lat_min);

%% 

landmask = double(nc_varget('rita_lsm.nc','LANDMASK'));
landmask = landmask.*-1 + 1;
lkm = double(nc_varget('lakemask.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

lm = landmask.*lkm;

lsm = squeeze(lsm(:,:,1));
lsm = lsm.*-1 + 1;

% Tq = interp2(lsm,lon,lat,'nearest',0);

sst_y = double(nc_varget('CTL_SST.nc','SST'))-273.15;
sst_no = double(nc_varget('NOANM_SST.nc','SST'))-273.15;


ssta = sst - sstm;
ssta2 = sst_y - sst_no;

for i = 1:221
    for j = 1:301
        if ssta(i,j) <= -11.7
            ssta(i,j) = 0;
        end
        
%         if sstm(i,j) <= -1.68
%             sstm(i,j) = 0;
%         end
    end
end

%%

disp('Making Figures...')

[lon1,lat1]=meshgrid(longitude,latitude);

load coastlines
fig1 = figure;
fig1.Position = [182 271 1600 600]; 

tld = tiledlayout(1,2);

t1 = nexttile;
hold on; 
worldmap('World')
worldmap([min(lat,[],'all') max(lat,[],'all')],[min(lon,[],'all') max(lon,[],'all')])
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-98:4:-72],'ParallelLabel','on','PLabelLocation',[12:4:30],'FontSize',12);
pcolorm(lat,lon,sst_y.*lm); shading interp; colormap(t1,mymap); 

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([26 31]);
cb.Label.String = '\bf \fontsize{16} Sea Surface Temperature (C)';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.4])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5); hold on;
title( 'Sea Surface Temperature' ,'FontSize',20,'FontWeight','bold');
  
%..........................................................................

t2 = nexttile;
hold on; 
worldmap('World')
axesm('miller','MeridianLabel','on','MLabelParallel','south','MLabelLocation',...
    [-98:4:-72],'ParallelLabel','on','PLabelLocation',[12:4:30],'FontSize',12);
pcolorm(lat1,lon1,ssta); shading interp; colormap(t2,anomalymap); 

cb = colorbar;
cb.FontWeight = 'bold';
cb.FontSize = 16;
cb.Box = 'on';
cb.LineWidth = 1;
caxis([-1.5 1.5]);
cb.Label.String = '\bf \fontsize{16} Anomaly (C)';

setm(gca,'MapLatLimit',[12 30],'MapLonLimit',[-98 -71.4])
framem on;
framem('FlineWidth',3)
tightmap;
plotm(coastlat,coastlon,'k','LineWidth',0.5)
title( 'Anomaly ' ,'FontSize',20,'FontWeight','bold');

text(0.62,0.05,'September 1985-2005 Reference','Units','normalized')

title(tld,'September 20, 2005','FontSize',20,'FontWeight','bold');

% print('wrf_sst','-dpng','-r200',fig1);