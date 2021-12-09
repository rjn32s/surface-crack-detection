clf;
clc;


%img1= imread("texture-concrete-crack-old-preview.jpg");
Image = imread("crack-3949432_1280.jpg");
Image1 = imgaussfilt(Image,1);
out = surfacecrackdetection(Image1);
subplot(121);imshow(Image,[]);title('Input Image')
subplot(122);imshow(out,[]);title('Detected Image')