% for route with elevation
function [rdf] = distanceIncr4(lat,long,size,lastdist)
    R = 6371000;
    rdf = zeros(1);
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
    
        rdf = cat(1, rdf, rdf(i-1) + d) ; % in meters

        if (rdf(i)>lastdist)
            rdf(i) = lastdist;
        end
    end
end