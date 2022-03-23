%
%    This file is part of NOS-NOC.
%
%    NOS-NOC -- A software for NOnSmooth Numerical Optimal Control.
%    Copyright (C) 2022 Armin Nurkanovic, Moritz Diehl (ALU Freiburg).
%
%    NOS-NOC is free software; you can redistribute it and/or
%    modify it under the terms of the GNU Lesser General Public
%    License as published by the Free Software Foundation; either
%    version 3 of the License, or (at your option) any later version.
%
%    NOS-NOC is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%    Lesser General Public License for more details.
%
%    You should have received a copy of the GNU Lesser General Public
%    License along with NOS-NOC; if not, write to the Free Software Foundation,
%    Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
%
%
clear all
clc
close all
import casadi.*
%%
use_fesd = 1;
plot_solution_trajectory = 1;
%% Benchmark settings
% discretization settings
N_stages  = 3;
N_finite_elements = 1;

%% Experiment Set Up
n_s = 5; % number of irk stages
T = 2;
ts = 1; % eact switching time
N_sim  = 20;
T_sim = T/N_sim;
h = T_sim/(N_stages*N_finite_elements);
%% settings
% collocation settings
settings = default_settings_fesd();
settings.collocation_scheme = 'radau';     % Collocation scheme: radau or legendre
settings.mpcc_mode = 5;
settings.s_elastic_max = 1e1;              % upper bound for elastic variables
% Penalty/Relaxation paraemetr
comp_tol = 1e-16;
settings.comp_tol = comp_tol;
settings.sigma_0 = 1e0;                     % starting smouothing parameter
settings.sigma_N = 1e-15;                     % starting smouothing parameter
settings.N_homotopy = 15;% number of steps
settings.kappa = 0.05;                      % decrease rate
%^ IPOPT Settings
opts_ipopt.verbose = 0;
opts_ipopt.ipopt.max_iter = 800;
opts_ipopt.ipopt.mu_strategy = 'adaptive';
opts_ipopt.ipopt.mu_oracle = 'quality-function';
opts_ipopt.ipopt.tol = comp_tol ;
opts_ipopt.ipopt.honor_original_bounds = 'yes';
opts_ipopt.ipopt.bound_relax_factor = 1e-16;
settings.opts_ipopt = opts_ipopt;
% finite elements with switch detection
settings.use_fesd = use_fesd;       % turn on moving finite elements algortihm
settings.fesd_complementartiy_mode = 3;       % turn on moving finite elements algortihm
settings.gamma_h = 1;
% how much can h addapt
settings.equidistant_control_grid = 0;
%% Time settings
omega = 2*pi;
% analytic solution
x_star = [exp(1);0];
s_star = [exp(2)  0; exp(2)*2*omega exp(2)];
t1_star = 1; % optimal siwtch points
T = 2;                            % time budget of transformed pseudo time
T_sim = T;
model.N_stages = N_stages;
model.N_finite_elements = N_finite_elements;



settings.n_s = n_s;

% update step size
model.T = T_sim;
model.T_sim = T_sim;
model.h = h;
model.N_sim = N_sim;
model = oscilator(model);
%% Call integrator
[results,stats] = integrator_fesd(model,settings);
% numerical error
x_fesd = results.x_res(:,end);
error_x = norm(x_fesd-x_star,"inf");
% complementarity
max_complementarity_exp = max(stats.complementarity_stats);
fprintf('Error with (h = %2.5f, n_s = %d ) is %5.2e : \n',h,n_s,error_x);
fprintf('Complementarity residual %5.2e : \n',max_complementarity_exp);

%% plot_solution_trajectory
diff_states = results.x_res;
h_opt_full = results.h_vec;
x1_opt = diff_states(1,:);
x2_opt = diff_states(2,:);
tgrid = cumsum([0;h_opt_full]);
figure
subplot(121)
plot(tgrid,x1_opt,'linewidt',1.0);
grid on
hold on
plot(tgrid,x2_opt,'linewidt',1.0);
xline(1)
xlabel('$t$','interpreter','latex');
ylabel('$x(t)$','interpreter','latex');
legend({'$x_1(t)$','$x_2(t)$'},'interpreter','latex');
%         xlim([1-1e-5 1+1e-5])
%         ylim([0-1e-5 0+1e-5])
subplot(122)
plot(x1_opt,x2_opt,'linewidt',1.8);
hold on
fimplicit(@(x,y) (x-0).^2+(y-0).^2-1^2, [-3 3],'r','linewidth',1.5)
xlabel('$x_1$','interpreter','latex');
ylabel('$x_2$','interpreter','latex');
axis equal
grid on
[X,Y] = meshgrid(-3:0.35:3,-3:0.35:3);
[U,V] = oscilator_eval(X,Y);
quiver(X,Y,U,V,'Color',0.65*ones(3,1),'LineWidth',1.2,'AutoScaleFactor',3);

xlim([-exp(1) exp(1)]*1.01)
ylim([-exp(1) exp(1)]*0.9)
%%
figure
stairs(results.h_vec)
xlabel('integration step')
ylabel('$h$','Interpreter','latex');
%%