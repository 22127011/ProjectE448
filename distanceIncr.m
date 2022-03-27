function [df, avgspeed] = distanceIncr(x,lat,long,size)
    R = 6371000;
    df = zeros(1);
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
    end 

    avgspeed = df(size)/x; % speed in meters per second. df(size) = total distance.
    speedinminpkm = 1/(avgspeed*0.06); % speed in minutes per km
end