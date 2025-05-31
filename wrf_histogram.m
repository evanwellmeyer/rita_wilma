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

r.sst.track.ctl = mean(r.sst.track.ctl(r.sst.track.ctl>0));
r.sst.track.noanm = mean(r.sst.track.noanm(r.sst.track.noanm>0));
r.sst.track.m1 = mean(r.sst.track.m1(r.sst.track.m1>0));
r.sst.track.m2 = mean(r.sst.track.m2(r.sst.track.m2>0));
r.sst.track.m3 = mean(r.sst.track.m3(r.sst.track.m3>0));
r.sst.track.oml17 = mean(r.sst.track.oml17(r.sst.track.oml17>0));
r.sst.track.oml70 = mean(r.sst.track.oml70(r.sst.track.oml70>0));
r.sst.track.p1 = mean(r.sst.track.p1(r.sst.track.p1>0));
r.sst.track.p2 = mean(r.sst.track.p2(r.sst.track.p2>0));
r.sst.track.p3 = mean(r.sst.track.p3(r.sst.track.p3>0));

r.sst.track.noaa = mean(r.sst.track.noaa(r.sst.track.noaa>0));

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

w.sst.track.ctl = mean(w.sst.track.ctl(w.sst.track.ctl>0));
w.sst.track.noanm = mean(w.sst.track.noanm(w.sst.track.noanm>0));
w.sst.track.m1 = mean(w.sst.track.m1(w.sst.track.m1>0));
w.sst.track.m2 = mean(w.sst.track.m2(w.sst.track.m2>0));
w.sst.track.m3 = mean(w.sst.track.m3(w.sst.track.m3>0));
w.sst.track.oml35 = mean(w.sst.track.oml35(w.sst.track.oml35>0));
w.sst.track.oml100 = mean(w.sst.track.oml100(w.sst.track.oml100>0));
w.sst.track.p1 = mean(w.sst.track.p1(w.sst.track.p1>0));
w.sst.track.p2 = mean(w.sst.track.p2(w.sst.track.p2>0));
w.sst.track.p3 = mean(w.sst.track.p3(w.sst.track.p3>0));

w.sst.track.noaa = mean(w.sst.track.noaa(w.sst.track.noaa>0));

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

%% Pres

r.pres.ctl = 996 - min(r.ctl(:,8));
r.pres.noanm = 996 - min(r.noanm(:,8));
r.pres.m1 = 996 - min(r.m1(:,8));
r.pres.m2 = 996 - min(r.m2(:,8));
r.pres.m3 = 996 - min(r.m3(:,8));
r.pres.oml17 = 996 - min(r.oml17(:,8));
r.pres.oml70 = 996 - min(r.oml70(:,8));
r.pres.p1 = 996 - min(r.p1(:,8));
r.pres.p2 = 996 - min(r.p2(:,8));
r.pres.p3 = 996 - min(r.p3(:,8));

w.pres.ctl = 998 - min(w.ctl(:,8));
w.pres.noanm = 998 - min(w.noanm(:,8));
w.pres.m1 = 998 - min(w.m1(:,8));
w.pres.m2 = 998 - min(w.m2(:,8));
w.pres.m3 = 998 - min(w.m3(:,8));
w.pres.oml35 = 998 - min(w.oml35(:,8));
w.pres.oml100 = 998 - min(w.oml100(:,8));
w.pres.p1 = 998 - min(w.p1(:,8));
w.pres.p2 = 998 - min(w.p2(:,8));
w.pres.p3 = 998 - min(w.p3(:,8));

%% max DR

r.dr.ctl = max(r.ctl(:,9));
r.dr.noanm = max(r.noanm(:,9));
r.dr.m1 = max(r.m1(:,9));
r.dr.m2 = max(r.m2(:,9));
r.dr.m3 = max(r.m3(:,9));
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

%%  Rita Figure
colors = distinguishable_colors(6,'k');

fig1 = figure(1);
fig1.Position = [182 271 1200 600];
x = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10];

vals = [r.sst.track.m3 r.ohc.m3.track r.ace.m3 r.pres.m3 r.dr.m3 r.dE.m3;
        r.sst.track.m2 r.ohc.m2.track r.ace.m2 r.pres.m2 r.dr.m2 r.dE.m2;
        r.sst.track.m1 r.ohc.m1.track r.ace.m1 r.pres.m1 r.dr.m1 r.dE.m1;
        r.sst.track.oml17 r.ohc.oml17.track r.ace.oml17 r.pres.oml17 r.dr.oml17 r.dE.oml17;
        r.sst.track.noanm r.ohc.noanm.track r.ace.noanm r.pres.noanm r.dr.noanm r.dE.noanm;
        r.sst.track.ctl r.ohc.ctl.track r.ace.ctl r.pres.ctl r.dr.ctl r.dE.ctl;
        r.sst.track.oml70 r.ohc.oml70.track r.ace.oml70 r.pres.oml70 r.dr.oml70 r.dE.oml70;
        r.sst.track.p1 r.ohc.p1.track r.ace.p1 r.pres.p1 r.dr.p1 r.dE.p1;
        r.sst.track.p2 r.ohc.p2.track r.ace.p2 r.pres.p2 r.dr.p2 r.dE.p2;
        r.sst.track.p3 r.ohc.p3.track r.ace.p3 r.pres.p3 r.dr.p3 r.dE.p3;];

