function ball_center = get_3d_location(depth_image, coordinates, roi_size)

% Crop ROI around coordinates
x_start = fix(max(1,coordinates(1)-roi_size/2));
y_start = fix(max(1,coordinates(2)-roi_size/2));

x_end = fix(min(size(depth_image,2),coordinates(1) + roi_size/2));
y_end = fix(min(size(depth_image,1),coordinates(2) + roi_size/2));

roi = depth_image(y_start:y_end, x_start:x_end);

% % Remove zeros as faulty measurements
%
% % Locate center of ball (point closest to the depth camera)
% [ball_center_z, index] = min(roi(roi~=0));
% [y, x] = ind2sub(size(roi), index);
% 
% % Change to depth image coordinates
% ball_center_x = x + x_start - 1;
% ball_center_y = y + y_start - 1;
% ball_center = [ball_center_x, ball_center_y, ball_center_z];
%

ball_center_z = mean(mean(roi));

% Add depth coordinate
ball_center = [coordinates, ball_center_z];

end
