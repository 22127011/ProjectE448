strava = load('set16el.mat'); % loads matlab sensor data
strava2 = load('set12el.mat');
strava3 = cat(2,strava,strava2);

p1 = strava.Position;
p2 = strava2.Position;
Position = cat(1,p1,p2);

lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(lat);

[df, dInc, nll, new_alt] = distanceIncr(lat,long,alt,course,size);
[newdf, newdInc] = checknll(nll(:,1),nll(:,2),length(nll(:,1)));

plot(1:length(alt),alt);
xlabel('Number of recorded points');
ylabel('Altitude');
title('Altitude changes');
figure
plot(1:length(new_alt),new_alt);
xlabel('Number of exprapolated points');
ylabel('Altitude');
title('Altitude changes');

player = geoplayer(lat(1),long(1),21);
player.Parent.Name = 'RecorderHD';
player.Basemap = 'streets'; 
plotRoute(player,nll(:,1),nll(:,2),"Color","red");
plotRoute(player,lat,long,"Color","blue","LineWidth",1);
for i = 1:length(nll(:,1))
    plotPosition(player,nll(i,1),nll(i,2),"TrackID",1,"Marker","*","Label","HD"); 
end