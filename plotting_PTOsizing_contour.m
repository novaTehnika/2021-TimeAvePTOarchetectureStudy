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
labelPTO = ["P-FF","P-VF","S-FF","S-VF","M-FF","P-FV","P-VV","S-FV","S-VV","M-FV"];

X = 1e-3*[[0,data(iPTO).S_ro(1,:)];[zeros(nD_w,1), data(iPTO).S_ro]];
Y = [zeros(1,nS_ro+1);[data(iPTO).D_w(:,1), data(iPTO).D_w]];
Z = 24*3600*[zeros(1,nS_ro+1);[zeros(nS_ro,1), data(iPTO).q_permTotal]];


% loadColors
inc = 250;
levels = [inc:inc:4000];
% color1 = maroon;
% color2 = gold;
nlines = length(levels);
% colorWeight = linspace(0,1,nlines);
% co = zeros(nlines,3);
% offset = 1e4;
% for i=1:nlines
%     co(i,:) = colorWeight(i)*color2 + colorWeight(nlines-(i-1))*color1;
% end

f = figure;
% ax1 = axes;
% colormap(f,turbo)
% s = surf(ax1,X,Y,Z,'EdgeColor','Interp','FaceColor','Interp');
% xlim([0 30])
% ylim([0 1])
% view(2)
% hold on
ax2 = axes;
[~,c1] = contour(ax2,X,Y,Z,levels,'-k','ShowText','on')
c1.LineWidth = lineWidth;
% ax2.Visible = 'off';
% ax2.XTick = [];
% ax2.YTick = [];
xlim([0 10])
ylim([0 1])
[M,I] = max(24*3600*data(iPTO).q_permTotal(:));

