%
%
% Take the list of gulf hurricanes and create a list of those storms full
% history

clear all

%% import gulf hurricane list
Gulf = import_gulf_extract('hurdat_gulf_HU_24-30N_85-955W_1940-2021.txt');

% make list of ID numbers
IDs = unique(Gulf{:,1},'stable');

%% import full hurdat reformatted

import_hurdat_reformatted;
hurdat = hurdatreformatted; clear hurdatreformatted;

%% select full sequence of each storm on the list

full_sel = table();

for i = 1:length(IDs)
    
    idx = find(hurdat{:,1} == IDs(i));
    full_sel = [full_sel;hurdat(idx,:)]; %#ok
    
end

full_sel.Properties.VariableNames = {'ID','Y','M','D','HH','Name','status','lat','lon','kt_max','mbar_min'};

% output data file .txt
ID = full_sel.ID;
Y = full_sel.Y;
M = full_sel.M;
D = full_sel.D;
HH = full_sel.HH;
Name = string(full_sel.Name);
stat = string(full_sel.status);
lat = full_sel.lat;
lon = full_sel.lon;
kt = full_sel.kt_max;
pres = full_sel.mbar_min;


fileID=fopen('hurdat_gulf_HU_24-30N_85-955W_1940-2021_full_sequence.txt','w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %9s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[ID Y M D HH Name stat lat lon kt pres]');
fclose(fileID);
