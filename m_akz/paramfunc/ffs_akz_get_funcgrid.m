%% Generate States/Choices/Shocks Grids, get Functions (Interpolated + Risky + Safe Asset)
% *back to <https://fanwangecon.github.io Fan>'s
% <https://fanwangecon.github.io/CodeDynaAsset/ Dynamic Assets Repository>
% Table of Content.*

%%
function [armt_map, func_map] = ffs_akz_get_funcgrid(varargin)
%% FFS_AKZ_GET_FUNCGRID get funcs, params, states choices shocks grids
% Centralized gateway for retrieving parameters, and solution grids and
% functions.
%
% This function services both
% <https://github.com/FanWangEcon/CodeDynaAsset/tree/master/m_akz m_akz> as
% well as <https://github.com/FanWangEcon/CodeDynaAsset/tree/master/m_akbz
% m_akbz> functions. This means that the function here support solving both
% the borrowing as well as the savings problems.
%
% Note that while we have several versions of algorithms, one version
% requires interpolation, so there are several matrixes and vectors below
% that are specifically for that. These interpolation related matrixes and
% arrays are not used when we solve the wkz or akz problem, but are used
% when we solve the iwkz problem.
%
% For the ikwz problem, we have two cash-on-hand matrixes: mt_coh_wkb
%
% Note that in the m_abz problem's funcgrid function, we also called
% <https://fanwangecon.github.io/CodeDynaAsset/m_abz/paramfunc/html/ffs_abz_gen_borrsave_grid.html
% ffs_abz_gen_borrsave_grid> function, which generates borrowing grid
% depending on if default is allowed or not. In the problem here, the
% situation is more complicated, because now the maximum borrowing level is
% a function of the risky investment choice when default is not allowed. We
% impose a exogenous borrowing bound here.
%
% @param param_map container parameter container
%
% @param support_map container support container
%
% @param bl_input_override boolean if true varargin contained param_map and
% support_map fully overrides local default. Local default is not invoked.
% This could be important for speed if this function is getting invoked
% within certain loops. Default is 0.
%
% @return armt_map container container with states, choices and shocks
% grids that are inputs for grid based solution algorithm. keys included in
% armt_map are described below for each group of vectors when they are
% stored into armt_map.
%
% @return func_map container container with function handles for
% consumption cash-on-hand etc.
%
% @example
%
%    it_param_set = 2; bl_input_override = true; [param_map, support_map] =
%    ffs_akz_set_default_param(it_param_set); [armt_map, func_map] =
%    ffs_akz_get_funcgrid(param_map, support_map, bl_input_override);
%
% @include
%
% *
% <https://fanwangecon.github.io/CodeDynaAsset/m_akz/paramfunc/html/ffs_akz_set_functions.html
% ffs_akz_set_functions>
% *
% <https://github.com/FanWangEcon/CodeDynaAsset/blob/master/tools/ffto_gen_tauchen_jhl.m
% ffto_gen_tauchen_jhl>
% *
% <https://github.com/FanWangEcon/CodeDynaAsset/blob/master/tools/fft_gen_grid_loglin.m
% fft_gen_grid_loglin>
%

%% Default

if (~isempty(varargin))
    
    % override when called from outside
    [param_map, support_map] = varargin{:};
    
else
    % default internal run
    [param_map, support_map] = ffs_akz_set_default_param();
    support_map('bl_graph_funcgrids') = true;
    support_map('bl_display_funcgrids') = true;
    default_maps = {param_map, support_map};
        
    % Run Default with Borrowing
    param_map('fl_b_bd') = -20;
    
    % numvarargs is the number of varagin inputted
    [default_maps{1:length(varargin)}] = varargin{:};
    param_map = [param_map; default_maps{1}];
    support_map = [support_map; default_maps{2}];
end

%% Parse Parameters

params_group = values(param_map, {'it_z_n', 'fl_z_mu', 'fl_z_rho', 'fl_z_sig'});
[it_z_n, fl_z_mu, fl_z_rho, fl_z_sig] = params_group{:};

params_group = values(param_map, {'fl_b_bd', 'fl_w_max', 'it_w_n', 'fl_coh_interp_grid_gap'});
[fl_b_bd, fl_w_max, it_w_n, fl_coh_interp_grid_gap] = params_group{:};

