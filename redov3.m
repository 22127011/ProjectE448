%% Speed control (with elevation change) with functions

load('set16el.mat'); % loads matlab sensor data
oldlat = Position.latitude;
oldlong = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(oldlat);
fpc = 60; % frequency of pace change.
x = 180; % completion time in x seconds. Modified by user
play = true;

[df1, nll, NewSize] = distanceIncr(oldlat,oldlong,alt,size);
oldlat = nll(:,1);
oldlong = nll(:,2);
alt = nll(:,3);
oldsize = size;
size = NewSize;
% causes timing issues. runner avgspeed calc wrong 

[df, distance_per_segment] = distanceIncr3(oldlat,oldlong,size,fpc); 
% df = df*df1(oldsize)/df(size);
% distance_per_segment = distance_per_segment*df1(oldsize)/df(size);

avgspeed = df(size)/x;
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
player = geoplayer(oldlat(1),oldlong(1),18);
player.Parent.Name = 'Runner vs robot';
player.Basemap = 'streets'; 
plotRoute(player,oldlat,oldlong,"Color","cyan");
sampleTime = rateControl(st); % 1 second sampling rate to represent real world
i = 1;
k = 1;
results = [];
dfr = zeros(1);
speed = {};
new_alt = [];
time = 0;

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
while(i<=sizemax && play==true)
    if i<size
        plotPosition(player,oldlat(i),oldlong(i),"TrackID",1,"Marker","+","Label","Dummy");
    end

    if i<=x
        if dist(i) <= df(k)
            new_alt = cat(1, new_alt, alt(k));
            results = cat(1,results, [oldlat(k) oldlong(k)]); % coordinates at this time instance 
            plotPosition(player,oldlat(k),oldlong(k),"TrackID",i,"Marker","*");
            
            if dist(i) >= distance_to_travel 
                distance_to_travel = distance_to_travel + distance_per_segment(step);
                step = step + 1; % possibly must come before previous line
            end
            
            speed{i} = speed_per_segment(step);
            current_speed = speed_per_segment(step)
            distanceRan = dist(i)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            time = time + 1

            if k>i 
                status = 'You are behind'
            else 
                status = 'You are on pace or ahead'
            end

            i = i + 1;
            % waitfor(sampleTime); % wait for 1 second
        else
            k = k + 1; % final time is almost x; this line takes 0.3 ms to execute
        end
        % TimeElasped = sampleTime.TotalElapsedTime % prints twice to show the 0.3 ms gap
                                                    % remove the one in if 
    else 
        i = i + 1;
        plotPosition(player,oldlat(size),oldlong(size),"TrackID",i,"Marker","*","Label","RobotDone");
        % waitfor(sampleTime); % turn this on
    end

    if i==x+1
        new_alt = cat(1, new_alt, alt(size));
        results = cat(1,results, [oldlat(size) oldlong(size)]);
        plotPosition(player,oldlat(size),oldlong(size),"TrackID",i,"Marker","*","Label","RobotDone");
        speed{i} = speed_per_segment(step);
        current_speed = speed_per_segment(step)
        distanceRan = df(size)
        TimeElasped = sampleTime.TotalElapsedTime
        status = 'Run must have been completed already'
    end
end
completionTime = round(TimeElasped) + 1
% hides route -> reset(player); 
% hide(player); % closes visualizer

if play==true
    plotResults(results,x,speed,avgspeed,alt,new_alt,dist,df);
else 
    plotResultsf(x,size,alt,dist);
end
