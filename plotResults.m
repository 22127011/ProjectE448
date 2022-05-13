function plotResults(results,x,speed,avgspeed,alt,new_alt,dist,df)
    scatter( results(:,1) , results(:,2) , [] , linspace(results(1,2),results(length(results(:,2)),2),x) ,"filled" )
    label = {};
    for i = 1:x
        % label{i} = 'Time: ' + string(i) + 's, ' + 'Speed: ' + string(speed{i});
        label{i} = i;
    end
    text(results(:,1),results(:,2),label,'VerticalAlignment','bottom','HorizontalAlignment','left');
    title('Latitude and Longitude coordinates for each time instance');
    xlabel('Longitude');
    ylabel('Latitude');
    

    fileID = fopen('Robot.txt','w');
    fprintf(fileID,'%3.7f,%3.7f\n',[results(:,1) results(:,2)]);
    fclose(fileID);
    
    figure
    plot(1:length(new_alt),new_alt) % Robot
    title('Altitude vs Time');
    xlabel('Time');
    ylabel('Altitude');
    hold on
    plot(1:length(new_alt),alt(1:length(new_alt))); % Runner
    hold off
    legend('Robot','Dummy Runner')

    figure
    plot(0:x,dist)
    title('Distance vs Time');
    xlabel('Time');
    ylabel('Distance travelled'); % Robot
    hold on
    plot(0:x,df(1:x+1)) % Runner
    hold off
    legend('Robot','Dummy Runner')

    figure
    plot(1:x-1,cell2mat(speed))
    title('Speed vs Time');
    xlabel('Time');
    ylabel('Speed');
    hold on
    speedr = [];
    for i = 1:x-1
        speedr = cat(1,speedr,avgspeed);
    end
    plot(1:x-1,speedr)
    hold off
    legend('Robot speed','Dummy Runner average speed')
end