function ii = computeIntegralImage(img)
    ii = cumsum(cumsum(double(img), 2), 1);
end
