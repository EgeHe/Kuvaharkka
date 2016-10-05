function [pos, radii] = search_position(im, prev_size)

if nargin < 1
    error('Image needed, size optional');
elseif nargin < 2
    size = [100, 180];
else
    size = [prev_size - 40, prev_size + 40];
end

[centers, radii] = imfindcircles(im, size);
%imshow(im);
%viscircles(centers, radii,'EdgeColor','b');

pos = centers(1);
radii = radii(1);