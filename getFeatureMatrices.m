function [trainFeatureValuesMatrix, testFeatureValuesMatrix] = getFeatureMatrices(train_data, test_data)
    
    numTrainImages = length(train_data);
    numTestImages = length(test_data);
    
    % Initialize arrays to store integral images
    integralTrainImages = zeros(32, 32, numTrainImages);
    integralTestImages = zeros(32, 32, numTestImages);
    
    % Compute integral images for training data
    for i = 1:numTrainImages
        img = train_data{i};
        grayImg = im2gray(img);
        integralTrainImages(:, :, i) = computeIntegralImage(grayImg); 
    end
    
    % Compute integral images for test data
    for i = 1:numTestImages
        img = test_data{i};
        grayImg = im2gray(img);
        integralTestImages(:, :, i) = computeIntegralImage(grayImg);
    end
    
    
    numFeatures = 750;
    features = selectRandomHaarFeatures(numFeatures, 32);
    
    % Initialize matrices to store feature values for all training and test images
    trainFeatureValuesMatrix = zeros(numTrainImages, numFeatures);
    testFeatureValuesMatrix = zeros(numTestImages, numFeatures);
    
    
    % Compute Haar feature values for training data
    for i = 1:numTrainImages
        ii = integralTrainImages(:, :, i); % Get the integral image for the i-th training image
        for j = 1:numFeatures
            trainFeatureValuesMatrix(i, j) = computeHaarFeatureValue(ii, features(j));
        end
    end
    
    
    % Compute Haar feature values for test data
    for i = 1:numTestImages
        ii = integralTestImages(:, :, i); % Get the integral image for the i-th test image
        for j = 1:numFeatures
            testFeatureValuesMatrix(i, j) = computeHaarFeatureValue(ii, features(j));
        end
    end
end