%% ROS initialization, run with f9
% Edit ROS network variables to fit your network
%{
setenv('ROS_MASTER_URI','http://127.0.0.1:11311')
setenv('ROS_HOSTNAME','127.0.0.1')
rosinit
%}

%%
imagetopic = '/kinect2/qhd/image_color';
imsub = rossubscriber(imagetopic, 'sensor_msgs/Image');

depth_imagetopic = '/kinect2/sd/image_depth';
depthimsub = rossubscriber(depth_imagetopic, 'sensor_msgs/Image');

%%
radius = 120;
prev_pos = [];
time = rostime('now');
time = seconds(double(time.Sec) + double(time.Nsec)/10^9);

while true
    msg = receive(imsub, 0.5); % 0.5 sec timeout
    depth_msg = receive(depthimsub, 0.5);
    
    msg_time = seconds(double(msg.Header.Stamp.Sec) + double(msg.Header.Stamp.Nsec)/10^9);
    dt = msg_time - time;
    time = msg_time;
    
    image = readImage(msg);
    depth_image = readImage(depth_msg);
    
    corr_y = size(image, 1);
    corr_x = size(image, 2);
    
    bin_img = thresh_green(image);
    [obj_pos, radius] = search_position(bin_img, radius);
    
    corrected_pos = [obj_pos(1) * corr_y, obj_pos(2) * corr_x];
    corrected_radius = mean([corr_x, corr_y]) * radius;
    
    ball_pos = get_3d_location(depth_image, corrected_pos, corrected_radius);
    
    if isequal(size(prev_pos), [0, 0])
        prev_pos = ball_pos;
        continue
    end
    
    vel = calculate_velocity(prev_pos, ball_pos, dt);
    prev_pos = ball_pos;
    
    imagesc(image);
    hold on;
end

