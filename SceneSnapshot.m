function [] = SceneSnapshot

    clc;
    clearvars;
    
    file_name = sprintf('/Users/nikita/Documents/Projects/spss/spssLangevinIntegration/v0_1_xir_1_Dr_0_xiphi_1_Dphi_0_sigma_1_rho_0.1_alpha_0_N_1000_0_0.bin');
    file_id = fopen(file_name);
    
    N = 1000;
    S = 6;
    skip_time = 90 * 10;
    
    size_of_float = 4;
    status = fseek(file_id, (1 + S * N) * skip_time * size_of_float, 'bof'); % skip t_0 steps
    assert(~status);
    
    figure;
    for t = 0 : 0
        time = fread(file_id, [1, 1], 'float') % skip time stamp
        system_state = fread(file_id, [S * N, 1], 'float'); % w/o time
        x = mod(system_state(1:S:end),1);
        y = mod(system_state(2:S:end),1);
        v_x = system_state(3 : S : end);
        v_y = system_state(4 : S : end);
%         v = mean(v_x .^ 2 + v_y .^ 2)
        phi = mod(system_state(5:S:end),2*pi);
        scatter(x, y, [], phi ./ (2*pi), 'filled', 'MarkerEdgeColor', [0 0 0]); hold on;
        caxis([0 1]); colormap(hsv);
        quiver(x, y, cos(phi), sin(phi), 0.5, 'Color', [1 0 0]);
        quiver(x, y, v_x, v_y, 0.5, 'Color', [0 0 1]);
        grid on; box on;
        axis square;
        title(num2str(time));
        axis([0 1 0 1]);
        drawnow;
        hold off;
    end % t
%     set(gca,...
%         'Units', 'normalized',...
%         'FontUnits', 'points',...
%         'FontWeight', 'normal',...
%         'FontSize', 24,...
%         'FontName', 'Helvetica',...
%         'linew', 1);
%     set(gcf, 'Units', 'normalized', 'Position', [.1 .1 .6 .6]);
        
end