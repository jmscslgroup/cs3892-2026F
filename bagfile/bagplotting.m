% choose your file!
filename='../../hwilexample.bag';
% filename='../../2025_06_18_12_55_42_2T3MWRFVXLW056972cbf_codegen_test.bag';
bag = rosbag(filename);


%% extract the x velocity information
vel_x_bag = select(bag,'Topic','/car/state/vel_x');
vel_x = timeseries(vel_x_bag);

%% extract relative velocity of lead car
rel_vel_bag = select(bag,'Topic','/rel_vel');
rel_vel = timeseries(rel_vel_bag);

%% extract relative distance of lead car
lead_dist_bag = select(bag,'Topic','/lead_dist');
lead_dist = timeseries(lead_dist_bag);

% time t0
% t0 = vel_x.Time(10)

%% plot the results
figure
hold on
plot(vel_x)
% plot(rel_vel)
scatter(rel_vel.Time(:),rel_vel.Data(:),marker='.');
% plot(lead_dist);
scatter(lead_dist.Time(:),lead_dist.Data(:),marker='.')
legend({'vel x (m/s)','rel vel (m/s)','lead dist (m)'})
ylabel('meters or meters/second')
xlabel('Unix time in GMT')
title('Speed, Relative Velocity, and Relative Distance')
axis equal
fontsize(gcf,"scale",2.5)
