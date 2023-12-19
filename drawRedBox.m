function imgWithBox = drawRedBox(img, x, y, width, height)
    imgWithBox = img;
    boxThickness = 2; % Thickness of the box edges

    % Define the coordinates of the box edges
    topEdge = y:(y + height);
    leftEdge = x:(x + width);
    
    % Top and bottom horizontal lines of the box
    imgWithBox(y:y + boxThickness - 1, leftEdge, 1) = 255;
    imgWithBox(y + height - boxThickness + 1:y + height, leftEdge, 1) = 255;

    % Left and right vertical lines of the box
    imgWithBox(topEdge, x:x + boxThickness - 1, 1) = 255;
    imgWithBox(topEdge, x + width - boxThickness + 1:x + width, 1) = 255;

    % Set the other color channels to 0 (to make the box red)
    imgWithBox(y:y + boxThickness - 1, leftEdge, 2:3) = 0;
    imgWithBox(y + height - boxThickness + 1:y + height, leftEdge, 2:3) = 0;
    imgWithBox(topEdge, x:x + boxThickness - 1, 2:3) = 0;
    imgWithBox(topEdge, x + width - boxThickness + 1:x + width, 2:3) = 0;
end