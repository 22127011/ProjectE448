load('testset.mat'); 
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
course = Position.course;
size = length(lat);
scatter(lat ,long , [] , linspace(lat(1),lat(size),size) ,"filled");
title('Single point test');
xlabel('Longitude');
ylabel('Latitude');

u = sum(alt,"all")/size;
ud = 0;
sd = ones(size,1);
for i = 1:size
    ud = ud + (alt(i)-u)^(2);
end
sd = sd*(sqrt(ud)/sqrt(size));

figure
errorbar(0:size-1,alt,sd)
title('Altitude test');
xlabel('Number of collected points');
ylabel('Altitude');