%% Load Solar Panel and Battery Models
Voc = 37;       % Solar panel open-circuit voltage
Isc = 8.21;     % Solar panel short-circuit current
Capacity = 5;   % Battery capacity in Ah
V_nom = 12;     % Battery nominal voltage
SOC = 50;       % Initial battery SOC (%)
dt = 1;         % Time step (s)
time = 0:dt:3600;  % 1 hour simulation

%% Load / Consumption profile (A)
Load_current = 2 + sin(time/3600*2*pi); % variable load

%% Initialize variables
SOC_array = zeros(size(time));
SOC_array(1) = SOC;
Solar_current = Isc * (1 - (0:dt:3600)/3600); % simplified I-V effect
Battery_current = zeros(size(time));

%% Simulation loop
for t = 2:length(time)
    % Net current: solar - load
    Net_current = Solar_current(t) - Load_current(t);
    
    % Battery charges if excess, discharges if deficit
    Battery_current(t) = -Net_current;
    SOC_array(t) = SOC_array(t-1) + (Battery_current(t)*dt/Capacity)*100;
    
    % Limit SOC to 0-100%
    SOC_array(t) = max(0, min(100, SOC_array(t)));
end

%% Plot results
figure;
plot(time/60, SOC_array, 'LineWidth', 2);
xlabel('Time (min)');
ylabel('Battery SOC (%)');
title('Microgrid Battery SOC Simulation');
grid on;

figure;
plot(time/60, Load_current, 'LineWidth', 2);
hold on;
plot(time/60, Solar_current, 'LineWidth', 2);
plot(time/60, Battery_current, 'LineWidth', 2);
xlabel('Time (min)');
ylabel('Current (A)');
title('Microgrid Currents');
legend('Load','Solar','Battery');
grid on;
