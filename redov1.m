%% Speed control on flat

load('matlab.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 

R = 6371000;
df = zeros(1);
size = length(lat);
for i=2:1:size
    a11 = (lat(i)-lat(i-1))*pi/180;
    a41 = (long(i)-long(i-1))*pi/180;

    a1 = sin(a11/2)^2;
    a2 = cos(lat(1)*pi/180);
    a3 = cos(lat(size)*pi/180);
    a4 = sin(a41/2)^2;

    a = a1 + a2 * a3 * a4;
    c = 2 * atan2(sqrt(a),sqrt(1-a));
    d = R * c ; % in meters

    df = cat(1, df, df(i-1) + d) ; % in meters
end 

Position.distance = df;

speedinmps = df(size)/size % speed in meters per second. df(size) = total distance.
speedinminpkm = 1/(speedinmps*0.06); % speed in minutes per km

% Speed Control
x = 40; % completion time in x seconds
speedinmpsx = df(size)/x % speed in m/s
speedinminpkmx = 1/(speedinmpsx*0.06); % speed in minutes per km

% Distance for every second
dist = zeros(1);
for i = 2:1:x+1
    dist = cat(1, dist, dist(i-1)+speedinmpsx);
end

% plot 
player = geoplayer(lat(1),long(1),18);
player.Parent.Name = 'AI Runs given time';
player.Basemap = 'streets'; % 'darkwater', 'grayland', 'bluegreen', 'grayterrain', 'colorterrain', 'landcover', 'streets', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'none'
plotRoute(player,lat,long);
sampleTime = rateControl(1); % 1 second sampling rate to represent real world
i = 1;
k = 1;
while(i<=x) 
    if dist(i) <= df(k)
        i = i + 1;
        plotPosition(player,lat(k),long(k),"TrackID",1,"Marker","*","Label","AI");
        TimeElasped = int8(sampleTime.TotalElapsedTime) 
        waitfor(sampleTime); % wait for 1 second
        % maybe also spit out coordinates at this time instance 
    else
        k = k + 1; % final tme is almost x; this line takes 0.3 ms to execute
    end
    % TimeElasped = sampleTime.TotalElapsedTime % prints twice to show the 0.3 ms gap
                                                % remove the one in if  
end
plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","AI");
% hides route -> reset(player); 
% hide(player); % closes visualizer