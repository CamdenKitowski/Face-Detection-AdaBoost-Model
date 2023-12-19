function [images, faceBboxesMap] = getTestImages(foldNum, foldsDir, originalPicsDir)
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

    faceBboxesMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    annotationIndex = 1;
    images = {};
    specificIndices = [3, 28, 35];


    for i = 1:numel(imagePaths{1})
        
        imagePath = fullfile(originalPicsDir, strcat(imagePaths{1}{i}, '.jpg'));
        img = imread(imagePath);
        
        if ismember(i, specificIndices)
            images{end+1} = img; % Append only if i is in the specific indices
            
        end

        % figure;
        % imshow(img);
        % hold on; 

        numFaces = str2double(annotations{1}{annotationIndex + 1});
        annotationIndex = annotationIndex + 2; % Move past the image name and number of faces
        
        bboxes = []; % Array to store bounding boxes for this image
        for j = 1:numFaces
            ann = str2num(annotations{1}{annotationIndex});
            bbox = ellipseToBoundingBox(ann(1), ann(2), ann(3), ann(4), ann(5));
            bboxes = [bboxes; bbox]; % Append bbox to the array for this image
            % rectangle('Position', bbox, 'EdgeColor', 'r', 'LineWidth', 2);
            % fprintf('Image %d, Box %d: Width = %f, Height = %f\n', i, j, bbox(3), bbox(4));
            annotationIndex = annotationIndex + 1;
        end
        
        if ismember(i, specificIndices)
            faceBboxesMap(i) = bboxes;
        end
        
        % fprintf('number of boxes : %d\n', numberOfBoxes);
        % title(sprintf('Image %d with Detected Faces', i));
        % hold off;
        
    end
end