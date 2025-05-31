% select gulf TCs for analysis
clear all

TCs = import_gulf_extract('hurdat_gulf_extract_24-30N_85-955W.txt');

% set minimum length of cyclones in hours
min_len = 72;

% indexing equivalent to hour length
len = min_len/6;


IDs = unique(TCs{:,1},'stable');

gulf_select = table();

% loop over the cyclones and check if they meet length requirement
for i = 1:length(IDs)
    bool = 0;
    
    TC_id = IDs(i);
    idx = find(TCs{:,1} == TC_id);
    year = max(TCs{idx,2});
    
    if length(idx) >= len && year >= 1995
        bool = 1;
    end
    
    if bool == 1 && isempty(gulf_select)
        gulf_select = TC_id;       
    elseif bool == 1       
        gulf_select = [gulf_select;TC_id]; %#ok
    end
    
    
end


figure;
for i = 1:length(gulf_select)
    idx = find(TCs{:,1} == gulf_select(i));
    geoplot(TCs{idx,8},TCs{idx,9},'k'); hold on;
end



%% create table with only gulf TCs


TCs_gulf_select = table();

for i = 1:length(gulf_select)
    
    idx = find(TCs{:,1} == gulf_select(i));
    TCs_gulf_select = [TCs_gulf_select;TCs(idx,:)]; %#ok
    
end

TCs_gulf_select.Properties.VariableNames = {'ID','Y','M','D','HH','Name','status','lat','lon','kt_max','mbar_min'};

%% write gulf tcs to file

ID = TCs_gulf_select.ID;
Y = TCs_gulf_select.Y;
M = TCs_gulf_select.M;
D = TCs_gulf_select.D;
HH = TCs_gulf_select.HH;
Name = string(TCs_gulf_select.Name);
stat = string(TCs_gulf_select.status);
lat = TCs_gulf_select.lat;
lon = TCs_gulf_select.lon;
kt = TCs_gulf_select.kt_max;
pres = TCs_gulf_select.mbar_min;


fileID=fopen('hurdat_gulf_24-30N_85-955W_1940-2021.txt','w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %9s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[ID Y M D HH Name stat lat lon kt pres]');
fclose(fileID);
