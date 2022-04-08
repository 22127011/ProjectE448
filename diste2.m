% does not work well 
function dist = diste2(df,nww,x,fpc,size,avg)
    dist = zeros(1);
    step = 1;
    avgspeed = avg(1);
    for i = 2:1:x
      if mod(i,round((x*fpc)/size))==0
          step = step + 1;
          try
               avgspeed = avg(step);
          catch 
               warning('Impossible running time attempt. But GO for it CHAMP!!!');
               avgspeed = avgspeed(1);
          end
          % 'here'
      end
      dist = cat(1, dist, dist(i-1)+avgspeed);
    end
    % ratio = df(size)/dist(length(dist));
    % dist = ratio*dist;
end
