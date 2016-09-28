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

%%
while true
    msg = receive(imsub, 3.5); % 0.5 sec timeout
    image = readImage(msg);
    
    
    imagesc(image);
    hold on;
end

