%% Plot 
variableToPlot = 3;

iiSS = find([data.design(end,end,:).feasible]);
switch variableToPlot
    case 1
        Y = [data.design(end,end,iiSS).S_ro];
        xLim = [0 3700];
        bins = 0:100:3700;
        varLabel = 'membrane area (m^2)';
        varTitle = 'Active Membrane Area';
    case 2
        Y = [data.design(end,end,iiSS).D_w];
        xLim = [0 D_w];
        bins = linspace(0,D_w,20);
        varLabel = 'membrane area (m^2)';
        varTitle = 'Active Membrane Area';
    case 3
        Y = [data.design(end,end,iiSS).duty];
        xLim = [0 1];
        bins = linspace(0,1,20);
        varLabel = 'duty';
        varTitle = 'Switching Valve Duty';
end


black = [0 0 0];
maroon = [122 0 25]/256;
gold = [255 204 51]/256;
blue = [0 75 135]/256;
orange = [226 100 55]/256;
green = [63 150 87]/256;
pink = [255 101 134]/256;
pink = [255 121 150]/256;
lightMaroon = ([1 1 1] - 0.5*([1 1 1]-maroon));

bottomEdge = 3;
leftEdge = 3;
width = 3.5625; % one column: 3+9/16, two column: 7.5
height = 1.5;
fontSize = 8;
lineWidth = 1;

% iPTO = iiPTO;
labelPTO = ["P-FF","P-VF","S-FF","S-VF","M-FF", ...
            "P-FV","P-VV","S-FV","S-VV","M-FV"];

fig = figure;
fig.Units = 'inches';
fig.Position = [leftEdge bottomEdge width height ];

n_plots = 1;
ax1 = subplot(n_plots,1,1);
ax1.FontName = 'times';
ax1.FontSize = fontSize-1;
hold on



% PTO design data
h1 = histogram(Y,bins);
h1.FaceColor = maroon;
h1.FaceAlpha = 1;
h1.EdgeColor = 'k';
h1.LineWidth = 0.1;

xlim(xLim)
% ylim([0 12])
grid on

xlabel(varLabel,...
    'FontSize',fontSize-1,'fontname','Times')
ylabel('count',...
    'FontSize',fontSize-1,'fontname','Times')
title(varTitle + " Specification Count: " + labelPTO(iPTO),...
    'FontSize',fontSize,'fontname','Times')
