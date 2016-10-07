function [pos, radii] = search_position(im, prev_size)

if nargin < 1
    error('Image needed, size optional');
elseif nargin < 2
    size = [10, 40];
else
    size = [max(10,prev_size - 20), prev_size + 20];
end
size = int8(size);
[centers, radii] = imfindcircles(im, size(1,:));

pos = centers;
radii = radii;