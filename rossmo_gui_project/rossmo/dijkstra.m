function [distance, steps, n_it] = dijkstra(distanceTable,startIndex,endIndex)

% we need a matrix DIJ with n lines and 3 columns, where 
% n = length of one side of the square matrix distanceTable
% DIJ column 1 = distance from startIndex to this point
% DIJ column 2 = this point has (1) or has not (0) been visited yet
% DIJ column 3 = point that was visited prior to this one on the shortest path

n=size(distanceTable,1);

%initialize DIJ
DIJ(1:n,1) = NaN(n,1);
DIJ(1:n,2) = zeros(n,1);
DIJ(1:n,3) = NaN(n,1);

% initialize output variables
distance = 0;
steps = []; 

% set start point (distance from start point = 0)
DIJ(startIndex,1) = 0;
endPoint = startIndex;

n_it = 0; % iteration counter
while endPoint ~= endIndex
  n_it = n_it+1; 
  DIJ(endPoint,2) = 1; % set this point as visited
  
  % find the cities that are connected with this one
  next_cities = find(~isnan(distanceTable(endPoint,:)));
  
  % loop over the connected cities
  for c = next_cities
    % if city has not yet been an end point
    if (DIJ(c,2)==0)
      % if distance of c is undefined OR
      % distance of c -> startIndex is longer than endPoint -> startIndex + c->endPoint
      if isnan(DIJ(c,1)) || DIJ(c,1) > DIJ(endPoint,1)+distanceTable(c,endPoint)
        % set distance from startIndex to this city
        DIJ(c,1) = DIJ(endPoint,1)+distanceTable(c,endPoint);
        % set prior to this city to endPoint
        DIJ(c,3) = endPoint;
      end
    end
  end
  
  % the next endPoint is the point as yet unvisited with the smallest distance
  unvisited = find(DIJ(:,2)==0);
  mdist = min(DIJ(unvisited,1));
  endPoint = find(DIJ(:,1)==mdist);
  
end

% set the distance for output
distance = DIJ(endIndex,1);

% find the steps to output by going backwards on third column of DIJ
endPoint = endIndex;
steps = [endPoint, steps];
while endPoint ~= startIndex
  endPoint = DIJ(endPoint,3);
  steps = [endPoint, steps];
end

end