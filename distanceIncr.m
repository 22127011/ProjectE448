% for flat route
function [df, NewLatLongAlt, NewSize] = distanceIncr(lat,long,alt,course,size)
    R = 6371000;
    df = zeros(1);
    dInc = [];
    NewLatLongAlt = [lat(1) long(1) alt(1)];
    lat1 = lat(1)*pi/180;
    long1 = long(1)*pi/180;
    d_move = 2;

    for i=2:1:size
        latim1temp = lat(i-1);
        longim1temp = long(i-1);

        a11 = (lat(i)-latim1temp)*pi/180;
        a41 = (long(i)-longim1temp)*pi/180;
    
        a1 = sin(a11/2)^2;
        a2 = cos(latim1temp*pi/180);
        a3 = cos(lat(i)*pi/180);
        a4 = sin(a41/2)^2;
    
        a = a1 + a2 * a3 * a4;
        c = 2 * atan2(sqrt(a),sqrt(1-a));
        d = R * c ; % in meters
        
        df = cat(1, df, df(i-1) + d); % in meters
        dInc = cat(1, dInc, d);
        
        br = (course(i))*pi/180;
        dcheck = 0;
        while(dInc(i-1)>dcheck)
            lat2 = lat1 + asin(sin(a1)*cos(d_move/R) + cos(a1)*sin(d_move/R)*cos(br));
            long2 = long1 + atan2(sin(br)*sin(d_move/R)*cos(lat1),cos(d_move/R)-sin(lat1)*sin(lat2));
            NewLatLongAlt = cat(1, NewLatLongAlt, [lat2*180/pi long2*180/pi (alt(i)-alt(i-1))/dInc(i-1)*dcheck+alt(i-1)]);
            long1 = long2;
            lat1 = lat2;
            dcheck = dcheck + d_move;
        end
    end
    NewSize = length(NewLatLongAlt(:,1));
end