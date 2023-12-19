loadedModel = load('adaBoostModel.mat');
adaBoostModel = loadedModel.adaBoostModel;
                                            
baseDir = './'; % Adjust this path as necessary
originalPicsDir = fullfile(baseDir, 'originalPics');
foldsDir = fullfile(baseDir, 'FDDB-folds');

% Test on fold 6
foldNum = 6;
[testImages, faceBboxesMap] = getTestImages(foldNum, foldsDir, originalPicsDir);


%%% --- Sliding Window --- %%%

configurations = [
    % struct('windowSize', [130, 130], 'stepSize', [12, 12]),
    struct('windowSize', [120, 75], 'stepSize', [10, 10]),
    % struct('windowSize', [70, 70], 'stepSize', [8, 8]),
];

numFeatures = 750;
features = selectRandomHaarFeatures(numFeatures, 32);
thresholds = fliplr(.1:0.1:1);
precisionValues = zeros(length(thresholds), 1);
recallValues = zeros(length(thresholds), 1);
specificIndices = [3, 28, 35];


for tIndex = 1:length(thresholds)
    thresholdCurve = thresholds(tIndex);
    fprintf('ThresholdCurve: %d\n', thresholdCurve);
    totalTP = 0;
    totalFP = 0;
    totalFN = 0;
    fprintf('Threshold Iteration: %d\n', tIndex);

    for configIndex = 1:length(configurations)
        config = configurations(configIndex);
        windowSize = config.windowSize;
        stepSize = config.stepSize;
        fprintf('configIndex: %d\n', configIndex);

    % Iterate through each test image
        for i = 1:length(testImages)
            index = specificIndices(i);
            if mod(i, 25) == 0
                fprintf('Current iteration: %d\n', i);
            end
            img = testImages{i}; % Access the i-th test image

            groundTruthBboxes = faceBboxesMap(index);

            [imgHeight, imgWidth, ~] = size(img);
            detections = []; % Array to hold [x, y, width, height, score]

            imgCopy = img;
            otherCopy = img;

            % Slide window across the image
            for y = 1:stepSize(1):(imgHeight-windowSize(1)+1)
                for x = 1:stepSize(2):(imgWidth-windowSize(2)+1)
                    % Extract the subframe
                    subframe = img(y:(y+windowSize(1)-1), x:(x+windowSize(2)-1), :);

                    % Resize the subframe to match the input size of the AdaBoost model
                    resizedSubframe = imresize(subframe, [32, 32]);

                    % Get Haar feature for subframe
                    featureVector = testHaarFeatures(resizedSubframe, numFeatures, features);

                    % Classify the subframe using the AdaBoost model
                    [~, score] = predict(adaBoostModel, featureVector);
                    positiveClassScore = score(:, 2);

                    % Apply a threshold to determine if the subframe contains a face
                    % threshold = 0.5; % Adjust as needed
                    isFace = positiveClassScore >= thresholdCurve;


                    % Do something with the result (e.g., mark the subframe, store the result)
                    if isFace
                        detections = [detections; x, y, windowSize(2), windowSize(1), positiveClassScore];
                    end

                end
            end

            nonMaxThreshold = .3;
            finalBoxes = nonMaxSuppression(detections, nonMaxThreshold, thresholdCurve);
               
            % --- Uncomment to see the detections with red boxes --- %
            % for j = 1:size(finalBoxes, 1)
            %     x = finalBoxes(j, 1);
            %     y = finalBoxes(j, 2);
            %     width = finalBoxes(j, 3);
            %     height = finalBoxes(j, 4);
            %     otherCopy = drawRedBox(otherCopy, x, y, width, height);
            % 
            % end
            % figure;
            % imshow(otherCopy);
            % title('Sliding Window + Human Classification');

            iouThreshold = 0.5;
            [TP, FP, FN] = calculatePR(groundTruthBboxes, finalBoxes, iouThreshold);
            totalTP = totalTP + TP;
            totalFP = totalFP + FP;
            totalFN = totalFN + FN;
            
        end

    end

    if totalFN < 0
        totalFN = 0;
    end
    precisionValues(tIndex) = totalTP / (totalTP + totalFP);
    if totalTP + totalFN == 0
        recallValues(tIndex) = 0;
    else
        recallValues(tIndex) = totalTP / (totalTP + totalFN);
    end
end


% Plot the precision-recall curve
figure;
plot(recallValues, precisionValues);
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
axis([0 1 0 1]);

disp(precisionValues);
disp(recallValues);
disp(totalTP);
disp(totalFN);
disp(totalFP);



