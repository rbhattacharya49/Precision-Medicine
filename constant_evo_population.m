%s, mu, sigma_t, sigma_k, K_m, r, k, d

%High Evo
%  pars_no_drug = [0, 0, sqrt(6), 10, 100, 0.3, 0.3, 0.12];
%  pars_chemotherapy = [0.15, 0, sqrt(6), 10, 100, 0.3, 0.3 0.12];
%  pars_targeted = [0.3, 0, sqrt(2), 10, 100, 0.3, 0.3, 0.12];

%Low Evo
pars_no_drug = [0, 0, sqrt(6), 10, 100, 0.3, 0.1, 0.12];
pars_chemotherapy = [0.15, 0, sqrt(6), 10, 100, 0.3, 0.1, 0.12];
pars_targeted = [0.3, 0, sqrt(2), 10, 100, 0.3, 0.1, 0.12];


init = [20, 0.01]; %initial conditions

figure(1);
title({'Cancer Dynamics under Targeted Therapy:',...
    'Low, High, Facultative Evolvability'})
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold')
ylabel("Population Size: x", 'FontSize', 28, 'Fontweight', 'bold')
grid on
ylim([0 100]);
hold on

%%%%%%%%%%%no therapy for 0-600 time steps%%%%%%%%%%%%
yfin_no_drug = [];
tfin_no_drug = [];
[t_no_drug, y_no_drug] = ode45(@constant_evo_model, [0 600], init, [], pars_no_drug);

yfin_no_drug = [yfin_no_drug; y_no_drug(1:end, :)];
tfin_no_drug = [tfin_no_drug; t_no_drug(1:end)];

plot(tfin_no_drug, yfin_no_drug(:,1), ':','Color',[1 0 0], 'Linewidth', 6);
%plot(tfin_no_drug, yfin_no_drug(:,1), 'Color',[1 0 0], 'Linewidth', 6);

%%%%%%%%%%%%%plotting chemotherapy%%%%%%%%%%%
yfin_chemotherapy = [];
tfin_chemotherapy = [];
[t_chemotherapy, y_chemotherapy] = ode45(@constant_evo_model, [601, 4000], [yfin_no_drug(end,1), yfin_no_drug(end,2)], [], pars_chemotherapy);

yfin_chemotherapy = [yfin_chemotherapy; y_chemotherapy(1:end, :)];
tfin_chemotherapy = [tfin_chemotherapy; t_chemotherapy(1:end)];

yfin_chemotherapy_x = [];
yfin_chemotherapy_x = [yfin_chemotherapy_x; yfin_chemotherapy(:,1)];

for i=1:length(yfin_chemotherapy_x)
    if yfin_chemotherapy_x(i) <= 1
        yfin_chemotherapy_x(i:end) = 0;
    end
end

%plot(tfin_chemotherapy, yfin_chemotherapy_x, '--', 'Color',[1 0 0], 'Linewidth', 6);
%plot(tfin_chemotherapy, yfin_chemotherapy_x, 'Color',[0 0 1], 'Linewidth', 6);


%%%%%%%%%%%plotting targeted therapy%%%%%%%%%%%%%%
yfin_targeted = [];
tfin_targeted = [];
[t_targeted, y_targeted] = ode45(@constant_evo_model, [601, 4000], [yfin_no_drug(end,1), yfin_no_drug(end,2)], [], pars_targeted);

yfin_targeted = [yfin_targeted; y_targeted(1:end, :)];
tfin_targeted = [tfin_targeted; t_targeted(1:end)];

yfin_targeted_x = [];
yfin_targeted_x = [yfin_targeted_x; yfin_targeted(:,1)];

for i=1:length(yfin_targeted_x)
    if yfin_targeted_x(i) < 1
        yfin_targeted_x(i:end) = 0;
    end
end

plot(tfin_targeted, yfin_targeted_x, ':', 'Color',[1 0 0],'Linewidth', 6);
%plot(tfin_targeted, yfin_targeted_x, 'Color',[1 0 0],'Linewidth', 6);

%legend('Facultative Evolvability', 'High Evolvability', 'Low Evolvability', 'FontSize', 22 , 'Location', 'southeast')

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.TitleFontSizeMultiplier = 1;
ax.GridLineStyle = '-';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
%hold off
