function color = takeColor(index,pixel)
    color = pixel;
    red = pixel(1)*0.299;
    green = pixel(2)*0.587;
    blue = pixel(3)*0.114;
    c_pixel = [red,green,blue];
    [~,i] = max(c_pixel);
    if index ~= i
        color(:) = 0;
    end
    