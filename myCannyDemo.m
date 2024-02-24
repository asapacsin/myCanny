img = imread('lena.jpg');
img = rgb2gray(img);
subplot(1,4,1)
imshow(img),title('original')
i = myCanny(img,0.15);
inew = myCanny(img,0.3);
e = edge(img,'Canny');
subplot(1,4,2)
imshow(e),title('matlab setting')
subplot(1,4,3)
imshow(i),title('threshold 0.15')
subplot(1,4,4)
imshow(inew),title('threshold 0.3')