r.normed.sst = normalize(vals(:,1),'zscore');
r.normed.ohc = normalize(vals(:,2),'zscore');
r.normed.ace = normalize(vals(:,3),'zscore');
r.normed.pres = normalize(vals(:,4),'zscore');
r.normed.dr = normalize(vals(:,5),'zscore');
r.normed.dE = normalize(vals(:,6),'zscore');

vals(:,1) = r.normed.sst;
vals(:,2) = r.normed.ohc;
vals(:,3) = r.normed.ace;
vals(:,4) = r.normed.pres;
vals(:,5) = r.normed.dr;
vals(:,6) = r.normed.dE;

b = bar(x,vals); grid on; box on;
set(b(1),'facecolor',colors(1,:)); set(b(2),'facecolor',colors(2,:));
set(b(3),'facecolor',colors(3,:)); set(b(4),'facecolor',colors(4,:));
set(b(5),'facecolor',colors(5,:)); set(b(6),'facecolor',colors(6,:));
xticks([1 2 3 4 5 6 7 8 9 10])
xticklabels({'-3{\circ}C','-2{\circ}C','-1{\circ}C','1/2 OMLD','No Anom.',...
    'Control','2*OMLD','+1{\circ}C','+2{\circ}C','+3{\circ}C'});
% ylim([0 1])
ylabel('ZSCORE')
legend('SST','OHC','ACE','\DeltaP','DR','\DeltaE','location','northwest','FontSize',16)
% title('Normalized Simulation Results - Hurricane Rita','FontSize',16)

set(gca,'FontSize',16)

% print('SST_OHC_ACE_MI_DR_rita','-djpeg','-r400',fig1);

%%  WILMA Figure

fig2 = figure(2);
fig2.Position = [200 300 1200 600];

x = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10];
vals = [w.sst.track.m3 w.ohc.m3.track w.ace.m3 w.pres.m3 w.dr.m3 w.dE.m3;
        w.sst.track.m2 w.ohc.m2.track w.ace.m2 w.pres.m2 w.dr.m2 w.dE.m2;
        w.sst.track.m1 w.ohc.m1.track w.ace.m1 w.pres.m1 w.dr.m1 w.dE.m1;
        w.sst.track.oml35 w.ohc.oml35.track w.ace.oml35 w.pres.oml35 w.dr.oml35 w.dE.oml35;
        w.sst.track.noanm w.ohc.noanm.track w.ace.noanm w.pres.noanm w.dr.noanm w.dE.noanm;
        w.sst.track.ctl w.ohc.ctl.track w.ace.ctl w.pres.ctl w.dr.ctl w.dE.ctl;
        w.sst.track.oml100 w.ohc.oml100.track w.ace.oml100 w.pres.oml100 w.dr.oml100 w.dE.oml100;
        w.sst.track.p1 w.ohc.p1.track w.ace.p1 w.pres.p1 w.dr.p1 w.dE.p1;
        w.sst.track.p2 w.ohc.p2.track w.ace.p2 w.pres.p2 w.dr.p2 w.dE.p2;
        w.sst.track.p3 w.ohc.p3.track w.ace.p3 w.pres.p3 w.dr.p3 w.dE.p3;];

w.normed.sst = normalize(vals(:,1),'zscore');
w.normed.ohc = normalize(vals(:,2),'zscore');
w.normed.ace = normalize(vals(:,3),'zscore');
w.normed.pres = normalize(vals(:,4),'zscore');
w.normed.dr = normalize(vals(:,5),'zscore');
w.normed.dE = normalize(vals(:,6),'zscore');

vals(:,1) = w.normed.sst;
vals(:,2) = w.normed.ohc;
vals(:,3) = w.normed.ace;
vals(:,4) = w.normed.pres;
vals(:,5) = w.normed.dr;
vals(:,6) = w.normed.dE;

b = bar(x,vals); grid on; box on;
set(b(1),'facecolor',colors(1,:)); set(b(2),'facecolor',colors(2,:));
set(b(3),'facecolor',colors(3,:)); set(b(4),'facecolor',colors(4,:));
set(b(5),'facecolor',colors(5,:)); set(b(6),'facecolor',colors(6,:));
xticks([1 2 3 4 5 6 7 8 9 10])
xticklabels({'-3{\circ}C','-2{\circ}C','-1{\circ}C','1/2 OMLD','No Anom.',...
    'Control','1.4*OMLD','+1{\circ}C','+2{\circ}C','+3{\circ}C'});
% ylim([0 1])
ylabel('ZSCORE')
legend('SST','OHC','ACE','\DeltaP','DR','\DeltaE','location','northwest','FontSize',16)
% title('Normalized Simulation Results - Hurricane Wilma','FontSize',16)

set(gca,'FontSize',16)

% print('SST_OHC_ACE_MI_DR_wilma','-djpeg','-r400',fig2);


