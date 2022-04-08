%% Speed control (with elevation change) with functions

% x = 64-68 doesnt work for set12

load('matlabflat.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
rtimeflat = 30; % completion time in x seconds. Modified by user
x = rtimeflat;

[df, avgspeed, dist] = distanceIncr3(x,lat,long,size); % not flat
nww = segmentTimes(x, alt, fpc);
