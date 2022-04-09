function svgText = createAcrylicBox(boxSize, svgSavePath, thouPerTab, materialThickness, materialDims, door, tabFraction, tabTolerance)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% createAcrylicBox: Generate an SVG image of the pieces of a box with the
%                   given parameters, useful laser cutting.
%
% usage:  svgText = createAcrylicBox(boxSize, svgSavePath)
%         svgText = createAcrylicBox(boxSize, svgSavePath, thouPerTab)
%         svgText = createAcrylicBox(boxSize, svgSavePath, thouPerTab, 
%                                    materialThickness)
%         svgText = createAcrylicBox(boxSize, svgSavePath, thouPerTab, 
%                                    materialThickness, materialDims)
% where,
%    svgText is the text of the svg file
%    boxSize is a 1x3 vector giving the outside dimensions of the box in 
%       thou (thousandths of an inch). The untabbed side will have the 
%       dimensions given by the first two elements of this vector. For 
%       example, if the box size is [6000, 7000, 8000] (6in x 7in x 8in), 
%       one of the 6in x 7in sides will be the untabbed door of the box.
%    svgSavePath is the filepath to use to save the SVG file
%    thouPerTab (optional) is the length of each tab (innie + outie).
%       Default = 500 thou (0.5 inches) per tab
%    materialThickness (optional) is the thickness of the material the box 
%       will be cut from in thou. This determines the depth of the tabs. 
%       Default = 125 thou (1/8 inch)
%    materialDims (optional) is a 1x2 vector indicating the canvas size to 
%       make the SVG file with, in thou. This does not affect the box, just 
%       the canvas that SVG editors will display the box on when opened. 
%       Default = [24000, 12000]
%    door (optional) is a boolean flag indicating whether or not to include
%       a non-tabbed side to serve as a door
%    tabFraction (optional) is a number between 0 and 1 indicating what %
%       of each tab (innie + outie) is outie. The default, 0.5, produces 
%       equal sized tabs (outies) and gaps (innies).
%    tabTolerance (optional) is the amount in thou that each tab will be
%       oversized by in order to make a tighter fit with the gaps. Positive
%       numbers will result in oversized tabs (tighter fit), and a negative 
%       number will result in undersized (looser fitting) tabs. Default is
%       0 (tabs and gaps are laid out as equal sizes)
%
% This function creates an SVG file containing the outlines of the walls of
%   a box. If material is cut with a laser cutter using the output pattern 
%   of this script, the resulting pieces can be assembled into a box. The 
%   box has interlocking tabs, which allows for easier assembly and 
%   stronger bonding. The box also optionally features one side that is 
%   left un-tabbed, which can serve as a door or an opening. This script 
%   also outputs the SVG file as a char array, and displays a figure 
%   showing a preview of the shape created.
%
% See also: SVGDoc
%
% Version: 1.0
% Author:  Brian Kardon
% Email:   bmk27=cornell*org, brian*kardon=google*com
% Real_email = regexprep(Email,{'=','*'},{'@','.'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine # of tabs to include
if ~exist('thouPerTab', 'var') || isempty(thouPerTab)
    thouPerTab = 500;
end
numTabs = [0, 0, 0];
for k = 1:3
    dim = boxSize(k);
    numTabs(k) = ceil(dim/thouPerTab);
end

if ~exist('materialThickness', 'var') || isempty(materialThickness)
    materialThickness = 125;
end
if ~exist('materialDims', 'var') || isempty(materialDims)
    materialDims = [24000, 12000];
end

if ~exist('door', 'var') || isempty(door)
    door = true;
end

if ~exist('tabFraction', 'var') || isempty(tabFraction)
    tabFraction = 0.5;
end

if ~exist('tabTolerance', 'var') || isempty(tabTolerance)
    tabTolerance = 0;
end


% Shape determinations (F=flat-out, f=flat-in, O=outie, I=innie):
if door
    % Face shapes with un-tabbed side for door
    faceShapes = {
        ['f', 'O', 'I', 'O'];
        ['f', 'O', 'I', 'O']; 
        ['f', 'I', 'O', 'I'];
        ['f', 'I', 'O', 'I'];
        ['O', 'I', 'O', 'I'];
        ['F', 'F', 'F', 'F']};
else
    % Face shapes with no door
    faceShapes = {
        ['I', 'O', 'I', 'O'];
        ['I', 'O', 'I', 'O']; 
        ['O', 'I', 'O', 'I'];
        ['O', 'I', 'O', 'I'];
        ['O', 'I', 'O', 'I'];
        ['O', 'I', 'O', 'I']};
end
% Direction of each edge (corresponding to edge shapes above), given as a
% coordinate index
faceDirections = [
    [2, 3, 2, 3];
    [2, 3, 2, 3];
    [1, 3, 1, 3];
    [1, 3, 1, 3];
    [2, 1, 2, 1];
    [2, 1, 2, 1]
    ];
% Coordinate indices indicating which dimension each face is placed out on
faceCoordinateIndices = [1, 1, 2, 2, 3, 3];
% 
unitEdgeOffsets = [
    [ 1, 0];
    [ 0, 1];
    [-1, 0];
    [0, -1];
    ];

% Create all six sets of face coordiantes
faceCoordinates = {};
for faceNum = 1:6
    faceCoordinates{faceNum} = createFaceCoordinates(faceShapes{faceNum}, faceDirections(faceNum, :), boxSize, numTabs, materialThickness, tabFraction, tabTolerance);
end

% Initialize an SVGDoc object
s = SVGDoc(materialDims(1), materialDims(2));

% Spacing between faces in SVG
intraFaceDistance = 250;

% Draw each face to the SVG doc
offset = [0, 0];
for f = 1:length(faceCoordinates)
    singleFaceCoordinates = faceCoordinates{f};
    minX = min(singleFaceCoordinates(:, 1));
    minY = min(singleFaceCoordinates(:, 2));
    singleFaceCoordinates = singleFaceCoordinates - [minX, minY];
    maxX = max(singleFaceCoordinates(:, 1));
    singleFaceCoordinates = singleFaceCoordinates + offset;
    % Loop over line segments and add to SVG doc
    for k = 1:(size(singleFaceCoordinates, 1)-1)
        x1 = singleFaceCoordinates(k, 1);
        y1 = singleFaceCoordinates(k, 2);
        x2 = singleFaceCoordinates(k+1, 1);
        y2 = singleFaceCoordinates(k+1, 2);
        s.addLine(x1, y1, x2, y2, [], 'lasercutter')
    end
    offset = offset + [maxX + intraFaceDistance, 0];
end
% Display preview in figure
s.preview();
% Save SVG to file
s.saveSVG(svgSavePath);
% Return SVG text
svgText = s.createSVG();

function coords = createEdgeCoordinates(cornerCoords, edgeVector, numTabs, edgeType, tabFraction, materialThickness, tabTolerance)
% cornerCoords: coordinates of the initial corner of the edge, oriented
%   such that the edge vector goes CCW around the face
% edgeVector: vector representing the direction of the edge starting at the
%   corner moving CCW around the face, with length equal to the edge length
% numTabs: number of tabs to make on the edge
% tabFraction: The fraction of each tab cycle taken up by tab vs not tab
% tolerance: amount to increase or decrease the size of the tabs. 0 would
%   make the tabs and gaps fit perfectly (on paper). Negative values would
%   make the tabs fit tighter, postive values make the fit more loosely.

edgeLength = norm(edgeVector);
edgeHat = edgeVector/edgeLength;
edgeVector = edgeVector - 2*materialThickness*edgeHat;
edgeLength = norm(edgeVector);
tabVector = edgeHat * edgeLength/(1+numTabs/tabFraction);
tabLength = norm(tabVector);
gapVector = edgeHat * tabLength*((1-tabFraction)/tabFraction);

switch edgeType
    case 'I'
        tabTolerance = -tabTolerance;
        inVector = materialThickness * rotateEdge(edgeVector, -1) / norm(edgeVector);
        outVector = materialThickness * rotateEdge(edgeVector, 1) / norm(edgeVector);
        startCoords = edgeHat * materialThickness;
    case 'O'
        inVector = materialThickness * rotateEdge(edgeVector, 1) / norm(edgeVector);
        outVector = materialThickness * rotateEdge(edgeVector, -1) / norm(edgeVector);
        startCoords = outVector + edgeHat * materialThickness;
    case 'F'
        tabTolerance = -tabTolerance;
        inVector = materialThickness * rotateEdge(edgeVector, -1) / norm(edgeVector);
        outVector = materialThickness * rotateEdge(edgeVector, 1) / norm(edgeVector);
        startCoords = edgeHat * materialThickness;
    case 'f'
        inVector = materialThickness * rotateEdge(edgeVector, 1) / norm(edgeVector);
        outVector = materialThickness * rotateEdge(edgeVector, -1) / norm(edgeVector);
        startCoords = outVector + edgeHat * materialThickness;
end
endCoords = startCoords + edgeVector;
coords = startCoords;

for k = 1:numTabs
    if k == 1
        offset = [0, 0];
    else
        offset = tabTolerance*edgeHat;
    end
    coords(end+1, :) = coords(end, :) + tabVector - offset;
    coords(end+1, :) = coords(end, :) + inVector;
    coords(end+1, :) = coords(end, :) + gapVector + offset;
    coords(end+1, :) = coords(end, :) + outVector;
end
if numTabs > 0
    coords(end+1, :) = coords(end, :) + tabVector;
end
coords(end+1, :) = endCoords;

coords = coords + cornerCoords;

function faceCoordinates = createFaceCoordinates(edgeShapes, edgeDirections, boxSize, numTabs, materialThickness, tabFraction, tabTolerance)
faceCoordinates = [];

corners = {[0, 0], [1, 0], [1, 1], [0, 1], [0, 0]};
edgeSizes = boxSize(edgeDirections(1:2));

for edgeNum = 1:(length(corners)-1)
    edgeShape = edgeShapes(edgeNum);
    edgeDirection = edgeDirections(edgeNum);
    edgeSize = boxSize(edgeDirection);
    otherSize = boxSize(unique(edgeDirections(edgeDirections ~= edgeDirection)));
    if edgeShape == 'F' || edgeShape == 'f'
        currentNumTabs = 0;
    else
        currentNumTabs = numTabs(edgeDirection);
    end
    
    corner = corners{edgeNum} .* edgeSizes;
    nextCorner = corners{edgeNum+1} .* edgeSizes;
    
    edgeVector = nextCorner-corner;
    edge = createEdgeCoordinates(corner, edgeVector, currentNumTabs, edgeShape, tabFraction, materialThickness, tabTolerance);
    faceCoordinates = [faceCoordinates; edge];
end
faceCoordinates(end+1, :) = faceCoordinates(1, :);

function rotatedEdge = rotateEdge(edge, k)
% Rotate edge coordinates by k*90 degrees
rotatedEdge = edge * [cos(k*pi/2), -sin(k*pi/2); sin(k*pi/2), cos(k*pi/2)];