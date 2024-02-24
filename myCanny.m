function I1= myCanny(I,k)
img0 = double(I);
gauss = [1 2 1; 2 4 2;1 2 1] / 16;  % Gauss平滑模板
sobelx = [-1 0 1; -2 0 2; -1 0 1];  % Sobel horizontal gradient
sobely = sobelx';                   % Sobel vertical gradient

img = conv2(img0, gauss, 'same');   % 平滑
gradx = conv2(img, sobelx, 'same'); % horizontal convolution
grady = conv2(img, sobely, 'same'); % vertical convolution

M = sqrt(gradx .^ 2 + grady .^ 2);  % root square
% M = abs(gradx)+ abs(grady);  % approximate
alpha = atan(grady ./ gradx);       % gradient angle

N = zeros(size(M));                 % non maximum inhibit
for i = 2: length(M(:, 1)) - 1
    for j = 2: length(M(1, :)) - 1
        dirc = alpha(i, j);      
        
        if abs(dirc) <= pi / 8
            if M(i, j) == max([(M(i, j - 1)), M(i, j), M(i, j + 1)])%vertical gradient，horizontal line
                N(i, j) = M(i, j);
            end
        elseif abs(dirc) >= 3 * pi / 8
            if M(i, j) == max([(M(i - 1, j)), M(i, j), M(i + 1, j)])%horizontal gradient，vertical line
                N(i, j) = M(i, j);
            end
        elseif dirc > pi / 8 && dirc < 3 * pi / 8
            if M(i, j) == max([(M(i - 1, j - 1)), M(i, j), M(i + 1, j + 1)])
                N(i, j) = M(i, j);
            end
        elseif dirc > - 3 * pi / 8 && dirc < - pi / 8
            if M(i, j) == max([(M(i + 1, j - 1)), M(i, j), M(i - 1, j + 1)])
                N(i, j) = M(i, j);
            end
        end
    end
end

TH = 0.05* max(max(N));              % high threshold
TL = 0.025 * max(max(N));              % low threshold
THedge = N; 
TLedge = N;

THedge(THedge < TH) = 0;             
TLedge(TLedge < TL) = 0;             

THedge = padarray(THedge, [1, 1], 0, 'both');   % prevent neighbour problem
TLedge = padarray(TLedge, [1, 1], 0, 'both');
TLedge0 = TLedge;

isvis = ones(size(THedge));          % trace matrix

while(sum(sum(THedge)))
    [x, y] = find(THedge ~= 0, 1);   % find non zero coordinate
    THedge = THedge .* isvis;        % if searched then record
    [TLedge0, isvis] = traverse(TLedge0, x, y, isvis);      % record connected component
end

TLedge = TLedge - TLedge0;           % 作差求出Canny
TLedge(:, end) = []; TLedge(end, :) = []; TLedge(1, :) = []; TLedge(:, 1) = [];

pmin=min(min(TLedge));pmax=max(max(TLedge));
I1=uint8((double(TLedge)-pmin)/(pmax-pmin)*255);
I1=im2bw(I1,k);