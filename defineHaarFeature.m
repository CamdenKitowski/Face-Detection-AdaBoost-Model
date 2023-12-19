function feature = defineHaarFeature(featureType, position, size, orientation)
    % featureType: 'two-rectangle', 'three-rectangle', 'four-rectangle'
    % position: [x, y] - top-left corner of the feature
    % size: [width, height] - size of the feature
    % orientation: 'horizontal' or 'vertical' (for two-rectangle features)
    
    feature.type = featureType;
    feature.position = position;
    feature.size = size;
    feature.orientation = orientation;
end