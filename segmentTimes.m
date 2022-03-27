function newtimeel = segmentTimes(x, alt, fpc) 
    sizeof = length(alt);
    elevation = [];
    divisor = sizeof/fpc; 
    counter = 1;
    step = 1;
    while(counter<=sizeof)
      if mod(counter,sizeof/divisor)==0
        elevation = cat(1,elevation,alt(counter,1)-alt(step,1));
        step = counter; % the end point (index) of recorded elevation
      end
      counter = counter + 1;
    end
    
    newtimeel = [];
    rtimeflatd = x/length(elevation);
    televation = sum(elevation,'all'); % total elevation
    if televation==0
        for i=1:length(elevation)
            newtimeel(i) = rtimeflatd;
        end
    else
        elevation = elevation/televation; % gets the % elevation contribution of each segment
        elevation = rtimeflatd*(1+elevation); % assigns time spent on each segment
        newtimeel = sum(elevation,'all'); % total new completion time
        ratio = x/newtimeel; % ratio (expansion or compression of rtimeflat)
        newtimeel = ratio*elevation; % adjusted time spent on each segment
    end

    newtimeel = cat(1,newtimeel,newtimeel(length(newtimeel))); % solves edge case. df dist mismatch
end      
