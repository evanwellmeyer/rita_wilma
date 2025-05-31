% hurdat file reshape
file = 'hurdat2-1851-2022.txt';
tr = readtable(file,'Format','%s%s%s%s%s%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');

IDs = {'AL011851','UNNAMED'};
% create list of all cyclone IDs and names
for i = 1:size(tr,1)
    if isnan(tr.Var7(i))
        ID = tr.Var1(i);
        name = tr.Var2(i);
        IDs = [IDs;ID,name];
    end
end


%% create table with first cyclone in file

% convert ID to numeric
temp = IDs(1,1);
ID_num = char(temp);
ID_num = string(ID_num(3:end));
ID_num = double(ID_num);

ID_vec = zeros(14,1);
ID_vec = ID_vec + ID_num;

name = cell(length(ID_vec),1);
for i = 1:14
    name(i) = IDs(1,2);
end

% make datetime vector
hours = string(tr{1:14,2});
hours(hours == "0") = "0000";
t = datetime(strcat(string(tr{1:14,1})," ",hours),'InputFormat','uuuuMMdd HHmm');

% convert N/S/E/W to +/-
lat_raw = string(tr{1:14,5});
lat_raw(strlength(lat_raw) == 4) = strcat("0", lat_raw(strlength(lat_raw) == 4));
lon_raw = string(tr{1:14,6});
lon_raw(strlength(lon_raw) == 4) = strcat("00", lon_raw(strlength(lon_raw) == 4));
lon_raw(strlength(lon_raw) == 5) = strcat("0", lon_raw(strlength(lon_raw) == 5));
lat = zeros(length(lat_raw),1);
lon = zeros(length(lon_raw),1);

for j=1:14
    if lat_raw(j) == "" 
        lat(j) = double("");
    elseif extract(lat_raw(j),5) == 'S' 
        lat(j) = -double(extractBetween(lat_raw(j),1,4));
    else
        lat(j) = double(extractBetween(lat_raw(j),1,4));        
    end
    if lon_raw(j) == ""
        lon(j) = double("");
    elseif extract(lon_raw(j),6) == 'W'
        lon(j) = -double(extractBetween(lon_raw(j),1,5));
    else
        lon(j) = double(extractBetween(lon_raw(j),1,5));
    end
end

tab1 = table(ID_vec,name, t, tr{1:14,4},lat,lon,tr{1:14,7},tr{1:14,8});


tab1.Properties.VariableNames = {'ID_vec','name','t','status','lat','lon','kt_max','mbar_min'};

%%


for i = 2:length(IDs)
    
    % recreate table with an extra column for ID at every row
    [t, ~, status, lon, lat, kt_max, mbar_min, ~, ~, ~, ~, ~, ~,...
        ~, ~, ~, ~, ~, ~, ~] = readHurdat2(file, IDs(i));

    temp = IDs(i);
    ID_num = char(temp);
    ID_num = string(ID_num(3:end));
    ID_num = double(ID_num);

    ID_vec = zeros(length(t),1);
    ID_vec = ID_vec + ID_num;
    
    name = cell(length(ID_vec),1);
    for ii = 1:length(name)
        name(ii) = IDs(i,2);
    end

    TT = table(ID_vec, name, t, status, lat, lon, kt_max, mbar_min);


    tab1 = [tab1;TT]; %#ok
    
    if mod(i,50)==0
        disp(['Iteration: ',num2str(i)])
    end

end

%% output to file

[Y,M,D,H,~,~] = datevec(tab1.t);

fileID=fopen('hurdat_reformatted_2022.txt','w');

Fspec = '%6.0f %4.0f %2.0f %2.0f %2.0f %9s %2s %3.1f %6.1f %3.0f %4.0f \n';
fprintf(fileID,Fspec,[tab1.ID_vec Y M D H tab1.name tab1.status tab1.lat tab1.lon tab1.kt_max tab1.mbar_min]');
fclose(fileID);

















