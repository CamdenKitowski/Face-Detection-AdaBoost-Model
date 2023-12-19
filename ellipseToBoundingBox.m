function bbox = ellipseToBoundingBox(a, b, theta, x0, y0)
    % Calculate the width and height of the bounding box
    W = 2 * a * abs(cos(theta)) + 2 * b * abs(sin(theta));
    H = 2 * a * abs(sin(theta)) + 2 * b * abs(cos(theta));
    
    % Calculate the top-left corner of the bounding box
    topLeftX = x0 - W/2;
    topLeftY = y0 - H/2;
    
    % Define the bounding box [x, y, width, height]
    bbox = [topLeftX, topLeftY, W, H];
end