function [x,y,distanceTable,TRI] = genDelaunayCity(x_km, y_km, npts)
% Generates a random city plan, with streets optimized
% into Delunay triangles

% generate the coordinates of intersections
x = rand(npts,1)*x_km;
y = rand(npts,1)*y_km;
distanceTable = nan(npts);
distanceTable(find(eye(npts)==1)) = 0;

% Delunay triangulation
TRI = delaunay(x,y);

% number of triangles
ntri = size(TRI,1);

% scalar euclidean distanceTable
dist = @(x1,x2,y1,y2) sqrt((x1-x2).^2 + (y1-y2).^2);

% iterate over triangles to compute euclidean distances
% between vertices
for it = 1:ntri
  indexes = TRI(it,:);
  pairs = nchoosek(indexes,2);
  npairs = size(pairs,1);
  for ip = 1:npairs
    pair = pairs(ip,:);
    ip1 = pair(1);
    ip2 = pair(2);
    x1 = x(ip1);
    x2 = x(ip2);
    y1 = y(ip1);
    y2 = y(ip2);
    pdist = dist(x1,x2,y1,y2);
    distanceTable(ip1,ip2) = pdist;
    distanceTable(ip2,ip1) = pdist;
  end
  
end

end