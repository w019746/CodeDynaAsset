%% Test Shock *Default* (Risky + Safe Asset + Save + Borr + R Shock + Interpolated-Percentage), Test over Shock Mean and SD (cross)
% *back to <https://fanwangecon.github.io Fan>'s
% <https://fanwangecon.github.io/CodeDynaAsset/ Dynamic Assets Repository>
% Table of Content.*
% *cross test*: given (x,y), vary x along X, y along Y, one at a time
%
% Compare against
% <https://fanwangecon.github.io/CodeDynaAsset/m_akz/test/ff_iwkz_ds_vecsv/test_shock/html/fsi_iwkz_ds_vecsv_shock_cross.html
% fsi_iwkz_ds_vecsv_shock_cross> from *iwkz*. Here, we use *ipwkz*.
%
% @include
%
% * <https://fanwangecon.github.io/CodeDynaAsset/m_az/solvepost/html/ff_az_test_analyze.html ff_az_test_analyze>
% * <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/paramfunc/html/ffs_ipwkbzr_set_default_param.html ffs_ipwkbzr_set_default_param>
%
% @seealso
%
% * test speed: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_speed/html/fsi_ipwkbzr_ds_vecsv_speed_default.html fsi_ipwkbzr_ds_vecsv_speed_default>
% * test joint *RANDOM*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_joint/html/fsi_ipwkbzr_ds_vecsv_joint_default_rand.html fsi_ipwkbzr_ds_vecsv_joint_default_rand>
%
% * test interest rate default: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_borr/html/fsi_ipwkbzr_ds_vecsv_default.html fsi_ipwkbzr_ds_vecsv_default>
% * test interest rate default *RANDOM*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_borr/html/fsi_ipwkbzr_ds_vecsv_default_rand.html fsi_ipwkbzr_ds_vecsv_default_rand>
% * test interest rate default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_borr/html/fsi_ipwkbzr_ds_vecsv_default_cross.html fsi_ipwkbzr_ds_vecsv_default_cross>
% * test interest rate no default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_borr/html/fsi_ipwkbzr_ds_vecsv_nbc_cross.html fsi_ipwkbzr_ds_vecsv_nbc_cross>
%
% * test preference default: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_pref/html/fsi_ipwkbzr_ds_vecsv_pref_default.html fsi_ipwkbzr_ds_vecsv_pref_default>
% * test preference default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_pref/html/fsi_ipwkbzr_ds_vecsv_pref_default_cross.html fsi_ipwkbzr_ds_vecsv_pref_default_cross>
% * test preference no default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_pref/html/fsi_ipwkbzr_ds_vecsv_pref_nbc_cross.html fsi_ipwkbzr_ds_vecsv_pref_nbc_cross>
%
% * test ymin and save r default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_price/html/fsi_ipwkbzr_ds_vecsv_price_default_cross.html fsi_ipwkbzr_ds_vecsv_price_default_cross>
% * test ymin and save r no default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_price/html/fsi_ipwkbzr_ds_vecsv_price_nbc_cross.html fsi_ipwkbzr_ds_vecsv_price_nbc_cross>
%
% * test preference default: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_prod/html/fsi_ipwkbzr_ds_vecsv_prod_default.html fsi_ipwkbzr_ds_vecsv_prod_default>
% * test production default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_prod/html/fsi_ipwkbzr_ds_vecsv_prod_default_cross.html fsi_ipwkbzr_ds_vecsv_prod_default_cross>
% * test production no default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_prod/html/fsi_ipwkbzr_ds_vecsv_prod_nbc_cross.html fsi_ipwkbzr_ds_vecsv_prod_nbc_cross>
%
% * test shock default: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_shock/html/fsi_ipwkbzr_ds_vecsv_shk_default.html fsi_ipwkbzr_ds_vecsv_shk_default>
% * test shock default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_shock/html/fsi_ipwkbzr_ds_vecsv_shk_default_cross.html fsi_ipwkbzr_ds_vecsv_shk_default_cross>
% * test shock no default *CROSS*: <https://fanwangecon.github.io/CodeDynaAsset/m_ipwkbzr/test/ff_ipwkbzr_ds_vecsv/test_shock/html/fsi_ipwkbzr_ds_vecsv_shk_nbc_cross.html fsi_ipwkbzr_ds_vecsv_shk_nbc_cross>
%

%% Set Shared Parameters

% Borrowing/Savings Parameters
bl_default = true;

%% Simulate and Graph

% Set which to graph, simulate over which variables
bl_simu_cross = 'c';
cl_st_param_keys = {'fl_z_wage_rho', 'fl_z_wage_sig'};

% Generate Benchmark Parameters
it_param_set = 9;
[param_map, support_map] = ffs_ipwkbzr_set_default_param(it_param_set);

% Borrowing Parameters
param_map('bl_default') = bl_default;

% Support Parameters
support_map('bl_replacefile') = false;
support_map('bl_graph_onebyones') = true;
support_map('bl_display_graph_stats') = false;
support_map('st_mat_test_prefix') = ['dft_'];

% Generate Arrays of Parameter Values to Loop Over
it_simu_vec_len = 15;
param_tstar_map = containers.Map('KeyType','char', 'ValueType','any');
param_tstar_map('fl_z_wage_rho') = linspace(0, 0.985, it_simu_vec_len);
param_tstar_map('fl_z_wage_sig') = linspace(0.05, 0.65, it_simu_vec_len);

%% Quick Grid Simulation (Limited Graphs)
it_size_type = 1;
ar_it_plot_sets = [3,4,102, 104,105,106];

% Simulate along parameters
ff_az_test_analyze( ...
    ar_it_plot_sets, bl_simu_cross, it_size_type, cl_st_param_keys, ...
    param_map, support_map, param_tstar_map);

close all;

%% Medium Grid Simulation (Limited Graphs)
it_size_type = 2;
ar_it_plot_sets = [3,4,102, 104,105,106];

% Simulate along parameters
ff_az_test_analyze( ...
    ar_it_plot_sets, bl_simu_cross, it_size_type, cl_st_param_keys, ...
    param_map, support_map, param_tstar_map);

close all;

%% Larger Grid Simulation
it_size_type = 3;
ar_it_plot_sets = [1,2,101, 3,4,102, 5,6,103, 51,52,53, 201,205,207, 104,106,10];

% Simulate along parameters
[tb_outcomes, ~ ] = ff_az_test_analyze( ...
    ar_it_plot_sets, bl_simu_cross, it_size_type, cl_st_param_keys, ...
    param_map, support_map, param_tstar_map);

close all