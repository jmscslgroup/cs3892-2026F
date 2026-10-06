% choose your file!
[fileName, pathName] = uigetfile('*.bag');

bag = rosbag([pathName, fileName]);


% choose your file!
% filename='../../hwilexample.bag';
% filename='../../2025_06_18_12_55_42_2T3MWRFVXLW056972cbf_codegen_test.bag';
% bag = rosbag(filename);


%% extract the x velocity information
vel_x_bag = select(bag,'Topic','/car/state/vel_x');
vel_x = timeseries(vel_x_bag);

%% extract relative velocity of lead car
rel_vel_bag = select(bag,'Topic','/rel_vel');
rel_vel = timeseries(rel_vel_bag);

%% extract relative distance of lead car
lead_dist_bag = select(bag,'Topic','/lead_dist');
lead_dist = timeseries(lead_dist_bag);

% time t0: start of the bag file, so the x-axis shows elapsed seconds
t0 = bag.StartTime;

%% plot the results
figure
hold on
plot(vel_x.Time(:)-t0,vel_x.Data(:))
% plot(rel_vel)
scatter(rel_vel.Time(:)-t0,rel_vel.Data(:),marker='.');
% plot(lead_dist);
scatter(lead_dist.Time(:)-t0,lead_dist.Data(:),marker='.')
legend({'vel x (m/s)','rel vel (m/s)','lead dist (m)'})
ylabel('meters or meters/second')
xlabel('Time since start of bag file (s)')
title('Speed, Relative Velocity, and Relative Distance')
fontsize(gcf,"scale",2.5)
