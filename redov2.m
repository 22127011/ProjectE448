%% Speed control with functions

load('matlab.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
rtimeflat = 10; % completion time in x seconds. Modified by user
x = rtimeflat;

[df,avgspeed] = distanceIncr(x,lat,long,size);
% nww = segmentTimes(x,alt,fpc);
% nww = [0,10,20,10];

% Distance for every second
% dist = diste(df,nww,x,fpc,size);
dist = distf(x,avgspeed);

% plot 
myPlot(df,x,lat,long,1,dist,size);