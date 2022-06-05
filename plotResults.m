function plotResults(results,x,speed,avgspeed,alt,new_alt,dist,df)
    %{
    scatter( results(:,1) , results(:,2) , [] , linspace(results(1,2),results(length(results(:,2)),2),x) ,"filled" )
    label = {};
    for i = 1:x
        % label{i} = 'Time: ' + string(i) + 's, ' + 'Speed: ' + string(speed{i});
        label{i} = i-1;
    end
    text(results(:,1),results(:,2),label,'VerticalAlignment','baseline','HorizontalAlignment','left');
    title('Latitude and Longitude coordinates for each time instance');
    xlabel('Longitude');
    ylabel('Latitude');
    %}

    fileID = fopen('robot.txt','w');
    fprintf(fileID,'%3.7f,%3.7f\n',[transpose(results(:,1)) ; transpose(results(:,2))]);
    fclose(fileID);

    s = cell2mat(speed);
    
    figure
    %label = {};
    for i = 1:x-1
        % label{i} = i-1;
        if (i>=length(df))
            df = cat(1,df,df(length(df)));
        end
        if (i>=length(dist))
            dist = cat(1,dist,dist(length(dist)));
        end

        
        if ((df(i)-dist(i))>=-(s(i)) && (df(i)-dist(i))<=(s(i)))
            c = 'yellow'; 
        elseif ((df(i)-dist(i))>(s(i))) % 1 being the resolution
            c = 'green';
        else 
            c = 'red';
        end
        scatter( results(i,2), results(i,1) , c ,"filled" )
        hold on;
    end
    %text(results(:,1),results(:,2),label,'VerticalAlignment','bottom','HorizontalAlignment','left');
    title('Latitude and Longitude coordinates for each time instance');
    xlabel('Longitude');
    ylabel('Latitude');
    % legend('behind', 'ahead', 'on pace');
    hold off;

    figure
    plot(1:length(new_alt),new_alt) % Robot
    title('Altitude vs Time');
    xlabel('Time');
    ylabel('Altitude');
    hold on
    plot(1:length(alt),alt); % Runner
    hold off
    legend('Robot','Dummy Runner')

    figure
    plot(0:x-1,dist(1:x))
    title('Distance vs Time');
    xlabel('Time');
    ylabel('Distance travelled'); % Robot
    hold on
    plot(0:x-1,df(1:x)) % Runner
    hold off
    legend('Robot','Dummy Runner')

    figure
    plot(1:x-1,s(1:x-1))
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