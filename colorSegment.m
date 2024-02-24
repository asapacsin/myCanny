img = imread('peppers.jpg');
red = 202;
green = 152;
blue = 255;
[row,col,~] = size(img);
d02 = 250;
seg_img = img;
for i = 1:row
    for j = 1:col
        r = seg_img(i,j,1);
        g = seg_img(i,j,2);
        b = seg_img(i,j,3);
        d2 = (r-red)^2+(g-green)^2+(b-blue)^2;
        if d2>d02
            seg_img(i,j,:) = 0;
        end
    end
end
subplot(1,2,1)
imshow(img),title('origin')
subplot(1,2,2)
imshow(seg_img),title('color segmentation')