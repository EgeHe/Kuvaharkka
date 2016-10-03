%% ROS initialization, run with f9
% Edit ROS network variables to fit your network
%{
setenv('ROS_MASTER_URI','http://192.168.2.90:11311')
setenv('ROS_HOSTNAME','192.168.2.90')
rosinit
%}

%%
imagetopic = '/kinect2/qhd/image_color/compressed';
imsub = rossubscriber(imagetopic, 'sensor_msgs/CompressedImage');

depth_imagetopic = '/kinect2/qhd/image_depth';
depthimsub = rossubscriber(depth_imagetopic, 'sensor_msgs/Image');

%%
while true
    msg = receive(imsub, 0.5); % 0.5 sec timeout
    depth_msg = receive(depthimsub, 0.5);
    
    image = readImage(msg);
    depth_image = readImage(depth_msg);
    
    bin_img = thresh_green(image);
    obj_pos = search_position(bin_img, depth_image);
    
    imagesc(image);
    hold on;
end

