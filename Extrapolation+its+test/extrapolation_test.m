load('set16el.mat'); % loads matlab sensor data
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(lat);
st = rateControl(1); % 1/d_move to get 1 second per 1m

[df dInc nll] = distanceIncr(lat,long,course,size);
[newdf newdInc] = checknll(nll(:,1),nll(:,2),length(nll(:,1)));

player = geoplayer(lat(1),long(1),21);
player.Parent.Name = 'RecorderHD';
player.Basemap = 'streets'; % 'darkwater', 'grayland', 'bluegreen', 'grayterrain', 'colorterrain', 'landcover', 'streets', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'none'
plotRoute(player,nll(:,1),nll(:,2));
plotRoute(player,lat,long,"Color","blue");
plotRoute(player,lat(1:110),long(1:110),"Color","yellow");
for i = 1:length(nll(:,1))
    plotPosition(player,nll(i,1),nll(i,2),"TrackID",1,"Marker","*","Label","HD");
    distance = newdf(i)
    time = st.TotalElapsedTime
    %waitfor(st); 
end

%edit newdInc to suit you