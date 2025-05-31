% north antlantic analysis

clear all

TCs = import_atl_extract('hurdat_1961-2022.txt');

IDs = unique(TCs{:,1},'stable');

%% table of max windspeed index
% go through each storm one at a time and select all the data at its most
% intense timestep

% initialize
TC_max_IDs = [];
MaxBerg = zeros(length(IDs),1);

% loop over the cyclones
for i = 1:length(IDs)
    
    % select current TC
    TC_id = IDs(i);
    
    % take all indices of current TC
    idx = find(TCs{:,1} == TC_id);
    
    % take index of max windspeed for that TC
    [~,MI] = max(TCs{idx,10});
    
    % convert to index of full series
    max_id = idx(MI);
    
    % take max deepening rate
    berg = get_bergeron_hu(TCs,TC_id,24,3);
    MaxBerg(i) = max(berg);
    
    % concatenate into array
    if isempty(TC_max_IDs)
        TC_max_IDs = max_id;       
    else      
        TC_max_IDs = [TC_max_IDs;max_id]; %#ok
    end
    
    
end

% create table of max wind indices
TC_max = TCs(TC_max_IDs,:);
TC_max{:,12} = MaxBerg;

TC_max.Properties.VariableNames = {'ID','Y','M','D','HH','Name','status','lat','lon','kt_max','mbar_min','Max_DR'};

%% number by year

yr_stats = zeros(61,2);
tc_stats = zeros(61,2);
ts_stats = zeros(61,2);
hu_stats = zeros(61,2);
mh_stats = zeros(61,2);
ri_stats = zeros(61,2);

ii=1;
for i = 1961:2022
    len = length(find(TC_max{:,2} == i));
    yr_stats(ii,:) = [i,len];
    
    tc = length(find(TC_max{:,2} == i & TC_max{:,7} ~= 'LO' & TC_max{:,7} ~= 'SS'));
    tc_stats(ii,:) = [i,tc];
    
    ts = length(find(TC_max{:,2} == i & TC_max{:,7} ~= 'HU'));
    ts_stats(ii,:) = [i,ts];
    
    hu = length(find(TC_max{:,2} == i & TC_max{:,7} == 'HU' & TC_max{:,10} <= 95 & TC_max{:,12} < 1));
    hu_stats(ii,:) = [i,hu];
    
    mh = length(find(TC_max{:,2} == i & TC_max{:,10} >= 96 & TC_max{:,12} < 1));
    mh_stats(ii,:) = [i,mh];
    
    ri = length(find(TC_max{:,2} == i & TC_max{:,7} == 'HU' & TC_max{:,12} >= 1));
    ri_stats(ii,:) = [i,ri];
    
    ii=ii+1;
end

x = yr_stats(:,1);
y = [ts_stats(:,2)'; hu_stats(:,2)'; mh_stats(:,2)'; ri_stats(:,2)'];
yy = [mean(ts_stats(:,2)); mean(hu_stats(:,2)); mean(mh_stats(:,2)); mean(ri_stats(:,2))];

fig1 = figure;
fig1.Position = [100 100 1200 700];
% tiledlayout('flow')
% 
% nexttile
p = pie(yy);
%p(1).FaceColor = [.3 .3 .3]; p(2).FaceColor = [.2 .6 .5]; p(4).FaceColor = [.8 .2 .2];
title('Distribution of North Atlantic Disturbances 1961-2022')
legend('Non-Hurricane Strength Disturbances','Non-Major Hurrianes (Non RI)',...
    'Major Hurricanes (Non RI)','Hurricanes w/ Rapid Intensications','Location','south')
colormap(gray)

fig1 = figure;
fig1.Position = [100 100 1200 700];
% nexttile
b = bar(x,y);%'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0])
b(1).FaceColor = [.3 .3 .3]; b(2).FaceColor = [.2 .6 .5]; b(4).FaceColor = [.8 .2 .2];
title('\bf \fontsize{18} Number of North Atlantic TCs by year 1961-2022')
legend('Non-Hurricane Strength Disturbances','Hurricanes','Major Hurricanes','Rapid Intensifications')
grid on;

%% ACE by year

ace_stats = zeros(61,2);

ii=1;
for i = 1961:2022
    idx = find(TCs{:,2} == i);
    kts = TCs{idx,10};
    ace = ace_index6(kts);
    ace_stats(ii,:) = [i,ace];
    ii=ii+1;
end

fig1 = figure;
fig1.Position = [100 100 1200 700];
tiledlayout(2,1)

