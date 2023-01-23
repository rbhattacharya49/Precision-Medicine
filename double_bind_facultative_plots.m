s1_no_drug = 0; mu1 = 0; sigma_t1 = sqrt(6); sigma_k1 = 10; K_m = 100; r= 0.3; k_r1= 1.67; d1 = 0.12;
s2_no_drug = 0; mu2 = 0; sigma_t2 = sqrt(2); sigma_k2 = 10; k_r2= 0.84; d2 = 0.12;
s1_chemo = 0.15; s2_chemo = 0;
s1_targeted = 0; s2_targeted = 0.3;


% s1_no_drug = 0; mu1 = 0; sigma_t1 = sqrt(6); sigma_k1 = 10; K_m = 100; r= 0.3; k_r1= 1.5; d1 = 0.12;
% s2_no_drug = 0; mu2 = 0; sigma_t2 = sqrt(2); sigma_k2 = 10; k_r2= 0.85; d2 = 0.12;
% s1_chemo = 0.15; s2_chemo = 0;
% s1_targeted = 0; s2_targeted = 0.3;


pars_no_drug = [s1_no_drug, mu1, sigma_t1, sigma_k1, K_m, r, k_r1, d1, s2_no_drug, mu2, sigma_t2, sigma_k2, k_r2, d2];
pars_chemotherapy = [s1_chemo, mu1, sigma_t1, sigma_k1, K_m, r, k_r1, d1, s2_chemo, mu2, sigma_t2, sigma_k2, k_r2, d2];
pars_targeted = [s1_targeted, mu1, sigma_t1, sigma_k1, K_m, r, k_r1, d1, s2_targeted, mu2, sigma_t2, sigma_k2, k_r2, d2];

tMax = 5000;
tstep = 500; %1 week
tInspect= tstep;
tinitial=1;
t_therapy_on = 600;
init0 = [20, 0.01, 0.01];

Total_iterations= ceil((tMax- t_therapy_on)/tInspect);


xfin = [];
tfin = [];
figure(1);
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Population Size: x", 'FontSize', 28, 'Fontweight', 'bold')
ylim([0 100]);
[t, x] = ode45(@double_bind_facultative_model, [1, t_therapy_on], init0, [], pars_no_drug);

xfin = [xfin; x];
tfin = [tfin, t];
 
for j=1:Total_iterations
    if mod(j, 2) ==0
       pars = pars_targeted;
            %disp(j)
    else
       pars = pars_chemotherapy;
       
       
    end
    
    pars(1);
    pars(9);
    %tInspect = min(tInspect + tstep, tMax);
    init_New = [x(end, 1) x(end, 2) x(end,3)];
    [t, x] = ode45(@double_bind_facultative_model, [t_therapy_on, t_therapy_on+ 500], init_New, [], pars);
    t_therapy_on = t_therapy_on + 500;
    xfin = [xfin; x(2:end, :)];
    tfin = [tfin; t(2:end)];
end

xfin_x = [];
xfin_x = [xfin_x; xfin(:,1)];
xfin_v1 = [];
xfin_v1 = [xfin_v1; xfin(:,2)];
xfin_v2 = [];
xfin_v2 = [xfin_v2; xfin(:,3)];

for i = 1:length(xfin)
    if xfin_x(i) < 1
        xfin_x(i:end) = 0;
        %xfin_v1(i:end) = 0;
        %xfin_v2(i:end) = 0;
    end
end

    
%plot(tfin, xfin(:,1), 'b', 'Linewidth', 1);

plot(tfin, xfin_x, 'Color', [0.4 0 0.6], 'Linewidth', 4);
%legend('Double Bind', 'Fontsize', 24)