% scatter(1e-3*data(iPTO).S_ro(I),data(iPTO).D_w(I),100,'xk','Linewidth',lineWidth);
xlabel('Membrane Area (1000 m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('Permeate Production (L/s)')
title(['Permeate Production (m^3/day): ',labelPTO(iPTO)])

%% Plot production along specified pump displacement
Dw_target = [0.1,0.2,0.3,0.4,0.5];

bottomEdge = 1;
leftEdge = 3;
width = 3.5625; % one column: 3+9/16, two column: 7.5
height = 2.75;
fontSize = 8;
lineWidth = 1.5;

iPTO = 1;
labelPTO = ["P-FF","P-VF","S-FF","S-VF","M-FF","P-FV","P-VV","S-FV","S-VV","M-FV"];
legLabels = cell(length(Dw_target),1);

f = figure;
for i = 1:length(Dw_target)
    iD_wArray = find(D_wArray <= Dw_target(i),1,'last');
    iSro = find(24*3600*data(iPTO).q_permTotal(iD_wArray,:) > 50);

    X = 1e-3*[data(iPTO).S_ro(iD_wArray,iSro)];
    Y = 24*3600*[data(iPTO).q_permTotal(iD_wArray,iSro)];

    s = scatter(X,Y,'.')
    s.SizeData = 100;

    % plot(X,Y,'LineWidth',lineWidth')

    hold on
    legLabels(i) = {[num2str(Dw_target(i)),'m^3/rad']};
end


iD_wArray = find(D_wArray <= 0.3,1,'last');
iSro = find(data(iPTO).S_ro(iD_wArray,:) <= 1500,1,'last');
X = 1e-3*[data(iPTO).S_ro(iD_wArray,iSro)];
Y = 24*3600*[data(iPTO).q_permTotal(iD_wArray,iSro)];
s = scatter(X,Y,'xk')
s.SizeData = 100;
s.LineWidth = 5;
legLabels(i+1) = {['Selected design, 0.3m^3/rad']};

xlim([0 10])

leg = legend(char(legLabels));
leg.Location = 'best';
leg.FontSize = fontSize-1;
leg.FontName = 'Times';

xlabel('membrane area (1000 m^2)')
ylabel('production (m^3/day)')
title(['Annual Average Water Production'])
title(['Annual Average Water Production: ',labelPTO(iPTO)])

%% Plot with specified levels and compared to Yu and Jenne 2017
black = [0 0 0];
maroon = [122 0 25]/256;
gold = [255 204 51]/256;
blue = [0 75 135]/256;
orange = [226 100 55]/256;
green = [63 150 87]/256;
pink = [255 101 134]/256;
pink = [255 121 150]/256;
lightMaroon = ([1 1 1] - 0.5*([1 1 1]-maroon));

bottomEdge = 1;
leftEdge = 3;
width = 3.5625; % one column: 3+9/16, two column: 7.5
height = 2.75;
fontSize = 8;
lineWidth = 1;

D_w_YuJenne2017 = 0.5466; % [m^3/rad]
S_ro_YuJenne2017 = (2162)/1e3; % [1000m^2]
q_permTotal_YuJenne2017 = 1780; % [m^3/day]
q_permTotal_YuJenne2017_wPRV = 1480; % [m^3/day]
refColor_YuJenne2017 = 'r';

D_w_PFF = 0.23; % [m^3/rad]
S_ro_PFF = 3700/1e3; % [m^2]
q_permTotal_PFF = 0.0175673200663364*24*3600; % [m^3/day -> m^3/s]
refColor_PFF = blue;

% iPTO = iiPTO;
labelPTO = ["P-FF","P-VF","S-FF","S-VF","M-FF", ...
            "P-FV","P-VV","S-FV","S-VV","M-FV"];

X = 1e-3*[[0,data(iPTO).S_ro(1,:)];[zeros(nD_w,1), data(iPTO).S_ro]];
Y = [zeros(1,nS_ro+1);[data(iPTO).D_w(:,1), data(iPTO).D_w]];
Z = 24*3600*[zeros(1,nS_ro+1);[zeros(nS_ro,1), data(iPTO).q_permTotal]];

levels = [500:500:4000];

fig = figure;
fig.Units = 'inches';
fig.Position = [leftEdge bottomEdge width height ];

n_plots = 1;
ax1 = subplot(n_plots,1,1);
ax1.FontName = 'times';
ax1.FontSize = fontSize-1;
hold on

% PTO design data
[C,c1] = contour(X,Y,Z,levels,'-','ShowText','on');
c1.LineWidth = lineWidth;
c1.LineColor = 'k';
c1.HandleVisibility='off';

% reference contours
 % contour for ref, Yu and Jenne
[~,c2] = contour(X,Y,Z,[0 q_permTotal_YuJenne2017_wPRV],'--','ShowText','off');
c2.LineWidth = lineWidth*2;
c2.LineColor = refColor_YuJenne2017;
c2.HandleVisibility='off';
 % contour for PFF performance
[~,c3] = contour(X,Y,Z,[0 q_permTotal_PFF],':','ShowText','off');
c3.LineWidth = lineWidth*2;
c3.LineColor = refColor_PFF;
c3.HandleVisibility='off';

% reference markers
 % marker for ref, Yu and Jenne
s1 = scatter(S_ro_YuJenne2017,D_w_YuJenne2017,75,refColor_YuJenne2017,'x','LineWidth',lineWidth*1.5);
s1.HandleVisibility='off';
 % marker for PFF performance
s2 = scatter(S_ro_PFF,D_w_PFF,50,refColor_PFF,'o','LineWidth',lineWidth*1.5);
s2.HandleVisibility='off';

% dummy plots for legend
 % countour for architecture
p1 = plot(-99*[1, 0.5],-99*[1, 0.5],'-');
p1.LineWidth = c1.LineWidth;
p1.Color = c1.LineColor;
p1.LineStyle = c1.LineStyle;

 % contour for ref, Yu and Jenne
p2 = plot(-99*[1 1],-99*[1 1],'--');
p2.LineWidth = c2.LineWidth;
p2.Color = c2.LineColor;
p2.LineStyle = c2.LineStyle;
 % marker for ref, Yu and Jenne
s1dummy = scatter(-99*[1, 0.5],-99*[1, 0.5]);
s1dummy.Marker = s1.Marker;
s1dummy.CData = s1.CData;
s1dummy.SizeData = s1.SizeData;
s1dummy.LineWidth = s1.LineWidth;

 % contour for ref, PPF
p3 = plot(-99*[1 1],-99*[1 1],'--');
p3.LineWidth = c3.LineWidth;
p3.Color = c3.LineColor;
p3.LineStyle = c3.LineStyle;
 % marker for ref, PFF
s2dummy = scatter(-99*[1, 0.5],-99*[1, 0.5]);
s2dummy.Marker = s2.Marker;
s2dummy.CData = s2.CData;
s2dummy.SizeData = s2.SizeData;
s2dummy.LineWidth = s2.LineWidth;

xlim([0 20])
ylim([0 1])

clabel(C,c1,'Interpreter','latex','FontSize',fontSize-1,'fontname','Times')
xlabel('membrane area (1000 m^2)',...
    'FontSize',fontSize-1,'fontname','Times')
ylabel('displacement (m^3/rad)',...
    'FontSize',fontSize-1,'fontname','Times')
title("Permeate Production (m^3/day): "+labelPTO(iPTO),...
    'FontSize',fontSize,'fontname','Times')
if iPTO == 3 || iPTO == 4 || iPTO == 5 || iPTO == 8 || iPTO == 9 || iPTO == 10
    switch 1
        case 1
            title("Permeate Production (m^3/day): "+labelPTO(iPTO)+...
                " with 30 MPa Limit",...
                'FontSize',fontSize,'fontname','Times')
        case 2
            title("Permeate Production (m^3/day): "+labelPTO(iPTO)+...
                " with 20 MPa Limit",...
                'FontSize',fontSize,'fontname','Times')
    end
end

% legLabels = ["performance of "+labelPTO(iPTO),...
% labelPTO(iPTO)+" designs producing " + num2str(q_permTotal_YuJenne2017_wPRV) + "m^3/day", ...
% "reference design producing " + num2str(q_permTotal_YuJenne2017_wPRV)+"m^3/day"];
legLabels = [labelPTO(iPTO),...
labelPTO(iPTO)+" at " + num2str(q_permTotal_YuJenne2017_wPRV) + " m^3/day", ...
"ref. design A",...
labelPTO(iPTO)+" at " + num2str(q_permTotal_PFF,4) + " m^3/day", ...
"ref. design B"];
leg = legend(legLabels);
leg.Location = 'best';
leg.FontSize = fontSize-1;
leg.FontName = 'Times';


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
co_contour = zeros(nlines,3);
for i=1:nlines
    co_contour(i,:) = colorWeight(i)*color2 + colorWeight(nlines-(i-1))*color1; 
end


f = figure;
colormap(f,co_contour) % set colormap

[~,c1] = contour(data(iPTO1).S_ro,data(iPTO1).D_w,data(iPTO1).q_permTotal,'-','ShowText','on');
hold on 
[~,c2] = contour(data(iPTO2).S_ro,data(iPTO2).D_w,data(iPTO2).q_permTotal,levels,'--','ShowText','off');
c1.LineWidth = lineWidth;
c2.LineWidth = lineWidth;
xlabel('Membrane Area (m^2)')
ylabel('Displacement (m^3/rad)')
% zlabel('')
title(['Permeate Production (m^3/s): PTO ',num2str(iPTO1)])
