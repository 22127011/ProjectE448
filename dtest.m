load('dt3.mat');
lat = Position.latitude;
long = Position.longitude; 

player = geoplayer(lat(1),long(1),21);
player.Parent.Name = 'Runner vs robot';
player.Basemap = 'streets'; 
plotRoute(player,lat,long,"Color","cyan");

figure
plot(lat,long);
hold on;

% load('dt2.mat');
% lat = Position.latitude;
% long = Position.longitude;
% plotRoute(player,lat,long,"Color","blue");
% 
% load('dt3.mat');
% lat = Position.latitude;
% long = Position.longitude;
% plotRoute(player,lat,long,"Color","yellow");
% 
% load('dt4.mat');
% lat = Position.latitude;
% long = Position.longitude;
% plotRoute(player,lat,long,"Color","red");
% 
load('dt5.mat');
lat = Position.latitude;
long = Position.longitude;
plotRoute(player,lat,long,"Color","black");

plot(lat,long);

