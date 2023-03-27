
load("data_coulombPTO_dampingStudy_20220927_slim.mat")

load("SSset_top80.mat")
SSset_top80 = SSset;
load("SSset_top90.mat")
SSset_top90 = SSset;
load("randSSset_top80.mat")
randSSset_top80 = SSset(1:10);

% switch 1
%     case 1
%         SSset = SSset_top80;
%     case 2
%         SSset = SSset_top80;
% end

D = 1; % [m^3/rad]
eta_w = 0.9; 
p_c = 1e6; % [Pa]
A_perm = 2.57e-12;
S_ro = 2750;
p_osm = 2.275e6; % [Pa]
p_f = linspace(p_osm,8e6); % [Pa] feed pressure 


PP_ro = @(p_f) p_f.*S_ro*A_perm.*(p_f - p_osm);

bounds = [1,2];
figure
% for iSS = SSset_top90
%         plot(1e-6*T_c_data(iSS,:)/D,1e-3*PP_w_data(iSS,:),'--',"Color",0.25*[1 1 1])
%         hold on
% end

for iSS = 1:10
    SS = randSSset_top80(iSS)
        plot(1e-6*(T_c_data(iSS,:)/D*eta_w + p_c),1e-3*PP_w_data(iSS,:),'-',"Color",0.0*[1 1 1])
        hold on
end

plot(1e-6*p_f,1e-3*PP_ro(p_f),'-r')
