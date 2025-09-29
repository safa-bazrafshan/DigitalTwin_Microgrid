%% Parameters
Voc = 37;       % Solar panel open-circuit voltage
Isc = 8.21;     % Solar panel short-circuit current
Capacity = 5;   % Battery capacity (Ah)
SOC = 50;       % Initial SOC (%)
V_nom = 12;     
dt = 1;         % Time step (s)
time = 0:dt:3600; % 1 hour

%% Load profile
Load_current = 2 + sin(time/3600*2*pi);

%% Initialize variables
SOC_array = zeros(size(time));
SOC_array(1) = SOC;
Solar_current = Isc * (1 - (0:dt:3600)/3600); % simplified
Battery_current = zeros(size(time));

%% Control parameters
SOC_upper = 90;  % Upper SOC limit (%)
SOC_lower = 20;  % Lower SOC limit (%)

%% Simulation loop with control
for t = 2:length(time)
    Net_current = Solar_current(t) - Load_current(t);
    
    % Simple control: battery charges only if SOC < SOC_upper
    if Net_current > 0 && SOC_array(t-1) < SOC_upper
        Battery_current(t) = -Net_current; % charge battery
    elseif Net_current < 0 && SOC_array(t-1) > SOC_lower
        Battery_current(t) = -Net_current; % discharge battery
    else
        Battery_current(t) = 0; % stop charging/discharging
    end
    
    SOC_array(t) = SOC_array(t-1) + (Battery_current(t)*dt/Capacity)*100;
    SOC_array(t) = max(0, min(100, SOC_array(t)));
end

%% Plot SOC
figure;
plot(time/60, SOC_array, 'LineWidth', 2);
xlabel('Time (min)');
ylabel('Battery SOC (%)');
title('Microgrid Battery SOC with Control');
grid on;

%% Plot currents
figure;
plot(time/60, Load_current, 'LineWidth', 2);
hold on;
plot(time/60, Solar_current, 'LineWidth', 2);
plot(time/60, Battery_current, 'LineWidth', 2);
xlabel('Time (min)');
ylabel('Current (A)');
title('Microgrid Currents with Control');
legend('Load','Solar','Battery');
grid on;
