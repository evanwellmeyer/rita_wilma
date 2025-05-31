% wrf domain figure 

clear all;

ref_lat = 21.207;
ref_lon = -84.721;

dx1 = 9;
dx2 = 3;

e_we1 = 445;
e_we2 = 976;

e_sn1 = 357;
e_sn2 = 778;

L_we1 = dx1*e_we1;
L_sn1 = dx1*e_sn1;

L_we2 = dx2*e_we2;
L_sn2 = dx2*e_sn2;

lat1_n = 35.70079;
lat1_s = 6.713;

lon1_e = -65.42537;
lon1_w = -104.0166;

lat2_n = 31.7356;
lat2_s = 10.678;

lon2_e = -70.614;
lon2_w = -98.8278;



fig1 = figure;
fig1.Position = [182 271 1091 794];
gx = geoaxes;

% domain 1
geoplot([lat1_n lat1_n],[lon1_w lon1_e],'k','LineWidth',2); hold on;
geoplot([lat1_s lat1_s],[lon1_w lon1_e],'k','LineWidth',2);
geoplot([lat1_s lat1_n],[lon1_w lon1_w],'k','LineWidth',2);
geoplot([lat1_s lat1_n],[lon1_e lon1_e],'k','LineWidth',2);

% domain 2
geoplot([lat2_n lat2_n],[lon2_w lon2_e],'k','LineWidth',2);
geoplot([lat2_s lat2_s],[lon2_w lon2_e],'k','LineWidth',2);
geoplot([lat2_s lat2_n],[lon2_w lon2_w],'k','LineWidth',2);
geoplot([lat2_s lat2_n],[lon2_e lon2_e],'k','LineWidth',2);

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)

geobasemap none
geolimits([-5 45],[-120 -50])

gx.FontSize = 15;
print('wrf_domain','-djpeg','-r200',fig1);


