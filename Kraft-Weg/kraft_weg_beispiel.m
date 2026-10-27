
clear;
clc;
close all;

%% 1. Messdaten automatisch einlesen
daten = readtable('messdaten_kraft_weg_300.csv');

F = daten.Kraft_N;
x = daten.Auslenkung_mm;

% Ungueltige Messwerte entfernen
gueltig = isfinite(F) & isfinite(x);
F = F(gueltig);
x = x(gueltig);

%% 2. Approximation 2. Grades berechnen
p = polyfit(F, x, 2);

F_fit = linspace(min(F), max(F), 500);
x_fit = polyval(p, F_fit);

% Approximierte Werte fuer alle Messpunkte
x_approx = polyval(p, F);

%% 3. Automatische Fehleranalyse
fehler = x - x_approx;

RMSE = sqrt(mean(fehler.^2));
MAE = mean(abs(fehler));

% Bestimmtheitsmass R^2
SSE = sum(fehler.^2);
SST = sum((x - mean(x)).^2);

if SST > 0
    R2 = 1 - SSE/SST;
else
    R2 = NaN;
end

%% 4. Ergebnisse im Command Window ausgeben
fprintf('\n--- MESSDATENANALYSE ---\n');
fprintf('Anzahl Messpunkte: %d\n', numel(F));

fprintf('\nApproximationsgleichung:\n');
fprintf('x(F) = %.6f * F^2 + %.6f * F + %.6f\n', ...
    p(1), p(2), p(3));

fprintf('\nQualitaet der Approximation:\n');
fprintf('RMSE: %.4f mm\n', RMSE);
fprintf('MAE:  %.4f mm\n', MAE);
fprintf('R^2:  %.5f\n', R2);

%% 5. Messdaten und Approximation darstellen
figure;

scatter(F, x, 25, 'b', 'filled');
hold on;
plot(F_fit, x_fit, 'r-', 'LineWidth', 2);

grid on;
xlabel('Kraft F (N)');
ylabel('Auslenkung x (mm)');
title('Automatische Auswertung der Kraft-Weg-Kennlinie');

legend('Messdaten', 'Approximation 2. Grades', ...
    'Location', 'northwest');

