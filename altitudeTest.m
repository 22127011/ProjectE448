load('testset.mat'); 
lat = Position.latitude;
long = Position.longitude; 
alt = Position.altitude;
size = length(lat);

u = sum(alt,"all")/size;
ud = 0;
sd = ones(size,1);
for i = 1:size
    ud = ud + (alt(i)-u)^(2);
end
sd = sd*(sqrt(ud)/sqrt(size));

figure
errorbar(0:size-1,alt,sd)
title('Altitude vs Time', FontSize=16);
xlabel('Time (s)',FontSize=12);
ylabel('Altitude (m)',FontSize=12);