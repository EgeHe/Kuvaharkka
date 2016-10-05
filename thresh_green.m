function binary_image = thresh_green(image)

red = image(:,:,1);
green = image(:,:,2);
blue = image(:,:,3);

%Extract only green
green_only = green - blue/2 - red/2;

%Turn to binary image
bw_green = im2bw(green_only, 0.10);

%Clean binary image
%Fill holes
bw_clean = imfill(bw_green, 'holes');
%Remove too small objects (some better way for this?)
binary_image = bwareaopen(bw_clean, 20);