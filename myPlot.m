function myPlot(df,x,lat,long,st,dist,size)
    player = geoplayer(lat(1),long(1),18);
    player.Parent.Name = 'AI Runs given time';
    player.Basemap = 'streets'; % 'darkwater', 'grayland', 'bluegreen', 'grayterrain', 'colorterrain', 'landcover', 'streets', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'none'
    plotRoute(player,lat,long);
    sampleTime = rateControl(st); % 1 second sampling rate to represent real world
    i = 1;
    k = 1;
    while(i<=x-1) 
        if dist(i) <= df(k)
            i = i + 1;
            plotPosition(player,lat(k),long(k),"TrackID",1,"Marker","*","Label","AI");
            if i>1
                speed = dist(i) - dist(i-1)
            end
            distance = dist(i)
            TimeElasped = sampleTime.TotalElapsedTime % the one in if 
            waitfor(sampleTime); % wait for 1 second
            % maybe also spit out coordinates at this time instance 
        else
            k = k + 1; % final tme is almost x; this line takes 0.3 ms to execute
        end
        % TimeElasped = sampleTime.TotalElapsedTime % prints twice to show the 0.3 ms gap
                                                    % remove the one in if 
    end
    plotPosition(player,lat(size),long(size),"TrackID",1,"Marker","*","Label","AI");
    speed = speed
    distance = df(size) 
    completionTime = int8(sampleTime.TotalElapsedTime)
    % hides route -> reset(player); 
    % hide(player); % closes visualizer
end