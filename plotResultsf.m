function plotResultsf(x,size,alt,dist)
    figure
    plot(0:size-1,alt);
    title('Altitude data');
    xlabel('Coordinate #');
    ylabel('Altitude');

    figure
    plot(0:x,dist)
    title('Distance vs Time');
    xlabel('Time');
    ylabel('Distance travelled');
end