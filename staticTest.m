fileID = fopen('static.txt','r');
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
title('Static test with latitude and longitude', 'FontSize', 16);
xlabel('Longitude (°)', 'FontSize', 12);
ylabel('Latitude (°)', 'FontSize', 12);

figure
scatter(xEast , yNorth , "filled");
title('Static test with distance', 'FontSize', 16);
ylabel('yNorth (m)', 'FontSize', 12);
xlabel('xEast (m)', 'FontSize', 12);

u = mean(latf);
x = ones(size);
x = u*x;
figure
plot(1:size,latf);
hold on
plot(1:size,x);
title('Latitude vs Time', 'FontSize', 16);
ylabel('Latitude (°)', 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
legend('Latitude Time Series','Average Latitude', 'FontSize', 10)

u = mean(longf);
x = ones(size);
x = u*x;
figure
plot(1:size,longf);
hold on
plot(1:size,x);
title('Longitude vs Time', 'FontSize', 16);
ylabel('Longitude (°)', 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 12);
legend('Longitude Time Series','Average Latitude', 'FontSize', 10)
