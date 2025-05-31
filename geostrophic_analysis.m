% geostrophic analysis

clear all

phi = 0:0.5:90;

sanders = sind(phi)./sind(60);
zhang = sind(phi)./sind(45);
wellm = sind(phi)./sind(60);


figure;
hold on;
plot(24.*sanders,phi)
plot(24.*zhang,phi)
plot(24.*wellm,phi)
legend('Sanders','Zhang','Well')
axis([0 50 0 90])
ylabel('Latitude')
xlabel('hPa DR Equivalence for 1 Bergeron')
box on;