% hurdat reformatte analysis
clear all;

% import_hurdat_reformatted;
% 
% TCs = hurdatreformatted; clear hurdatreformatted;

TCs = importhurdatRF('hurdat_reformatted_2022.txt', 25874, 53976);

IDs = unique(TCs{:,1},'stable');


%% check if TC enters the gulf 

gulf_TCs = [];

% gulf domain [lat_min, lat_max, lon_min, lon,max]
% gulf = [23,30,-95,-84]; % original
gulf = [24,30,-95.5,-85];

% loop over the cyclones and check if they enter the domain
for i = 943:length(IDs)
    bool = 0;
    
    TC_id = IDs(i);
    idx = find(TCs{:,1} == TC_id);
    
    lats = TCs{idx,8};
    lons = TCs{idx,9};
    
    for ii = 1:length(idx)
%         if lats(ii) > gulf(1) && lats(ii) < gulf(2) && lons(ii) > gulf(3) && lons(ii) < gulf(4)
            if TCs{idx(ii),7} == 'TS' % sets strength threshhold for the region TCs{idx(ii),10} >= 34 %||
                bool = 1;
            end
%         end
    end
    
    if bool == 1 && isempty(gulf_TCs)
        gulf_TCs = TC_id;       
    elseif bool == 1       
        gulf_TCs = [gulf_TCs;TC_id]; %#ok
    end
    
    
end

%% create table with only gulf TCs


TCs_gulf = table();

for i = 1:length(gulf_TCs)
    
    idx = find(TCs{:,1} == gulf_TCs(i));
    TCs_gulf = [TCs_gulf;TCs(idx,:)]; %#ok
    
end

TCs_gulf.Properties.VariableNames = {'ID','Y','M','D','HH','Name','status','lat','lon','kt_max','mbar_min'};

%% write gulf tcs to file

ID = TCs_gulf.ID;
Y = TCs_gulf.Y;
M = TCs_gulf.M;
D = TCs_gulf.D;
HH = TCs_gulf.HH;
Name = string(TCs_gulf.Name);
stat = string(TCs_gulf.status);
lat = TCs_gulf.lat;
lon = TCs_gulf.lon;
kt = TCs_gulf.kt_max;
pres = TCs_gulf.mbar_min;


fileID=fopen('hurdat_1961-2022.txt','w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %11s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[ID Y M D HH Name stat lat lon kt pres]');
fclose(fileID);




%%

fig1 = figure;
fig1.Position = [100 100 1600 700];
tl = tiledlayout('flow');

nexttile
geodensityplot(TCs_gulf{:,8},TCs_gulf{:,9},'FaceColor','interp')
geolimits([0 60],[-110 0])
geobasemap darkwater
colormap jet
title('Track Density')


select = unique(TCs_gulf{:,1},'stable');

% fig1 = figure;
% fig1.Position = [100 100 1200 700];
nexttile
for i = 1:length(select)
    idx = find(TCs_gulf{:,1} == select(i));
    geoplot(TCs_gulf{idx,8},TCs_gulf{idx,9},':','Color',[0 0 0]); hold on;
end
geolimits([0 60],[-110 0])
geobasemap darkwater
title('Tracks')

title(tl,'\bf \fontsize{14} 1010 North Atlantic Tropical Cyclones 1961-2022')

% print('cat0+_1940-2021','-dpng','-r400',fig1);



