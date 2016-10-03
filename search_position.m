function pos = search_position(im, depth_im)

if nargin < 2
    error('Two input images needed');
elseif nargin < 3
    size = [40, 250];
end

[centers, radii] = imfindcircles(im, size);
imshow(im);
viscircles(centers, radii,'EdgeColor','b');


pos = [centers 0];