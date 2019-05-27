function [param_map, support_map] = ffs_az_default_param(varargin)
%% Defaults
params_len = length(varargin);
if params_len > 1
    error('cm_test_a:TooManyOptionalParameters', ...
          'allows at most 1 optional parameters');
end

it_subset = 0;
default_params = {it_subset};
[default_params{1:params_len}] = varargin{:};
it_subset = default_params{:};

%% Main Setting
param_map = containers.Map('KeyType','char', 'ValueType','any');
% Preferences
param_map('fl_crra') = 1.5;
param_map('fl_beta') = 0.94;
% Shock Parameters
param_map('it_z_n') = 25;
param_map('fl_z_mu') = 0;
param_map('fl_z_rho') = 0.8;
param_map('fl_z_sig') = 0.2;
% Choice vector
param_map('fl_b_bd') = 0; % borrow bound, = 0 if save only
param_map('fl_a_min') = 0; % if there is minimum savings requirement
param_map('fl_a_max') = 100;
param_map('bl_loglin') = true; % log lin threshold structure
param_map('fl_loglin_threshold') = 1; % dense points before 1
param_map('it_a_n') = 1000;
% Prices
param_map('fl_w') = 1.28;
param_map('fl_r') = 0.025;
% Minimum Consumption, utility lower bound (major impact parameter
param_map('fl_c_min') = 0.001;

% Solution Accuracy
param_map('it_maxiter_val') = 1000;
param_map('fl_tol_val') = 10^-5;
param_map('fl_tol_pol') = 10^-5;

support_map = containers.Map('KeyType','char', 'ValueType','any');
support_map('bl_display') = true;
support_map('it_display_every') = 10; % how often to print results
support_map('bl_graph') = false;
support_map('bl_graph_onebyones') = false;
support_map('bl_time') = false;
support_map('bl_profile') = false;
support_map('st_profile_path') = [pwd '/profile'];


%% Subset Options, Basic Testing Options
if (ismember(it_subset, [1,2,3,4]))
    if (ismember(it_subset, [1]))
        % TEST quick
        param_map('it_a_n') = 50;
        param_map('it_z_n') = 5;
        support_map('it_display_every') = 1;
    end
    if (ismember(it_subset, [3]))
        % Main Run
        support_map('bl_graph') = true;
        support_map('bl_time') = true;
    end
    if (ismember(it_subset, [3]))
        % Profile run
        support_map('bl_profile') = true;
        support_map('bl_display') = false; % don't print
        support_map('bl_time') = true;
    end
    if (ismember(it_subset, [4]))
        % Publish Run
        param_map('bl_display') = false; % don't print
        support_map('bl_graph') = true;
        support_map('bl_graph_onebyones') = true;
        support_map('bl_time') = true;
    end
end

end