params_group = values(param_map, {'fl_k_min', 'it_ak_n'});
[fl_k_min, it_ak_n] = params_group{:};

params_group = values(param_map, {'fl_crra', 'fl_c_min', 'it_c_interp_grid_gap'});
[fl_crra, fl_c_min, it_c_interp_grid_gap] = params_group{:};

params_group = values(param_map, {'fl_Amean', 'fl_alpha', 'fl_delta'});
[fl_Amean, fl_alpha, fl_delta] = params_group{:};

params_group = values(param_map, {'fl_r_save', 'fl_r_borr', 'fl_w'});
[fl_r_save, fl_r_borr, fl_w] = params_group{:};

params_group = values(support_map, {'bl_graph_funcgrids', 'bl_display_funcgrids'});
[bl_graph_funcgrids, bl_display_funcgrids] = params_group{:};

%% Get Asset and Choice Grid
% This generate triangular choice structure. Household choose total
% aggregate savings, and within that how much to put into risky capital and
% how much to put into safe assets. See
% <https://fanwangecon.github.io/CodeDynaAsset/m_akz/paramfunc/html/ffs_akz_set_default_param.html
% ffs_akz_set_default_param> for details.

fl_w_min = param_map('fl_b_bd'); 
fl_k_max = (param_map('fl_w_max') - param_map('fl_b_bd'));

ar_w = linspace(fl_w_min, fl_w_max, it_w_n);
ar_k = linspace(fl_k_min, fl_k_max, it_ak_n);

mt_a = ar_w - ar_k';
mt_k = ar_w - mt_a;

mt_bl_constrained = (mt_a < fl_b_bd); % this generates NAN, some NAN have -Inf Util
mt_a_wth_na = mt_a;
mt_k_wth_na = mt_k;
mt_a_wth_na(mt_bl_constrained) = nan;
mt_k_wth_na(mt_bl_constrained) = nan;

ar_a_mw_wth_na = mt_a_wth_na(:);
ar_k_mw_wth_na = mt_k_wth_na(:);

ar_a_meshk = ar_a_mw_wth_na(~isnan(ar_a_mw_wth_na));
ar_k_mesha = ar_k_mw_wth_na(~isnan(ar_k_mw_wth_na));

%% Get Shock Grids

[~, mt_z_trans, ar_stationary, ar_z] = ffto_gen_tauchen_jhl(fl_z_mu,fl_z_rho,fl_z_sig,it_z_n);

%% Get Equations

[f_util_log, f_util_crra, f_util_standin, f_prod, f_inc, f_coh, f_cons] = ...
    ffs_akz_set_functions(fl_crra, fl_c_min, fl_Amean, fl_alpha, fl_delta, fl_r_save, fl_r_borr, fl_w);

%% Generate Cash-on-Hand/State Matrix
% The endogenous state variable is cash-on-hand, it has it_z_n*it_a_n
% number of points, covering all reachable points when ar_a is the choice
% vector and ar_z is the shock vector. requires inputs from get Asset and
% choice grids, get shock grids, and get equations above.

mt_coh_wkb = f_coh(ar_z, ar_a_meshk, ar_k_mesha);
mt_z_mesh_coh_wkb = repmat(ar_z, [size(mt_coh_wkb,1),1]);

