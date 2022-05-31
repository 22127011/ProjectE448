load('dt3.mat');
lat = Position.latitude;
long = Position.longitude; 
origin = [lat(1), long(1), 0];
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);

figure
hold on;
scatter(xEast(5),yNorth(5));
scatter(xEast(50),yNorth(50));

load('dt5.mat');
lat = Position.latitude;
long = Position.longitude;
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
scatter(xEast(5),yNorth(5));
scatter(xEast(50),yNorth(50));

load('dt1.mat');
lat = Position.latitude;
long = Position.longitude;
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
scatter(xEast(5),yNorth(5));
scatter(xEast(51),yNorth(51));

load('dt2.mat');
lat = Position.latitude;
long = Position.longitude;
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
scatter(xEast(5),yNorth(5));
scatter(xEast(50),yNorth(50));

load('dt4.mat');
lat = Position.latitude;
long = Position.longitude;
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
scatter(xEast(5),yNorth(5));
scatter(xEast(45),yNorth(45));

title('Distance deviation');
ylabel('yNorth (m)');
xlabel('xEast (m)');
legend('start1', 'end1', 'start2', 'end2');

