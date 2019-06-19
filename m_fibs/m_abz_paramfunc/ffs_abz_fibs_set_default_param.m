%% Set Model Parameters (ABZ FIBS)
% *back to <https://fanwangecon.github.io Fan>'s
% <https://fanwangecon.github.io/CodeDynaAsset/ Dynamic Assets Repository>
% Table of Content.*

%%
function [param_map, support_map] = ffs_abz_fibs_set_default_param(varargin)
%% FFS_ABZ_FIBS_SET_DEFAULT_PARAM setting model default parameters
% two groups of default parameters stored in container maps
%
% @param it_subset integer default parameter control subsetting. it_subset = 1 is
% basic invoke quick test. it_subset = 2 is main invoke. it_subset = 3 is
% profiling invoke. it_subset = 4 is matlab publish.
%
% @param bl_display_defparam boolean local printing
%
% @return param_map container parameters needed for solving the model
%
% @return support_map container programming control parameters like to graph to print etc
%
% @example
%
%   it_param_set = 1;
%   [param_map, support_map] = ffs_abz_fibs_set_default_param(it_param_set);
%

%% Default

it_subset = 0;
bl_display_defparam = false;
default_params = {it_subset bl_display_defparam};
[default_params{1:length(varargin)}] = varargin{:};
[it_subset, bl_display_defparam] = default_params{:};

%% Setting param_map container

param_map = containers.Map('KeyType','char', 'ValueType','any');

% Preferences
param_map('fl_crra') = 1.5;
param_map('fl_beta') = 0.94;

% Shock Parameters
param_map('it_z_n') = 15;
param_map('fl_z_mu') = 0;
param_map('fl_z_rho') = 0.8;
param_map('fl_z_sig') = 0.2;

% Borrowing
% fl_default_aprime is the next period asset level
% households face if they default.
param_map('fl_b_bd') = -20; % borrow bound, = 0 if save only
param_map('fl_default_aprime') = 0;
param_map('bl_default') = 1; % if borrowing is default allowed

% Savings
param_map('fl_a_min') = 0; % if there is minimum savings requirement
param_map('fl_a_max') = 50;
param_map('bl_loglin') = false; % log lin threshold structure
param_map('fl_loglin_threshold') = 1; % dense points before 1
param_map('it_a_n') = 750;

% Prices
param_map('fl_w') = 1.28;
param_map('fl_r_save') = 0.025;
param_map('fl_r_borr') = 0.035;

% formal informal parameters
% fl_for_br_block are the formal borrowing grid block sizes.
param_map('fl_r_inf') = 0.06;
param_map('fl_r_fsv') = 0.01;
param_map('fl_r_fbr') = 0.035;
param_map('fl_for_br_block') = -1;
param_map('bl_b_is_principle') = false;
% see: ffs_for_br_block.m
param_map('st_forbrblk_type') = 'seg3';
param_map('fl_forbrblk_brmost') = -10;
param_map('fl_forbrblk_brleast') = -1;
param_map('fl_forbrblk_gap') = -1;

% Minimum Consumption, c_min is for default, when c < 0, replace utility
% with fl_nan_replace.
param_map('fl_c_min') = 0.001;
param_map('fl_nan_replace') = -9999;

% Solution Accuracy
param_map('it_maxiter_val') = 1000;
param_map('fl_tol_val') = 10^-5;
param_map('fl_tol_pol') = 10^-5;
param_map('it_tol_pol_nochange') = 25; % number of iterations where policy does not change

%% Setting support_map container

support_map = containers.Map('KeyType','char', 'ValueType','any');
% root directory
[st_root_path] = preamble();
st_matimg_path_root = [st_root_path '/m_fibs/'];
support_map('st_matimg_path_root') = st_matimg_path_root;
% timer
support_map('bl_time') = true;
% Print Controls
support_map('bl_display') = true;
support_map('it_display_every') = 5; % how often to print results
% Profile Controls
support_map('bl_profile') = false;
support_map('st_profile_path') = [st_matimg_path_root '/m_abz_solve/profile/'];
support_map('st_profile_prefix') = [''];
support_map('st_profile_name_main') = ['_default'];
support_map('st_profile_suffix') = ['_p' num2str(it_subset)];

support_map('bl_post') = false;
% Final Print
support_map('bl_display_final') = false; % print finalized results
support_map('it_display_final_rowmax') = 100; % max row to print (states/iters)
support_map('it_display_final_colmax') = 12; % max col to print (shocks)
% Mat File Controls
support_map('bl_mat') = false;
support_map('st_mat_path') = [st_matimg_path_root '/m_abz_solve/mat/'];
support_map('st_mat_prefix') = [''];
support_map('st_mat_name_main') = ['_default'];
support_map('st_mat_suffix') = ['_p' num2str(it_subset)];
% Graphing Controls
support_map('bl_graph') = false;
support_map('bl_graph_onebyones') = true;
support_map('bl_graph_val') = true;
support_map('bl_graph_pol_lvl') = true;
support_map('bl_graph_pol_pct') = true;
support_map('bl_graph_coh_t_coh') = true;
support_map('bl_graph_discrete') = true;

% Image Saving Controls (given graphing)
support_map('st_title_prefix') = '';
support_map('bl_img_save') = false;
support_map('st_img_path') = [st_matimg_path_root '/m_abz_solve/img/'];
support_map('st_img_prefix') = [''];
support_map('st_img_name_main') = ['_default'];
support_map('st_img_suffix') = ['_p' num2str(it_subset) '.png'];

% Sub-function graphing controls
support_map('bl_graph_funcgrids') = false;
support_map('bl_display_funcgrids') = false;
support_map('bl_display_minccost') = false;
support_map('bl_display_infbridge') = false;

%% Subset Options
%
% # it_subset = 1 is basic invoke quick test
% # it_subset = 2 is main invoke
% # it_subset = 3 is profiling invoke
% # it_subset = 4 is matlab publish.
%

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
        % close figures
        close all;
        % Main Run
        support_map('bl_time') = true;
        support_map('bl_display') = true;
        support_map('it_display_every') = 5;

        support_map('bl_post') = true;
        support_map('bl_display_final') = true;
        support_map('bl_mat') = false;
        support_map('bl_graph') = true;
        support_map('bl_graph_onebyones') = false;
        support_map('bl_img_save') = true;
        if (ismember(it_subset, [4]))
            support_map('bl_time') = false;
            support_map('bl_display') = false;
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