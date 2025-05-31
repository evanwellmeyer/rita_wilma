% calculate ohc
%
% import sst data for each run and take average temperature along the path

clear all;


%% structs to store variables

r = struct();
w = struct();

r.lat = nc_varget('rita/CTL_SST.nc','XLAT');
r.lon = nc_varget('rita/CTL_SST.nc','XLONG');

w.lat = nc_varget('wilma/wilma_masks.nc','XLAT');
w.lon = nc_varget('wilma/wilma_masks.nc','XLONG');

%% create land + lake mask

landmask = double(nc_varget('rita_lsm.nc','LANDMASK'));
landmask = landmask.*-1 + 1;
lkm = double(nc_varget('lakemask.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

r.lm = landmask.*lkm; clear landmask lkm;

lsm = double(nc_varget('wilma_masks.nc','LANDMASK'));
lsm = lsm.*-1 + 1;

lkm = double(nc_varget('wilma_masks.nc','LAKEMASK'));
lkm = lkm.*-1 + 1;

w.lm = lsm.*lkm; clear lsm lkm;


%% import sst for each run


r.sst.ctl = (double(nc_varget('rita/CTL_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.noanm = (double(nc_varget('rita/NOANM_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.m1 = (double(nc_varget('rita/M1_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.m2 = (double(nc_varget('rita/M2_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.m3 = (double(nc_varget('rita/M3_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.oml17 = (double(nc_varget('rita/OML17_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.oml70 = (double(nc_varget('rita/OML70_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.p1 = (double(nc_varget('rita/P1_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.p2 = (double(nc_varget('rita/P2_TSK.nc','TSK'))-273.15).*r.lm;
r.sst.p3 = (double(nc_varget('rita/P3_TSK.nc','TSK'))-273.15).*r.lm;


w.sst.ctl = (double(nc_varget('wilma/CTL_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.noanm = (double(nc_varget('wilma/NOANM_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.m1 = (double(nc_varget('wilma/M1_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.m2 = (double(nc_varget('wilma/M2_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.m3 = (double(nc_varget('wilma/M3_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.oml35 = (double(nc_varget('wilma/OML35_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.oml100 = (double(nc_varget('wilma/OML100_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.p1 = (double(nc_varget('wilma/P1_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.p2 = (double(nc_varget('wilma/P2_TSK.nc','TSK'))-273.15).*w.lm;
w.sst.p3 = (double(nc_varget('wilma/P3_TSK.nc','TSK'))-273.15).*w.lm;


% w.sst.ctl = squeeze(w.sst.ctl(1,:,:));
% w.sst.noanm = squeeze(w.sst.noanm(1,:,:));

%% import tracks

r.ctl = load('rita_ctl.txt');
r.m1 = load('rita_M1.txt');
r.m2 = load('rita_M2.txt');
r.m3 = load('rita_M3.txt');
r.noanm = load('rita_noanm.txt');
r.oml17 = load('rita_oml17.txt');
r.oml70 = load('rita_oml70.txt');
r.p1 = load('rita_P1.txt');
r.p2 = load('rita_P2.txt');
r.p3 = load('rita_P3.txt');

w.ctl = load('wilma_ctl.txt');
w.m1 = load('wilma_m1.txt');
w.m2 = load('wilma_m2.txt');
w.m3 = load('wilma_m3.txt');
w.noanm = load('wilma_noanm.txt');
w.oml35 = load('wilma_oml35.txt');
w.oml100 = load('wilma_oml100.txt');
w.p1 = load('wilma_p1.txt');
w.p2 = load('wilma_p2.txt');
w.p3 = load('wilma_p3.txt');

r.date = datetime(r.ctl(:,1),r.ctl(:,2),r.ctl(:,3),r.ctl(:,4),0,0);
w.date = datetime(w.ctl(:,1),w.ctl(:,2),w.ctl(:,3),w.ctl(:,4),0,0);

r.hurdat = import_gulf_extract('rita_hurdat.txt');
w.hurdat = import_gulf_extract('wilma_hurdat.txt');

%% Pres

[val, idx] = min(r.ctl(:,8)); r.pres.ctl = 996 - val; r.pres.ctl_idx = idx;
[val, idx] = min(r.noanm(:,8)); r.pres.noanm = 996 - val; r.pres.noanm_idx = idx;
[val, idx] = min(r.m1(:,8)); r.pres.m1 = 996 - val; r.pres.m1_idx = idx;
[val, idx] = min(r.m2(:,8)); r.pres.m2 = 996 - val; r.pres.m2_idx = idx;
[val, idx] = min(r.m3(:,8)); r.pres.m3 = 996 - val; r.pres.m3_idx = idx;
[val, idx] = min(r.oml17(:,8)); r.pres.oml17 = 996 - val; r.pres.oml17_idx = idx;
[val, idx] = min(r.oml70(:,8)); r.pres.oml70 = 996 - val; r.pres.oml70_idx = idx;
[val, idx] = min(r.p1(:,8)); r.pres.p1 = 996 - val; r.pres.p1_idx = idx;
[val, idx] = min(r.p2(:,8)); r.pres.p2 = 996 - val; r.pres.p2_idx = idx;
[val, idx] = min(r.p3(:,8)); r.pres.p3 = 996 - val; r.pres.p3_idx = idx;


[val, idx] = min(w.ctl(:,8)); w.pres.ctl = 998 - val; w.pres.ctl_idx = idx;
[val, idx] = min(w.noanm(:,8)); w.pres.noanm = 998 - val; w.pres.noanm_idx = idx;
[val, idx] = min(w.m1(:,8)); w.pres.m1 = 998 - val; w.pres.m1_idx = idx;
[val, idx] = min(w.m2(:,8)); w.pres.m2 = 998 - val; w.pres.m2_idx = idx;
[val, idx] = min(w.m3(:,8)); w.pres.m3 = 998 - val; w.pres.m3_idx = idx;
[val, idx] = min(w.oml35(:,8)); w.pres.oml35 = 998 - val; w.pres.oml35_idx = idx;
[val, idx] = min(w.oml100(:,8)); w.pres.oml100 = 998 - val; w.pres.oml100_idx = idx;
[val, idx] = min(w.p1(:,8)); w.pres.p1 = 998 - val; w.pres.p1_idx = idx;
[val, idx] = min(w.p2(:,8)); w.pres.p2 = 998 - val; w.pres.p2_idx = idx; 
[val, idx] = min(w.p3(:,8)); w.pres.p3 = 998 - val; w.pres.p3_idx = idx;


%% interpolat sst to track position

% set interval to take sst along path
r.deepening = 1:21;

r.latm = mean(r.lat,2);
r.lonm = mean(r.lon,1);

% interpolate sst along path for selected interval
r.sst.track.ctl = interp2(r.lonm,r.latm,r.sst.ctl.*r.lm,r.ctl(r.deepening,6),r.ctl(r.deepening,5),'linear');
r.sst.track.noanm = interp2(r.lonm,r.latm,r.sst.noanm.*r.lm,r.noanm(r.deepening,6),r.noanm(r.deepening,5),'linear');
r.sst.track.m1 = interp2(r.lonm,r.latm,r.sst.m1.*r.lm,r.m1(r.deepening,6),r.m1(r.deepening,5),'linear');
r.sst.track.m2 = interp2(r.lonm,r.latm,r.sst.m2.*r.lm,r.m2(r.deepening,6),r.m2(r.deepening,5),'linear');
r.sst.track.m3 = interp2(r.lonm,r.latm,r.sst.m3.*r.lm,r.m3(r.deepening,6),r.m3(r.deepening,5),'linear');
r.sst.track.oml17 = interp2(r.lonm,r.latm,r.sst.oml17.*r.lm,r.oml17(r.deepening,6),r.oml17(r.deepening,5),'linear');
r.sst.track.oml70 = interp2(r.lonm,r.latm,r.sst.oml70.*r.lm,r.oml70(r.deepening,6),r.oml70(r.deepening,5),'linear');
r.sst.track.p1 = interp2(r.lonm,r.latm,r.sst.p1.*r.lm,r.p1(r.deepening,6),r.p1(r.deepening,5),'linear');
r.sst.track.p2 = interp2(r.lonm,r.latm,r.sst.p2.*r.lm,r.p2(r.deepening,6),r.p2(r.deepening,5),'linear');
r.sst.track.p3 = interp2(r.lonm,r.latm,r.sst.p3.*r.lm,r.p3(r.deepening,6),r.p3(r.deepening,5),'linear');

r.sst.track.noaa = interp2(r.lonm,r.latm,r.sst.ctl.*r.lm,r.hurdat{11:31,9},r.hurdat{11:31,8},'linear');

r.sst.track.ctl = max(r.sst.track.ctl(r.sst.track.ctl > 0));
r.sst.track.noanm = max(r.sst.track.noanm(r.sst.track.noanm > 0));
r.sst.track.m1 = max(r.sst.track.m1(r.sst.track.m1 > 0));
r.sst.track.m2 = max(r.sst.track.m2(r.sst.track.m2 > 0));
r.sst.track.m3 = max(r.sst.track.m3(r.sst.track.m3 > 0));
r.sst.track.oml17 = max(r.sst.track.oml17(r.sst.track.oml17 > 0));
r.sst.track.oml70 = max(r.sst.track.oml70(r.sst.track.oml70 > 0));
r.sst.track.p1 = max(r.sst.track.p1(r.sst.track.p1 > 0));
r.sst.track.p2 = max(r.sst.track.p2(r.sst.track.p2 > 0));
r.sst.track.p3 = max(r.sst.track.p3(r.sst.track.p3 > 0));

r.sst.track.noaa = max(r.sst.track.noaa(r.sst.track.noaa > 0));

r.sst.ctl = mean(r.sst.ctl(r.sst.ctl>0),'all');
r.sst.noanm = mean(r.sst.noanm(r.sst.noanm>0),'all');
r.sst.m1 = mean(r.sst.m1(r.sst.m1>0),'all');
r.sst.m2 = mean(r.sst.m2(r.sst.m2>0),'all');
r.sst.m3 = mean(r.sst.m3(r.sst.m3>0),'all');
r.sst.oml17 = mean(r.sst.oml17(r.sst.oml17>0),'all');
r.sst.oml70 = mean(r.sst.oml70(r.sst.oml70>0),'all');
r.sst.p1 = mean(r.sst.p1(r.sst.p1>0),'all');
r.sst.p2 = mean(r.sst.p2(r.sst.p2>0),'all');
r.sst.p3 = mean(r.sst.p3(r.sst.p3>0),'all');

%....WILMA................................................................

% set interval to take sst along path
w.deepening = 1:24;

w.latm = mean(w.lat,2);
w.lonm = mean(w.lon,1);

w.sst.track.ctl = interp2(w.lonm,w.latm,w.sst.ctl.*w.lm,w.ctl(w.deepening,6),w.ctl(w.deepening,5),'linear');
w.sst.track.noanm = interp2(w.lonm,w.latm,w.sst.noanm.*w.lm,w.noanm(w.deepening,6),w.noanm(w.deepening,5),'linear');
w.sst.track.m1 = interp2(w.lonm,w.latm,w.sst.m1.*w.lm,w.m1(w.deepening,6),w.m1(w.deepening,5),'linear');
w.sst.track.m2 = interp2(w.lonm,w.latm,w.sst.m2.*w.lm,w.m2(w.deepening,6),w.m2(w.deepening,5),'linear');
w.sst.track.m3 = interp2(w.lonm,w.latm,w.sst.m3.*w.lm,w.m3(w.deepening,6),w.m3(w.deepening,5),'linear');
w.sst.track.oml35 = interp2(w.lonm,w.latm,w.sst.oml35.*w.lm,w.oml35(w.deepening,6),w.oml35(w.deepening,5),'linear');
w.sst.track.oml100 = interp2(w.lonm,w.latm,w.sst.oml100.*w.lm,w.oml100(w.deepening,6),w.oml100(w.deepening,5),'linear');
w.sst.track.p1 = interp2(w.lonm,w.latm,w.sst.p1.*w.lm,w.p1(w.deepening,6),w.p1(w.deepening,5),'linear');
w.sst.track.p2 = interp2(w.lonm,w.latm,w.sst.p2.*w.lm,w.p2(w.deepening,6),w.p2(w.deepening,5),'linear');
w.sst.track.p3 = interp2(w.lonm,w.latm,w.sst.p3.*w.lm,w.p3(w.deepening,6),w.p3(w.deepening,5),'linear');

w.sst.track.noaa = interp2(w.lonm,w.latm,w.sst.ctl.*w.lm,w.hurdat{10:27,9},r.hurdat{10:27,8},'linear');

w.sst.track.ctl = max(w.sst.track.ctl(w.sst.track.ctl > 0));
w.sst.track.noanm = max(w.sst.track.noanm(w.sst.track.noanm > 0));
w.sst.track.m1 = max(w.sst.track.m1(w.sst.track.m1 > 0));
w.sst.track.m2 = max(w.sst.track.m2(w.sst.track.m2 > 0));
w.sst.track.m3 = max(w.sst.track.m3(w.sst.track.m3 > 0));
w.sst.track.oml35 = max(w.sst.track.oml35(w.sst.track.oml35 > 0));
w.sst.track.oml100 = max(w.sst.track.oml100(w.sst.track.oml100 > 0));
w.sst.track.p1 = max(w.sst.track.p1(w.sst.track.p1 > 0));
w.sst.track.p2 = max(w.sst.track.p2(w.sst.track.p2 > 0));
w.sst.track.p3 = max(w.sst.track.p3(w.sst.track.p3 > 0));

w.sst.track.noaa = max(w.sst.track.noaa(w.sst.track.noaa > 0));

w.sst.ctl = mean(w.sst.ctl(w.sst.ctl>0),'all');
w.sst.noanm = mean(w.sst.noanm(w.sst.noanm>0),'all');
w.sst.m1 = mean(w.sst.m1(w.sst.m1>0),'all');
w.sst.m2 = mean(w.sst.m2(w.sst.m2>0),'all');
w.sst.m3 = mean(w.sst.m3(w.sst.m3>0),'all');
w.sst.oml35 = mean(w.sst.oml35(w.sst.oml35>0),'all');
w.sst.oml100 = mean(w.sst.oml100(w.sst.oml100>0),'all');
w.sst.p1 = mean(w.sst.p1(w.sst.p1>0),'all');
w.sst.p2 = mean(w.sst.p2(w.sst.p2>0),'all');
w.sst.p3 = mean(w.sst.p3(w.sst.p3>0),'all');

%% calculate mean OHC along the track and domain

rho = 1000; % kg/m^3
C_p = 4186; % J/kgK

dz = 35; % m

% ohc along the track
r.ohc.ctl.track = rho.*C_p.*(r.sst.track.ctl-26).*dz;
r.ohc.noanm.track = rho.*C_p.*(r.sst.track.noanm-26).*dz;
r.ohc.m1.track = rho.*C_p.*(r.sst.track.m1-26).*dz;
r.ohc.m2.track = rho.*C_p.*(r.sst.track.m2-26).*dz;
r.ohc.m3.track = rho.*C_p.*(r.sst.track.m3-26).*dz;
r.ohc.oml17.track = rho.*C_p.*(r.sst.track.oml17-26).*17;
r.ohc.oml70.track = rho.*C_p.*(r.sst.track.oml70-26).*70;
r.ohc.p1.track = rho.*C_p.*(r.sst.track.p1-26).*dz;
r.ohc.p2.track = rho.*C_p.*(r.sst.track.p2-26).*dz;
r.ohc.p3.track = rho.*C_p.*(r.sst.track.p3-26).*dz;

% ohc in domain
r.ohc.ctl.d2 = rho.*C_p.*(r.sst.ctl-26).*dz;
r.ohc.noanm.d2 = rho.*C_p.*(r.sst.noanm-26).*dz;
r.ohc.m1.d2 = rho.*C_p.*(r.sst.m1-26).*dz;
r.ohc.m2.d2 = rho.*C_p.*(r.sst.m2-26).*dz;
r.ohc.m3.d2 = rho.*C_p.*(r.sst.m3-26).*dz;
r.ohc.oml17.d2 = rho.*C_p.*(r.sst.oml17-26).*17;
r.ohc.oml70.d2 = rho.*C_p.*(r.sst.oml70-26).*70;
r.ohc.p1.d2 = rho.*C_p.*(r.sst.p1-26).*dz;
r.ohc.p2.d2 = rho.*C_p.*(r.sst.p2-26).*dz;
r.ohc.p3.d2 = rho.*C_p.*(r.sst.p3-26).*dz;

dz = 75; % m

% ohc along track
w.ohc.ctl.track = rho.*C_p.*(w.sst.track.ctl-26).*dz;
w.ohc.noanm.track = rho.*C_p.*(w.sst.track.noanm-26).*dz;
w.ohc.m1.track = rho.*C_p.*(w.sst.track.m1-26).*dz;
w.ohc.m2.track = rho.*C_p.*(w.sst.track.m2-26).*dz;
w.ohc.m3.track = rho.*C_p.*(w.sst.track.m3-26).*dz;
w.ohc.oml35.track = rho.*C_p.*(w.sst.track.oml35-26).*35;
w.ohc.oml100.track = rho.*C_p.*(w.sst.track.oml100-26).*100;
w.ohc.p1.track = rho.*C_p.*(w.sst.track.p1-26).*dz;
w.ohc.p2.track = rho.*C_p.*(w.sst.track.p2-26).*dz;
w.ohc.p3.track = rho.*C_p.*(w.sst.track.p3-26).*dz;

% ohc in domain
w.ohc.ctl.d2 = rho.*C_p.*(w.sst.ctl-26).*dz;
w.ohc.noanm.d2 = rho.*C_p.*(w.sst.noanm-26).*dz;
w.ohc.m1.d2 = rho.*C_p.*(w.sst.m1-26).*dz;
w.ohc.m2.d2 = rho.*C_p.*(w.sst.m2-26).*dz;
w.ohc.m3.d2 = rho.*C_p.*(w.sst.m3-26).*dz;
w.ohc.oml35.d2 = rho.*C_p.*(w.sst.oml35-26).*35;
w.ohc.oml100.d2 = rho.*C_p.*(w.sst.oml100-26).*100;
w.ohc.p1.d2 = rho.*C_p.*(w.sst.p1-26).*dz;
w.ohc.p2.d2 = rho.*C_p.*(w.sst.p2-26).*dz;
w.ohc.p3.d2 = rho.*C_p.*(w.sst.p3-26).*dz;

%% ACE

r.ace.ctl = ace_index3(r.ctl(:,7));
r.ace.noanm = ace_index3(r.noanm(1:35,7));
r.ace.m1 = ace_index3(r.m1(1:35,7));
r.ace.m2 = ace_index3(r.m2(1:35,7));
r.ace.m3 = ace_index3(r.m3(1:35,7));
r.ace.oml17 = ace_index3(r.oml17(1:35,7));
r.ace.oml70 = ace_index3(r.oml70(:,7));
r.ace.p1 = ace_index3(r.p1(:,7));
r.ace.p2 = ace_index3(r.p2(:,7));
r.ace.p3 = ace_index3(r.p3(:,7));

w.ace.ctl = ace_index3(w.ctl(:,7));
w.ace.noanm = ace_index3(w.noanm(:,7));
w.ace.m1 = ace_index3(w.m1(:,7));
w.ace.m2 = ace_index3(w.m2(:,7));
w.ace.m3 = ace_index3(w.m3(:,7));
w.ace.oml35 = ace_index3(w.oml35(:,7));
w.ace.oml100 = ace_index3(w.oml100(:,7));
w.ace.p1 = ace_index3(w.p1(:,7));
w.ace.p2 = ace_index3(w.p2(:,7));
w.ace.p3 = ace_index3(w.p3(:,7));




%% max DR

r.dr.ctl = max(r.ctl(:,9));
r.dr.noanm = max(r.noanm(:,9));
r.dr.m1 = max(r.m1(:,9));
r.dr.m2 = max(r.m2(:,9));
r.dr.m3 = max(r.m3(1:30,9));
r.dr.oml17 = max(r.oml17(:,9));
r.dr.oml70 = max(r.oml70(:,9));
r.dr.p1 = max(r.p1(:,9));
r.dr.p2 = max(r.p2(:,9));
r.dr.p3 = max(r.p3(:,9));

w.dr.ctl = max(w.ctl(:,9));
w.dr.noanm = max(w.noanm(:,9));
w.dr.m1 = max(w.m1(:,9));
w.dr.m2 = max(w.m2(:,9));
w.dr.m3 = max(w.m3(:,9));
w.dr.oml35 = max(w.oml35(:,9));
w.dr.oml100 = max(w.oml100(:,9));
w.dr.p1 = max(w.p1(:,9));
w.dr.p2 = max(w.p2(:,9));
w.dr.p3 = max(w.p3(:,9));

%% delta E
% rita: 111 hours
% wilma: 99 hours
%
% W*s=J

r.dE.ctl = nanmean(r.ctl(:,12)).*10^(12).*399600;
r.dE.noanm = nanmean(r.noanm(:,12)).*10^(12).*399600;
r.dE.m1 = nanmean(r.m1(:,12)).*10^(12).*399600;
r.dE.m2 = nanmean(r.m2(:,12)).*10^(12).*399600;
r.dE.m3 = nanmean(r.m3(:,12)).*10^(12).*399600;
r.dE.oml17 = nanmean(r.oml17(:,12)).*10^(12).*399600;
r.dE.oml70 = nanmean(r.oml70(:,12)).*10^(12).*399600;
r.dE.p1 = nanmean(r.p1(:,12)).*10^(12).*399600;
r.dE.p2 = nanmean(r.p2(:,12)).*10^(12).*399600;
r.dE.p3 = nanmean(r.p3(:,12)).*10^(12).*399600;

w.dE.ctl = nanmean(w.ctl(:,12)).*10^(12).*356400;
w.dE.noanm = nanmean(w.noanm(:,12)).*10^(12).*356400;
w.dE.m1 = nanmean(w.m1(:,12)).*10^(12).*356400;
w.dE.m2 = nanmean(w.m2(:,12)).*10^(12).*356400;
w.dE.m3 = nanmean(w.m3(:,12)).*10^(12).*356400;
w.dE.oml35 = nanmean(w.oml35(:,12)).*10^(12).*356400;
w.dE.oml100 = nanmean(w.oml100(:,12)).*10^(12).*356400;
w.dE.p1 = nanmean(w.p1(:,12)).*10^(12).*356400;
w.dE.p2 = nanmean(w.p2(:,12)).*10^(12).*356400;
w.dE.p3 = nanmean(w.p3(:,12)).*10^(12).*356400;

%% delta W
% rita: 111 hours
% wilma: 99 hours
%

r.dW.ctl = nanmax(r.ctl(:,12));
r.dW.noanm = nanmax(r.noanm(:,12));
r.dW.m1 = nanmax(r.m1(:,12));
r.dW.m2 = nanmax(r.m2(:,12));
r.dW.m3 = nanmax(r.m3(:,12));
r.dW.oml17 = nanmax(r.oml17(:,12));
r.dW.oml70 = nanmax(r.oml70(:,12));
r.dW.p1 = nanmax(r.p1(:,12));
r.dW.p2 = nanmax(r.p2(:,12));
r.dW.p3 = nanmax(r.p3(:,12));

w.dW.ctl = nanmax(w.ctl(:,12));
w.dW.noanm = nanmax(w.noanm(:,12));
w.dW.m1 = nanmax(w.m1(:,12));
w.dW.m2 = nanmax(w.m2(:,12));
w.dW.m3 = nanmax(w.m3(:,12));
w.dW.oml35 = nanmax(w.oml35(:,12));
w.dW.oml100 = nanmax(w.oml100(:,12));
w.dW.p1 = nanmax(w.p1(:,12));
w.dW.p2 = nanmax(w.p2(:,12));
w.dW.p3 = nanmax(w.p3(:,12));




%% fitting for sst vs delta E and ACE...


% Prepare data for linear fit
sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
dE_values = [r.dE.ctl, r.dE.noanm, r.dE.m1, r.dE.m2, r.dE.m3, ...
               r.dE.p1, r.dE.p2, r.dE.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dE_values);
sst_values = sst_values(valid_indices);
dE_values = dE_values(valid_indices)./10^(19);

% Perform linear regression
p1 = polyfit(sst_values, dE_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dE_fit1 = polyval(p1, sst_values);

% Calculate residuals
residuals = dE_values - dE_fit1;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dE_values - mean(dE_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita dE/C: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

% Prepare data for linear fit
sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
dE_values = [w.dE.ctl, w.dE.noanm, w.dE.m1, w.dE.m2, w.dE.m3, ...
               w.dE.p1, w.dE.p2, w.dE.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dE_values);
sst_values = sst_values(valid_indices);
dE_values = dE_values(valid_indices)./10^(19);

% Perform linear regression
p2 = polyfit(sst_values, dE_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dE_fit2 = polyval(p2, sst_values);

% Calculate residuals
residuals = dE_values - dE_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dE_values - mean(dE_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma dE/C: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% Prepare data for linear fit
sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
dW_values = [r.dW.ctl, r.dW.noanm, r.dW.m1, r.dW.m2, r.dW.m3, ...
               r.dW.p1, r.dW.p2, r.dW.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dW_values);
sst_values = sst_values(valid_indices);
dW_values = dW_values(valid_indices);

% Perform linear regression
p1 = polyfit(sst_values, dW_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dW_fit1 = polyval(p1, sst_values);

% Calculate residuals
residuals = dW_values - dW_fit1;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dW_values - mean(dW_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita dW/C: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

% Prepare data for linear fit
sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
dW_values = [w.dW.ctl, w.dW.noanm, w.dW.m1, w.dW.m2, w.dW.m3, ...
               w.dW.p1, w.dW.p2, w.dW.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dW_values);
sst_values = sst_values(valid_indices);
dW_values = dW_values(valid_indices);

% Perform linear regression
p2 = polyfit(sst_values, dW_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dW_fit2 = polyval(p2, sst_values);

% Calculate residuals
residuals = dW_values - dW_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));
% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dW_values - mean(dW_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma dW/C: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);


%% Prepare data for linear fit
sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
ace_values = [r.ace.ctl, r.ace.noanm, r.ace.m1, r.ace.m2, r.ace.m3, ...
               r.ace.p1, r.ace.p2, r.ace.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dE_values);
sst_values = sst_values(valid_indices);
ace_values = ace_values(valid_indices);

% Perform linear regression
p3 = polyfit(sst_values, ace_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
ace_fit1 = polyval(p3, sst_values);

% Calculate residuals
residuals = ace_values - ace_fit1;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((ace_values - mean(ace_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita ACE/C: %.4f +/- %.4f\n', p3(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);


%% Prepare data for linear fit
sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
ace_values = [w.ace.ctl, w.ace.noanm, w.ace.m1, w.ace.m2, w.ace.m3, ...
               w.ace.p1, w.ace.p2, w.ace.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(ace_values);
sst_values = sst_values(valid_indices);
ace_values = ace_values(valid_indices);

% Perform linear regression
p4 = polyfit(sst_values, ace_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
ace_fit2 = polyval(p4, sst_values);

% Calculate residuals
residuals = ace_values - ace_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((ace_values - mean(ace_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma ACE/C: %.4f +/- %.4f\n', p4(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);


%% delta P............

sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
dP_values = [r.pres.ctl, r.pres.noanm, r.pres.m1, r.pres.m2, r.pres.m3, ...
               r.pres.p1, r.pres.p2, r.pres.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dP_values);
sst_values = sst_values(valid_indices);
dP_values = dP_values(valid_indices);

% Perform linear regression
p5 = polyfit(sst_values, dP_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dP_fit1 = polyval(p5, sst_values);

% Calculate residuals
residuals = dP_values - dP_fit1;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dP_values - mean(dP_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita dP/C: %.4f +/- %.4f\n', p5(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%%
sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
dP_values = [w.pres.ctl, w.pres.noanm, w.pres.m1, w.pres.m2, w.pres.m3, ...
               w.pres.p1, w.pres.p2, w.pres.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dP_values);
sst_values = sst_values(valid_indices);
dP_values = dP_values(valid_indices);

% Perform linear regression
p6 = polyfit(sst_values, dP_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dP_fit2 = polyval(p6, sst_values);

% Calculate residuals
residuals = dP_values - dP_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dP_values - mean(dP_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma dP/C: %.4f +/- %.4f\n', p6(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% DR ............

sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
dr_values = [r.dr.ctl, r.dr.noanm, r.dr.m1, r.dr.m2, r.dr.m3, ...
               r.dr.p1, r.dr.p2, r.dr.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dr_values);
sst_values = sst_values(valid_indices);
dr_values = dr_values(valid_indices);

% Perform linear regression
p7 = polyfit(sst_values, dr_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit1 = polyval(p7, sst_values);

% Calculate residuals
residuals = dr_values - dr_fit1;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dr_values - mean(dr_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita dr/C: %.4f +/- %.4f\n', p7(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%%
sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
dr_values = [w.dr.ctl, w.dr.noanm, w.dr.m1, w.dr.m2, w.dr.m3, ...
               w.dr.p1, w.dr.p2, w.dr.p3];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(dr_values);
sst_values = sst_values(valid_indices);
dr_values = dr_values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, dr_values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = dr_values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((dr_values - mean(dr_values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma dr/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);


%% OMLD fitting

% Define OMLD factors for each run
% omld_factors_r = [0.5, 1, 2]; % 0.5,1, 2 for Rita
% omld_factors_w = [0.5, 1, 1.4]; % 0.5, 1, 1.4 for Wilma

omld_factors_r = [17, 35, 70]; % 0.5,1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dE.....................................

% Rita: Prepare data for linear fit with OMLD factors
dE_values_r = [r.dE.oml17, r.dE.ctl, r.dE.oml70]./10^(17);

% Perform linear regression
p1 = polyfit(omld_factors_r, dE_values_r, 1); 

% Generate fitted values for plotting
dE_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dE_values_r - dE_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dE_values_r - mean(dE_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita dE/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dE_values_w = [w.dE.oml35, w.dE.ctl, w.dE.oml100]./10^(17);


% Perform linear regression
p2 = polyfit(omld_factors_w, dE_values_w, 1); 

% Generate fitted values for plotting
dE_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dE_values_w - dE_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dE_values_w - mean(dE_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma dE/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% ...dP.............................................


% Rita: Prepare data for linear fit with OMLD factors
dP_values_r = [r.pres.oml17, r.pres.ctl, r.pres.oml70];


% Perform linear regression
p3 = polyfit(omld_factors_r, dP_values_r, 1); 

% Generate fitted values for plotting
dP_fit_r = polyval(p3, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dP_values_r - dP_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dP_values_r - mean(dP_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita dP/OMLD*: %.4f +/- %.4f\n', p3(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dP_values_w = [w.pres.oml35, w.pres.ctl, w.pres.oml100];

% Perform linear regression
p4 = polyfit(omld_factors_w, dP_values_w, 1); 

% Generate fitted values for plotting
dP_fit_w = polyval(p4, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dP_values_w - dP_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dP_values_w - mean(dP_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma dP/OMLD*: %.4f +/- %.4f\n', p4(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%%...dr...

% Rita: Prepare data for linear fit with OMLD factors
dr_values_r = [r.dr.oml17, r.dr.ctl, r.dr.oml70];


% Perform linear regression
p5 = polyfit(omld_factors_r, dr_values_r, 1); 

% Generate fitted values for plotting
dr_fit_r = polyval(p5, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dr_values_r - dr_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dr_values_r - mean(dr_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita dr/OMLD*: %.4f +/- %.4f\n', p5(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dr_values_w = [w.dr.oml35, w.dr.ctl, w.dr.oml100];

% Perform linear regression
p6 = polyfit(omld_factors_w, dr_values_w, 1); 

% Generate fitted values for plotting
dr_fit_w = polyval(p6, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dr_values_w - dr_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dr_values_w - mean(dr_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma dr/OMLD*: %.4f +/- %.4f\n', p6(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%...ace...

% Rita: Prepare data for linear fit with OMLD factors
ace_values_r = [r.ace.oml17, r.ace.ctl, r.ace.oml70];


% Perform linear regression
p7 = polyfit(omld_factors_r, ace_values_r, 1); 

% Generate fitted values for plotting
ace_fit_r = polyval(p7, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = ace_values_r - ace_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((ace_values_r - mean(ace_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita ace/OMLD*: %.4f +/- %.4f\n', p7(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
ace_values_w = [w.ace.oml35, w.ace.ctl, w.ace.oml100];

% Perform linear regression
p8 = polyfit(omld_factors_w, ace_values_w, 1); 

% Generate fitted values for plotting
dr_fit_w = polyval(p8, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = ace_values_w - dr_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((ace_values_w - mean(ace_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma ace/OMLD*: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% dW / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dW.....................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [r.dW.oml17, r.dW.ctl, r.dW.oml70];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita dW/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [w.dW.oml35, w.dW.ctl, w.dW.oml100];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma dW/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%%
sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
values = [54.4, 52.7, 50.8, 48.0, 42.6, ...
               58.7, 61.8, 68.0];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita 10m mws/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%...............

sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
values = [60.4, 58.5, 55.5, 48.6, 41.5, ...
               63.7, 65.9, 74.6];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma values/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% THFX/C

sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
values = [2.87, 1.86, 2.08, 1.92, 1.20, ...
               4.19, 5.17, 6.87];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita THFX kW/m2/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%...............

sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
values = [4.52, 3.69, 3.13, 2.12, 1.29, ...
               5.15, 7.07, 10.55];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma THFX kW/m2/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% theta_e/C

sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
values = [385.06, 377.49, 379.54, 373.69, 366.63, ...
               393.63, 400.96, 410.93];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita theta_e K/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%...............

sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
values = [390.87, 382.97, 381.97, 372.36, 363.80, ...
               399.77, 405.66, 419.53];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma theta_e K/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% MWS/C

sst_values = [r.sst.ctl, r.sst.noanm, r.sst.m1, r.sst.m2, r.sst.m3, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
values = [85, 78.4, 80.8, 76.1, 68.8, ...
               96.7, 104.3, 116.7];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita MWS/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%...............

sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
values = [97.6, 88.5, 87.3, 74.9, 60.7, ...
               101.8, 110.9, 127.5];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma MWS/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% PR/C

sst_values = [r.sst.m3, r.sst.m2, r.sst.m1, r.sst.noanm, r.sst.ctl, ...
               r.sst.p1, r.sst.p2, r.sst.p3];
values = [226, 188, 192, 192, 226, 240, 316, 364];


% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Rita PR/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%...............

sst_values = [w.sst.ctl, w.sst.noanm, w.sst.m1, w.sst.m2, w.sst.m3, ...
               w.sst.p1, w.sst.p2, w.sst.p3];
values = [282, 270, 281, 266, 238, ...
               302, 333, 480];

% Remove NaN values (if any)
valid_indices = ~isnan(sst_values) & ~isnan(values);
sst_values = sst_values(valid_indices);
values = values(valid_indices);

% Perform linear regression
p8 = polyfit(sst_values, values, 1); % p(1) = slope, p(2) = intercept

% Generate fitted values for plotting
dr_fit2 = polyval(p8, sst_values);

% Calculate residuals
residuals = values - dr_fit2;

% Calculate RMSE
rmse = sqrt(mean(residuals.^2));

% standard deviations
stdev = std(residuals);

% Calculate R-squared
ss_total = sum((values - mean(values)).^2); % Total sum of squares
ss_residual = sum(residuals.^2); % Residual sum of squares
r_squared = 1 - (ss_residual / ss_total); % R-squared

% Display results
fprintf('Wilma PR/C: %.4f +/- %.4f\n', p8(1), stdev);
fprintf('R-squared: %.4f\n', r_squared);

%% 10m MWS / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dW.....................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [50.3, 54.4, 57];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita 10m MWS/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [56.8, 60.4, 59.8];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma 10m MWS/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% THFX / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dW.....................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [2.08, 2.87, 3.57];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita THFX kW/m^2 /m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [3.51, 4.52, 4.83];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma THFX kW/m^2 /m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% theta_e / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dW.....................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [379.52, 385.06, 390.93];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita theta_e  K/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [384.05, 390.87, 391.64];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma theta_e  K/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% MWS / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%..dW.....................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [81.5, 85.0, 86.5];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita mws m/s/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [91.8, 97.6, 99.1];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma mws  m/s/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%% PR / omld

omld_factors_r = [17, 35, 70]; % 0.5, 1, 2 for Rita
omld_factors_w = [35, 70, 100]; % 0.5, 1, 1.4 for Wilma

%......................................

% Rita: Prepare data for linear fit with OMLD factors
dW_values_r = [246, 226, 340];

% Perform linear regression
p1 = polyfit(omld_factors_r, dW_values_r, 1); 

% Generate fitted values for plotting
dW_fit_r = polyval(p1, omld_factors_r);

% Calculate residuals and error metrics
residuals_r = dW_values_r - dW_fit_r;
rmse_r = sqrt(mean(residuals_r.^2));
stdev = std(residuals_r);
ss_total_r = sum((dW_values_r - mean(dW_values_r)).^2);
ss_residual_r = sum(residuals_r.^2);
r_squared_r = 1 - (ss_residual_r / ss_total_r); 

% Display results for Rita
fprintf('Rita PR/m: %.4f +/- %.4f\n', p1(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_r);

% Wilma: Prepare data for linear fit with OMLD factors
dW_values_w = [246, 282, 294];

% Perform linear regression
p2 = polyfit(omld_factors_w, dW_values_w, 1); 

% Generate fitted values for plotting
dW_fit_w = polyval(p2, omld_factors_w);

% Calculate residuals and error metrics
residuals_w = dW_values_w - dW_fit_w;
rmse_w = sqrt(mean(residuals_w.^2));
stdev = std(residuals_w);
ss_total_w = sum((dW_values_w - mean(dW_values_w)).^2);
ss_residual_w = sum(residuals_w.^2);
r_squared_w = 1 - (ss_residual_w / ss_total_w); 

% Display results for Wilma
fprintf('Wilma PR/m: %.4f +/- %.4f\n', p2(1), stdev);
fprintf('R-squared: %.4f\n', r_squared_w);

%%  Rita Figure
colors = distinguishable_colors(11,'k');

fig1 = figure(1);
fig1.Position = [182 271 1200 1300];

tiledlayout(2,1)

nexttile
x = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10];

% SST / OHC / ACE / dP / DR / dE / THFX / theta_e / 10m MWS / MWS / Precip
vals = [r.sst.track.m3 r.ohc.m3.track r.ace.m3 r.pres.m3 r.dr.m3 r.dW.m3 1.20 366.63 42.6 68.8 226;
        r.sst.track.m2 r.ohc.m2.track r.ace.m2 r.pres.m2 r.dr.m2 r.dW.m2 1.92 373.69 48.0 76.1 188;
        r.sst.track.m1 r.ohc.m1.track r.ace.m1 r.pres.m1 r.dr.m1 r.dW.m1 2.08 379.54 50.8 80.9 192;
        r.sst.track.oml17 r.ohc.oml17.track r.ace.oml17 r.pres.oml17 r.dr.oml17 r.dW.oml17 2.08 379.52 50.3 81.5 246;
        r.sst.track.noanm r.ohc.noanm.track r.ace.noanm r.pres.noanm r.dr.noanm r.dW.noanm 1.86 377.49 52.7 78.4 192;
        r.sst.track.ctl r.ohc.ctl.track r.ace.ctl r.pres.ctl r.dr.ctl r.dW.ctl 2.87 385.06 54.4 85.0 226;
        r.sst.track.oml70 r.ohc.oml70.track r.ace.oml70 r.pres.oml70 r.dr.oml70 r.dW.oml70 3.57 390.93 57.0 86.5 340;
        r.sst.track.p1 r.ohc.p1.track r.ace.p1 r.pres.p1 r.dr.p1 r.dW.p1 4.19 393.63 58.7 96.7 240;
        r.sst.track.p2 r.ohc.p2.track r.ace.p2 r.pres.p2 r.dr.p2 r.dW.p2 5.17 400.96 61.8 104.3 316;
        r.sst.track.p3 r.ohc.p3.track r.ace.p3 r.pres.p3 r.dr.p3 r.dW.p3 6.87 410.93 68.0 116.7 364;];

% Retain a copy of raw values for Rita
rawValsR = vals; 

% Identify the control simulation row (assumed to be row 6 for Rita)
controlRowR = 6;
controlValsR = rawValsR(controlRowR, :);

% Compute percentage differences relative to the control simulation
percDiffR = ((rawValsR - controlValsR) ./ controlValsR) * 100;

% Display the results in a readable table format
rowNamesR = {'-3°C','-2°C','-1°C','OML17','No Anom.','Control','OML70','+1°C','+2°C','+3°C'};
variableNames = {'SST','OHC','ACE','ΔP','DR','ΔE','THFX','θ_e','10m_MWS','MWS','PR'};

fprintf('Percentage differences for Hurricane Rita relative to Control:\n');
disp(array2table(percDiffR, 'VariableNames', variableNames, 'RowNames', rowNamesR));

% Create a table for Rita percentage differences
tableRita = array2table(percDiffR, 'VariableNames', variableNames, 'RowNames', rowNamesR);

% Write the table to a CSV file
writetable(tableRita, 'RitaPercentageDifferences.csv', 'WriteRowNames', true);

r.normed.sst = normalize(vals(:,1),'zscore');
r.normed.ohc = normalize(vals(:,2),'zscore');
r.normed.ace = normalize(vals(:,3),'zscore');
r.normed.pres = normalize(vals(:,4),'zscore');
r.normed.dr = normalize(vals(:,5),'zscore');
r.normed.dW = normalize(vals(:,6),'zscore');
r.normed.thfx = normalize(vals(:,7),'zscore');
r.normed.th_e = normalize(vals(:,8),'zscore');
r.normed.mws10 = normalize(vals(:,9),'zscore');
r.normed.mws = normalize(vals(:,10),'zscore');
r.normed.pr = normalize(vals(:,11),'zscore');

vals(:,1) = r.normed.sst;
vals(:,2) = r.normed.ohc;
vals(:,3) = r.normed.ace;
vals(:,4) = r.normed.pres;
vals(:,5) = r.normed.dr;
vals(:,6) = r.normed.dW;
vals(:,7) = r.normed.thfx;
vals(:,8) = r.normed.th_e;
vals(:,9) = r.normed.mws10;
vals(:,10) = r.normed.mws;
vals(:,11) = r.normed.pr;

b = bar(x,vals); grid on; box on;
set(b(1),'facecolor',colors(1,:)); set(b(2),'facecolor',colors(2,:));
set(b(3),'facecolor',colors(3,:)); set(b(4),'facecolor',colors(4,:));
set(b(5),'facecolor',colors(5,:)); set(b(6),'facecolor',colors(6,:));
set(b(7),'facecolor',colors(7,:)); set(b(8),'facecolor',colors(8,:));
set(b(9),'facecolor',colors(9,:)); set(b(10),'facecolor',colors(10,:));
set(b(11),'facecolor',colors(11,:));

xticks([1 2 3 4 5 6 7 8 9 10])
xticklabels({'-3{\circ}C','-2{\circ}C','-1{\circ}C','OML17','No Anom.',...
    'Control','OML70','+1{\circ}C','+2{\circ}C','+3{\circ}C'});
% ylim([0 1])
ylabel('ZSCORE')
legend('SST','OHC','ACE','\DeltaP','DR','\DeltaE','THFX','\theta_e','10m MWS','MWS','PR',...
    'location','northwest','FontSize',13)
title('Hurricane Rita','FontSize',16)

set(gca,'FontSize',16)

% print('SST_OHC_ACE_MI_DR_rita','-djpeg','-r400',fig1);

% WILMA Figure

% fig2 = figure(2);
% fig2.Position = [200 300 1200 600];

nexttile

x = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10];

% SST / OHC / ACE / dP / DR / dE / THFX / theta_e / 10m MWS / MWS / Precip
vals = [w.sst.track.m3 w.ohc.m3.track w.ace.m3 w.pres.m3 w.dr.m3 w.dW.m3 1.29 363.80 41.5 60.7 238;
        w.sst.track.m2 w.ohc.m2.track w.ace.m2 w.pres.m2 w.dr.m2 w.dW.m2 2.12 372.36 48.6 74.9 266;
        w.sst.track.m1 w.ohc.m1.track w.ace.m1 w.pres.m1 w.dr.m1 w.dW.m1 3.13 381.97 55.5 87.3 281;
        w.sst.track.oml35 w.ohc.oml35.track w.ace.oml35 w.pres.oml35 w.dr.oml35 w.dW.oml35 3.51 384.05 56.8 91.8 246;
        w.sst.track.noanm w.ohc.noanm.track w.ace.noanm w.pres.noanm w.dr.noanm w.dW.noanm 3.69 382.97 58.5 88.5 270;
        w.sst.track.ctl w.ohc.ctl.track w.ace.ctl w.pres.ctl w.dr.ctl w.dW.ctl 4.52 390.87 60.4 97.6 282;
        w.sst.track.oml100 w.ohc.oml100.track w.ace.oml100 w.pres.oml100 w.dr.oml100 w.dW.oml100 4.83 391.64 59.8 99.1 294;
        w.sst.track.p1 w.ohc.p1.track w.ace.p1 w.pres.p1 w.dr.p1 w.dW.p1 5.15 399.77 63.7 101.8 302;
        w.sst.track.p2 w.ohc.p2.track w.ace.p2 w.pres.p2 w.dr.p2 w.dW.p2 7.07 405.66 65.9 110.9 333;
        w.sst.track.p3 w.ohc.p3.track w.ace.p3 w.pres.p3 w.dr.p3 w.dW.p3 10.55 419.53 74.6 127.5 480;];

% Retain a copy of raw values for Wilma
rawValsW = vals; 

% Identify the control simulation row (assumed to be row 6 for Wilma)
controlRowW = 6;
controlValsW = rawValsW(controlRowW, :);

% Compute percentage differences relative to the control simulation
percDiffW = ((rawValsW - controlValsW) ./ controlValsW) * 100;

% Define row labels for Wilma based on xticklabels order
rowNamesW = {'-3°C','-2°C','-1°C','OML35','No Anom.','Control','OML100','+1°C','+2°C','+3°C'};

fprintf('Percentage differences for Hurricane Wilma relative to Control:\n');
disp(array2table(percDiffW, 'VariableNames', variableNames, 'RowNames', rowNamesW));

% Create a table for Wilma percentage differences
tableWilma = array2table(percDiffW, 'VariableNames', variableNames, 'RowNames', rowNamesW);

% Write the table to a CSV file
writetable(tableWilma, 'WilmaPercentageDifferences.csv', 'WriteRowNames', true);

w.normed.sst = normalize(vals(:,1),'zscore');
w.normed.ohc = normalize(vals(:,2),'zscore');
w.normed.ace = normalize(vals(:,3),'zscore');
w.normed.pres = normalize(vals(:,4),'zscore');
w.normed.dr = normalize(vals(:,5),'zscore');
w.normed.dW = normalize(vals(:,6),'zscore');
w.normed.thfx = normalize(vals(:,7),'zscore');
w.normed.th_e = normalize(vals(:,8),'zscore');
w.normed.mws10 = normalize(vals(:,9),'zscore');
w.normed.mws = normalize(vals(:,10),'zscore');
w.normed.pr = normalize(vals(:,11),'zscore');

vals(:,1) = w.normed.sst;
vals(:,2) = w.normed.ohc;
vals(:,3) = w.normed.ace;
vals(:,4) = w.normed.pres;
vals(:,5) = w.normed.dr;
vals(:,6) = w.normed.dW;
vals(:,7) = w.normed.thfx;
vals(:,8) = w.normed.th_e;
vals(:,9) = w.normed.mws10;
vals(:,10) = w.normed.mws;
vals(:,11) = w.normed.pr;

b = bar(x,vals); grid on; box on;
set(b(1),'facecolor',colors(1,:)); set(b(2),'facecolor',colors(2,:));
set(b(3),'facecolor',colors(3,:)); set(b(4),'facecolor',colors(4,:));
set(b(5),'facecolor',colors(5,:)); set(b(6),'facecolor',colors(6,:));
set(b(7),'facecolor',colors(7,:)); set(b(8),'facecolor',colors(8,:));
set(b(9),'facecolor',colors(9,:)); set(b(10),'facecolor',colors(10,:));
set(b(11),'facecolor',colors(11,:));

xticks([1 2 3 4 5 6 7 8 9 10])
xticklabels({'-3{\circ}C','-2{\circ}C','-1{\circ}C','OML35','No Anom.',...
    'Control','OML100','+1{\circ}C','+2{\circ}C','+3{\circ}C'});
% ylim([0 1])
ylabel('ZSCORE')
legend('SST','OHC','ACE','\DeltaP','DR','\DeltaE','THFX','\theta_e','10m MWS','MWS','PR',...
    'location','northwest','FontSize',13)
title('Hurricane Wilma','FontSize',16)

set(gca,'FontSize',16)

% print('SST_OHC_ACE_MI_DR_wilma','-djpeg','-r400',fig2);

