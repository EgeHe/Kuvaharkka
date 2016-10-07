%% ROS initialization, run with f9
% Edit ROS network variables to fit your network
%{
setenv('ROS_MASTER_URI','http://127.0.0.1:11311')
setenv('ROS_HOSTNAME','127.0.0.1')
rosinit
%}
close all;
clear all;

%%
imagetopic = '/kinect2/qhd/image_color';
imsub = rossubscriber(imagetopic, 'sensor_msgs/Image');

depth_imagetopic = '/kinect2/sd/image_depth';
depthimsub = rossubscriber(depth_imagetopic, 'sensor_msgs/Image');

%%
radius = 20;
prev_pos = [];
time = rostime('now');
time = seconds(double(time.Sec) + double(time.Nsec)/10^9);
fig_image = figure;
fig_speed = figure;
fig_total_speed = figure;
while true
    msg = receive(imsub, 10); % 0.5 sec timeout
    depth_msg = receive(depthimsub, 10);
    
    msg_time = seconds(double(msg.Header.Stamp.Sec) + double(msg.Header.Stamp.Nsec)/10^9);
    dt = msg_time - time;   
    
    image = readImage(msg);
    depth_image = readImage(depth_msg);
    
    %Select overlapping regions from images (different FOV, image ratio and some offset)
    image = image(:,115:844,:);
    depth_image = depth_image(26:406,:);
        
    %Create binary image with only green objects
    bin_img = thresh_green(image);
    
    %Search round object from binary image
    [obj_pos, radius] = search_position(bin_img, radius);
    %Take the biggest found radius
    [biggest, ind] = max(radius);
    obj_pos = obj_pos(ind,:); 
    radius = radius(ind); 
    
    %Show image
    figure(fig_image);
    imagesc(image);
    hold on;
    
    %Take next picture, if nothing found
    if isequal(size(obj_pos), [0, 0])
        radius = 20;
        continue
    end
    
    %Scale down to SD image size
    corr_y = size(depth_image, 1)/size(image, 1);
    corr_x = size(depth_image, 2)/size(image, 2);
    
    corrected_pos = [obj_pos(1,1) * corr_x,obj_pos(1,2) * corr_y];
    corrected_radius = mean([corr_x, corr_y]) * radius(1);

    %Calculate ball 3D location using depth image
    ball_pos = get_3d_location(depth_image, corrected_pos, corrected_radius);
    %Convert location to millimeters
    corr_ball_pos = pixels_to_mm(ball_pos);
    
    %Save time information for next detection
    time = msg_time;
    
    %If no previous location, take next picture
    if isequal(size(prev_pos), [0, 0])
        prev_pos = corr_ball_pos;
        continue
    end

    %Calculate velocities for each axis
    [vel total_vel] = calculate_velocity(prev_pos, corr_ball_pos, dt);
    
    %Save current ball position
    prev_pos = corr_ball_pos;
    
    %Show detected ball
    viscircles(obj_pos, radius, 'EdgeColor', 'r');
    
    %Show speed
    figure(fig_speed);
    bar(vel)
    ylim([-3 3])
    title('Axis speeds'); 
    set(gca,'xticklabel',{'X';'Y';'Z'})
    
    %Show total speed
    figure(fig_total_speed);
    bar(total_vel)
    ylim([-3 3])
    title('Total speed'); 
end

