function [ ] = plot_results_car_hysteresis(varargin)
close all
%[] = plot_results_throwing_ball(results,settings,model)
% crate and solve and OCP for an example time freezing problem


%%
import casadi.*
if nargin == 0
    error('Results and model should be forwarded to this function.')
elseif nargin == 1
    results = varargin{1};
    unfold_struct(results,'caller');
elseif nargin == 2
    results = varargin{1};
    settings = varargin{2};
    unfold_struct(results,'caller');
    unfold_struct(settings,'caller');
elseif nargin == 3
    results = varargin{1};
    settings = varargin{2};
    model = varargin{3};
    unfold_struct(results,'caller');
    unfold_struct(model,'caller');
    unfold_struct(settings,'caller');
else
        results = varargin{1};
    settings = varargin{2};
    model = varargin{3};
    stats = varargin{4};
    unfold_struct(results,'caller');
    unfold_struct(model,'caller');
    unfold_struct(settings,'caller');
%     unfold_struct(stats,'caller');
end
%%
N_finite_elements = N_finite_elements(1);
h_k = h_k(1);

%%
%  Colors
extensive_plots = 0;
blue = [0 0.4470 0.7410];
red = [0.8500 0.3250 0.0980];
organe = [0.9290 0.6940 0.1250];
grey = [0.85 0.85 0.85];
%%
n = n_x+n_u;
nn = n-1;
tgrid = linspace(0, T, N_stages+1);
tgrid_z = linspace(0, T, N_stages);
%% Read solutions

diff_states = w_opt(ind_x);
controls = w_opt(ind_u);
alg_states = w_opt(ind_z);

% differential states
for i = 1:n_x
    eval( ['x' num2str(i) '_opt = diff_states(' num2str(i) ':n_x+n_x*d:end);']);
end
%
% for i = 1:n_x
%     eval( ['x' num2str(i) '_opt = diff_states(' num2str(i) ':n_x:end);']);
% end

% convex multiplers
for i = 1:n_theta
    eval( ['theta' num2str(i) '_opt = alg_states(' num2str(i) ':n_z+n_z*(d-1):end);']);
    %     eval( ['theta' num2str(i) '_opt = alg_states(' num2str(i) ':n_z:end);']);
end
% lambdas
for i = 1:n_theta
    %     eval( ['lambda' num2str(i) '_opt = alg_states(' num2str(i+n_theta) ':n_z+n_z*d:end);']);
    eval( ['lambda' num2str(i) '_opt = alg_states(' num2str(i+n_theta) ':n_z+n_z*(d-1):end);']);
end
% mu
% lambdas
for i = 1:n_simplex
    %     eval( ['mu_opt = alg_states(' num2str(i+2*n_theta) ':n_z+n_z*d:end);']);
    eval( ['mu' num2str(i) '_opt = alg_states(' num2str(i+2*n_theta) ':n_z+n_z*(d-1):end);']);
end

for i = 1:n_u
    %     eval( ['mu_opt = alg_states(' num2str(i+2*n_theta) ':n_z+n_z*d:end);']);
    eval( ['u' num2str(i) '_opt = controls(' num2str(i) ':n_u:end);']);
end


if use_fesd
    h_opt = w_opt(ind_h);
    tgrid = (cumsum([0;h_opt]));
    tgrid_z = cumsum(h_opt)';
end

%%
if time_freezing
    figure
    tt = linspace(0,T,N_stages*N_finite_elements+1);
    plot(tt,x5_opt,'linewidth',1.2)
    hold on
    plot(tt,x5_opt,'.','color',blue,'MarkerSize',7)
    plot(tt(1:N_finite_elements:end),x5_opt(1:N_finite_elements:end),'k.','MarkerSize',9)
    plot(tt,tt,'k:')
    % grid on
    h = T/N_stages;
    for ii = 0:N_stages+1
        xline(h*ii,'k--')
    end
    % xlim([0 0.6])
    % ylim([0 0.6])
    axis equal
    xlim([0 T])
    ylim([0 T])
    xlabel('$\tau$ [Numerical Time]','interpreter','latex');
    ylabel('$t(\tau)$ [Phyisical Time]','interpreter','latex');
end
%%

%%
% figure
h_opt_stagewise = reshape(h_opt,N_finite_elements,N_stages);
if length(ind_tf)>1
    s_sot = w_opt(ind_tf);
elseif length(ind_tf) == 0
    s_sot = ones(N_stages,1);
else
    s_sot = w_opt(ind_tf)*ones(N_stages,1);
