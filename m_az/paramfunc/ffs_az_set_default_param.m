%% Generating model default parameters
function [param_map, support_map] = ffs_az_set_default_param(varargin)
%% Defaults
params_len = length(varargin);
if params_len > 1
    error('cm_test_a:TooManyOptionalParameters', ...
        'allows at most 1 optional parameters');
end

it_subset = 0;
bl_graph_defparam = false;
bl_display_defparam = false;
default_params = {it_subset bl_graph_defparam bl_display_defparam};
[default_params{1:params_len}] = varargin{:};
[it_subset, bl_graph_defparam, bl_display_defparam] = default_params{:};

%% Main Setting for param_map
param_map = containers.Map('KeyType','char', 'ValueType','any');
% Preferences
param_map('fl_crra') = 1.5;
param_map('fl_beta') = 0.94;
% Shock Parameters
param_map('it_z_n') = 11;
param_map('fl_z_mu') = 0;
param_map('fl_z_rho') = 0.8;
param_map('fl_z_sig') = 0.2;
% Choice vector
param_map('fl_b_bd') = 0; % borrow bound, = 0 if save only
param_map('fl_a_min') = 0; % if there is minimum savings requirement
param_map('fl_a_max') = 10;
param_map('bl_loglin') = false; % log lin threshold structure
param_map('fl_loglin_threshold') = 1; % dense points before 1
param_map('it_a_n') = 100;
% Prices
param_map('fl_w') = 1.28;
param_map('fl_r_save') = 0.025;
param_map('fl_r_borr') = 0.025;
% Minimum Consumption, utility lower bound (major impact parameter
param_map('fl_c_min') = 0.001;

% Solution Accuracy
param_map('it_maxiter_val') = 1000;
param_map('fl_tol_val') = 10^-5;
param_map('fl_tol_pol') = 10^-5;
param_map('it_tol_pol_nochange') = 25; % number of iterations where policy does not change

%% Setting for support_map
support_map = containers.Map('KeyType','char', 'ValueType','any');
% root directory
st_matimg_path_root = 'C:/Users/fan/CodeDynaAsset/m_az/';
support_map('st_matimg_path_root') = st_matimg_path_root;
% timer
support_map('bl_time') = true;
% Print Controls
support_map('bl_display') = true;
support_map('it_display_every') = 5; % how often to print results
% Profile Controls
support_map('bl_profile') = false;
support_map('st_profile_path') = [st_matimg_path_root '/solve/profile/'];
support_map('st_profile_prefix') = [''];
support_map('st_profile_name_main') = ['default'];
support_map('st_profile_suffix') = ['_p' num2str(it_subset)];

support_map('bl_post') = false;
% Final Print
support_map('bl_display_final') = false; % print finalized results
% Mat File Controls
support_map('bl_mat') = false;
support_map('st_mat_path') = [st_matimg_path_root '/solvepost/mat/'];
support_map('st_mat_prefix') = [''];
support_map('st_mat_name_main') = ['default'];
support_map('st_mat_suffix') = ['_p' num2str(it_subset)];
% Graphing Controls
support_map('bl_graph') = false;
support_map('bl_graph_onebyones') = true;
support_map('bl_graph_val') = true;
support_map('bl_graph_pol_lvl') = true;
support_map('bl_graph_pol_pct') = true;
% Image Saving Controls (given graphing)
support_map('st_title_prefix') = 'Final ';
support_map('bl_img_save') = false;
support_map('st_img_path') = [st_matimg_path_root '/solvepost/img/'];
support_map('st_img_prefix') = [''];
support_map('st_img_name_main') = ['default'];
support_map('st_img_suffix') = ['_p' num2str(it_subset) '.png'];

% Sub-function graphing controls
support_map('bl_graph_funcgrids') = false;
support_map('bl_display_funcgrids') = false;

%% Subset Options, Basic Testing Options
if (ismember(it_subset, [1,2,3,4]))
    if (ismember(it_subset, [1]))
        % TEST quick
        param_map('it_a_n') = 25;
        param_map('it_z_n') = 3;
        param_map('it_maxiter_val') = 50;
        param_map('it_tol_pol_nochange') = 1000;
        support_map('bl_display') = true;
        support_map('it_display_every') = 1;
    end
    if (ismember(it_subset, [2, 4]))
        % Main Run
        support_map('bl_time') = true;
        support_map('bl_display') = true;
        support_map('it_display_every') = 1;

        support_map('bl_post') = true;
        support_map('bl_display_final') = true;
        support_map('bl_mat') = true;
        support_map('bl_graph') = true;
        support_map('bl_graph_onebyones') = false;
        support_map('bl_img_save') = true;
        if (ismember(it_subset, [4]))
            support_map('bl_graph_onebyones') = true;
            support_map('bl_img_save') = false;
        end
    end
    if (ismember(it_subset, [3]))
        % Profile run
        support_map('bl_profile') = true;
        support_map('bl_display') = false; % don't print
        support_map('bl_time') = true;
    end
end

%% Display
if (bl_display_defparam)
    disp('param_map');
    disp(param_map);
    param_map_keys = keys(param_map);
    param_map_vals = values(param_map);
    for i = 1:length(param_map)
        st_display = strjoin(['pos =' num2str(i) '; key =' string(param_map_keys{i}) '; val =' string(param_map_vals{i})]);
        disp(st_display);
    end

    disp('support_map')
    disp(support_map);
    param_map_keys = keys(support_map);
    param_map_vals = values(support_map);
    for i = 1:length(support_map)
        st_display = strjoin(['pos =' num2str(i) '; key =' string(param_map_keys{i}) '; val =' string(param_map_vals{i})]);
        disp(st_display);
    end
end

end