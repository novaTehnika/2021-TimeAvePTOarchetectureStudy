%% Plot without specified levels
iPTO = 1;

f = figure;

[M,c1] = contour(1e-3*data(iPTO).S_ro,data(iPTO).D_w,24*3600*data(iPTO).q_permTotal,'-','ShowText','on')
c1.LineWidth = lineWidth;
hold on
xlabel('Membrane Area (1000 m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('Permeate Production (L/s)')
title(['Permeate Production (m^3/day): PTO ',num2str(iPTO)])


%% Plot with specified levels
lineWidth = 1.5;
iPTO = 1;

loadColors
levels = 500:500:3500;
color1 = maroon;
color2 = gold; 
nlines = length(levels);
colorWeight = linspace(0,1,nlines);
co = zeros(nlines,3);
for i=1:nlines
    co(i,:) = colorWeight(i)*color2 + colorWeight(nlines-(i-1))*color1; 
end

f = figure;
colormap(f,co)

[M,c1] = contour(1e-3*data(iPTO).S_ro,data(iPTO).D_w,24*3600*data(iPTO).q_permTotal,levels,'-','ShowText','on')
c1.LineWidth = lineWidth;
hold on
xlabel('Membrane Area (1000 m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('Permeate Production (L/s)')
title(['Permeate Production (m^3/day): PTO ',num2str(iPTO)])



%% Compare two PTOs
loadColors
iPTO1 = 1;
iPTO2 = 2;
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

[~,c1] = contour(data(iPTO1).S_ro,data(iPTO1).D_w,data(iPTO1).q_permTotal,'-','ShowText','on');
hold on 
[~,c2] = contour(data(iPTO2).S_ro,data(iPTO2).D_w,data(iPTO2).q_permTotal,levels,'--','ShowText','off');
c1.LineWidth = lineWidth;
c2.LineWidth = lineWidth;
xlabel('Membrane Area (m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('')
title(['Permeate Production (m^3/s): PTO ',num2str(iPTO1)])
