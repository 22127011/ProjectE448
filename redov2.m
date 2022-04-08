%% Speed control (with elevation change) with functions

% x = 64-68 doesnt work for set12

load('matlabflat.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
rtimeflat = 20; % completion time in x seconds. Modified by user
x = rtimeflat;

nww = segmentTimes(x,alt,fpc);
% nww = [0,10,20,10];

% [df,avgspeed] = distanceIncr2(x,lat,long,size); % flat
[df, avgspeed, distance_on_segment] = distanceIncr2(x,lat,long,size,fpc,nww); % not flat

% Distance for every second
% dist = distf(x,avgspeed);
% dist = diste(df,nww,x,fpc,size); gives right time but no speed change
dist = diste2(df,nww,x,fpc,size,avgspeed);
dist_store = dist;
ratio = df(size)/dist(length(dist));
dist = ratio*dist; % representation of data in real world
% avgspeed = ratio*avgspeed;

err_allowed = ceil(length(avgspeed)*0.02); % 2% error margin. For bad data.
for i = 1:length(avgspeed)
    if avgspeed(i)>7.2 % 1 mile record pace
        if err_allowed==0 
            warning('Impossible running time attempt. But GO for it CHAMP!!!')
            break;
        end
        err_allowed = err_allowed - 1;
    end
end

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
results = [];
speed = {};

% choose array with longer time (to avoid index array bounds)
% robot or human will continue running if the other has already reached the end of the route
size2 = length(dist);
if size>size2
    sizemax = size;
else
    sizemax = size2;
end

while(i<=sizemax) 
    if i<=size
        plotPosition(player,lat(i),long(i),"TrackID",2,"Marker","+","Label","Thato");
    end

    if i<=x-1
        if dist(i) <= df(k)
            i = i + 1;
            results = cat(1,results, [lat(k) long(k)]); % coordinates at this time instance 
            plotPosition(player,lat(k),long(k),"TrackID",1,"Marker","*","Label","Robot");
            if i>1
                speed{i} = dist_store(i) - dist_store(i-1);
            end
            distanceRan = df(k)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            if k>i 
                'You are behind'
            end
            % waitfor(sampleTime); % wait for 1 second
        else
            k = k + 1; % final time is almost x; this line takes 0.3 ms to execute
        end
        % TimeElasped = sampleTime.TotalElapsedTime % prints twice to show the 0.3 ms gap
                                                    % remove the one in if 
    else 
        i = i + 1;
        plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","Robot");
        % waitfor(sampleTime); % turn this on
    end

    if i==x
        plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","Robot");
        results = cat(1,results, [lat(size) long(size)]);
        'Run must have been completed already'
        completionTime = round(sampleTime.TotalElapsedTime);
        completionTime = completionTime + st % 1 second lost from (if i<=x-1)
    end
end
% hides route -> reset(player); 
% hide(player); % closes visualizer

plotResults(results,x,speed,size,alt);