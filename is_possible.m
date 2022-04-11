function is_possible = is_possible(speed_per_segment)
    err_allowed = ceil(length(speed_per_segment)*0.02); % 2% error margin. For bad data.
    is_possible = true;
    for i = 1:length(speed_per_segment)
        if speed_per_segment(i)>7.2 % 1 mile record pace
            if err_allowed==0 
                warning('Impossible running time attempt. But GO for it CHAMP!!!')
                is_possible = false;
                break;
            end
            err_allowed = err_allowed - 1;
        end
    end
end