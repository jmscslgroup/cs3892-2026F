% choose your file!
filename='../../rossim/2025_10_29_20_50_04_2T3MWRFVXLW056972profacc_test.bag';
% filename='../../2025_06_18_12_55_42_2T3MWRFVXLW056972cbf_codegen_test.bag';
bag = rosbag(filename);

%% look at ACC info
acc_info_bag = select(bag,'Topic','/acc/acc_info');
acc_info = timeseries(acc_info_bag);


%% extract the x velocity information
vel_x_bag = select(bag,'Topic','/car/state/vel_x');
vel_x = timeseries(vel_x_bag);

plot(vel_x.Time,vel_x.Data);

%% extract relative velocity of lead car
rel_vel_bag = select(bag,'Topic','/rel_vel_reversed');
rel_vel = timeseries(rel_vel_bag);

lead_dist_bag = select(bag,'Topic','/lead_dist_extra');
lead_dist = timeseries(lead_dist_bag);

figure
hold on
plot(rel_vel.Time,rel_vel.Data);
plot(lead_dist.Time,lead_dist.Data);


t0 = vel_x.Time(10)

%% plot the results
figure
hold on
plot(vel_x.Time(:)-t0, vel_x.Data(:))
% plot(rel_vel)
scatter(rel_vel.Time(:)-t0,rel_vel.Data(:),marker='.');
% plot(lead_dist);
scatter(lead_dist.Time(:)-t0,lead_dist.Data(:),marker='.')
legend({'vel x (m/s)','rel vel (m/s)','lead dist (m)'})
ylabel('meters or meters/second')
xlabel('Unix time in GMT')
title('Speed, Relative Velocity, and Relative Distance')
axis equal
fontsize(gcf,"scale",2.5)

%% cmd_accel and cmd_accel_pre
cmd_accel_bag = select(bag,'Topic','/cmd_accel');
cmd_accel = timeseries(cmd_accel_bag);

cmd_accel_pre_bag = select(bag,'Topic','/cmd_accel_pre');
cmd_accel_pre = timeseries(cmd_accel_pre_bag);

cruise_state_bag = select(bag,'Topic','/cruise_state');
cruise_state= timeseries(cruise_state_bag);


% acc_info_bag = select(bag,'Topic','/acc/cruise_state_int');
% acc_info = timeseries(acc_info_bag);



% /acc/cruise_state_int

figure
hold on
plot(cmd_accel.Time,cmd_accel.Data)
plot(cmd_accel_pre.Time,cmd_accel_pre.Data)
plot(cruise_state.Time,cruise_state.Data(:,1))
plot(cruise_state.Time,cruise_state.Data(:,3))
legend({'cmd\_accel (m/s^2)','cmd\_accel\_pre (m/s^2)','ACC Info (on/off)', 'ACC Info (substate)'})
ylabel('meters/second^2')
xlabel('Unix time in GMT')
title('Commanded acceleration of safety vs. my controller')



