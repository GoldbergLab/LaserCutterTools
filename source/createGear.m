function [xs, ys] = createGear(numTeeth, toothDepth, strokeLength, toothTopFraction, circular)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createGear: procedural gear/rack profile coordinate generation
% usage:  [xs, ys] = createGear(numTeeth, toothDepth, strokeLength, 
%                               toothTopFraction, circular)
%
% where,
%    numTeeth is the number of teeth the gear or rack will have
%    toothDepth is the distance from the tip to the root of the teeth
%    strokeLength is the full length of the toothed surface. For circular
%       gears, this is the circumference of the "pitch circle". For linear
%       gears, it's merely the length.
%    toothTopFraction is the fraction of the tooth period that is either
%       the tip surface or the root surface, as opposed to the contact
%       surface.
%    circular is a boolean flag indicating whether to make a circular gear
%       (true) or a rack (false)
%    xs is a list of x coordinates defining the gear profile
%    ys is a list of y coordinates defining the gear profile.
%
% This is a function that creates a simple procedural gear, either circular
%   or linear (known as a rack). At the moment, it creates flat contact
%   surfaces, which is not ideal - the ideal shape would be an involute
%   of a circle. Future versions may have that option.
%
% The output of this function could be used, for example, to produce an
%   SVG file for laser cutting using the SVGDoc tool:
%
%   s = SVGDoc();
%   [x, y] = createGear(24, 75, 2*pi*(750/2), 0.5, true);
%   s.addPolygon(x, y, '', 'lasercutter');
%   s.preview()
%   s.saveSVG('gearTest.svg')
%
% See also: SVGDoc
%
% Version: 1.0
% Author:  Brian Kardon
% Email:   bmk27=cornell*org, brian*kardon=google*com
% Real_email = regexprep(Email,{'=','*'},{'@','.'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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