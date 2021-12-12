function oImage = surfacecrackdetection(Image)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Code Block will Calculate the number of Blocks of image required for Given size of Block
[Image_Height,Image_Width,Number_Of_Colour_Channels] = size(Image);

Block_Size = 50; % Algorith Works better with this size
Number_Of_Blocks_Vertically = floor(Image_Height/Block_Size); 
Number_Of_Blocks_Horizontally = floor(Image_Width/Block_Size);
Image_Blocks = struct('Blocks',[]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculating the Global threshold for Image segmentation %%%%%%%%%%%%

[counts,x] = imhist(im2gray(Image),16);
T = otsuthresh(counts);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterating over each block and processing the small block of image.
Index = 1;
for Row = 1: +Block_Size: Number_Of_Blocks_Vertically*Block_Size
    for Column = 1: +Block_Size: Number_Of_Blocks_Horizontally*Block_Size
        
    Row_End = Row + Block_Size - 1;
    Column_End = Column + Block_Size - 1;
   % To handel the overflow from image  Boundary   
    if Row_End > Image_Height
       Row_End = Image_Height;
    end
    
    if Column_End > Image_Width
       Column_End = Image_Width;
    end
    
    Temporary_Tile = Image(Row:Row_End,Column:Column_End,:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%% Now That we have Single Frame we will Now Perform the RGB Channel Sepration
    process_img =Temporary_Tile;
    r = process_img(:,:,1);
    g = process_img(:,:,2);
    b = process_img(:,:,3);
    test = rgb2gray(process_img);
    dummy = test;
    sz = size(test);
    gs = imadjust(dummy);
  
    %[counts,x] = imhist(dummy,16);
%stem(x,counts)
    %T = otsuthresh(counts);
    % For smoothing the rough surfaces
    H = fspecial("average",21);
    gssmooth = imfilter(dummy,H,"replicate");


    %BW = imbinarize(gssmooth,min(0.19,T));

    % Segmentation
    test(test < min(70,255*T)) = 0;
    test(test >= min(70,255*T)) = 255;
    detected = 255*uint8(~test);
    detected=medfilt2(detected);
    avg = fspecial('average' , 49);
    detected=imfilter(detected,avg);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This section Takes decission weather an image block have edge or not
    cost = sum(detected , 2);
    %cost2 = sum(detected , 1);
    if sum(cost) > 15000
        %disp('Fault Detected')
        im = cat(3,r,g+detected,b);
        % Highlighting the Edge
        %imshow(detected,[]);title('Crack Detected');
    else
        im = cat(3,r,g,b);

    end% read image from datastore

    # Making the Detected image
    oImage(Row:Row_End,Column:Column_End,:) = im;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end  
end

end
