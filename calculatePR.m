function [TP, FP, FN] = calculatePR(groundTruthBboxes, finalDetections, iouThreshold)
    % Initialize counters for true positives, false positives, and false negatives
    TP = 0;
    FP = 0;
    FN = size(groundTruthBboxes, 1); % Start with all ground truth boxes as false negatives
    
    % fprintf('length(groundTruthBboxes) : %d\n', size(groundTruthBboxes, 1));
    
    
    % Compare each detection with ground truth bounding boxes
    for i = 1:size(finalDetections, 1)
        detectedBox = finalDetections(i, 1:4);
        isMatched = false;
    
        for j = 1:size(groundTruthBboxes, 1)
            groundTruthBox = groundTruthBboxes(j, :);
            iou = calculateIoU(detectedBox, groundTruthBox);
    
            if iou > iouThreshold

                TP = TP + 1;
                FN = FN - 1; % One less false negative
                isMatched = true;
                break; % Assume one detection can only match one ground truth
            end
        end
    
        if ~isMatched
            FP = FP + 1;
        end
    end
    
    % Calculate precision and recall
    precision = TP / (TP + FP);
    recall = TP / (TP + FN);
    
end

function iou = calculateIoU(boxA, boxB)
    % Unpack the positions and dimensions of the two boxes
    xA = boxA(1);
    yA = boxA(2);
    wA = boxA(3);
    hA = boxA(4);

    xB = boxB(1);
    yB = boxB(2);
    wB = boxB(3);
    hB = boxB(4);

    % Calculate the coordinates of the intersection rectangle
    xLeft = max(xA, xB);
    yTop = max(yA, yB);
    xRight = min(xA + wA, xB + wB);
    yBottom = min(yA + hA, yB + hB);

    % Calculate the area of the intersection rectangle
    intersectionArea = max(0, xRight - xLeft) * max(0, yBottom - yTop);

    % Calculate the area of both bounding boxes
    boxAArea = wA * hA;
    boxBArea = wB * hB;

    % Calculate the area of the union of both bounding boxes
    unionArea = boxAArea + boxBArea - intersectionArea;

    % Calculate the IoU
    iou = intersectionArea / unionArea;
end