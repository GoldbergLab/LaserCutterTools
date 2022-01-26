function coords = createGear(numTeeth, toothDepth, strokeLength, toothTopFraction, circular)
toothPeriod = strokeLength/numTeeth;
slopeWidth = (1-toothTopFraction)*toothPeriod/2;
x = -toothDepth/2;
y = 0;
pointNum = 1;
coords = [];
for toothNum = 1:numTeeth
    coords(:, pointNum) = [x; y];
    pointNum = pointNum + 1;
    % First slope
    x = x + toothDepth;
    y = y + slopeWidth;
    coords(:, pointNum) = [x; y];
    pointNum = pointNum + 1;
    % Tooth top
    x = x + 0;
    y = y + toothTopFraction*toothPeriod/2;
    coords(:, pointNum) = [x; y];
    pointNum = pointNum + 1;
    % Second slope
    x = x - toothDepth;
    y = y + slopeWidth;
    coords(:, pointNum) = [x; y];
    pointNum = pointNum + 1;
    % Tooth bottom
    x = x + 0;
    y = y + toothTopFraction*toothPeriod/2;
    coords(:, pointNum) = [x; y];
    pointNum = pointNum + 1;
end
coords(:, pointNum) = [x; y];

if circular
    transformedCoords = [];
    radius = strokeLength / (2*pi);
    transformedCoords(1, :) = (radius+coords(1, :)).*cos(2*pi*coords(2, :)/strokeLength);
    transformedCoords(2, :) = (radius+coords(1, :)).*sin(2*pi*coords(2, :)/strokeLength);
    coords = transformedCoords;
end