function plotResults(results,x,speed,size,alt)
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
    plot(1:size,alt);
    title('Altitude data');
    xlabel('Coordinate #');
    ylabel('Altitude');
end