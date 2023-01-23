%s = pars(1); mu = pars(2); sigma_t = pars(3); sigma_k = pars(4); K_m =
%pars(5); r= pars(6); k_r = pars(7); s_max = pars(8)

pars_no_drug = [0, 0, sqrt(6), 10, 100, 0.3, 0, 0.12];
pars_chemo = [0.15, 0, sqrt(6), 10, 100, 0.3, 1.67, 0.12];
pars_targeted = [0.3, 0, sqrt(2), 10, 100, 0.3, 0.84, 0.12];


init = [20, 0.01];


%%%%%%%% plotting strategy %%%%%%%%%%
figure(1);
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold')
ylabel("Strategy: v", 'FontSize', 28, 'Fontweight', 'bold')
grid on
hold on


%%%%%%%%%%no therapy for 0-600 time steps%%%%%%%%%%%
yfin_no_drug = [];
tfin_no_drug = [];
[t_no_drug, y_no_drug] = ode45(@faculatative_evo_model, [0 600], init, [], pars_no_drug);

yfin_no_drug = [yfin_no_drug; y_no_drug(1:end, :)];
tfin_no_drug = [tfin_no_drug; t_no_drug(1:end)];

yfin_no_drug_v = [];
yfin_no_drug_v = [yfin_no_drug_v; yfin_no_drug(:,2)];

plot(tfin_no_drug, yfin_no_drug(:,2), '-','Color',[1 0 0], 'Linewidth', 6);
%plot(tfin_no_drug, yfin_no_drug(:,2), 'Color',[1 0 0], 'Linewidth', 6);

%%%%%%%%%%%%% chemotherapy %%%%%%%%%%%%%%%%
yfin_chemotherapy = [];
tfin_chemotherapy = [];
[t_chemotherapy, y_chemotherapy] = ode45(@faculatative_evo_model, [601, 4000], [yfin_no_drug(end,1), yfin_no_drug(end,2)], [], pars_chemo);

yfin_chemotherapy = [yfin_chemotherapy; y_chemotherapy(1:end, :)];
tfin_chemotherapy = [tfin_chemotherapy; t_chemotherapy(1:end)];

%plot(tfin_chemotherapy, yfin_chemotherapy(:,2), '-','Color',[0 0 1], 'Linewidth', 6);
%plot(tfin_chemotherapy, yfin_chemotherapy(:,2), 'Color',[0 0 1], 'Linewidth', 6);

yfin_chemotherapy_v = [];
yfin_chemotherapy_v = [yfin_chemotherapy_v; yfin_chemotherapy(:,2)];

yfin_chemotherapy_x = [];
yfin_chemotherapy_x = [yfin_chemotherapy_x; yfin_chemotherapy(:,1)];

for i=1:length(yfin_chemotherapy_x)
    if yfin_chemotherapy_x(i) <= 1
        yfin_chemotherapy_x(i:end) = 0;
        %yfin_chemotherapy_v(i:end) = 0;
    end
end

%%%%%%%%%%%%%%% targeted therapy %%%%%%%%%%%%%%
yfin_targeted = [];
tfin_targeted = [];
[t_targeted, y_targeted] = ode45(@faculatative_evo_model, [601, 4000], [yfin_no_drug(end,1), yfin_no_drug(end,2)], [], pars_targeted);

yfin_targeted = [yfin_targeted; y_targeted(1:end, :)];
tfin_targeted = [tfin_targeted; t_targeted(1:end)];

yfin_targeted_v = [];
yfin_targeted_v = [yfin_targeted_v; yfin_targeted(:,2)];

yfin_targeted_x = [];
yfin_targeted_x = [yfin_targeted_x; yfin_targeted(:,1)];

for i=1:length(yfin_targeted_x)
    if yfin_targeted_x(i) < 1.5
        yfin_targeted_x(i:end) = 0;
        %yfin_targeted_v(i:end) = 0;
    end
end

plot(tfin_targeted, yfin_targeted(:,2),'Color',[1 0 0], 'Linewidth', 6);
%plot(tfin_targeted, yfin_targeted(:,2), '--','Color',[1 0 0], 'Linewidth', 6);
ylim([0 4]);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
%hold off
hold off


%%%%%%%%%%%%%%% Plotting Evolvability %%%%%%%%%%%%%%%%%
figure(2)
hold on
grid on
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold')
ylabel("Evolvability: \sigma_{g}^{2}", 'FontSize', 28, 'Fontweight', 'bold')

%replace with par_targeted or pars_chemo
s = pars_targeted(1); mu = pars_targeted(2); sigma_t = pars_targeted(3); sigma_k = pars_targeted(4); K_m = pars_targeted(5); r= pars_targeted(6); k_r= pars_targeted(7); d = pars_targeted(8);
%array_k = zeros(length(1, yfin_chemotherapy_v));
array_k_chemo = [];

for i = 1:length(yfin_targeted)
    k = k_r*s*exp((-(yfin_targeted_v(i) - mu)^2)/(sigma_t^2));
    display(k)
    array_k_chemo = [array_k_chemo; k];
end

%plot(yfin_targeted_v, array_k_targeted, 'Color', [1, 0, 0], 'Linewidth', 6)
plot(tfin_targeted, array_k_chemo, 'Color', [0, 0, 1], 'Linewidth', 6)

s = pars_no_drug(1); mu = pars_no_drug(2); sigma_t = pars_no_drug(3); sigma_k = pars_no_drug(4); K_m = pars_no_drug(5); r= pars_no_drug(6); k_r= pars_no_drug(7); d = pars_no_drug(8);
%array_k = zeros(length(1, yfin_chemotherapy_v));
array_k_no_drug = [];

for i = 1:length(yfin_no_drug)
    k = k_r*s*exp((-(yfin_no_drug_v(i) - mu)^2)/(sigma_t^2));
    display(k)
    array_k_no_drug = [array_k_no_drug; k];
end


plot(yfin_no_drug_v, array_k_no_drug, 'Color', [0, 0, 1], 'Linewidth', 6)
plot(tfin_no_drug, array_k_no_drug, 'Color', [0, 0, 1], 'Linewidth', 6)
plot([tfin_no_drug(end),tfin_chemotherapy(1)],[array_k_no_drug(end),array_k_chemo(1)], 'Color', [0, 0, 1], 'Linewidth', 6)


low_evo = [];
for i = 1:length(yfin_no_drug_v)
    k = 0.1;
    low_evo = [low_evo; k];
end

for i = 1:length(yfin_targeted_v)
    k = 0.1;
    low_evo = [low_evo; k];
end


high_evo = [];
for i = 1:length(yfin_no_drug_v)
    k = 0.3;
    high_evo = [high_evo; k];
end

for i = 1:length(yfin_targeted_v)
    k = 0.3;
    high_evo = [high_evo; k];
end


x1 = linspace(1,4000);
low = [];
high = [];
for i = 1:length(x1)
    high = [high; 0.3];
end

x2 = linspace(1,4000);
for i = 1:length(x2)
    low = [low; 0.1];
end


plot(x2, low, ':', 'Color', [0, 0, 1], 'Linewidth', 6)
plot(x1, high, '--', 'Color', [0, 0, 1], 'Linewidth', 6)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',24)

legend('','','Facultative Evolvability', 'High Evolvability', 'Low Evolvability', 'FontSize', 22 , 'Location', 'northeast')


ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
%hold off

hold off