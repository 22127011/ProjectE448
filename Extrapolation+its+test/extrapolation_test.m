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

origin = [lat(1), long(1), 0];
[xEast,yNorth] = latlon2local(lat,long,zeros(length(lat),1),origin);
plot(xEast,yNorth);
hold on;

[df, dInc, nll, new_alt] = distanceIncr(lat,long,alt,size);
[newdf, newdInc] = checknll(nll(:,1),nll(:,2),length(nll(:,1)));

[xEast,yNorth] = latlon2local(nll(:,1),nll(:,2),zeros(length(nll(:,1)),1),origin);
plot(xEast,yNorth);
xlabel('xEast (m)',FontSize=12);
ylabel('yNorth (m)',FontSize=12);
title('Recorded route and Cleaned route',FontSize=16);
legend('Recorded route','Cleaned route',FontSize=10);
axis('equal');
hold off;

figure
plot(1:length(alt),alt);
xlabel('Number of recorded points',FontSize=12);
ylabel('Altitude (m)',FontSize=12);
title('Altitude changes',FontSize=16);
figure
plot(1:length(new_alt),new_alt);
xlabel('Distance (m)',FontSize=12);
ylabel('Altitude (m)',FontSize=12);
title('Altitude changes',FontSize=16);

player = geoplayer(lat(1),long(1),21);
player.Parent.Name = 'RecorderHD';
player.Basemap = 'streets'; 
plotRoute(player,nll(:,1),nll(:,2),"Color","red");
plotRoute(player,lat,long,"Color","blue","LineWidth",1);
% for i = 1:length(nll(:,1))
%     plotPosition(player,nll(i,1),nll(i,2),"TrackID",1,"Marker","*","Label","HD"); 
% end