%% Speed control with functions

load('set16el.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
rtimeflat = 53; % completion time in x seconds. Modified by user
x = rtimeflat;

nww = segmentTimes(x,alt,fpc);
% nww = [0,10,20,10];

% [df,avgspeed] = distanceIncr2(x,lat,long,size); % flat
[df, avgspeed] = distanceIncr2(x,lat,long,size,fpc,nww); % not flat


% Distance for every second
% dist = distf(x,avgspeed);
dist = diste(df,nww,x,fpc,size);
ratio = df(size)/dist(length(dist));
dist = ratio*dist;
avgspeed = ratio*avgspeed;


% plot 
myPlot(df,x,lat,long,1,dist,size);