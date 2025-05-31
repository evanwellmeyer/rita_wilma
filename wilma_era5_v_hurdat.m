% wilma era5 vs hurdat

clear all

hurdat = import_gulf_extract('wilma_hurdat.txt');

era5 = load('wilma_era5.txt');

%% take stats 

% hurdat stats 
pres_noaa = hurdat{:,11};
kt_noaa = hurdat{:,10};
windsp_noaa = max(kt_noaa);
minpres_noaa = min(pres_noaa(pres_noaa>0));
ace_noaa = ace_index6(kt_noaa);
berg_noaa = get_bergeron_hu(hurdat,252005,12,1);
MaxBerg_noaa = max(berg_noaa);
date_noaa = datetime(hurdat{:,2},hurdat{:,3},hurdat{:,4},hurdat{:,5},0,0);

[~,mI_h] = max(berg_noaa);


% era5 stats 
pres_era5 = era5(:,8);
kt_era5 = era5(:,7);
windsp_era5 = max(kt_era5);
minpres_era5 = min(pres_era5(pres_era5>0));
ace_era5 = ace_index(kt_era5);
berg_era5 = get_bergeron(era5,12,1);
MaxBerg_era5 = max(berg_era5);
date_era5 = datetime(era5(:,1),era5(:,2),era5(:,3),era5(:,4),0,0);

[~,mI_e] = max(berg_era5);


%% 

fig1 = figure;
fig1.Position = [100 100 1570 1120];

t = tiledlayout('flow');

% mapping 
nexttile

% hurdat
geoplot(hurdat{10:19,8},hurdat{10:19,9},'k'); hold on;
geoplot(era5(55:6:109,5),era5(55:6:109,6),'r'); hold on;

geoscatter(hurdat{10:19,8},hurdat{10:19,9},60,pres_noaa(10:19),'filled','markerEdgeColor','k'); hold on; 
geoscatter(hurdat{mI_h,8},hurdat{mI_h,9},500,'k','o')

% era5

geoscatter(era5(55:6:109,5),era5(55:6:109,6),60,pres_era5(55:6:109),'filled','markerEdgeColor','r'); hold on; 
geoscatter(era5(mI_e,5),era5(mI_e,6),500,'r','o')

cb = colorbar;
cb.Location = 'eastoutside';
caxis([900 1020]);
colormap(jet);
cb.Label.String = '\bf \fontsize{12} Minimum Pressure (hPa) ';

% colororder(colors)
geobasemap grayterrain
geolimits([14 24],[-88 -78])


name = hurdat{1,6};

nexttile
hold on;
plot(date_noaa,pres_noaa,'k')
plot(date_era5,pres_era5,'r')
ylabel('Min. Pressure (hPa)')
ylim([870 1020])
grid on;
box on;
legend('HURDAT','ERA5','Pressure','Max DR')

nexttile
hold on;
plot(date_noaa,kt_noaa,'k')
plot(date_era5,kt_era5,'r')
ylabel('Max Wind Speed (kts)')
ylim([20 170])
grid on;
box on;

nexttile
hold on;
plot(date_noaa,berg_noaa,'k')
plot(date_era5,berg_era5,'r')
ylabel('12 hour DR (bergeron)')
ylim([-2.5 10])
grid on;
box on;

str = 'NOAA: Max Sust. Wind: %i kts, Min. Pres.: %i hPa, ACE: %0.2f, Max DR: %0.1f \n ERA5: Max Sust. Wind: %i kts, Min. Pres.: %i hPa, ACE: %0.2f, Max DR: %0.1f \n';

ttlestr = sprintf(str,windsp_noaa,minpres_noaa,ace_noaa,MaxBerg_noaa...
    ,windsp_era5,minpres_era5,ace_era5,MaxBerg_era5);

title(t,'Hurricane Wilma 2005: Oct. 18 00UTC - Oct 20 06UTC','FontSize',16,'FontWeight','bold')

xlabel(t,ttlestr,'FontSize',16,'FontWeight','bold')

% print('wilma_hurdat_v_era5_map','-dpng','-r500',fig1);
