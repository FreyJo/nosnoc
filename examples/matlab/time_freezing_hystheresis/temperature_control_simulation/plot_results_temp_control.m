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
%% read solutions

diff_states = w_opt(ind_x);
controls = w_opt(ind_u);
alg_states = w_opt(ind_z);

% differential states
for i = 1:n_x
    eval( ['x' num2str(i) '_opt = diff_states(' num2str(i) ':n_x+n_x*d:end);']);
end
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

for i = 1:n_u_DAE
    %     eval( ['mu_opt = alg_states(' num2str(i+2*n_theta) ':n_z+n_z*d:end);']);
    eval( ['u' num2str(i) '_opt = controls(' num2str(i) ':n_u:end);']);
end


if finite_elements_with_switch_detection
    
%     eval( ['h_opt = controls(n_u:n_u:end);']);
    h_opt = w_opt(ind_h);
    tgrid = (cumsum([0;h_opt]));
    tgrid_z = cumsum(h_opt)';
end

%%
figure
tt = linspace(0,T,N_stages*N_finite_elements+1);
plot(tt,x3_opt,'linewidth',1.2)
hold on
plot(tt,x3_opt,'.','color',blue,'MarkerSize',7)
plot(tt(1:N_finite_elements:end),x3_opt(1:N_finite_elements:end),'k.','MarkerSize',9)
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



%%
% figure
if finite_elements_with_switch_detection
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
end
%%
if 0
figure
stairs(tgrid(1:N_finite_elements:end),[s_sot;nan],'linewidth',1.2)
xlabel('$\tau$','interpreter','latex');
ylabel('$s(\tau)$','interpreter','latex');
grid on
ylim([0.5 3.2])
end


%% plots in numerical time
figure
subplot(311)
plot(tgrid,x1_opt)
xlabel('$\tau$ [numerical time]','Interpreter','latex')
ylabel('$\theta(\tau)$ [temperature]','Interpreter','latex')
grid on
subplot(312)
plot(tgrid,x2_opt)
xlabel('$\tau$ [numerical time]','Interpreter','latex')
ylabel('$w(\tau)$ [hystheresis state]','Interpreter','latex')
grid on
subplot(313)
plot(tgrid,x3_opt)
xlabel('$\tau$ [numerical time]','Interpreter','latex')
ylabel('$t(\tau)$ [phyisical time]','Interpreter','latex')
grid on


%% plots in phyisicaltime
figure
subplot(211)
plot(x3_opt,x1_opt)
xlabel('$t$ [phyisical time]','Interpreter','latex')
ylabel('$\theta(t)$ [temperature]','Interpreter','latex')
hold on
grid on
yline(y1,'k--')
yline(y2,'k--')
subplot(212)
plot(x3_opt,x2_opt)
grid on

%% phase plot
figure
plot(x1_opt,x2_opt)
hold on
xline(y1,'k--')
xline(y2,'k--')
grid on
ylim([-0.1 1.1])
ylabel('$w$ [hystheresis state]','Interpreter','latex')
xlabel('$\theta$ [temperature]','Interpreter','latex')

%%


