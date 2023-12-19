function finalBoxes = nonMaxSuppression(detections, iouThreshold, thresholdCurve)
    % Sort detections by score
    [~, indices] = sort(detections(:, 5), 'descend');
    detections = detections(indices, :);

    finalBoxes = [];

    while ~isempty(detections)
        % Take the detection with the highest score
        currentBox = detections(1, :);
        finalBoxes = [finalBoxes; currentBox];

        % Compute IoU with the rest of the boxes
        remainingBoxes = detections(2:end, :);
        iou = computeIoU(currentBox, remainingBoxes);

        % Keep boxes with IoU lower than the threshold
        detections = remainingBoxes(iou < iouThreshold, :);
    end

    % Determine the number of boxes to remove
    numBoxesToRemove = round(thresholdCurve * size(finalBoxes, 1));
    finalBoxes = finalBoxes(1:end-numBoxesToRemove, :);

    % if thresholdCurve == 1
    %     finalBoxes = finalBoxes(1, :); % Keep only the first row
    % else
    %     finalBoxes = finalBoxes(1:end-numBoxesToRemove, :);
    % end
end

function iou = computeIoU(boxA, boxesB)
    % Extract coordinates for boxA
    xA = boxA(1);
    yA = boxA(2);
    wA = boxA(3);
    hA = boxA(4);

    % Initialize IoU array
    iou = zeros(size(boxesB, 1), 1);

    for i = 1:size(boxesB, 1)
        % Extract coordinates for boxB
        xB = boxesB(i, 1);
        yB = boxesB(i, 2);
        wB = boxesB(i, 3);
        hB = boxesB(i, 4);

        % Compute intersection
        xIntersect = max(xA, xB);
        yIntersect = max(yA, yB);
        intersectW = min(xA + wA, xB + wB) - xIntersect;
        intersectH = min(yA + hA, yB + hB) - yIntersect;
        if intersectW > 0 && intersectH > 0
            % Compute union
            unionArea = wA * hA + wB * hB - intersectW * intersectH;
            % Compute IoU
            iou(i) = (intersectW * intersectH) / unionArea;
        end
    end
end