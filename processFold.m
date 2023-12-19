function [data, labels] = processFold(foldNum, foldsDir, originalPicsDir)
    imagePathFile = fullfile(foldsDir, sprintf('FDDB-fold-%02d.txt', foldNum));
    ellipseListFile = fullfile(foldsDir, sprintf('FDDB-fold-%02d-ellipseList.txt', foldNum));

    % Read image paths
    fileID = fopen(imagePathFile, 'r');
    imagePaths = textscan(fileID, '%s');
    fclose(fileID);

    % Read annotations
    fileID = fopen(ellipseListFile, 'r');
    annotations = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);

    data = {};
    labels = [];

    annotationIndex = 1;

    count = 0;
    positiveCount = 0;
    addLoop = 0;

    for i = 1:numel(imagePaths{1})
        imagePath = fullfile(originalPicsDir, strcat(imagePaths{1}{i}, '.jpg'));

        img = imread(imagePath);
        
        numFaces = str2double(annotations{1}{annotationIndex + 1});
        annotationIndex = annotationIndex + 2; % Move past the image name and number of faces
        
        for j = 1:numFaces
            ann = str2num(annotations{1}{annotationIndex});
            bbox = ellipseToBoundingBox(ann(1), ann(2), ann(3), ann(4), ann(5));
            
            % Draw the bounding box on the image
            % figure; imshow(img); hold on;
            % rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
            % hold off;

            % Append positive patch and label
            positivePatch = imcrop(img, bbox);
            positivePatch = imresize(positivePatch, [32, 32]);
            positiveCount = positiveCount + 1;
            data{end+1} = positivePatch;
            labels(end+1) = 1; % 1 for positive

            % Generate negative patch
            [negativePatch, negativeCount] = generateNegativePatch(img, bbox);
            count = count + negativeCount;

            if ~isempty(negativePatch)
                data{end+1} = negativePatch;
                labels(end+1) = 0; % 0 for negative
            end

            annotationIndex = annotationIndex + 1;
        end
    end
end

function [negativePatch, count] = generateNegativePatch(img, faceBboxes)
    % Define the size of the negative patch (you can adjust this)
    count = 0;
    patchWidth = faceBboxes(3);
    patchHeight = faceBboxes(4);
  
    % Get the dimensions of the image
    [imgHeight, imgWidth, ~] = size(img);

    % Try up to a maximum number of attempts to find a negative patch
    maxAttempts = 1000;
    for attempt = 1:maxAttempts
        % Handle the case where the patch is too large for the image
        if patchWidth >= imgWidth || patchHeight >= imgHeight
        continue; 
        end

        % Randomly select the top-left corner of the patch
        x1 = randi([1, floor(imgWidth - patchWidth + 1)]);
        y1 = randi([1, floor(imgHeight - patchHeight + 1)]);
        x2 = x1 + patchWidth - 1;
        y2 = y1 + patchHeight - 1;

        % Check for overlap with any face bounding boxes
        overlap = any(bxOverlap(x1, y1, x2, y2, faceBboxes));
        if ~overlap
            % If no overlap, crop the patch and return
            negativePatch = imcrop(img, [x1, y1, patchWidth - 1, patchHeight - 1]);
            negativePatch = imresize(negativePatch, [32, 32]);
            return;
        end
    end
    % If no suitable patch found, return an empty array
    count = count + 1;
    negativePatch = [];
end

function isOverlap = bxOverlap(x1, y1, x2, y2, bboxes)
    % Check if the given box overlaps with any of the bounding boxes
    isOverlap = false;
    for i = 1:size(bboxes, 1)
        bbox = bboxes(i, :);
        if (x1 < (bbox(1) + bbox(3)) && x2 > bbox(1) && ...
            y1 < (bbox(2) + bbox(4)) && y2 > bbox(2))
            isOverlap = true;
            return;
        end
    end
end