par = struct;


% Aici sunt datele initiale care vor fi folosite pentru a genera semnalul
par.A0 = 0; % componenta continua a primului semnalului
par.A = 1; % amplitudinea primului semnalului
par.B0 = 0; % componenta continua a semnalului al doilea
par.B = 1; % amplitudinea semnalului al doilea
par.f = 1000; % frecventa semnalului
par.R1 = 1; % rezistenta 1
par.R2 = 1; % rezistenta 2
par.AMP = 1 + par.R2/par.R1; % amplificarea

main_figure = uifigure('Name','UI Test','Position',[100 100 800 800]); % creez o fereastra

s_plot = uiaxes(main_figure, 'Units', 'normalize', 'Position', [0.05 0.5 0.4 0.4]); % creez un plot
out_plot = uiaxes(main_figure, 'Units', 'normalize', 'Position', [0.55 0.5 0.4 0.4]); % creez un plot

% Creez un panel in care sa pun toate controalele
panel = uipanel(main_figure, 'Title', 'Parameters', 'Units', 'normalize', 'Position', [0.1 0.05 0.8 0.4]);

% Creez un grid layout pentru a aranja controalele
grid = uigridlayout(panel, [3 3]); % 3 randuri si 3 coloane

% Creez un grup de radio buttons pentru a alege numarul de perioade
radio_group_button1 = uibuttongroup(grid, 'Title', 'Period');
radio_group_button1.Layout.Row = 1;
radio_group_button1.Layout.Column = 1;

radio1 = uiradiobutton(radio_group_button1, 'Text', '5 Perioade', 'Position', [10 10 100 22]);
radio2 = uiradiobutton(radio_group_button1, 'Text', '10 Perioade', 'Position', [10 30 100 22]);

% Creez un grup de radio buttons pentru a alege tipul de semnal
radio_group_button2 = uibuttongroup(grid, 'Title', 'Amplitude');
radio_group_button2.Layout.Row = 1;
radio_group_button2.Layout.Column = 3;

radio3 = uiradiobutton(radio_group_button2, 'Text', 'Sinus', 'Position', [10 10 100 22]);
radio4 = uiradiobutton(radio_group_button2, 'Text', 'Dreptunghi', 'Position', [10 30 100 22]);

% Creez un checkbox pentru a alege daca se doreste sau nu componenta continua
ckb1 = uicheckbox(grid, 'Text', 'CC', 'Value', true);
ckb1.Layout.Row = 2;
ckb1.Layout.Column = 1;

% Creez un formular pentru a introduce parametrii
form = struct;
form.panel = uipanel(grid, 'Title', 'Parameters');
form.panel.Layout.Row = [1, 2];
form.panel.Layout.Column = 2;

uilabel(form.panel, 'Text', 'A0: ', 'Position', [10 10 100 22]);
form.A0 = uieditfield(form.panel, 'numeric', 'Value', par.A0, 'Position', [30 10 100 22]);

uilabel(form.panel, 'Text', 'A: ', 'Position', [10 30 100 22]);
form.A = uieditfield(form.panel, 'numeric', 'Value', par.A, 'Position', [30 30 100 22]);

uilabel(form.panel, 'Text', 'B0: ', 'Position', [10 50 100 22]);
form.B0 = uieditfield(form.panel, 'numeric', 'Value', par.B0, 'Position', [30 50 100 22]);

uilabel(form.panel, 'Text', 'B: ', 'Position', [10 70 100 22]);
form.B = uieditfield(form.panel, 'numeric', 'Value', par.B, 'Position', [30 70 100 22]);

uilabel(form.panel, 'Text', 'f: ', 'Position', [10 90 100 22]);
form.f = uieditfield(form.panel, 'numeric', 'Value', par.f, 'Position', [30 90 100 22]);

uilabel(form.panel, 'Text', 'R1: ', 'Position', [10 110 100 22]);
form.R1 = uieditfield(form.panel, 'numeric', 'Value', par.R1, 'Position', [30 110 100 22]);

uilabel(form.panel, 'Text', 'R2: ', 'Position', [10 130 100 22]);
form.R2 = uieditfield(form.panel, 'numeric', 'Value', par.R2, 'Position', [30 130 100 22]);


% Creez un buton pentru a submita datele
submit_button = uibutton(grid, 'Text', 'Submit', 'ButtonPushedFcn', @(btn,event) submit_button_callback(s_plot, out_plot, par, radio_group_button1, radio_group_button2, form, ckb1));
submit_button.Layout.Row = 3;
submit_button.Layout.Column = 2;

% Functia care se apeleaza la apasarea butonului
function submit_button_callback(axe1, axe2, par, grp1, grp2, form, ckb1)
    par.A0 = form.A0.Value;
    par.A = form.A.Value;
    par.B0 = form.B0.Value;
    par.B = form.B.Value;
    par.f = form.f.Value;
    par.R1 = form.R1.Value;
    par.R2 = form.R2.Value;
    par.AMP = 1 + par.R2/par.R1;

    if strcmp(grp1.SelectedObject.Text, '5 Perioade')
        T = 5/par.f;
    else
        T = 10/par.f;
    end

    % Generez semnalul
    % Daca semnalul este sinusoidal
    if strcmp(grp2.SelectedObject.Text, 'Sinus')
        t = 0:1/(100*par.f):T;
        ya = par.A0 * ckb1.Value + par.A*sin(2*pi*par.f*t);
        yb = par.B0 * ckb1.Value+ par.B*sin(2*pi*par.f*t);
    else % Daca semnalul este dreptunghiular
        t = 0:1/(100*par.f):T;
        ya = par.A0 * ckb1.Value + par.A*sign(sin(2*pi*par.f*t));
        yb = par.B0 * ckb1.Value + par.B*sign(sin(2*pi*par.f*t));
    end

    % Calculez semnalul rezultant
    y = par.AMP*(ya - yb);

    % Limitez semnalul
    y(y > 25) = 25;
    y(y < -30) = -30;

    % Afisez semnalul
    plot(axe1, t, y);
    plot(axe2, t, y, t, ya, t, yb);
end

