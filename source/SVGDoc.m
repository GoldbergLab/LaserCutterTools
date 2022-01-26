classdef SVGDoc < handle
    % SVGDoc A tool for creating a SVG image procedurally.
    %   This is a class that allows the user to draw an SVG image by adding
    %       geometric primitives. It also allows for adding styling 
    %       directly, or by reference to style classes.
    properties
        Width = 24000      % Width of document page
        Height = 12000     % Height of document page
        Classes            % List of style classes defined in document
        Objects            % List of geometrical objects added to document
    end
    methods
        function obj = SVGDoc(width, height)
            % Create an SVGDoc instance, which represents a SVG document,
            %   which can contain a few attributes, various shapes, and style
            %   classes.
            %   width = the width of the document
            %   height = the height of the document
            if exist('width', 'var') && ~isempty(width)
                obj.Width = 24000;
            end
            if exist('height', 'var') && ~isempty(height)
                obj.Height = 12000;
            end
            % Prep empty structs
            obj.Objects = struct('type', [], 'data', [], 'style', [], 'classNames', []);
            obj.Objects(1) = [];
            obj.Classes = struct('name', [], 'style', []);
            obj.Classes(1) = [];
            
            % Define a default style class
            obj.defineClass('default', 'stroke', '#000000', 'stroke-width', 50, 'stroke-opacity', 1, 'fill', 'none');
            obj.defineClass('lasercutter', 'stroke', '#ff0000', 'stroke-width', 1, 'stroke-opacity', 1, 'fill', 'none');
        end
        function addRect(obj, x, y, width, height, style, classNames)
            % Add a rectangle shape to the SVG document
            % x = upper left x-coordinate
            % y = upper left y-coordinate
            % width = width of rectangle
            % height = height of rectangle
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            classNames = handleClassNamesInput(obj, classNames);

            newIdx = length(obj.Objects)+1;
            obj.Objects(newIdx).type = 'rect';
            obj.Objects(newIdx).data.x = x;
            obj.Objects(newIdx).data.y = y;
            obj.Objects(newIdx).data.w = width;
            obj.Objects(newIdx).data.h = height;
            obj.Objects(newIdx).style = style;
            obj.Objects(newIdx).classNames = classNames;
        end
        function addCircle(obj, cx, cy, r, style, classNames)
            % Add a circle shape to the SVG document
            % cx = upper left x-coordinate of the center of the circle
            % cy = upper left y-coordinate of the center of the circle
            % r = radius of the circle
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            classNames = handleClassNamesInput(obj, classNames);

            newIdx = length(obj.Objects)+1;
            obj.Objects(newIdx).type = 'circle';
            obj.Objects(newIdx).data.cx = cx;
            obj.Objects(newIdx).data.cy = cy;
            obj.Objects(newIdx).data.r = r;
            obj.Objects(newIdx).style = style;
            obj.Objects(newIdx).classNames = classNames;
        end
        function addEllipse(obj, cx, cy, rx, ry, style, classNames)
            % Add an ellipse shape to the SVG document
            % cx = upper left x-coordinate of the center of the ellipse
            % cy = upper left y-coordinate of the center of the ellipse
            % rx = horizontal radius of the ellipse
            % ry = vertical radius of the ellipse
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            classNames = handleClassNamesInput(obj, classNames);

           newIdx = length(obj.Objects)+1;
            obj.Objects(newIdx).type = 'rect';
            obj.Objects(newIdx).data.cx = cx;
            obj.Objects(newIdx).data.cy = cy;
            obj.Objects(newIdx).data.rx = rx;
            obj.Objects(newIdx).data.ry = ry;
            obj.Objects(newIdx).style = style;
            obj.Objects(newIdx).classNames = classNames;
        end
        function addLine(obj, x1, y1, x2, y2, style, classNames)
            % Add a line shape to the SVG document
            % x1 = starting x-coordinate of the line
            % y1 = starting y-coordinate of the line
            % x2 = ending x-coordinate of the line
            % y2 = ending y-coordinate of the line
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            
            data.x1 = x1;
            data.y1 = y1;
            data.x2 = x2;
            data.y2 = y2;
            obj.addObject('line', data, style, classNames)

            classNames = handleClassNamesInput(obj, classNames);

            newIdx = length(obj.Objects)+1;
            obj.Objects(newIdx).type = 'line';
            obj.Objects(newIdx).data.x1 = x1;
            obj.Objects(newIdx).data.y1 = y1;
            obj.Objects(newIdx).data.x2 = x2;
            obj.Objects(newIdx).data.y2 = y2;
            obj.Objects(newIdx).style = style;
            obj.Objects(newIdx).classNames = classNames;
        end
        function addPolyline(obj, xs, ys, style, classNames)
            % Add a polyline shape to the SVG document
            % xs = list of x-coordinates for the polyline points
            % ys = list of y-coordinates for the polyline points
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            
            data.xs = xs;
            data.ys = ys;
            obj.addObject('polyline', data, style, classNames)
        end
        function addPolygon(obj, xs, ys, style, classNames)
            % Add a polygon shape to the SVG document
            % xs = list of x-coordinates for the polygon points
            % ys = list of y-coordinates for the polygon points
            % style = a SVG/CSS style string (can be left as empty string)
            % classNames = a single class name, or a cell array of class
            %   names. Class names must already be defined in this SVG
            %   document. Each class contains a set of styles to apply to
            %   the object.
            if ~exist('style', 'var') || isempty(style)
                style = '';
            end
            if ~exist('classNames', 'var') || isempty(classNames)
                classNames = 'default';
            end
            
            data.xs = xs;
            data.ys = ys;
            obj.addObject('polygon', data, style, classNames)
        end
        function addObject(obj, type, data, style, classNames)
            classNames = handleClassNamesInput(obj, classNames);

            newIdx = length(obj.Objects)+1;
            obj.Objects(newIdx).type = type;
            obj.Objects(newIdx).data = data;
            obj.Objects(newIdx).style = style;
            obj.Objects(newIdx).classNames = classNames;
        end
        function defineClass(obj, className, varargin)
            % Define a class in the document. This does not apply the class
            %   to any objects, but it creates it so it can be referenced
            %   by future objects.
            %   className = a char array name for the class. This can be
            %       used to refer to the class later. Note that the
            %       className 'default' is reserved.
            %   name, value: the rest of the arguments should be in name
            %       value pairs, and must be valid SVG/CSS style names and
            %       values.
            if ~obj.validateClassName(className)
                error('%s is not a valid class name. Class names should start with a letter, hyphen, or underscore, followed by at least one letter, number, hyphen, or underscore.', className);
            end
            if obj.isDefaultClass(className)
                % If default class 
                if obj.validateClass(className)
                    error('Class name ''default'' is reserved.');
                end
            end
            [classExists, classIdx] = obj.validateClass(className);
            if classExists
                warning('Class %s already exists, this will overwrite it.');
            else
                classIdx = length(obj.Classes) + 1;
            end
            obj.Classes(classIdx) = SVGDoc.constructClass(className, varargin{:});
        end
        function removeClass(obj, className)
            % Delete a class definition from the document. If any existing
            %   objects refer to this class and no others, then they will
            %   revert to the 'default' class.
            if obj.isDefaultClass(className)
                error('Cannot delete default class.');
            end
            [classExists, ~] = obj.validateClass(className);
            if ~classExists
                error('Cannot delete class %s - it doesn''t exist.', className);
            else
                objectIdx = obj.findObjectsByClass(obj, className);
                if ~isempty(objectIdx)
                    warning('%d objects refer to class %s. This will revert them to the default class.', length(objectIdx), className);
                end
                classIdx = find(strcmp(obj.Objects(objectIdx).classNames, className));
                obj.Objects(objectIdx).classNames{classIdx} = [];
                if isempty(obj.Objects(objectIdx).classNames)
                    obj.Objects(objectIdx).classNames = {'default'};
                end
            end
            
        end
        function isDefault = isDefaultClass(obj, className)
            isDefault = strcmp(className, 'default');
        end
        function objectIdx = findObjectsByClass(obj, className)
            usedClasses = cellfun(@(element)element.classNames, obj.Objects, 'UniformOutput', false);
            objectIdx = find(strcmp(className, usedClasses));
        end
        function svg = createSVG(obj)
            % Translate geometry and styling into SVG text markup. This
            %   creates and returns the text, but does not save it to file.
            allClassText = '';
            for classNum = 1:length(obj.Classes)
                classText = SVGDoc.createClassText(obj.Classes(classNum));
                allClassText = [allClassText, classText];
            end
            svgStart = [
            ['<?xml version="1.0" encoding="UTF-8"?>', newline], ...
            ['<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">', newline], ...
            ['<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="24in" height="12in" version="1.1" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd"', newline], ...
            [sprintf('viewBox="0 0 %d %d"', obj.Width, obj.Height), newline], ...
            [' xmlns:xlink="http://www.w3.org/1999/xlink">', newline], ...
            [' <defs>', newline], ...
            ['  <style type="text/css">', newline], ...
            [sprintf('   <![CDATA[%s]]>', allClassText), newline], ...
            ['  </style>', newline], ...
            [' </defs>', newline], ...
            ];
            svgGroupStart = ['  <g>', newline];
            svgGroupEnd = ['  </g>', newline];
            svgEnd = ['</svg>'];
            
            svg = svgStart;
            for k = 1:length(obj.Objects)
                element = obj.Objects(k);
                elementText = SVGDoc.createElementText(element);
                svg = [svg, elementText, newline];
            end
            svg = [svg, svgEnd];
        end
        function preview(obj)
            % Preview image in figure
            f = figure;
            ax = axes(f);
            for k = 1:length(obj.Objects)
                object = obj.Objects(k);
                style = obj.resolveStyle(object);
                previewStyle = {};
                for j = 1:length(style)
                    switch style(j).key
                        case 'fill'
                            if any(strcmp(object.type, {'rect', 'circle', 'ellipse', 'polygon'}))
                                % Only some shapes can handles a face color
                                % style
                                previewStyle{end+1} = 'FaceColor';
                                previewStyle{end+1} = style(j).value;
                            else
                                continue;
                            end
                        case 'stroke'
                            if any(strcmp(object.type, {'line', 'polyline'}))
                                previewStyle{end+1} = 'Color';
                            else
                                previewStyle{end+1} = 'EdgeColor';
                            end
                            previewStyle{end+1} = style(j).value;
                        case 'stroke-width'
                            previewStyle{end+1} = 'LineWidth';
                            previewStyle{end+1} = str2double(style(j).value)/1000;
                        otherwise
                            continue;
                    end
                end
                
                switch object.type
                    case 'rect'
                        rectangle(ax, 'Position', [object.data.x, object.data.y, object.data.w, object.data.h], previewStyle{:});
                    case 'line'
                        line(ax, [object.data.x1, object.data.x2], [object.data.y1, object.data.y2], previewStyle{:});
                    case 'circle'
                        rectangle(ax, 'Position', [object.data.cx-object.data.r, object.data.cy-object.data.r, 2*object.data.r, 2*object.data.r], 'Curvature', [1, 1], previewStyle{:});
                    case 'ellipse'
                        rectangle(ax, 'Position', [object.data.cx-object.data.rx, object.data.cy-object.data.ry, 2*object.data.rx, 2*object.data.ry], 'Curvature', [1, 1], previewStyle{:});
                    case 'polyline'
                        plot(ax, object.data.xs, object.data.ys, previewStyle{:})
                    case 'polygon'
                        patch(ax, 'XData', object.data.xs, 'YData', object.data.ys, previewStyle{:});
                end
            end
            axis(ax, 'equal');
            xlim(ax, [0, obj.Width]);
            ylim(ax, [0, obj.Height]);
            ax.YDir = 'reverse';
            ax.XAxisLocation = 'top';
            ax.YAxisLocation = 'left';
        end
        function style = resolveStyle(obj, object)
            % Resolve the effective style elements for the object,
            %   considering the "inline" style attributes, and those 
            %   derived from its classes.
            %   object = a geometrical object struct
            style = [];
            for j = 1:length(object.classNames)
                % Add in elements from class styles, overriding as we
                % go if necessary.
                [~, classIdx] = obj.validateClass(object.classNames{j});
                classElement = obj.Classes(classIdx);
                style = SVGDoc.updateStyle(style, classElement.style);
            end
            % Finally individually specified style overrides class
            % styles
            style = SVGDoc.updateStyle(style, object.style);
        end
        function saveSVG(obj, filepath)
            % Create svg file
            svg = obj.createSVG();
            fileID = fopen(filepath, 'w');
            fprintf(fileID, svg);
            fclose(fileID);
            
        end
        function [classExists, classIdx] = validateClass(obj, className)
            % Check if a class by the given name exists in this document,
            %   and if it does exist, what its index in the class list is.
            %   className = a char array representing a className to query
            if isempty(obj.Classes)
                classExists = false;
                classIdx = [];
                return;
            end
            classNames = {obj.Classes.name};
            classIdx = find(strcmp(className, classNames));
            classExists = ~isempty(classIdx);
        end
        function classNames = handleClassNamesInput(obj, classNames)
            % Do some className input parsing and sanity checking
            % classNames = one or more classNames as either a char array or
            %   a cell array.
            if ischar(classNames)
                % Single class name passed - wrap in cell array
                classNames = {classNames};
            end
            for k = 1:length(classNames)
                if ~obj.validateClass(classNames{k})
                    error('Class %s does not exist. Create it before using it.', classNames{k});
                end
            end
        end
    end
    methods (Static)
        function style = updateStyle(style, newStyle)
            % Merges new style into old style, adding or overwriting
            %   properties as necessary
            %   style = the style object to merge into
            %   newStyle = the style object (or style char array) to merge
            if ischar(newStyle)
                % Parse style if it is a char array
                newStyle = SVGDoc.parseStyle(newStyle);
            end
            for k = 1:length(newStyle)
                addIdx = length(style)+1;
                for j = 1:length(style)
                    if strcmp(style(j).key, newStyle(k).key)
                        % Overwrite value
                        addIdx = j;
                        break;
                    end
                end
                style(addIdx).key = newStyle(k).key;
                style(addIdx).value = newStyle(k).value;
            end
        end
        function style = parseStyle(styleString)
            % Convert a string style specification into a key/value struct
            %   styleString = a char array formatted as an SVG/CSS style
            %       string
            %   style = a style object
            statements = split(styleString, ';');
            style = [];
            for k = 1:length(statements)
                if isempty(statements{k})
                    continue;
                end
                parts = split(statements{k}, ':');
                if length(parts) ~= 2
                    error('Invalid style.')
                end
                key = strip(parts{1});
                value = strip(parts{2});
                if ~isnan(str2double(value))
                    value = str2double(value);
                end
                newIdx = length(style)+1;
                style(newIdx).key = key;
                style(newIdx).value = value;
            end
        end
        function classNameValid = validateClassName(className)
            classNameValid = ~isempty(regexp(className, '^[\_\-a-zA-Z][\_\-a-zA-Z0-9]+$', 'once'));
        end
        function newClass = constructClass(className, varargin)
            % Create a new class object, which is just a list of key/value
            % pairs specifying an object style.
            %   className = the char array name of the class to create
            %   name/value = name value pairs represent key/value pairs for
            %       the style definition
            if mod(length(varargin), 2) ~= 0
                error('Classes must be created with key/value pairs. Unpaired key found.');
            end
            newClass.name = className;
            for k = 1:length(varargin)
                styleNum = ceil(k/2);
                if mod(k, 2) == 1
                    newClass.style(styleNum).key = varargin{k};
                else
                    value = varargin{k};
                    if isnumeric(value)
                        value = num2str(value);
                    end
                    newClass.style(styleNum).value = value;
                end
            end
        end
        function classText = createClassText(classElement)
            % Create a CSS/SVG string from the class struct
            % classElement = the struct as stored in the Classes array
            keyValueFormat = '%s:%s;';
            classFormat = '.%s {%s}\n';
            styleTexts = arrayfun(@(element)sprintf(keyValueFormat, element.key, element.value), classElement.style, 'UniformOutput', false);
            styleText = strjoin(styleTexts, ' ');
            classText = sprintf(classFormat, classElement.name, styleText);
        end
        function elementText = createElementText(element)
            % Create a SVG tag string from the struct element
            % element = the struct representing a geometrical element as
            %   stored in the Objects array
            data = element.data;
            classNames = strjoin(element.classNames, ' ');
            switch element.type
                case 'circle'
                    elementText = sprintf('<circle class="%s" cx="%.3f" cy="%.3f" r="%.3f" />\n', classNames, data.cx, data.cy, data.r);
                case 'rect'
                    elementText = sprintf('<rect class="%s" x="%.3f" y="%.3f" width="%.3f" height="%.3f" />\n', classNames, data.x, data.y, data.w, data.h);
                case 'ellipse'
                    elementText = sprintf('<ellipse class="%s" cx="%.3f" cy="%.3f" rx="%.3f" ry="%.3f" />\n', classNames, data.cx, data.cy, data.rx, data.ry);
                case 'line'
                    elementText = sprintf('<line class="%s" x1="%.3f" y1="%.3f" x2="%.3f" y2="%.3f" />\n', classNames, data.x1, data.y1, data.x2, data.y2);
                case 'polyline'
                    coordinatePairFormat = '%.3f,%.3f ';
                    coordinatePairText = sprintf(coordinatePairFormat, [data.xs; data.ys]);
                    elementText = sprintf('<polyline class="%s" points="%s" />', classNames, coordinatePairText);
                case 'polygon'
                    coordinatePairFormat = '%.3f,%.3f ';
                    coordinatePairText = sprintf(coordinatePairFormat, [data.xs; data.ys]);
                    elementText = sprintf('<polygon class="%s" points="%s" />', classNames, coordinatePairText);
                otherwise
                    error('Unknown SVG element type: %s\n', element.type);
            end
        end        
    end
end