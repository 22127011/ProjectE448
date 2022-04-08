% works on flat routes
function dist = distf(x,avgspeed)
    dist = zeros(1);
    for i = 2:1:x-1
        dist = cat(1, dist, dist(i-1)+avgspeed(1));
    end
end