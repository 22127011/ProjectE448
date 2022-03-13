%% Data loading
set1 = load('set16el.mat'); % collected route data
set2 = load('set12el.mat');
newset = cat(1,set1.Position,set2.Position);
lat = newset.latitude;
long = newset.longitude;
alt = newset.altitude;
% lat = Position.latitude; % if one set is loaded -> load('set16el.mat')
% long = Position.longitude; % if one set is loaded -> load('set16el.mat')
% alt = Position.altitude; % if one set is loaded -> load('set16el.mat')

%% Distance calculation
R = 6371000; % radius of Earth in meters
df = 0; % route ditance
size = length(lat); % number of waypoints along route
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

    df = df + d ; % in meters
end 
df


%% Speed Control 
% (speed assignemt for now)
rtimeflat = 60; % completion time in seconds for zero elevation
rspeed = df/rtimeflat; % current speed in m/s
speedinminpkmx = 1/(rspeed*0.06); % speed in minutes per km


%% Transform lat-long route data to xEast-yNorth.
% Initial robot position and orientation (pose)
origin = [lat(1), long(1), 0];
[xEast,yNorth,zUp] = latlon2local(lat,long,zeros(length(lat),1),origin);
path = [xEast yNorth];

% path = [2.00    1.00;
%        1.25    1.75;
%        5.25    8.25;
%        7.25    8.75;
%        11.75   10.75;
%        12.00   10.00];

robotInitialLocation = path(1,:);
robotGoal = path(end,:);
initialOrientation = 0;
robotCurrentPose = [robotInitialLocation initialOrientation]';

%% Robot and controller 
% Both robot models work
robot = differentialDriveKinematics("TrackWidth", 40, "VehicleInputs", "VehicleSpeedHeadingRate"); % changed from 1
% robot = bicycleKinematics("VehicleInputs","VehicleSpeedHeadingRate");

% Controller
controller = controllerPurePursuit();
controller.Waypoints = path;
controller.MaxAngularVelocity = 1; % changed from 2
controller.LookaheadDistance = 1; % changed from 0.3
controller.DesiredLinearVelocity = rspeed; % speed control 

goalRadius = controller.DesiredLinearVelocity; % 1 worked but sometimes spirals at the end
distanceToGoal = norm(robotInitialLocation - robotGoal);

% Initialize the simulation loop (10Hz)
sampleTime = 0.1;
vizRate = rateControl(1/sampleTime);

% Initialize the figure
% figure

% Determine vehicle frame size to most closely represent vehicle with plotTransforms
%frameSize = robot.TrackWidth/0.8;
frameSize = robot.TrackWidth; % when using differentialDrive model
%frameSize = 40; % when using bicycle model

reset_coords = 1; % 0 when while(0). Have Newcoord at right speed 
                  % 1 when while(distanceToGoal > goalRadius). Don't have Newcoord at right speed
if reset_coords==1 
    newcood = zeros(1,2);
end

counter = 0;
while( distanceToGoal > goalRadius )
% while( 0 )
    
    % Compute the controller outputs, i.e., the inputs to the robot
    [v, omega] = controller(robotCurrentPose);
    
    % Get the robot's velocity using controller inputs
    vel = derivative(robot, robotCurrentPose, [v omega]); % v changed to 2. Now we have a constant speed. Speed control here

    % Update the current pose
    robotCurrentPose = robotCurrentPose + vel*sampleTime; 
    
    % Re-compute the distance to the goal
    distanceToGoal = norm(robotCurrentPose(1:2) - robotGoal(:));
    
    % Update the plot
    % hold off
    
    % Plot path each instance so that it stays persistent while robot mesh moves
    % Show on x-y plot
    plot(path(:,1), path(:,2), "k--d")
    hold off

    % Plot the path of the robot as a set of transforms
    plotTrVec = [robotCurrentPose(1:2); 0];
    plotRot = axang2quat([0 0 1 robotCurrentPose(3)]);
    plotTransforms(plotTrVec', plotRot, "MeshFilePath", "groundvehicle.stl", "Parent", gca, "View","2D", "FrameSize", frameSize);
    light;
    
    % only record x-y once every second, not every robot sampling period
    counter = counter+1;
    if mod(counter,1/sampleTime) == 0
        newcood = cat(1, newcood,robotCurrentPose(1:2)');
    end
    
    TimeElasped = vizRate.TotalElapsedTime % Show elapsed time
    waitfor(vizRate); % Talk about this in report
end

%% Tranform xEast-yNorth to new lat-long and display AI on geographic map
zero = zeros(length(newcood(:,1)));

[newlat,newlong] = local2latlon(newcood(:,1),newcood(:,2),zero,origin); 
player = geoplayer(lat(1),long(1),16);
player.Parent.Name = 'Thato''s Run';
player.Basemap = 'streets'; % 'darkwater', 'grayland', 'bluegreen', 'grayterrain', 'colorterrain', 'landcover', 'streets', 'streets-light', 'streets-dark', 'satellite', 'topographic', 'none'
plotRoute(player,lat,long);

size1 = length(newcood(:,1));
size2 = length(lat);
% choose array with longer time (to avoid index array bounds)
if size1>size2
    sizemax = size1;
else
    sizemax = size2;
end

TimeElaspedReal = 0;
sampleTimeReal = rateControl(1+sampleTime); % 1s sampling rate to represent real world
                                     % 0.1s buffer from sampled rate
                                     % explain in report
for i = 1:sizemax
    % Only plotPosition for existing time 
    if i<size1
    plotPosition(player,newlat(i),newlong(i),"TrackID",1,"Marker","*","Label","AI");
    end
    if i<size2
    plotPosition(player,lat(i),long(i),"TrackID",2,"Marker","x","Label","Thato")
    end
    
    TimeElaspedReal = int8(sampleTimeReal.TotalElapsedTime)
    waitfor(sampleTimeReal); % wait for 1 second. Talk about this in report
end
% hides route -> reset(player); 
% hide(player); % closes visualizer