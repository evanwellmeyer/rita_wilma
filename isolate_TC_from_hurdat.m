% isolate selected TC to txt

clear all

% open full file of TCs
TCs = import_atl_extract('hurdat_1961-2022.txt');

IDs = unique(TCs{:,1},'stable');

names = strings(length(IDs),1);
list = strings(length(IDs),1);

for i = 1:length(IDs)
    idx = TCs{:,1} == IDs(i);
    name = TCs{idx,6};
    names(i) = name(1);
    list(i) = sprintf('%06d_%s',IDs(i),names(i));
end

% dialog to select output TC
[indx,tf] = listdlg('PromptString','Select TC to isolate:','SelectionMode'...
    ,'single','ListString',list);

if tf == 0
    error('No TC selected.')
end

% select TC ID for file output
ID_sel = IDs(indx);

% output file
prompt = {'Name of output file:'};
dlgtitle = 'Output File';
dims = [1 35];
definput = {sprintf('%s.txt',list(indx))};
answer = inputdlg(prompt,dlgtitle,dims,definput);

% output file name
fileout = string(answer);
    
% retrieve indices of the selected TC
idx = find(TCs{:,1} == ID_sel);

% create table with the data of the selected indices
full_sel = TCs(idx,:); %#ok
    
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


fileID=fopen(fileout,'w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %9s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[ID Y M D HH Name stat lat lon kt pres]');
fclose(fileID);
