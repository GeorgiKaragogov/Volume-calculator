clear;
clc;

fileDir = uigetfile({'*.txt';'*.kpt'},'Open points file');
data = load(fileDir);

pointNumbers = data(:,1);
realPoints = data(:,2:4);

trianglesD = delaunay(realPoints(:,1),realPoints(:,2));
indexes = boundary(realPoints(:,1),realPoints(:,2),0);
indexes(1) = [];
borderPoints = [realPoints(indexes,1),realPoints(indexes,2),realPoints(indexes,3)];
bottomPoints = realPoints(:,1:2);

bottomPoints(:,3) = griddata(borderPoints(:,1),borderPoints(:,2),...
    borderPoints(:,3),bottomPoints(:,1),bottomPoints(:,2));

volume = 0;
for i = 1:1:length(trianglesD(:,1))
    currentX = [bottomPoints(trianglesD(i,1),1);bottomPoints(trianglesD(i,2),1);bottomPoints(trianglesD(i,3),1);...
        realPoints(trianglesD(i,1),1);realPoints(trianglesD(i,2),1);realPoints(trianglesD(i,3),1)];
    currentY = [bottomPoints(trianglesD(i,1),2);bottomPoints(trianglesD(i,2),2);bottomPoints(trianglesD(i,3),2);...
        realPoints(trianglesD(i,1),2);realPoints(trianglesD(i,2),2);realPoints(trianglesD(i,3),2)];
    currentZ = [bottomPoints(trianglesD(i,1),3);bottomPoints(trianglesD(i,2),3);bottomPoints(trianglesD(i,3),3);...
        realPoints(trianglesD(i,1),3);realPoints(trianglesD(i,2),3);realPoints(trianglesD(i,3),3)];
    [~, currentV] = convhull(currentX,currentY,currentZ);
    volume = volume + currentV;
end

figure
hold on
axis equal
title(['The object`s volume is ',sprintf('%.2fm3',volume)],'FontSize',16);
trianglesDB = delaunay(bottomPoints(:,1),bottomPoints(:,2));
trisurf(trianglesD,realPoints(:,1),realPoints(:,2),realPoints(:,3),'facecolor',[0.62,0.32,0.17],'edgecolor','k');
trisurf(trianglesDB,bottomPoints(:,1),bottomPoints(:,2),bottomPoints(:,3),'facecolor',[0.42,0.32,0.17],'edgecolor','k');
scatter3(realPoints(:,1),realPoints(:,2),realPoints(:,3),'filled','MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75]);
text(realPoints(:,1),realPoints(:,2),realPoints(:,3),num2cell(pointNumbers),'Color','y');

disp('Computation has been successful.')
disp(['The object`s volume is ',sprintf('%.2fm3',volume)])

