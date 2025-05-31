% wilma timeseries compare

clear all;

% import wrf data
norm = load('wilma_wrf_ssthr2.txt');
noanm = load('wilma_wrf_sst_noanm2.txt');

% import noaa data
hurdat = import_gulf_extract('wilma_hurdat.txt');

ace_norm = ace_index3(norm(2:end,7));
ace_noanm = ace_index3(noanm(2:end,7));

ace_noaa = ace_index6(hurdat{11:27,10});

y = [ace_norm ace_noanm ace_noaa];
x = categorical({'Normal','No Anomaly','Observation'});

bar(x,y,0.5,'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0])
title('\bf \fontsize{18} ACE Index')
grid on;

