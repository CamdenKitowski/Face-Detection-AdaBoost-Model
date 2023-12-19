baseDir = './'; % Adjust this path as necessary
originalPicsDir = fullfile(baseDir, 'originalPics');
foldsDir = fullfile(baseDir, 'FDDB-folds');

numFoldsForTraining = 8; % Using first 8 folds for training

% Initialize arrays to store training data and labels
train_data = {};
train_labels = [];

% Processing folds for training data
for i = 1:numFoldsForTraining
    fprintf('i:  %d\n', i);
    [patches, patchLabels] = processFold(i, foldsDir, originalPicsDir);
    train_data = [train_data, patches];
    train_labels = [train_labels, patchLabels];
end


test_data = {};
test_labels = [];

foldForTesting = 10;

for i = 9:foldForTesting
    fprintf('i:  %d\n', i);
    [patches, patchLabels] = processFold(i, foldsDir, originalPicsDir);
    test_data = [test_data, patches];
    test_labels = [test_labels, patchLabels];
end

if iscell(train_labels)
    train_labels = cell2mat(train_labels);
end
if iscell(test_labels)
    test_labels = cell2mat(test_labels);
end

% Get Feature Value Matrices using Haar Features
[trainFeatureValuesMatrix, testFeatureValuesMatrix] = getFeatureMatrices(train_data, test_data);

%%% --- AdaBoost --- %%%

% Train the AdaBoost Model
adaBoostModel = fitcensemble(trainFeatureValuesMatrix, train_labels, 'Method', 'AdaBoostM1');

% Predict using the trained model
[~, testScores] = predict(adaBoostModel, testFeatureValuesMatrix);

% The scores for the positive class (usually, the second column corresponds to the positive class)
positiveClassScores = testScores(:, 2);

% (Optional) Convert scores to binary predictions, e.g., using a threshold
threshold = 0.5; % This can be adjusted based on your requirements
binaryPredictions = positiveClassScores >= threshold;

binaryPredictions = binaryPredictions(:);
test_labels = test_labels(:);

numCorrectPredictions = sum(binaryPredictions == test_labels);

% Total number of predictions
totalPredictions = length(test_labels);

% Calculate accuracy
accuracy = numCorrectPredictions / totalPredictions;

% Display accuracy
fprintf('Face Detection Accuracy: %.2f%%\n', accuracy * 100);

% Save variables to be used in another file % 
save('adaBoostModel.mat', 'adaBoostModel');
save('test_labels.mat', 'test_labels');
save('test_data.mat', 'test_data');
save('train_labels.mat', 'train_labels');
save('train_data.mat', 'train_data');





