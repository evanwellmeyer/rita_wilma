% fitting pressure and omld

% RITA
% max DR and min press vs temp

rMI = [-3 971;-2 957;-1 946;0 929;1 915;2 891;3 871];
rDR = [-3 0.25;-2 0.49;-1 0.61;0 0.89;1 1.29;2 1.54;3 1.88];

fig1 = figure;
fig1.Position = [434 479 986 710]; 

tld = tiledlayout(2,2);

t1 = nexttile;
colororder(t1,{'k','r'})

yyaxis left
f1 = fit(rMI(:,1),rMI(:,2),'poly1');
scatter(rMI(:,1),rMI(:,2),'filled'); hold on;
plot(f1,'k'); 
ylabel('Minimum Central Pressure (hPa)')
text('FontSize',12,'String','Fit: -16.54 \pm 2.28 hPa C^{-1}'...
        ,'Units','normalized','Position',[0.20 0.93 0],'Color',[0 0 0]);
legend off;
grid on;
ylim([840 980])

yyaxis right
f2 = fit(rDR(:,1),rDR(:,2),'poly1');
scatter(rDR(:,1),rDR(:,2),'filled'); hold on;
plot(f2)
ylabel('Maximum Deepening Rate (Bergeron)')
text('FontSize',12,'String','Fit: 0.27 \pm 0.041 Bergeron C^{-1}'...
        ,'Units','normalized','Position',[0.16 0.1 0],'Color','r');
legend off;
ylim([0 3])

xlabel('SST Modulation')
set(t1,'XTick',[-3 -2 -1 0 1 2 3],'XTickLabel',{'-3','-2','-1','0','1','2','3'});
box on;

% max DR and min press vs oml

rMI = [0.5 941;1 929;2 920];
rDR = [0.5 0.76;1 0.89;2 1.02];

t2 = nexttile;
colororder(t2,{'k','r'})

yyaxis left
f3 = fit(rMI(:,1),rMI(:,2),'poly1');
scatter(rMI(:,1),rMI(:,2),'filled'); hold on;
plot(f3,'k'); 
ylabel('Minimum Central Pressure (hPa)')
text('FontSize',12,'String','Fit: -22.62 \pm 11.18 hPa *OMLD^{-1}'...
        ,'Units','normalized','Position',[0.15 0.93 0],'Color',[0 0 0]);
legend off;
grid on;
ylim([890 945])

yyaxis right
f4 = fit(rDR(:,1),rDR(:,2),'poly1');
scatter(rDR(:,1),rDR(:,2),'filled'); hold on;
plot(f4)
ylabel('Maximum Deepening Rate (Bergeron)')
text('FontSize',12,'String','Fit: 0.28 \pm 0.154 Bergeron *OMLD^{-1}'...
        ,'Units','normalized','Position',[0.1 0.1 0],'Color','r');
legend off;
ylim([0 2])

xlabel('OMLD Multiplication Factor')
set(t2,'XTick',[0.5 1 2],'XTickLabel',{'0.5','1','2'});
box on;

title([t1 t2],'Hurricane Rita')

% WILMA
% max DR and min press vs temp

wMI = [-3 978;-2 952;-1 932;0 911;1 888;2 890;3 852];
wDR = [-3 0.34;-2 0.77;-1 1.07;0 1.60;1 1.97;2 1.78;3 2.71];

% fig2 = figure;
% fig2.Position = [1279 737 788 420]; 
% 
% tld = tiledlayout(1,2);

t3 = nexttile;
colororder(t3,{'k','r'})

yyaxis left
fw1 = fit(wMI(:,1),wMI(:,2),'poly1');
scatter(wMI(:,1),wMI(:,2),'filled'); hold on;
plot(fw1,'k'); 
ylabel('Minimum Central Pressure (hPa)')
text('FontSize',12,'String','Fit: -19.5 \pm 3.88 hPa C^{-1}'...
        ,'Units','normalized','Position',[0.20 0.93 0],'Color',[0 0 0]);
legend off;
grid on;
ylim([840 980])

yyaxis right
fw2 = fit(wDR(:,1),wDR(:,2),'poly1');
scatter(wDR(:,1),wDR(:,2),'filled'); hold on;
plot(fw2)
ylabel('Maximum Deepening Rate (Bergeron)')
text('FontSize',12,'String','Fit: 0.36 \pm 0.105 Bergeron C^{-1}'...
        ,'Units','normalized','Position',[0.1 0.1 0],'Color','r');
legend off;
ylim([0 3])

xlabel('SST Modulation')
set(t3,'XTick',[-3 -2 -1 0 1 2 3],'XTickLabel',{'-3','-2','-1','0','1','2','3'});
box on;

% max DR and min press vs oml

wMI = [0.5 921;1 911;1.43 912];
wDR = [0.5 1.38;1 1.60;1.43 1.02];

t4 = nexttile;
colororder(t4,{'k','r'})

yyaxis left
fw3 = fit(wMI(:,1),wMI(:,2),'poly1');
scatter(wMI(:,1),wMI(:,2),'filled'); hold on;
plot(fw3,'k'); 
ylabel('Minimum Central Pressure (hPa)')
text('FontSize',12,'String','Fit: -9.96 \pm 81.3 hPa *OMLD^{-1}'...
        ,'Units','normalized','Position',[0.10 0.93 0],'Color',[0 0 0]);
legend off;
grid on;
ylim([890 945])

yyaxis right
fw4 = fit(wDR(:,1),wDR(:,2),'poly1');
scatter(wDR(:,1),wDR(:,2),'filled'); hold on;
plot(fw4)
ylabel('Maximum Deepening Rate (Bergeron)')
text('FontSize',12,'String','Fit: -0.36 \pm 6.51 Bergeron *OMLD^{-1}'...
        ,'Units','normalized','Position',[0.05 0.08 0],'Color','r');
legend off;
ylim([0 2])

xlabel('OMLD Multiplication Factor')
set(t4,'XTick',[0.5 1 1.43],'XTickLabel',{'0.5','1','1.5'});
box on;

title([t3 t4],'Hurricane Wilma')

% print('fitting_rita_wilma','-djpeg','-r400',fig1);