end
t_control_grid_pseudo = cumsum([0,sum(h_opt_stagewise)]);
t_control_grid_pseudo_streched = cumsum([0,sum(h_opt_stagewise).*s_sot']);

%% speed of time
if use_speed_of_time_variables
    figure
    stairs(tgrid(1:N_finite_elements:end),[s_sot;nan],'linewidth',1.2)
    xlabel('$\tau$','interpreter','latex');
    ylabel('$s(\tau)$','interpreter','latex');
    grid on
    hold on
    plot(tgrid(1:N_finite_elements:end),tgrid(1:N_finite_elements:end)*0+s_sot_min,'k--')
    plot(tgrid(1:N_finite_elements:end),tgrid(1:N_finite_elements:end)*0+s_sot_max,'k--')
    ylim([0 max(s_sot)*1.05])
end

%% numerical time grid
figure
subplot(211)
stairs(0:N_stages-1,sum(h_opt_stagewise),'k')
ylim([(1-gamma_h)*h (1+gamma_h)*h])
grid on
xlabel('Stage n','interpreter','latex');
ylabel('$h_n$','interpreter','latex');

subplot(212)
stairs(h_opt,'k')
grid on
xlabel('finite element','interpreter','latex');
ylabel('$h_{n,m}$','interpreter','latex');
ylim([(1-gamma_h)*h_k (1+gamma_h)*h_k])
%%
if mpcc_mode == 4
    ind_t = find([1;theta1_opt]>1e-2);
else
    ind_t = find(diff([nan;x5_opt;nan])>1e-5);
end
time_physical = x5_opt(ind_t);
%% plots in numerical time
figure
subplot(321)
plot(tgrid,x1_opt)
xlabel('$\tau$','Interpreter','latex')
ylabel('$q(\tau)$ ','Interpreter','latex')
grid on
subplot(322)
plot(tgrid,x2_opt)
xlabel('$\tau$','Interpreter','latex')
ylabel('$v(\tau)$ ','Interpreter','latex')
grid on
hold on
plot(tgrid,x2_opt*0+v1,'k-')
plot(tgrid,x2_opt*0+v2,'k-')
plot(tgrid,x2_opt*0+v_max,'r--')
subplot(323)
plot(tgrid,x3_opt)
xlabel('$\tau$','Interpreter','latex')
ylabel('$L(\tau)$ ','Interpreter','latex')
grid on

subplot(324)
plot(tgrid,x4_opt)
xlabel('$\tau$','Interpreter','latex')
ylabel('$w(\tau)$ ','Interpreter','latex')
grid on
ylim([-0.1 1.1]);
subplot(325)
plot(tgrid,x5_opt)
xlabel('$\tau$','Interpreter','latex')
ylabel('$t(\tau)$ ','Interpreter','latex')
grid on

subplot(326)
stairs(tgrid(1:N_finite_elements:end),[u1_opt;nan])
xlabel('$\tau$','Interpreter','latex')
ylabel('$u(\tau)$ ','Interpreter','latex')
grid on


%% plots in phyisicaltime
figure
subplot(221)
plot(x5_opt,x1_opt)
xlabel('$t$ ','Interpreter','latex')
ylabel('$q(t)$ ','Interpreter','latex')
grid on
subplot(222)
plot(x5_opt,x2_opt)
hold on
plot(x5_opt,x2_opt*0+v1,'k-')
plot(x5_opt,x2_opt*0+v2,'k-')
plot(x5_opt,x2_opt*0+v_max,'r--')
xlabel('$t$ ','Interpreter','latex')
ylabel('$v(t)$ ','Interpreter','latex')

grid on

subplot(223)
plot(x5_opt,x4_opt)
xlabel('$t$ ','Interpreter','latex')
ylabel('$w(t)$ ','Interpreter','latex')
ylim([-0.1 1.1]);
grid on
subplot(224)
stairs(x5_opt(1:N_finite_elements:end),[u1_opt;nan])
xlabel('$t$ ','Interpreter','latex')
ylabel('$u(t)$ ','Interpreter','latex')
grid on

%%
%% plots in phyisical time for paper
figure
subplot(221)
plot(x5_opt,x2_opt,LineWidth=1.5)
hold on
plot(x5_opt,x2_opt*0+v1,'k--',LineWidth=1.0)
plot(x5_opt,x2_opt*0+v2,'k--',LineWidth=1.0)
plot(x5_opt,x2_opt*0+v_max,'r--',LineWidth=1.5)
xlabel('$t$ ','Interpreter','latex')
ylabel('$v(t)$ ','Interpreter','latex')
grid on

subplot(222)
stairs(x5_opt(1:N_finite_elements:end),[u1_opt;nan],LineWidth=1.5)
ylim([-u_max*1.1 u_max*1.1])
xlim([0 max(x5_opt(1:N_finite_elements:end))])
xlabel('$t$ ','Interpreter','latex')
ylabel('$u(t)$ ','Interpreter','latex')
grid on

subplot(223)
plot(x5_opt,x4_opt,LineWidth=1.5)
xlabel('$t$ ','Interpreter','latex')
ylabel('$w(t)$ ','Interpreter','latex')
ylim([-0.1 1.1]);
grid on

ind_t = find(diff(x5_opt)>0.01);
ind_t_complement = find(abs(diff(x5_opt))<0.00000000000001);
x2_opt_phy = x2_opt;
x4_opt_phy = x4_opt;
x2_opt_phy(ind_t_complement) = nan;
x4_opt_phy(ind_t_complement) = nan;
subplot(224)
plot(x2_opt,x4_opt,linewidth=1.5)
hold on
% plot(x2_opt_phy,x4_opt_phy,linewidth=2)
% plot(x2_opt(ind_t),x4_opt(ind_t),linewidth=2)
grid on
ylim([-0.1 1.1])
ylabel('$w$','Interpreter','latex')
xlabel('$v$','Interpreter','latex')
tt = -3:0.5:3;
hold on
plot(tt*0+v1,tt,'k--')
plot(tt*0+v2,tt,'k--')
%     xline(v2)

%% phase plot

figure
if use_hystereis_model
    plot(x2_opt,x4_opt)
    grid on
    ylim([-0.1 1.1])
    ylabel('$w$ [hystheresis state]','Interpreter','latex')
    xlabel('$v$','Interpreter','latex')
    xline(v1)
    xline(v2)
else
    plot(x2_opt,x1_opt)
    grid on
    ylabel('$q$ [hystheresis state]','Interpreter','latex')
    xlabel('$v$','Interpreter','latex')
    xline(v2)
end

if use_hystereis_model
%     plot_vector_fields_car_hysteresis
end


%%  Homotopy complementarity stats
if nargin >= 4
figure
complementarity_stats = stats.complementarity_stats;
semilogy(complementarity_stats,'k',LineWidth=1.5)
xlabel('iter','interpreter','latex');
ylabel('Complementarity residual','interpreter','latex');
grid on
end

%% Time grids of numerical and physical time
figure
plot(tgrid,x5_opt,'k',LineWidth=1.5)
% grid on
% for ii = 1:N_stages
xline(cumsum(sum(h_opt_stagewise)),'b-')
yline(x5_opt(1:N_finite_elements:end),'r-')
xlabel('$t_{\mathrm{num}}$','Interpreter','latex')
ylabel('$t_{\mathrm{phy}}$','Interpreter','latex')
axis equal

%% Plot homotopy results
if 0
    x_iter = sol.W(ind_x,:);
    % x_iter =x_iter(1:d+1:end,:);
    x_iter1= x_iter(1:n_x:end,:);
    x_iter2= x_iter(2:n_x:end,:);
    figure
    plot(x_iter1,x_iter2)

    legend_str = {};
    for ii = 1:size(x_iter2,2)
        legend_str  = [legend_str ; ['iter ' num2str(ii)]];
    end
    legend(legend_str);
end



%% Algebraic variavbles
if 1
    for ii = 1:n_simplex
        figure
        subplot(311);
        for i = m_ind_vec(ii):m_ind_vec(ii)+m_vec(ii)-1
            eval( ['plot(tgrid_z,theta' num2str(i) '_opt);']);
            if  i == m_ind_vec(ii)
                hold on
            end
        end
        xlabel('$t$','interpreter','latex');
        ylabel('$\theta(t)$','interpreter','latex');
        hold on
        grid on
        legend_str= {};
        for i = m_ind_vec(ii):m_ind_vec(ii)+m_vec(ii)-1
            legend_str = [legend_str, ['$\theta_' num2str(i) '(t)$']];
        end
        legend(legend_str ,'interpreter','latex');
        subplot(312);
        for i = m_ind_vec(ii):m_ind_vec(ii)+m_vec(ii)-1
            eval( ['plot(tgrid_z,lambda' num2str(i) '_opt);']);
            if  i == m_ind_vec(ii)
                hold on
            end
        end
        xlabel('$t$','interpreter','latex');
        ylabel('$\lambda(t)$','interpreter','latex');
        hold on
        grid on
        legend_str= {};
        for i = m_ind_vec(ii):m_ind_vec(ii)+m_vec(ii)-1
            legend_str = [legend_str, ['$\lambda' num2str(i) '(t)$']];
        end
        legend(legend_str ,'interpreter','latex');
        subplot(313);
        eval( ['plot(tgrid_z,mu' num2str(ii) '_opt);']);
        xlabel('$t$','interpreter','latex');
        ylabel(['$\mu_' num2str(ii) '(t)$' ],'interpreter','latex');
        grid on
    end

end

end

