%% Speed control (with elevation change) with functions

%% Route map
load('marais.mat'); % loads matlab sensor data
oldlat = Position.latitude;
oldlong = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(oldlat);
fpc = 100; % frequency of pace change.
x = 33; % completion time in x seconds. Modified by user
play = true;

%% Runner location
fileID = fopen('route33fcp100.txt','r');
A = fscanf(fileID,['%f' ',' '%f']);
fclose(fileID);

latf = [];
longf = [];
for i = 1:length(A)
    if (mod(i,2)==0)
        longf = cat(1, longf, A(i));
    else
        latf = cat(1, latf, A(i));
    end
end
 
%% Clean data
[df1, nll, NewSize] = distanceIncr(oldlat,oldlong,alt,size);
oldlat = nll(:,1);
oldlong = nll(:,2);
alt = nll(:,3);
oldsize = size;
size = NewSize;

%% Pace planner
[df, distance_per_segment] = distanceIncr3(oldlat,oldlong,size,fpc);
avgspeed = df(size)/x;
speed_per_segment = segmentTimes(avgspeed, alt, fpc, distance_per_segment,df(size));
dist = diste2(x,speed_per_segment,distance_per_segment,df,size);

%% Check if pace is doable
try 
    is_possible_time = is_possible(speed_per_segment); 
catch
    warning('is_possible not working')
end

%% Set up virtual runner
st = 1; 
player = geoplayer(oldlat(1),oldlong(1),18);
player.Parent.Name = 'Human vs Virtual Runner ';
player.Basemap = 'streets'; 
plotRoute(player,oldlat,oldlong,"Color","cyan");
sampleTime = rateControl(st); % 1 second sampling rate to represent real world
i = 1;
k = 1;
results = [];
speed = {};
new_alt = [];
time = 0;

% choose array with longer time (to avoid index array bounds)
% robot or human will continue running if the other has already reached the end of the route
size = length(latf);
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
       plotPosition(player,latf(i),longf(i),"TrackID",1,"Marker","+","Label","Dummy "+ int2str(i));
    end

    if i<x+1
        if dist(i) <= df(k)
            plotPosition(player,oldlat(k),oldlong(k),"TrackID",2,"Marker","*","Label","Robot");
            new_alt = cat(1, new_alt, alt(k));
            results = cat(1,results, [oldlat(k) oldlong(k)]);
            
            if dist(i) >= distance_to_travel 
                distance_to_travel = distance_to_travel + distance_per_segment(step);
                step = step + 1; 
            end
            
            speed{i} = speed_per_segment(step);
            current_speed = speed_per_segment(step)
            distanceRan = dist(i)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            time = time + 1

            i = i + 1;
            waitfor(sampleTime);
        else 
            k = k + 1;
        end
    else 
      i = i + 1;
      plotPosition(player,oldlat(NewSize),oldlong(NewSize),"TrackID",2,"Marker","*","Label","Robot");
      % waitfor(sampleTime);
    end
end

%% Runner distance calculation
[rdf] = distanceIncr4(latf,longf,size,dist(x+1));
avgspeed = rdf(x)/(x-1);
hrspeed = [];
altf = [alt(1)];
i = 1;
k = 1;
while(i<x+1)
    if rdf(i) <= df(k)
        altf = cat(1, altf, alt(k));
        hrspeed = cat(1, hrspeed, rdf(i+1)/i);
        i = i + 1;
    else
        k = k + 1; 
        if k > length(alt)
            break;
        end
    end
end 

%% Plots
plotResults(results,x,speed,hrspeed,avgspeed,altf,new_alt,dist,rdf);