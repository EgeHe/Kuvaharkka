%% Search green object

%Specify image location
folder = './Kuvat2/';
figure
for i=1:5
    image = imread(strcat(folder,strcat(num2str(i),'_rgb.png')));

    %Take color channels
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
    bw_clean = bwareaopen(bw_clean, 2000);
    
    %Plot image pair
    subplot(5,2,i*2-1);
    imshow(image);
    subplot(5,2,i*2);
    imshow(bw_clean);
end

    
   
