%% Speed control (with elevation change) with functions

% x = 64-68 doesnt work for set12

load('set16el.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);
fpc = 15; % frequency of pace change in seconds.
x = 65; % completion time in x seconds. Modified by user

[df, avgspeed, distance_per_segment] = distanceIncr3(x,lat,long,size,fpc); % not flat
speed_per_segment = segmentTimes(avgspeed, alt, fpc, distance_per_segment,df(size));

dist = diste2(x,speed_per_segment,distance_per_segment,df,size);

try 
    is_possible_time = is_possible(speed_per_segment); 
catch
    warning('is_possible not working')
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
new_alt = [];

% choose array with longer time (to avoid index array bounds)
% robot or human will continue running if the other has already reached the end of the route
size2 = length(dist);
if size>size2
    sizemax = size;
else
    sizemax = size2;
end

step = 1;
distance_to_travel = distance_per_segment(step);
while(i<=sizemax) 
    if i<=size
        plotPosition(player,lat(i),long(i),"TrackID",2,"Marker","+","Label","Thato");
    end

    if i<=x-1
        if dist(i) <= df(k)
            new_alt = cat(1, new_alt, alt(i*floor(size/x)));
            i = i + 1;
            results = cat(1,results, [lat(k) long(k)]); % coordinates at this time instance 
            plotPosition(player,lat(k),long(k),"TrackID",1,"Marker","*","Label","Robot");

            if dist(i-1) >= distance_to_travel 
                distance_to_travel = distance_to_travel + distance_per_segment(step);
                step = step + 1; % possibly must come before previous line
            end
            
            speed{i} = speed_per_segment(step);
            
            current_speed = speed_per_segment(step)
            distanceRan = dist(i)
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
        new_alt = cat(1, new_alt, alt(size));
        results = cat(1,results, [lat(size) long(size)]);
        plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","Robot");
        speed{i} = speed_per_segment(step);
        current_speed = speed_per_segment(step)
        distanceRan = df(size)
        TimeElasped = sampleTime.TotalElapsedTime
        'Run must have been completed already'
        completionTime = round(sampleTime.TotalElapsedTime);
        completionTime = completionTime + st % 1 second lost from (if i<=x-1)
    end
end
% hides route -> reset(player); 
% hide(player); % closes visualizer

plotResults(results,x,speed,size,alt,new_alt,dist);
