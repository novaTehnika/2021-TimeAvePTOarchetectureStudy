% study_PTOsizing.m script m-file
% AUTHORS:
% Jeremy Simmons (email: simmo536@umn.edu)
% University of Minnesota
% Department of Mechanical Engineering
%
% CREATION DATE:
% December 31, 2021
%
% PURPOSE:
% The purpose of this script is to perform a design study of PTO
% architectures for wave-powered reverse osmosis operating in a known 
% distibution of sea conditions. The script is set up to
% perform the same study for four different PTO architectures. 
% 
% The models used in the design study are simple, static models with that 
% include two-way coupling with the time-averaged simulation results of a
% WEC; the coupling is set up such that the reaction force from the PTO is   
% a function of the average WEC speed (or power absortion) and the average 
% WEC speed (or power absorption) is function of the reaction torque from 
% the PTO.
%
% In the design study, the WEC-driven pump displacement and RO module
% membrane area are varied across a grid of values. For each set
% of these design variables, an optimization is performed to select the
% nominal operating pressure of the system (either the RO feed pressure or 
% the pressure at the outlet of the WEC_driven pump depending on the PTO 
% architecture) and the switching duty (if applicable). This routine is
% performed for each sea state.
% 
% The optimization of the operating pressure and switching duty is a
% nonlinear, constrained optimization which seeks to maximize the permeate
% production subject to the following constraints:
% 1) the electrical power production meets or exceeds the electrical demand
% 2) the operating pressure at the RO module is within a prescribe range
% If the design does not meet these constraints, the value of zero is
% recorded as the permeate production rate for that design.
% 
% Once the results are obtained for the specified grid of design
% parameters, design parameters are selected for each sea state to give 
% optimal combinations based on four possible configurations:
% A) the WEC-driven pump and RO module size are fixed across all sea 
% conditions
% B) the WEC-driven pump is variable across all sea states while the active 
% RO module size is fixed
% C) the active RO module size is variable across all sea states while the
% WEC-driven pump displacement is fixed.
% D) Both the WEC-driven pump and active RO module size are variable across
% all sea states
% The design combinations are organized based on the largest allowable
% value for the two design parameters; the design parameters are selected 
% for each sea state from the set of designs that have design parameters 
% values are less than or equal to the maximum allowable value, when 
% variable by sea state. Otherwise, when the design parameter is fixed
% across the sea states, the set includes only designs that have the same 
% value of the fixed design parameter. The design with greatest permeate
% production is selected from the set of available designs in each sea
% state.
%
%
% FILE DEPENDENCIES:
% PTOsizing_multiSS.m
% zero2nan.m
% parameters_timeAvePTO.m
% loadColors.m
%
% UPDATES
% 12/31/2021 - created.
%
% Copyright (C) 2022  Jeremy W. Simmons II
% 
%   This program is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
% 
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License
%   along with this program. If not, see <https://www.gnu.org/licenses/>.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
clc

%% %%%%%%%%%%%%   SIMULATION/DESIGN PARAMETERS  %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialize parameter structure and get misc. base parameters 
par = parameters_timeAvePTO();

% bounds on pressures in system
bounds.p_f_bnds = [4e6 8e6]; % [Pa/Pa] Bounds for feed pressure
bounds.p_w_bnds = [4e6 30e6]; % [Pa/Pa] Bounds for pressure at WEC driven pump
bounds.D_bnds = [0.1 1]; % [-] bounds for valve switching duty

% WEC: load time averaged results for WEC performance
load('data_timeAveWEC_slim_XXXXX.mat')
par.T_c_data = T_c_data; % [Nm] Torque applied to WEC by PTO
par.PP_w_data = PP_w_data; % [W] Power transmitted by WEC to PTO
par.weight = weight; 
par.Hs = Hs;
par.Tp = Tp;
clearvars T_c_data PP_w_data weight Hs Tp

%% %%%%%%%%%%%%   Study Variables  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% WEC-driven pump displacment
nD_w = 101; % Size of array for displacment
% D_w = linspace(0.05,2,nD_w);
D_wArray = logspace(log10(0.01),log10(.75),nD_w); % [m^3/s] displacement

% membrane area in Ro module
S_roArray = [1500 3000 4500];% [m^2] membrane area
nS_ro = length(S_roArray); % Size of array for permeate coefficient

% Specify PTO configurations
iiPTO = [1 1 3 3];
design_case = [1 2 1 2];
nPTO = length(iiPTO);

