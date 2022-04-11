function new_completion_time = new_completion_time(dps, new_avgspeed_on_segment)
    new_completion_time = [];
    naos = new_avgspeed_on_segment;
    for i = 1:length(dps)
        new_completion_time = cat(1,new_completion_time,dps(i)/naos(i)); 
    end
    new_completion_time = sum(new_completion_time,'all');
end