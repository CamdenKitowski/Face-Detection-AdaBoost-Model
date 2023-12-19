function value = computeHaarFeatureValue(ii, feature)
    x = feature.position(1);
    y = feature.position(2);
    width = feature.size(1);
    height = feature.size(2);
    
    if strcmp(feature.type, 'two-rectangle')
        if strcmp(feature.orientation, 'horizontal')
            % Split horizontally
            part1 = sumRegion(ii, x, y, floor(width / 2), height);
            part2 = sumRegion(ii, floor(x + width / 2), y, floor(width / 2), height);
            value = part1 - part2;
        else
            % Split vertically
            part1 = sumRegion(ii, x, y, width, floor(height / 2));
            part2 = sumRegion(ii, x, floor(y + height / 2), width, floor(height / 2));
            value = part1 - part2;
        end
    end
    % Add logic for other feature types
end

function sum = sumRegion(ii, x, y, width, height)
    % Ensure the indices do not exceed the dimensions of ii
    [rows, cols] = size(ii);
    
    % Calculate end coordinates
    x_end = min(x + width, cols);
    y_end = min(y + height, rows);
    
    % Compute the sum within the region using the integral image
    sum = ii(y_end, x_end) - ii(y_end, x) - ii(y, x_end) + ii(y, x);

end