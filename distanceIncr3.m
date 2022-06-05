% for route with elevation
function [df, distance_per_segment] = distanceIncr3(lat,long,size,fpc)
    R = 6371000;
    step = 1;
    distance_per_segment = [];
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

        if mod(i,fpc)==0
           distance_per_segment = cat(1,distance_per_segment,df(i)-df(step));
           step = i; % the end point (index) of recorded elevation
        end
    end
    if mod(i,fpc)~=0
       distance_per_segment = cat(1,distance_per_segment,df(size)-df(step));
    end
end