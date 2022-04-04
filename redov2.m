%% Speed control (with elevation change) with functions and 

load('set12el.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
rtimeflat = 25; % completion time in x seconds. Modified by user
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
% myPlot(df,x,lat,long,1,dist,size);
st = 1; 
player = geoplayer(lat(1),long(1),18);
player.Parent.Name = 'Runner vs robot';
player.Basemap = 'streets'; % 'darkwater', 'grayland', 'bluegreen', 'grayterrain', 'colorterrain', 'landcover', 'streets', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'none'
plotRoute(player,lat,long);
sampleTime = rateControl(st); % 1 second sampling rate to represent real world
i = 1;
k = 1;
while(i<=size) 
    plotPosition(player,lat(i),long(i),"TrackID",2,"Marker","+","Label","Thato");
    if i<=x-1
        if dist(i) <= df(k)
            i = i + 1;
            plotPosition(player,lat(k),long(k),"TrackID",1,"Marker","*","Label","AI");
            if i>1
                speed = dist(i) - dist(i-1)
            end
            distance = df(k)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            waitfor(sampleTime); % wait for 1 second
            % maybe also spit out coordinates at this time instance 
        else
            k = k + 1; % final tme is almost x; this line takes 0.3 ms to execute
        end
        % TimeElasped = sampleTime.TotalElapsedTime % prints twice to show the 0.3 ms gap
                                                    % remove the one in if 
    else 
        i = i + 1;
        plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","AI");
        waitfor(sampleTime);
    end

    if i==x
        % plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","AI");
        completionTime = round(sampleTime.TotalElapsedTime);
    end

    if k>i 
        'You are behind'
    end
end
completionTime = completionTime
    
% hides route -> reset(player); 
% hide(player); % closes visualizer