myLat = [];
myLong = [];

load('dt3.mat');
lat = Position.latitude;
long = Position.longitude; 

myLat = cat(1,myLat,lat(5));
myLat = cat(1,myLat,lat(50));
myLong = cat(1,myLong,long(5));
myLong = cat(1,myLong,long(50));

load('dt5.mat');
lat = Position.latitude;
long = Position.longitude;

myLat = cat(1,myLat,lat(5));
myLat = cat(1,myLat,lat(50));
myLong = cat(1,myLong,long(5));
myLong = cat(1,myLong,long(50));

scatter(myLong,myLat);
title('Latitude and Longitude at start and end');
ylabel('Latitude');
xlabel('Longitude');

load('dt1.mat');
lat = Position.latitude;
long = Position.longitude;
myLat = cat(1,myLat,lat(5));
myLat = cat(1,myLat,lat(51));
myLong = cat(1,myLong,long(5));
myLong = cat(1,myLong,long(51));

load('dt2.mat');
lat = Position.latitude;
long = Position.longitude;
myLat = cat(1,myLat,lat(5));
myLat = cat(1,myLat,lat(50));
myLong = cat(1,myLong,long(5));
myLong = cat(1,myLong,long(50));

load('dt4.mat');
lat = Position.latitude;
long = Position.longitude;
myLat = cat(1,myLat,lat(5));
myLat = cat(1,myLat,lat(45));
myLong = cat(1,myLong,long(5));
myLong = cat(1,myLong,long(45));

origin = [mean(myLat), mean(myLong), 0];
[xEast,yNorth] = latlon2local(myLat,myLong,zeros(length(myLat),1),origin);
figure
scatter(xEast,yNorth);

title('Distance deviation');
ylabel('yNorth (m)');
xlabel('xEast (m)');

