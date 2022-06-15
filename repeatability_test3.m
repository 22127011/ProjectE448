load('dt22.mat');
lat = Position.latitude;
long = Position.longitude;
origin = [mean(lat(1:10)), mean(long(1:10)), 0];
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
plot(xEast,yNorth);

title('Route 1',FontSize=16);
ylabel('yNorth (m)',FontSize=12);
xlabel('xEast (m)',FontSize=12);

lati = mean(lat(1:10));
longi = mean(long(1:10));

latf = mean(lat(86:96));
longf = mean(long(86:96));

latdiff = latf - lati
longdiff = longf - longi

origin = [(latf+lati)/2, (longf+longi)/2, 0];
[xEast,yNorth] = latlon2local([latf,lati],[longf,longi],zeros(1,1),origin);
figure
scatter(xEast,yNorth);
title('Average',FontSize=16);
ylabel('yNorth (m)',FontSize=12);
xlabel('xEast (m)',FontSize=12);

