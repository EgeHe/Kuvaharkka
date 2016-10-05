function ball_center = get_3d_location(depth_image, coordinates, roi_size)


% Crop ROI around coordinates
x_start = coordinates(1)-roi_size/2;
y_start = coordinates(2)-roi_size/2;
roi = depth_image(y_start:y_start+roi_size, x_start:x_start+roi_size);

% Locate center of ball (point closest to the depth camera)
[ball_center_z, index] = min(roi(:));
[y, x] = ind2sub(size(roi), index);

% Change to depth image coordinates
ball_center_x = x + x_start - 1;
ball_center_y = y + y_start - 1;
ball_center = [ball_center_x, ball_center_y, ball_center_z];


end
