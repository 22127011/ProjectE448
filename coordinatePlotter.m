fileID = fopen('coordinates.txt','r');
A = fscanf(fileID,['%f' ',' '%f']);
fclose(fileID);

latf = [];
longf = [];
for i = 1:length(A)
    if (mod(i,2)==0)
        longf = cat(1, longf, A(i));
    else
        latf = cat(1, latf, A(i));
    end
end
size = length(latf);

player = geoplayer(latf(1),longf(1),18);
player.Parent.Name = 'Coordinates';
player.Basemap = 'streets'; 
plotRoute(player,latf,longf,"Color","cyan");