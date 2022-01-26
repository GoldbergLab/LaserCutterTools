function [xs, ys] = createGear(numTeeth, toothDepth, strokeLength, toothTopFraction, circular)
toothPeriod = strokeLength/numTeeth;
slopeWidth = (1-toothTopFraction)*toothPeriod/2;

initialX = -toothDepth/2;
initialY = 0;
x = initialX;
y = initialY;

pointNum = 1;
xs = [];
ys = [];
for toothNum = 1:numTeeth
    xs(pointNum) = x; ys(pointNum) = y;
    pointNum = pointNum + 1;
    % First slope
    x = x + toothDepth;
    y = y + slopeWidth;
    xs(pointNum) = x; ys(pointNum) = y;
    pointNum = pointNum + 1;
    % Tooth top
    x = x + 0;
    y = y + toothTopFraction*toothPeriod/2;
    xs(pointNum) = x; ys(pointNum) = y;
    pointNum = pointNum + 1;
    % Second slope
    x = x - toothDepth;
    y = y + slopeWidth;
    xs(pointNum) = x; ys(pointNum) = y;
    pointNum = pointNum + 1;
    % Tooth bottom
    x = x + 0;
    y = y + toothTopFraction*toothPeriod/2;
    xs(pointNum) = x; ys(pointNum) = y;
    pointNum = pointNum + 1;
end
xs(pointNum) = x; ys(pointNum) = y;

if circular
    % "Wrap" gear around a circle
    radius = strokeLength / (2*pi);
    transformedX = (radius + xs) .* cos(2*pi*ys/strokeLength);
    transformedY = (radius + xs) .* sin(2*pi*ys/strokeLength);
    xs = transformedX;
    ys = transformedY;
else
    % Add body to the gear
    depth = strokeLength/(2*pi);
    xs(end+1) = -depth;
    ys(end+1) = ys(end);
    xs(end+1) = -depth;
    ys(end+1) = 0;
end