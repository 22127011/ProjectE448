%% Speed control (with elevation change) with functions

load('marais.mat'); % loads matlab sensor data
oldlat = Position.latitude;
oldlong = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(oldlat);
fpc = 15; % frequency of pace change.
x = 33; % completion time in x seconds. Modified by user
play = true;

fileID = fopen('route32.txt','r');
A = fscanf(fileID,['%f' ',' '%f']);
fclose(fileID);

latf = [];
longf = [];
altf = [];
for i = 1:length(A)
    if (mod(i,2)==0)
        longf = cat(1, longf, A(i));
    else
        latf = cat(1, latf, A(i));
    end
end

[df1, nll, NewSize] = distanceIncr(oldlat,oldlong,alt,size);
oldlat = nll(:,1);
oldlong = nll(:,2);
alt = nll(:,3);
oldsize = size;
size = NewSize;
% causes timing issues. runner avgspeed calc wrong 

[df, distance_per_segment] = distanceIncr3(oldlat,oldlong,size,fpc);
% df = df*df1(oldsize)/df(length(latf));
% distance_per_segment = distance_per_segment*df1(oldsize)/df(length(latf));

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
       plotPosition(player,latf(i),longf(i),"TrackID",1,"Marker","+","Label","Dummy");
    end

    if i<x
        if dist(i) <= df(k)
            plotPosition(player,oldlat(k),oldlong(k),"TrackID",2,"Marker","*","Label","Robot");
            new_alt = cat(1, new_alt, alt(k));
            results = cat(1,results, [oldlat(k) oldlong(k)]);
            
            if dist(i) >= distance_to_travel 
                distance_to_travel = distance_to_travel + distance_per_segment(step);
                step = step + 1; % possibly must come before previous line
            end
            
            speed{i} = speed_per_segment(step);
            current_speed = speed_per_segment(step)
            distanceRan = dist(i)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            time = time + 1

            i = i + 1;
        else 
            k = k + 1;
        end
    else 
      i = i + 1;
      plotPosition(player,oldlat(NewSize),oldlong(NewSize),"TrackID",2,"Marker","*","Label","Robot");
    end
end
% hides route -> reset(player); 
% hide(player); % closes visualizer
[rdf] = distanceIncr3(latf,longf,size,fpc);
avgspeed = rdf(x)/(x-1);

i = 1;
k = 1;
while(i<x)
    if rdf(i) <= df(k)
        altf = cat(1, altf, alt(k));
        i = i + 1;
    else 
        k = k + 1;
    end 
end

if play==true
    plotResults(results,x,speed,avgspeed,altf,new_alt,dist,rdf);
else 
    plotResultsf(x,size,alt,dist);
end
