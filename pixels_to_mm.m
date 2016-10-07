%% Convert coordinates to real world millimeter values

function mm_coordinates = pixels_to_mm(coordinates)

if size(coordinates) ~= 3
    error('Coordinates must be in 3d');
end

% Angular FOVs
ang_horizontal_fov = 70.6;  %From depth camera
ang_vertical_fov = 53.8;    %From rgb-camera

image_size = [512 381];

% Horizontal and vertical FOVs are functions of depth and angular FOV,
% and equal the total real world width and height of the view in
% millimeters respectively.

horizontal_fov = 2*coordinates(3)*tand(ang_horizontal_fov/2);
vertical_fov = 2*coordinates(3)*tand(ang_vertical_fov/2);

x_in_mm = double(coordinates(1))/image_size(1) * horizontal_fov;
y_in_mm = double(coordinates(2))/image_size(2) * vertical_fov;

% Depth is already in millimeters
mm_coordinates = [x_in_mm, y_in_mm, coordinates(3)];