nexttile
b = bar(tc_stats(:,1),tc_stats(:,2),'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0]);
b.FaceColor = 'flat';
b.CData(45,:) = [1 0 0];
set(gca,'FontSize',18)
title('\bf \fontsize{18} North Atlantic TC Occurrences by year 1961-2022')
grid on;
ylim([0 32])

nexttile
bb = bar(ace_stats(:,1),ace_stats(:,2),'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0]);
bb.FaceColor = 'flat';
bb.CData(45,:) = [1 0 0];
set(gca,'FontSize',18)
title('\bf \fontsize{18} Accumulated Cyclone Energy by Year')
grid on;

nexttile
bar(ace_stats(:,1),ace_stats(:,2)./yr_stats(:,2),'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0])
title('\bf \fontsize{18} Averaged ACE per TC Occurrence by Year')
grid on;

%% number by month

mo_stats = zeros(12,2);
% number of ts + hu per year 
ii=1;
for i = 1:12
    len = length(find(TC_max{:,3} == i));
    mo_stats(ii,:) = [i,len];
    ii=ii+1;
end

fig1 = figure;
fig1.Position = [100 100 1200 700];
bar(mo_stats(:,1),mo_stats(:,2),'FaceColor',[.3 .3 .3],'EdgeColor',[0 0 0])
title('\bf \fontsize{18} North Atlantic TCs by month 1961-2022')
grid on;

%%

fig1 = figure;
fig1.Position = [100 100 1200 700];
for i = 51:length(IDs)
    idx = find(TCs{:,1} == IDs(i));
%     pres = TCs{idx,11};
%     kt = TCs{idx,10};
%     [~,mI] = min(TCs{idx,11});
%     [~,MI] = max(TCs{idx,10});
%     mII = idx(mI);
%     MII = idx(MI);
    geoplot(TCs{idx,8},TCs{idx,9},'k'); hold on;
%     geoscatter(TCs{idx,8},TCs{idx,9},20,kt,'filled','markerEdgeColor','k'); hold on; 
%     geoscatter(TCs{mII,8},TCs{mII,9},120,kt(MI),'o')
end

% cb = colorbar('Ticks',0:15:150,'FontSize',14);
% cb.Location = 'eastoutside';
% caxis([0 155]);
% colormap(jet);
% cb.Label.String = '\bf \fontsize{18} Max Wind Speed (kt) ';

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)
% colororder(colors)
geobasemap none

title('\bf \fontsize{18} Gulf of Mexico Hurricanes (44) 1940-2021')

legend('Track','Max Wind Speed','Maximum','FontSize',13)

%%

fig1 = figure;
fig1.Position = [100 100 1200 700];
geodensityplot(TCs{:,8},TCs{:,9},'FaceColor','interp')
geolimits([10 40],[-110 -60])

colormap(turbo)
load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)
% colororder(colors)
geobasemap none
geolimits([14 24],[-89 -78])

title('\bf \fontsize{18} Gulf of Mexico Hurricanes + Tropical Storms 1992-2021')


%% To plot specific cyclone
return;

% choose cyclone by identification number
% wilma 252005, ivan 92004, allen 41980, dorian 52019, irma 112017
TC = 252005;

fig1 = figure;
fig1.Position = [182 271 1091 794];
gx = geoaxes;


idx = find(TCs{:,1} == TC);
pres = TCs{idx,11};
kt = TCs{idx,10};
windsp = max(kt);
minpres = min(pres(pres>0));
ace = ace_index6(kt);
berg = get_bergeron_hu(TCs,TC,24,3);
MaxBerg = max(berg);
date = datetime(TCs{idx,2},TCs{idx,3},TCs{idx,4},TCs{idx,5},0,0);

[~,mI] = min(TCs{idx,11});
[~,MI] = max(TCs{idx,10});
mII = idx(mI);
MII = idx(MI);


geoplot(TCs{idx,8},TCs{idx,9},'k'); hold on;
geoscatter(TCs{idx,8},TCs{idx,9},100,pres,'filled','markerEdgeColor','k'); hold on; 
o = geoscatter(TCs{idx(14),8},TCs{idx(14),9},400,pres(mI),'o');

cb = colorbar('Ticks',882:20:1000,'FontSize',20);
cb.Location = 'eastoutside';
caxis([882 1010]);
colormap(flipud(turbo));
cb.Label.String = '\bf \fontsize{20} Min. Central Pressure (hPa) ';
legend(o,'Max DR','location','northwest','FontSize',20)

load coastlines
geoplot(coastlat,coastlon,'k','LineWidth',0.5)

% colororder(colors)
geobasemap none
geolimits([14 24],[-89 -78])
gx.FontSize = 15;


nameIDX = find(TCs{:,1}==TC,1);

name = TCs{nameIDX,6};



% figure for pressure
% fig2 = figure;
% fig2.Position = [100 100 1200 700];

nexttile
plot(date,pres,'k')
ylabel('Min. Pressure (hPa)')
ylim([870 1020])
grid on;

nexttile
plot(date,kt,'k')
ylabel('Max Wind Speed (kts)')
ylim([20 170])
grid on;

nexttile
plot(date,berg,'k')
ylabel('DR (bergeron)')
ylim([-1 3])
grid on;

ttlestr = sprintf('%s %i, Max Sust. Wind: %i kts, Min. Pres.: %i hPa, ACE: %0.2f, Max DR: %0.1f'...
    ,name,TCs{idx(1),2},windsp,minpres,ace,MaxBerg);

title(t,ttlestr,'FontSize',16,'FontWeight','bold')
% print('wilma_track','-djpeg','-r200',fig1);