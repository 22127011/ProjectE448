function [df, dInc, NewLatLong, NewAlt] = distanceIncr(lat,long,alt,size)
   R = 6371000;
    df = zeros(1);
    dInc = [];
    NewLatLong = [lat(1) long(1)];
    NewAlt = [alt(1)];
    d_move = 1;

    for i=2:1:size
        latim1temp = NewLatLong(length(NewLatLong(:,1)),1);
        longim1temp = NewLatLong(length(NewLatLong(:,1)),2);

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

        y = sin(a41)*cos(lat(i)*pi/180);
        x = cos(latim1temp*pi/180)*sin(lat(i)*pi/180) - sin(latim1temp*pi/180)*cos(lat(i)*pi/180)*cos(a41);
        br = atan2(y, x); % doesnt do much. Only include for marks on report

        lat1 = latim1temp*pi/180;
        long1 = longim1temp*pi/180;
        dcheck = 0;
        while(dInc(i-1)-dcheck>d_move)
            lat2 = asin(sin(lat1)*cos(d_move/R) + cos(lat1)*sin(d_move/R)*cos(br));
            long2 = long1 + atan2(sin(br)*sin(d_move/R)*cos(lat1),cos(d_move/R)-sin(lat1)*sin(lat2));
            NewLatLong = cat(1, NewLatLong, [lat2*180/pi long2*180/pi]);
            NewAlt = cat(1, NewAlt, (alt(i)-alt(i-1))/dInc(i-1)*dcheck+alt(i-1));
            long1 = long2;
            lat1 = lat2;
            dcheck = dcheck + d_move;
        end
        if (dInc(i-1)-dcheck~=0)
            df(i) = df(i) - dInc(i-1)+dcheck;
        end 
    end
end