% Specify the set of sea-states to design for
SSset = [ 1 2 3 4 5 6];
par.SSset = SSset;

%% %%%%%%%%%%%%   COLLECT DATA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iPTO = 1:nPTO
    for iS_ro = 1:nS_ro
        data(iPTO,iS_ro) = PTOsizing_multiSS(D_wArray,S_roArray(iS_ro), ...
                        bounds,iiPTO(iPTO),design_case(iPTO),par);
    end
end

%% %%%%%%%%%%%%   SAVE DATA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = ['data_PTOsizing_',date];
files = ls;
nfiles = size(files,1);
k = 1;
for j = 1:nfiles
    if strfind(files(j,:),filename)
        k = k+1;
    end
end
save([filename,'_',num2str(k)])

return

%% %%%%%%%%%%%%   PLOTTING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Cost Model


%% Plot results for each architecture on same plot
lines = [{'-'},{'-.'},{'--'},{':'}];
marker = [{'x'},{'s'},{'^'},{'*'}];
loadColors;
C = [black; maroon; blue; green];
figure
hold on
for iPTO = 1:nPTO
    for iS_ro = 1:nS_ro
        p(iPTO,iS_ro) = plot(1e3*data(iPTO,iS_ro).D_w(:),...
            1e3*data(iPTO,iS_ro).q_permTotal(:),...
            'Color', C(iPTO,:),'lineStyle',cell2mat(lines(iS_ro)),'lineWidth',1.5);
        p(iPTO,iS_ro).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
end

xLim = xlim;
yLim = ylim;
for iPTO = 1:nPTO
    scatter(-999,-999,50,C(iPTO,:),'filled','s')
end
for iS_ro = 1:nS_ro
    plot([-999 -998],[-999 -999],...
        'k','lineStyle',cell2mat(lines(iS_ro)),'lineWidth',1.5);
end
xlim(xLim)
ylim(yLim)

legend('PTO 1','PTO 2','PTO 3','PTO 4',...
    ['S_{ro}=',num2str(S_roArray(1)),'m^2'],...
    ['S_{ro}=',num2str(S_roArray(2)),'m^2'],...
    ['S_{ro}=',num2str(S_roArray(3)),'m^2'])
xlabel('Displacement (L/rad)')
ylabel('Permeate Production (L/s)')
title('Design Performance')



%% Plotting Cost
% Cost normalized by the cost per RO size
cost = @(D_w,S_ro,q_perm,lam_1,lam_2) ...
    (D_w + lam_1*S_ro + lam_2)./zero2nan(q_perm);

lines = [{'-'},{'-.'},{'--'},{':'}];
marker = [{'x'},{'s'},{'^'},{'*'}];
loadColors;
C = [black; maroon; blue; green];
figure
hold on
for iPTO = 1:nPTO
    for iS_ro = 1:nS_ro
        p(iPTO,iS_ro) = plot(1e3*data(iPTO,iS_ro).D_w(:),...
            cost(data(iPTO,iS_ro).D_w(:),S_roArray(iS_ro),24*3600*data(iPTO,iS_ro).q_permTotal(:),0.001,0.5),...
            'Color', C(iPTO,:),'lineStyle',cell2mat(lines(iS_ro)),'lineWidth',1.5);
        p(iPTO,iS_ro).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
end

xLim = xlim;
yLim = ylim;
for iPTO = 1:nPTO
    scatter(-999,-999,50,C(iPTO,:),'filled','s')
end
for iS_ro = 1:nS_ro
    plot([-999 -998],[-999 -999],...
        'k','lineStyle',cell2mat(lines(iS_ro)),'lineWidth',1.5);
end
xlim(xLim)
ylim(yLim)

legend('PTO 1','PTO 2','PTO 3','PTO 4',...
    ['S_{ro}=',num2str(S_roArray(1)),'m^2'],...
    ['S_{ro}=',num2str(S_roArray(2)),'m^2'],...
    ['S_{ro}=',num2str(S_roArray(3)),'m^2'])
xlabel('Displacement (L/rad)')
ylabel('Permeate Production (L/s)')
title('Design Performance')

%% mark minimum cost design
[~,iS_ro] = min(min(cost(1e3*D_w,S_ro,24*3600*q_permTotal,0.1,0.5)));
[~,iD_w] = min(cost(1e3*D_w(:,iS_ro),S_ro(:,iS_ro),24*3600*q_permTotal(:,iS_ro),0.1,0.5));
scatter(1e6*S_roArray(iS_ro),1e3*D_wArray(iD_w),50,'r*')

