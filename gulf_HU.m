% select hurricanes 'HU' from the categorical

clear all

TCs = import_gulf_extract('hurdat_gulf_24-30N_85-955W_1940-2021.txt');

% logical for when cyclones are TS or HU category
HU = TCs{:,7} == 'HU';
TS = TCs{:,7} == 'TS';
HU_TS = HU + TS;

HUs = table();

% create new table with only TS and HU category
for i = 1:length(HU)    
    if HU(i) == 1
        
        HUs = [HUs;TCs(i,:)];
   
    end
end


IDs = unique(HUs{:,1},'stable');

% set minimum length of cyclones in hours
min_len = 72;

% indexing equivalent to hour length
len = min_len/6;

HU_select = table();

% loop over the cyclones and check if they meet length requirement
for i = 1:length(IDs)
    bool = 0;
    
    TC_id = IDs(i);
    idx = find(HUs{:,1} == TC_id);
    
    if length(idx) >= len && TC_id ~= 252005
        bool = 1;
    end
    
    if bool == 1 && isempty(HU_select)
        HU_select = TC_id;       
    elseif bool == 1       
        HU_select = [HU_select;TC_id]; %#ok
    end
    
    
end



%% create new table with selected tcs

HUs_gulf_select = table();

for i = 1:length(HU_select)
    
    idx = find(HUs{:,1} == HU_select(i));
    HUs_gulf_select = [HUs_gulf_select;HUs(idx,:)]; %#ok
    
end

HUs_gulf_select.Properties.VariableNames = {'ID','Y','M','D','HH','Name','status','lat','lon','kt_max','mbar_min'};

%% write gulf tcs to file

ID = HUs_gulf_select.ID;
Y = HUs_gulf_select.Y;
M = HUs_gulf_select.M;
D = HUs_gulf_select.D;
HH = HUs_gulf_select.HH;
Name = string(HUs_gulf_select.Name);
stat = string(HUs_gulf_select.status);
lat = HUs_gulf_select.lat;
lon = HUs_gulf_select.lon;
kt = HUs_gulf_select.kt_max;
pres = HUs_gulf_select.mbar_min;


fileID=fopen('hurdat_gulf_HU_24-30N_85-955W_1940-2021.txt','w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %9s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[ID Y M D HH Name stat lat lon kt pres]');
fclose(fileID);
