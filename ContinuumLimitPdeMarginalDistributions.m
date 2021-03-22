function [] = ContinuumLimitPdeMarginalDistributions

    clc;
    clearvars;
    
    l = 128; k = 400;
    dphi = 2 * pi / l; domega = 20 / k;
    
%     folder = '/Users/nikita/Documents/Projects/spss/spssFiniteVolumeMethods/';
%     folder = '/Volumes/Kruk/spss/spssFiniteVolumeMethods/';
    folder = '/Volumes/Kruk/spss/spssFiniteVolumeMethods/continuation/from_disorder_to_solitary1/';
    base_name = strcat('dt_0.005_v0_1_xi_0.1_sigma_1_rho_0.8_alpha_0.3_Dphi_0.0875_', num2str(l), '_', num2str(k));
    file_name = strcat(folder, base_name, '.bin');
    size_of_real = 8;
    file_info = dir(file_name);
    file_size = file_info.bytes;
    t_max = floor(file_size / ((1 + l * k) * size_of_real));
    file_id = fopen(file_name);
    status = fseek(file_id, (1 + l * k) * (t_max - 1) * size_of_real, 'bof'); % skip t_0 steps
    assert(~status);
    
%     movie_folder = '/Users/nikita/Documents/Projects/spss/VideoStorage/';
%     fname_movie = strcat(movie_folder, base_name, '.mp4');
%     mov = VideoWriter(fname_movie, 'MPEG-4');
%     mov.FrameRate = 25;
%     mov.Quality = 20;
%     open(mov);

    figure;
    for t = 0 : 0
        integration_time = fread(file_id, 1, 'double')
        continuum_limit_pdf = fread(file_id, [l * k, 1], 'double');
        density_all = reshape(continuum_limit_pdf(1 : l * k, 1), l, k);
        
%         PlotAngularDensity(density_all, l, dphi, domega);
%         pause(1);
%         drawnow;
%         frame = getframe(gcf);
%         writeVideo(mov, frame);
%         [M, I] = max(density_phi, [], 1);
        
%         PlotAngularVelocityDensity(density_all, k, dphi, domega);
%         drawnow;
        
        PlotTwoDimDensity(density_all, l, k, dphi, domega);
%         title(sprintf('t=%.2f', integration_time));
%         drawnow;
%         frame = getframe(gcf);
%         writeVideo(mov, frame);
    end % t
    fclose(file_id);
    
end

function [density_phi] = PlotAngularDensity(density_all, l, dphi, domega)

    density_phi = squeeze(sum(density_all, 2) * domega);

    figure;
%     [~, mi] = min(density_phi);
    plot((0 : dphi : (l - 1) * dphi), circshift(density_phi, -0), 'k-', 'LineWidth', 4);
    grid on; box on;

end

function [density_omega] = PlotAngularVelocityDensity(density_all, k, dphi, domega)

    density_omega = squeeze(sum(density_all, 1) * dphi);

    figure;
    plot((-k/2*domega : domega : (k/2 - 1) * domega), circshift(density_omega, -0), 'k-', 'LineWidth', 4);
    grid on; box on;

end

function [] = PlotTwoDimDensity(density_all, l, k, dphi, domega)

    [mesh_phi, mesh_omega] = meshgrid(0 : dphi : (l - 1) * dphi, -k/2*domega : domega : (k/2 - 1)*domega);
    [~, lin_idx] = max(density_all(:));
    [idx_phi, idx_omega] = ind2sub(size(density_all), lin_idx);
    density_all = circshift(density_all, -idx_phi+l/2, 1);
%     density_all = circshift(density_all, -idx_omega+k/2, 2);
    
%     figure;
    h_p = pcolor(mesh_phi.', mesh_omega.', density_all);
    colormap('jet'); colorbar;
    set(gca, 'ColorScale', 'Log');
    set(h_p, 'EdgeColor', 'None');
    
    axis square tight;
%         xlabel('\phi', 'Interpreter', 'Tex');
%         ylabel('\omega', 'Interpreter', 'Tex');
%         set(gca, 'YTick', [], 'XTick', []);
    set(gca,...
        'Units', 'normalized',...
        'FontUnits', 'points',...
        'FontWeight', 'normal',...
        'FontSize', 30,...
        'FontName', 'Helvetica',...
        'linew', 1);
%         'XTickLabel', {'0', '1'},...
%         'YTickLabel', {'0', '1'},...
%         'XTick', [1, n],...
%         'YTick', [1, m]);
    set(gcf, 'Color', 'W');
    ylim([-k/2 k/2]*domega);

end