if (bl_display_funcgrids)
    
    % Generate Aggregate Variables
    ar_aplusk_mesh = ar_a_meshk + ar_k_mesha;
    
    % Genereate Table
    tab_ak_choices = array2table([ar_aplusk_mesh, ar_k_mesha, ar_a_meshk]);
    cl_col_names = {'ar_aplusk_mesh', 'ar_k_mesha', 'ar_a_meshk'};
    tab_ak_choices.Properties.VariableNames = cl_col_names;
    
    % Label Table Variables
    tab_ak_choices.Properties.VariableDescriptions{'ar_aplusk_mesh'} = ...
        '*ar_aplusk_mesh*: ar_aplusk_mesh = ar_a_meshk + ar_k_mesha;';
    tab_ak_choices.Properties.VariableDescriptions{'ar_k_mesha'} = ...
        '*ar_k_mesha*:';
    tab_ak_choices.Properties.VariableDescriptions{'ar_a_meshk'} = ...
        '*ar_a_meshk*:';

    cl_var_desc = tab_ak_choices.Properties.VariableDescriptions;
    for it_var_name = 1:length(cl_var_desc)
        disp(cl_var_desc{it_var_name});
    end
    
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('tab_ak_choices');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    it_rows_toshow = length(ar_w)*2;
    disp(size(tab_ak_choices));
    disp(head(array2table(tab_ak_choices), it_rows_toshow));
    disp(tail(array2table(tab_ak_choices), it_rows_toshow));


    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('mt_coh_wkb');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(mt_coh_wkb));
    disp(head(array2table(mt_coh_wkb), it_rows_toshow));
    disp(tail(array2table(mt_coh_wkb), it_rows_toshow));
    
end

%% IWKZ Interpolation Cash-on-hand Interpolation Grid
% For the iwkz problems, we solve the problem along a grid of cash-on-hand
% values, the interpolate to find v(k',b',z) at (k',b') choices. Crucially,
% we have to coh matrxies

fl_max_mt_coh = max(max(mt_coh_wkb));
fl_min_mt_coh = min(min(mt_coh_wkb));
it_coh_interp_n = (fl_max_mt_coh-fl_min_mt_coh)/(fl_coh_interp_grid_gap);
ar_interp_coh_grid = linspace(fl_min_mt_coh, fl_max_mt_coh, it_coh_interp_n);
[mt_interp_coh_grid_mesh_z, mt_z_mesh_coh_interp_grid] = ndgrid(ar_interp_coh_grid, ar_z);

%% IWKZ Interpolation Consumption Grid
% We also interpolate over consumption to speed the program up. We only
% solve for u(c) at this grid for the iwkz problmes, and then interpolate
% other c values.

fl_c_max = max(max(mt_coh_wkb)) - fl_b_bd;
it_interp_c_grid_n = (fl_c_max-fl_c_min)/(it_c_interp_grid_gap);
ar_interp_c_grid = linspace(fl_c_min, fl_c_max, it_interp_c_grid_n);

%% Store

armt_map = containers.Map('KeyType','char', 'ValueType','any');
armt_map('ar_w') = ar_w;
armt_map('ar_k') = ar_k;
armt_map('mt_z_trans') = mt_z_trans;
armt_map('ar_stationary') = ar_stationary;
armt_map('ar_z') = ar_z;
armt_map('mt_k_wth_na') = mt_k_wth_na;
armt_map('ar_a_mw_wth_na') = ar_a_mw_wth_na;
armt_map('ar_k_mw_wth_na') = ar_k_mw_wth_na;
armt_map('ar_a_meshk') = ar_a_meshk;
armt_map('ar_k_mesha') = ar_k_mesha;
armt_map('it_ameshk_n') = length(ar_a_meshk);
armt_map('mt_coh_wkb') = mt_coh_wkb;
armt_map('mt_z_mesh_coh_wkb') = mt_z_mesh_coh_wkb;
armt_map('ar_interp_c_grid') = ar_interp_c_grid;
armt_map('ar_interp_coh_grid') = ar_interp_coh_grid;
armt_map('mt_interp_coh_grid_mesh_z') = mt_interp_coh_grid_mesh_z;
armt_map('mt_z_mesh_coh_interp_grid') = mt_z_mesh_coh_interp_grid;

func_map = containers.Map('KeyType','char', 'ValueType','any');
func_map('f_util_log') = f_util_log;
func_map('f_util_crra') = f_util_crra;
func_map('f_util_standin') = f_util_standin;
func_map('f_prod') = f_prod;
func_map('f_inc') = f_inc;
func_map('f_coh') = f_coh;
func_map('f_cons') = f_cons;

%% Graph

