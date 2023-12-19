function features = selectRandomHaarFeatures(numFeatures, imgSize)
    rng(1); % Set random seed for reproducibility
    features = [];
    for i = 1:numFeatures
        type = 'two-rectangle'; % Simplification, you can randomize this
        maxWidth = imgSize / 2; % Adjust based on feature type
        maxHeight = imgSize / 2; % Adjust based on feature type
        width = randi([1, maxWidth]);
        height = randi([1, maxHeight]);
        x = randi([1, imgSize - width + 1]);
        y = randi([1, imgSize - height + 1]);
        if randi([1, 2]) == 1
            orientation = 'horizontal';
        else
            orientation = 'vertical';
        end
        feature = defineHaarFeature(type, [x, y], [width, height], orientation);
        % disp(feature);
        features = [features, feature];
    end
end