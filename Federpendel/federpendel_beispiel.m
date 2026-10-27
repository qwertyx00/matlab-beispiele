
% Gedämpftes Federpendel mit Reibung
% Simulation mit ode45

clear;
clc;
close all;

%% 1. Parameter des Systems
m = 0.5;       % Masse in kg
k = 20;        % Federkonstante in N/m
c = 0.5;       % Daempfungskonstante in Ns/m
A = 0.1;       % Anfangsauslenkung in m
v0 = 0;        % Anfangsgeschwindigkeit in m/s

%% 2. Anfangsbedingungen
y0 = [A; v0];  % y(1) = Position, y(2) = Geschwindigkeit
tspan = [0 10];

%% 3. Differentialgleichung numerisch loesen
[t, y] = ode45(@(t,y) federpendel(t,y,m,k,c), ...
    tspan, y0);

% Ergebnisse auslesen
x = y(:,1);    % Position in m
v = y(:,2);    % Geschwindigkeit in m/s

% Beschleunigung berechnen
a = -(k/m)*x - (c/m)*v;

% Mechanische Energie
E_kin = 0.5*m*v.^2;
E_feder = 0.5*k*x.^2;
E_gesamt = E_kin + E_feder;

%% 4. Ergebnisse darstellen
figure('Name','Gedaempftes Federpendel');

subplot(3,1,1);
plot(t,x,'b','LineWidth',2);
grid on;
title('Position mit Daempfung');
xlabel('Zeit t (s)');
ylabel('Position x (m)');

subplot(3,1,2);
plot(t,v,'r','LineWidth',2);
grid on;
title('Geschwindigkeit');
xlabel('Zeit t (s)');
ylabel('Geschwindigkeit v (m/s)');

subplot(3,1,3);
plot(t,E_gesamt,'k','LineWidth',2);
grid on;
title('Mechanische Energie');
xlabel('Zeit t (s)');
ylabel('Energie E (J)');

%% 5. Vergleich: unterschiedliche Daempfung
figure('Name','Einfluss der Daempfung');
hold on;

c_werte = [0 0.4 1.5];

for i = 1:length(c_werte)
    c_test = c_werte(i);

    [t_test,y_test] = ode45( ...
        @(t,y) federpendel(t,y,m,k,c_test), ...
        tspan,y0);

    plot(t_test,y_test(:,1),'LineWidth',2, ...
        'DisplayName',sprintf('c = %.1f Ns/m',c_test));
end

grid on;
xlabel('Zeit t (s)');
ylabel('Position x (m)');
title('Einfluss der Daempfung auf die Schwingung');
legend('Location','best');

%% 6. Differentialgleichung des Systems
function dydt = federpendel(~,y,m,k,c)

x = y(1);
v = y(2);

% Bewegungsgleichung:
% m*x'' + c*x' + k*x = 0

a = -(c/m)*v - (k/m)*x;

dydt = [v; a];

end
