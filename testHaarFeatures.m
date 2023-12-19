function featureVector = testHaarFeatures(subframe, numFeatures, features)

    % Convert the subframe to grayscale and compute its integral image
    graySubframe = im2gray(subframe);
    iiSubframe = computeIntegralImage(graySubframe);

    % Initialize feature vector for this subframe
    featureVector = zeros(1, numFeatures);

    % Compute Haar feature values for this subframe
    for j = 1:numFeatures
        featureVector(j) = computeHaarFeatureValue(iiSubframe, features(j));
    end

end