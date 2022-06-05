 function dist = diste2(x,speed_per_segment,distance_per_segment,df, size)
    dist = zeros(1);
    step = 1;
    distance_to_travel = distance_per_segment(step);
    for i=2:1:x+1
        if dist(i-1) >= distance_to_travel
            step = step + 1;
            distance_per_segment(step);
            distance_to_travel = distance_to_travel + distance_per_segment(step);
        end
        dist = cat(1,dist,dist(i-1)+speed_per_segment(step));
    end
%     ratio = df(size)/dist(length(dist));
%     dist = ratio*dist;
end
