function I = imsharpen(Img,radius,strength)
    img = im2double(rgb2gray(repmat(Img,[1,1,4-size(Img,3)])));
    g= fspecial('gaussian', 4*radius,radius);
    imblured = imfilter(img,g);
    mask = img-imblured;
    I = img+strength*mask;
end