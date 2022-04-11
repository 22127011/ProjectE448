function plotResults(results,x,speed,size,alt,new_alt,dist)
    plot(results(:,1),results(:,2));
    label = {};
    for i = 1:x
        label{i} = 'Time: ' + string(i) + 's, ' + 'Speed: ' + string(speed{i});
    end
    text(results(:,1),results(:,2),label,'VerticalAlignment','bottom','HorizontalAlignment','left');
    title('Latitude and Longitude coordinates for each time instance and speed');
    xlabel('Longitude');
    ylabel('Latitude');
    
    figure
    plot(0:size-1,alt);
    title('Altitude data');
    xlabel('Coordinate #');
    ylabel('Altitude');

    figure
    plot(0:x-1,new_alt)
    title('Altitude vs Time');
    xlabel('Time');
    ylabel('Altitude');

    figure
    plot(0:x,dist)
    title('Distance vs Time');
    xlabel('Time');
    ylabel('Distance travelled');

    figure
    plot(1:x-1,cell2mat(speed))
    title('Speed vs Time');
    xlabel('Time');
    ylabel('Speed');
end