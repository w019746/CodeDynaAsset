%% Tests the IPKWZ_VF_VECSV Algorithm with varyin w (fl_y_min) CRS

close all

ar_fl_y_min = [0, 0.20, 1];
% ar_it_w_n = [25, 50];

for fl_y_min = ar_fl_y_min

    %% Simulate with current ar_it_w
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(['fl_y_min = ' num2str(fl_y_min)]);
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('');
    disp('');
    disp('');
    disp('');

    it_param_set = 4;
    [param_map, support_map] = ffs_ipwkz_set_default_param(it_param_set);

    % Simulation Accuracy
    param_map('it_w_perc_n') = 500;
    param_map('it_ak_perc_n') = param_map('it_w_perc_n');
    param_map('it_z_n') = 15;

    param_map('fl_coh_interp_grid_gap') = 0.01;
    param_map('fl_w_interp_grid_gap') = 0.01;
    param_map('it_c_interp_grid_gap') = 10^-4;

    % Iteration Limits
    % param_map('it_maxiter_val') = 2;

    % Turn on 2nd stage graphs
    support_map('bl_graph_evf') = true;
    support_map('bl_display_evf') = false;

    % Production Function Parameters
    % note shock is log normal
    param_map('fl_Amean') = 1.0265;
    param_map('fl_alpha') = 1;
    param_map('fl_delta') = 1;
    param_map('fl_r') = 0.03;
    param_map('fl_w') = fl_y_min;

    % Shock Parameter, iid shocks
    param_map('fl_z_rho') = 0;
    param_map('fl_z_sig') = 0.05;

    % Display Parameters
    support_map('bl_display') = false;
    support_map('bl_display_final') = true;
    support_map('bl_time') = true;
    % support_map('bl_profile') = false;


    % Call Program
    ff_ipwkz_vf_vecsv(param_map, support_map);


end
