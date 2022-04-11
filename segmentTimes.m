function newspeed = segmentTimes(avgspeed, alt, fpc, dps, tdt) 
    size = length(alt);
    elevation = [];
    step = 1;
    for i = 1:1:size+1
      if mod(i,fpc)==0
        elevation = cat(1,elevation,alt(i,1)-alt(step,1));
        step = i; % the end point (index) of recorded elevation
      end
    end
    
    newspeed = [];
    televation = sum(elevation,'all'); % total elevation
    if televation==0
        for i=1:length(elevation)
            newspeed(i) = avgspeed;
        end
    else
        elevation = elevation/televation; % gets the % elevation contribution of each segment
        elevation = avgspeed*(1-elevation); % assigns speed each segment
        newspeed = tdt/new_completion_time(dps, elevation); % new average speed
        ratio = avgspeed/newspeed; % ratio (expansion or compression of average speed)
        newspeed = ratio*elevation; % adjusted average speed for each segment
        newspeed = cat(1,newspeed,newspeed(length(newspeed))); % solves edge case. df dist mismatch
    end

    % newspeed = cat(1,newspeed,newspeed(length(newspeed))); % solves edge case. df dist mismatch
end      
