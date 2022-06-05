fileID = fopen('route.txt','r');
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
size = length(latf);

origin = [mean(latf), mean(longf), 0];
[xEast,yNorth] = latlon2local(latf,longf,zeros(size,1),origin);

scatter(longf, latf , "filled");
title('Static test with latitude and longitude');
xlabel('Longitude');
ylabel('Latitude');

figure
scatter(xEast , yNorth , "filled");
title('Static test with distance');
ylabel('yNorth');
xlabel('xEast');

u = mean(latf);
x = ones(size);
x = u*x;
figure
plot(1:size,latf);
hold on
plot(1:size,x);
title('Latitude over Time');
ylabel('Latitude');
xlabel('Time');
legend('Latitude Time Series','Average Latitude')

u = mean(longf);
x = ones(size);
x = u*x;
figure
plot(1:size,longf);
hold on
plot(1:size,x);
title('Longitude over Time');
ylabel('Longitude');
xlabel('Time');
legend('Longitude Time Series','Average Latitude')
