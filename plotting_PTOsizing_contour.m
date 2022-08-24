loadColors

iPTO = 4;
levels = [0 5 10 15 20 25 30 35 40];
color1 = maroon;
color2 = gold; 
lineWidth = 1.5;

% Construct color order
nlines = length(levels);
colorWeight = linspace(0,1,nlines);
co = zeros(nlines,3);
for i=1:nlines
    co(i,:) = colorWeight(i)*color2 + colorWeight(nlines-(i-1))*color1; 
end


f = figure;
colormap(f,co) % set colormap

[~,c1] = contourf(data(iPTO1).S_ro,data(iPTO1).D_w,24*3600*data(iPTO1).q_permTotal,'-','ShowText','on');
% [~,c1] = contourf(data(iPTO1).S_ro,data(iPTO1).D_w,data(iPTO1).q_permTotal,levels,'-','ShowText','on');
c1.LineWidth = lineWidth;
c2.LineWidth = lineWidth;
xlabel('Membrane Area (m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('')
title(['Permeate Production (m^3/s): PTO ',num2str(iPTO1)])
