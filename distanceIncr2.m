% for route with elevation
function [df, avgspeed, distancec] = distanceIncr2(x,lat,long,size,fpc,nww)
    R = 6371000;
    step = 1;
    counter = 1;
    % divisor = size/fpc
    df = zeros(1);
    avgspeed = [];
    distancec = [];
    for i=2:1:size
        a11 = (lat(i)-lat(i-1))*pi/180;
        a41 = (long(i)-long(i-1))*pi/180;
    
        a1 = sin(a11/2)^2;
        a2 = cos(lat(1)*pi/180);
        a3 = cos(lat(size)*pi/180);
        a4 = sin(a41/2)^2;
    
        a = a1 + a2 * a3 * a4;
        c = 2 * atan2(sqrt(a),sqrt(1-a));
        d = R * c ; % in meters
    
        df = cat(1, df, df(i-1) + d) ; % in meters

        if mod(i,fpc)==0
           avgspeed = cat(1,avgspeed,(df(i-1)-df(step))/nww(counter));
           % avgspeed = cat(1,avgspeed,(59)/nww(counter)); % assuming equal segment distances
                                                           % shows algorithm works (perfect data input)
           distancec = cat(1,distancec,df(i-1)-df(step));
           step = i-1; % the end point (index) of recorded elevation
           counter = counter + 1;
        end
    end  
    avgspeed = cat(1,avgspeed,avgspeed(length(avgspeed))); % solves edge case. df dist mismatch
end