%legend('Targeted Therapy', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',36)

ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
%hold off


hold off;

figure(2)
hold on;
grid on;
ylim([0, 5]);
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Strategy: v", 'FontSize', 28, 'Fontweight', 'bold')

plot(tfin, xfin_v1, 'b', 'Linewidth', 4);
plot(tfin, xfin_v2, 'r', 'Linewidth', 4);

%legend('Chemotherapy', 'Targeted Therapy', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',36)

ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;

array_k1 = [];
array_k2 = [];
intervalSize = tstep;
for i = 1:length(tfin)
%     s1 = 0.15 * (mod(floor(max(x - (600 - intervalSize), 0)) / intervalSize), 2))
%     s2 = 0.3 *  (mod(floor(max(x - (600 - intervalSize), 0)) / intervalSize) + 1, 2))
    s1 = 0.15 * mod(floor(max(tfin(i) - (600 - intervalSize), 0) / intervalSize), 2);
    
    if tfin(i) < 600
        s2= 0.3*mod((floor(((max((tfin(i) - (600 - intervalSize)), 0))/intervalSize))),2);
        
    else
        
        s2 = 0.3*(mod(floor((((tfin(i) - (600 - intervalSize))/intervalSize) + 1)),2));
        %s2 = 0.3*mod(floor((((tfin(i) - (600 - intervalSize)/intervalSize)/intervalSize)+1)),2);
        
        
        %s2 = mod(floor(((max((tfin(i) - (600 - intervalSize)), 0))/intervalSize)+1),2);
        
%         (max(tfin(i) - (600 - intervalSize),0)
%         s2= 0.3*mod((floor(((max((tfin(i) - (600 - intervalSize)), 0))+1)/intervalSize))),2);
    end
    

    %s2 = mod((((max(tfin(i) - (600 - intervalSize), 0)) + 1)/intervalSize), 2);
    %s2 = 0.3 *  mod(floor(max(tfin(i) - (600 - intervalSize), 0) / (intervalSize + 1)), 2);
%     0.15*mod(floor(max(tfin(i) - (600 - intervalSize),0),2)
%     s1 = 0.15 * (mod(floor(max((tfin(i) - (600 - intervalSize)),0))/intervalSize,2));
%     s2 = 0.3 *  (mod(floor(max((tfin(i) - (600 - intervalSize)),0))/intervalSize,2));
%     
%     s1 = 0.15 * (mod(floor(max(tfin(i) - (600 - intervalSize), 0)) / intervalSize)), 2)
%     s2 = 0.3 *  (mod(floor(max(x - (600 - intervalSize), 0)) / intervalSize) + 1, 2))
    
    
%     s1 = tfin(i) - max((600 - intervalSize), 0)
%     s1 = 0.15 * mod(floor(max(tfin(i) - (600 - intervalSize), 0)) / intervalSize, 2);
%     s2 = 0.3 *  mod(floor(max(tfin(i) - (600 - intervalSize), 0)) / (intervalSize + 1), 2);
%     s1 = 0.15 * mod((floor(max(tfin(i) - 500, 0) / 100)) ,2);
%     s2 = 0.3 * mod((floor(max(tfin(i) - 500, 0) / 100)) ,2);
    k1 = 0.05 + k_r1*s1*exp((-(xfin_v1(i) - mu1)^2)/(sigma_t1^2));
    k2 = 0.05 + k_r2*s2*exp((-(xfin_v2(i) - mu2)^2)/(sigma_t2^2));
    array_k1 = [array_k1; k1];
    array_k2 = [array_k2; k2];
end

figure(3)
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability:(Chemotherapy)", 'FontSize', 28, 'Fontweight', 'bold')

plot(tfin, array_k1, 'b', 'Linewidth', 4);
%plot(tfin, array_k2, 'r', 'Linewidth', 4);

%legend('Chemotherapy', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',36)

ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;

figure(4)
hold on;
grid on;
xlabel("Time", 'FontSize', 28, 'Fontweight', 'bold' )
ylabel("Evolvability:(Targeted)", 'FontSize', 28, 'Fontweight', 'bold')

%plot(tfin, array_k1, 'b', 'Linewidth', 4);
plot(tfin, array_k2, 'r', 'Linewidth', 4);

%legend('Targeted', 'Fontsize', 24)

a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',36)

ax = gca;
ax.GridLineStyle = '-';
%ax.GridColor = 'k';
ax.GridAlpha = 0.4;
ax.LineWidth = 1.5;
