function plotResults(results,x,speed,hrspeed,avgspeed,alt,new_alt,dist,df)       
    size = length(results(:,1));
    s = cell2mat(speed);
    vrraspeed = [];
    i = 1;
    while(i<x+1)
        vrraspeed = cat(1, vrraspeed, dist(x+1)/x);
        i = i + 1;
    end

    figure
    for i = 1:x
        if (i>=length(df))
            df = cat(1,df,df(length(df)));
        end
        if (i>=length(dist))
            dist = cat(1,dist,dist(length(dist)));
        end

        if ((df(i)-dist(i))>=-(s(i)) && (df(i)-dist(i))<=(s(i)))
            c = 'yellow'; 
        elseif ((df(i)-dist(i))>(s(i))) 
            c = 'green';
        else 
            c = 'red';
        end
        scatter( results(i,2), results(i,1) , c ,"filled" )
        hold on;
    end
    title('Route and VRP indicators along route', FontSize=16);
    xlabel('Longitude (°)',FontSize=12);
    ylabel('Latitude (°)',FontSize=12);
    text(results(1,2),results(1,1),'START',FontSize=10);
    text(results(size,2),results(size,1),'END',FontSize=10);
    axis('equal');
    % legend('behind', 'ahead', 'on pace');
    hold off;

    figure
    plot(1:length(new_alt),new_alt) % Robot
    title('Altitude vs Time', FontSize=16);
    xlabel('Time (s)', FontSize=12);
    ylabel('Altitude (m)',FontSize=12);
    hold on
    plot(1:length(alt),alt); % Runner
    hold off
    legend('Virtual Runner','Human Runner',FontSize=10)

    figure
    plot(0:x,dist(1:x+1))
    title('Distance vs Time', FontSize=16);
    xlabel('Time (s)',FontSize=12);
    ylabel('Distance travelled (m)',FontSize=12); % Robot
    hold on
    plot(0:x,df(1:x+1)) % Runner
    hold off
    legend('Virtual Runner','Human Runner',FontSize=10);

    figure
    plot(1:x,s(1:x)) % Virtual Runner Speed
    title('Speed vs Time', FontSize=16);
    xlabel('Time (s)',FontSize=12);
    ylabel('Speed (m/s)',FontSize=12);
    hold on
    plot(1:x,vrraspeed(1:x)) % Virtual Runner Average Speed
    speedr = [];
    for i = 1:x
        speedr = cat(1,speedr,avgspeed); 
    end
    plot(1:length(hrspeed),hrspeed(1:length(hrspeed))) % Human Runner Rolling Average Speed
    plot(1:x,speedr) % Human Runner Average Speed
    hold off
    legend('Virtual Runner Speed','Virtual Runner Average Speed','Human Runner Rolling Average Speed','Human Runner Average Speed',FontSize=10);
end