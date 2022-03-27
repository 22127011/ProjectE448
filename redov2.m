%% Speed control with functions

load('set12el.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
rtimeflat = 20; % completion time in x seconds. Modified by user
fpc = 15; % frequency of pace change in seconds. Modified by user
x = rtimeflat;

[df,avgspeed] = distanceIncr(x,lat,long,size);
% nww = segmentTimes(x,alt,fpc);

% Distance for every second
dist = zeros(1);
for i = 2:1:x+1
    dist = cat(1, dist, dist(i-1)+avgspeed);
end

% plot 
myPlot(df,x,lat,long,1,dist,size);
