% does not work well 
function dist = diste(df,nww,x,fpc,size)
    dist = zeros(1);
    step = 1;
    avgspeed = (df(size)*fpc/size)/nww(step);
    for i = 2:1:x
      if mod(i,(x*fpc)/size)==0
          step = step + 1;
          avgspeed = (df(size)*fpc/size)/nww(step);
      end
      dist = cat(1, dist, dist(i-1)+avgspeed);
    end
    % ratio = df(size)/dist(length(dist));
    % dist = ratio*dist;
end