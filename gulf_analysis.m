% gulf select analysis

clear all

TCs = import_gulf_extract('hurdat_north_atl_1940-2021.txt');

IDs = unique(TCs{:,1},'stable');

%%

fig1 = figure;
fig1.Position = [100 100 1200 700];
for i = 1:length(IDs)
    idx = find(TCs{:,1} == IDs(i));
    pres = TCs{idx,11};
    kt = TCs{idx,10};
    [~,mI] = min(TCs{idx,11});
    [~,MI] = max(TCs{idx,10});
    mII = idx(mI);
    MII = idx(MI);
    geoplot(TCs{idx,8},TCs{idx,9},'k'); hold on;
    geoscatter(TCs{idx,8},TCs{idx,9},20,kt,'filled','markerEdgeColor','k'); hold on; 
    geoscatter(TCs{mII,8},TCs{mII,9},120,kt(MI),'o')
end

cb = colorbar('Ticks',0:15:150,'FontSize',14);
cb.Location = 'eastoutside';
caxis([0 155]);
colormap(jet);
cb.Label.String = '\bf \fontsize{18} Max Wind Speed (kt) ';

% colororder(colors)
geobasemap grayterrain

title('\bf \fontsize{18} Gulf of Mexico Hurricanes (44) 1940-2021')

legend('Track','Max Wind Speed','Maximum','FontSize',13)

%%

fig1 = figure;
fig1.Position = [100 100 1200 700];
geodensityplot(TCs{:,8},TCs{:,9},'FaceColor','interp')
geolimits([10 40],[-110 -60])

colormap hsv
geobasemap grayterrain

title('\bf \fontsize{18} Gulf of Mexico Hurricanes + Tropical Storms 1992-2021')


%% To plot specific cyclone
return;

% choose cyclone by identification number
TC = 41992;

fig1 = figure;
fig1.Position = [100 100 1200 700];

idx = find(TCs{:,1} == TC);
pres = TCs{idx,11};
kt = TCs{idx,10};
[~,mI] = min(TCs{idx,11});
[~,MI] = max(TCs{idx,10});
mII = idx(mI);
MII = idx(MI);
geoplot(TCs{idx,8},TCs{idx,9},'k'); hold on;
geoscatter(TCs{idx,8},TCs{idx,9},20,kt,'filled','markerEdgeColor','k'); hold on; 
geoscatter(TCs{MII,8},TCs{MII,9},120,kt(MI),'o')

cb = colorbar('Ticks',0:20:160,'FontSize',14);
cb.Location = 'eastoutside';
caxis([0 160]);
colormap(hsv);
cb.Label.String = '\bf \fontsize{18} Max Wind Speed (kt) ';

% colororder(colors)
geobasemap grayterrain

nameIDX = find(TCs{:,1}==TC,1);

name = TCs{nameIDX,6};

ttlestr = sprintf('HURRICANE %s',name);

title(ttlestr,'FontSize',18)

