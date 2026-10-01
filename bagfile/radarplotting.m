% choose your file!
filename='../../hwilexample.bag';
bag = rosbag(filename);

%% what can we see from radar data?
tracka0_bag = select(bag,'Topic','/car/radar/track_a0');
tracka0 = timeseries(tracka0_bag,'Point.X','Point.Y');

%%
figure
scatter(tracka0.Data(:,1),tracka0.Data(:,2));
title('Radar signatures in (x,y) of tracka0')
xlabel('Distance (x) in m')
ylabel('Distance (y) in m')
axis equal
fontsize(gcf,"scale",2.5)

%% okay, what about lots of other radar data?

tracka0_bag = select(bag,'Topic','/car/radar/track_a0');
tracka0 = timeseries(tracka0_bag,'Point.X','Point.Y');
tracka1_bag = select(bag,'Topic','/car/radar/track_a1');
tracka1 = timeseries(tracka1_bag,'Point.X','Point.Y');
tracka2_bag = select(bag,'Topic','/car/radar/track_a2');
tracka2 = timeseries(tracka2_bag,'Point.X','Point.Y');
tracka3_bag = select(bag,'Topic','/car/radar/track_a3');
tracka3 = timeseries(tracka3_bag,'Point.X','Point.Y');
tracka4_bag = select(bag,'Topic','/car/radar/track_a4');
tracka4 = timeseries(tracka4_bag,'Point.X','Point.Y');
tracka5_bag = select(bag,'Topic','/car/radar/track_a5');
tracka5 = timeseries(tracka5_bag,'Point.X','Point.Y');
tracka6_bag = select(bag,'Topic','/car/radar/track_a6');
tracka6 = timeseries(tracka6_bag,'Point.X','Point.Y');
tracka7_bag = select(bag,'Topic','/car/radar/track_a7');
tracka7 = timeseries(tracka7_bag,'Point.X','Point.Y');
% tracka8_bag = select(bag,'Topic','/car/radar/track_a8');
% tracka8 = timeseries(tracka8_bag,'Point.X','Point.Y');

%% and plot all of these
figure
hold on
scatter(tracka0.Data(:,1),tracka0.Data(:,2));
scatter(tracka1.Data(:,1),tracka1.Data(:,2));
scatter(tracka2.Data(:,1),tracka2.Data(:,2));
scatter(tracka3.Data(:,1),tracka3.Data(:,2));
scatter(tracka4.Data(:,1),tracka4.Data(:,2));
scatter(tracka5.Data(:,1),tracka5.Data(:,2));
scatter(tracka6.Data(:,1),tracka6.Data(:,2));
scatter(tracka7.Data(:,1),tracka7.Data(:,2));
title('Radar signatures in (x,y) of tracks a0-a7')
xlabel('Distance (x) in m')
ylabel('Distance (y) in m')
axis equal
fontsize(gcf,"scale",2)
%% what about the other tracks?

tracka8_bag = select(bag,'Topic','/car/radar/track_a8');
tracka8 = timeseries(tracka8_bag,'Point.X','Point.Y');
tracka9_bag = select(bag,'Topic','/car/radar/track_a9');
tracka9 = timeseries(tracka9_bag,'Point.X','Point.Y');
tracka10_bag = select(bag,'Topic','/car/radar/track_a10');
tracka10 = timeseries(tracka10_bag,'Point.X','Point.Y');
tracka11_bag = select(bag,'Topic','/car/radar/track_a11');
tracka11 = timeseries(tracka11_bag,'Point.X','Point.Y');
tracka12_bag = select(bag,'Topic','/car/radar/track_a12');
tracka12 = timeseries(tracka12_bag,'Point.X','Point.Y');
tracka13_bag = select(bag,'Topic','/car/radar/track_a13');
tracka13 = timeseries(tracka13_bag,'Point.X','Point.Y');
tracka14_bag = select(bag,'Topic','/car/radar/track_a14');
tracka14 = timeseries(tracka14_bag,'Point.X','Point.Y');
tracka15_bag = select(bag,'Topic','/car/radar/track_a15');
tracka15 = timeseries(tracka15_bag,'Point.X','Point.Y');

%% and plot all of these
figure
hold on
scatter(tracka8.Data(:,1),tracka8.Data(:,2));
scatter(tracka9.Data(:,1),tracka9.Data(:,2));
scatter(tracka10.Data(:,1),tracka10.Data(:,2));
scatter(tracka11.Data(:,1),tracka11.Data(:,2));
scatter(tracka12.Data(:,1),tracka12.Data(:,2));
scatter(tracka13.Data(:,1),tracka13.Data(:,2));
scatter(tracka14.Data(:,1),tracka14.Data(:,2));
scatter(tracka15.Data(:,1),tracka15.Data(:,2));
title('Radar signatures in (x,y) of tracks a8-a15')
xlabel('Distance (x) in m')
ylabel('Distance (y) in m')
axis equal
fontsize(gcf,"scale",2)

%% plot some of all of them on ONE plot
figure
hold on
scatter(tracka0.Data(1:20:end,1),tracka0.Data(1:20:end,2),'r');
scatter(tracka1.Data(1:20:end,1),tracka1.Data(1:20:end,2),'r');
scatter(tracka2.Data(1:20:end,1),tracka2.Data(1:20:end,2),'r');
scatter(tracka3.Data(1:20:end,1),tracka3.Data(1:20:end,2),'r');
scatter(tracka4.Data(1:20:end,1),tracka4.Data(1:20:end,2),'r');
scatter(tracka5.Data(1:20:end,1),tracka5.Data(1:20:end,2),'r');
scatter(tracka6.Data(1:20:end,1),tracka6.Data(1:20:end,2),'r');
scatter(tracka7.Data(1:20:end,1),tracka7.Data(1:20:end,2),'r');
% second set
scatter(tracka8.Data(1:20:end,1),tracka8.Data(1:20:end,2),'b');
scatter(tracka9.Data(1:20:end,1),tracka9.Data(1:20:end,2),'b');
scatter(tracka10.Data(1:20:end,1),tracka10.Data(1:20:end,2),'b');
scatter(tracka11.Data(1:20:end,1),tracka11.Data(1:20:end,2),'b');
scatter(tracka12.Data(1:20:end,1),tracka12.Data(1:20:end,2),'b');
scatter(tracka13.Data(1:20:end,1),tracka13.Data(1:20:end,2),'b');
scatter(tracka14.Data(1:20:end,1),tracka14.Data(1:20:end,2),'b');
scatter(tracka15.Data(1:20:end,1),tracka15.Data(1:20:end,2),'b');
title('Radar signatures in (x,y) of 1/20 of all tracks a0-15')
xlabel('Distance (x) in m')
ylabel('Distance (y) in m')
axis equal
fontsize(gcf,"scale",2)