if (bl_graph_funcgrids)

    %% Graph 1: a and k choice grid graphs
    figure('PaperPosition', [0 0 7 4]);
    hold on;

    chart = plot(mt_a_wth_na, mt_k_wth_na, 'blue');

    clr = jet(numel(chart));
    for m = 1:numel(chart)
       set(chart(m),'Color',clr(m,:))
    end
    if (length(ar_w) <= 100)
        scatter(ar_a_meshk, ar_k_mesha, 5, 'filled');
    end
    xline(0);
    yline(0);

    title('Choice Grids Conditional on k+a=w')
    ylabel('Capital Choice')
    xlabel({'Borrowing or Saving'})
    legend2plot = fliplr([1 round(numel(chart)/3) round((2*numel(chart))/4)  numel(chart)]);
    legendCell = cellstr(num2str(ar_w', 'k+a=%3.2f'));
    legend(chart(legend2plot), legendCell(legend2plot), 'Location','northeast');

    grid on;

    %% Graph 2: coh by shock
    figure('PaperPosition', [0 0 7 4]);
    chart = plot(mt_coh_wkb);
    clr = jet(numel(chart));
    for m = 1:numel(chart)
       set(chart(m),'Color',clr(m,:))
    end

    title('Cash-on-Hand given w(k+b),k,z');
    ylabel('Cash-on-Hand');
    xlabel({'Index of Cash-on-Hand Discrete Point'...
        'Each Segment is a w=k+b; within segment increasing k'...
        'For each w and z, coh maximizing k is different'});

    legend2plot = fliplr([1 round(numel(chart)/3) round((2*numel(chart))/4)  numel(chart)]);
    legendCell = cellstr(num2str(ar_z', 'shock=%3.2f'));
    legend(chart(legend2plot), legendCell(legend2plot), 'Location','southeast');

    grid on;

    %% Graph 3: coh by index
    figure('PaperPosition', [0 0 7 3.5]);
    ar_coh_kpzgrid_unique = unique(sort(mt_coh_wkb(:)));
    scatter(1:length(ar_coh_kpzgrid_unique), ar_coh_kpzgrid_unique);
    title('Cash-on-Hand given w(k+b),k,z');
    ylabel('Cash-on-Hand');
    xlabel({'Index of Cash-on-Hand Discrete Point'});
    grid on;

    %% Graph 4: coh by coh
    figure('PaperPosition', [0 0 7 3.5]);
    ar_coh_kpzgrid_unique = unique(sort(mt_coh_wkb(:)));
    scatter(ar_coh_kpzgrid_unique, ar_coh_kpzgrid_unique, '.');
    xline(0);
    yline(0);
    title('Cash-on-Hand given w(k+b),k,z; See Clearly Sparsity Density of Grid across Z');
    ylabel('Cash-on-Hand');
    xlabel({'Cash-on-Hand'});
    grid on;


end

%% Display

if (bl_display_funcgrids)

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('ar_z');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(ar_z));
    disp(ar_z);

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('ar_w');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(ar_w));
    disp(ar_w);
    
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('mt_z_trans');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(mt_z_trans));
    disp(head(array2table(mt_z_trans), 10));
    disp(tail(array2table(mt_z_trans), 10));

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('ar_interp_coh_grid');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    summary(array2table(ar_interp_coh_grid'));

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('ar_interp_c_grid');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    summary(array2table(ar_interp_c_grid'));

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('mt_interp_coh_grid_mesh_z');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(mt_interp_coh_grid_mesh_z));
    disp(head(array2table(mt_interp_coh_grid_mesh_z), 10));
    disp(tail(array2table(mt_interp_coh_grid_mesh_z), 10));

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('mt_a_wth_na');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(mt_a_wth_na));
    disp(head(array2table(mt_a_wth_na), 10));
    disp(tail(array2table(mt_a_wth_na), 10));

    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('mt_k_wth_na');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp(size(mt_k_wth_na));
    disp(head(array2table(mt_k_wth_na), 10));
    disp(tail(array2table(mt_k_wth_na), 10));
    
    disp('----------------------------------------');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    disp('ar_a_meshk and ar_k_mesha');
    disp('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    summary(array2table(ar_a_meshk));
    summary(array2table(ar_k_mesha));

    param_map_keys = keys(func_map);
    param_map_vals = values(func_map);
    for i = 1:length(func_map)
        st_display = strjoin(['pos =' num2str(i) '; key =' string(param_map_keys{i}) '; val =' func2str(param_map_vals{i})]);
        disp(st_display);
    end

end

end
