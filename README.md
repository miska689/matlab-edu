# Documentație pentru Codul MATLAB

## Descriere Generală

Acest cod MATLAB creează o aplicație GUI (Graphical User Interface) care permite utilizatorului să genereze și să vizualizeze semnale sinusoidale și dreptunghiulare. Utilizatorul poate ajusta parametrii semnalului, cum ar fi amplitudinea, frecvența și rezistențele, prin intermediul unor controale UI. Semnalele generate sunt apoi afișate în două grafice diferite.

## Componente UI Utilizate

1. **uifigure**: Creează o fereastră principală pentru aplicația GUI.
   ```matlab
   main_figure = uifigure('Name','UI Test','Position',[100 100 800 800]);
   ```

2. **uiaxes**: Creează axe pentru a plota semnalele.
   ```matlab
   s_plot = uiaxes(main_figure, 'Units', 'normalize', 'Position', [0.05 0.5 0.4 0.4]);
   out_plot = uiaxes(main_figure, 'Units', 'normalize', 'Position', [0.55 0.5 0.4 0.4]);
   ```

3. **uipanel**: Creează un panou pentru a organiza controalele UI.
   ```matlab
   panel = uipanel(main_figure, 'Title', 'Parameters', 'Units', 'normalize', 'Position', [0.1 0.05 0.8 0.4]);
   ```

4. **uigridlayout**: Organizează controalele UI într-un layout de tip grilă.
   ```matlab
   grid = uigridlayout(panel, [3 3]); % 3 rânduri și 3 coloane
   ```

5. **uibuttongroup**: Creează un grup de butoane radio pentru selecția parametrilor.
   ```matlab
   radio_group_button1 = uibuttongroup(grid, 'Title', 'Period');
   ```

6. **uiradiobutton**: Creează butoane radio pentru a selecta opțiuni.
   ```matlab
   radio1 = uiradiobutton(radio_group_button1, 'Text', '5 Perioade');
   ```

7. **uicheckbox**: Creează un checkbox pentru a activa sau dezactiva o opțiune.
   ```matlab
   ckb1 = uicheckbox(grid, 'Text', 'CC', 'Value', true);
   ```

8. **uieditfield**: Permite utilizatorului să introducă valori numerice.
   ```matlab
   form.A0 = uieditfield(form.panel, 'numeric', 'Value', par.A0);
   ```

9. **uibutton**: Creează un buton care execută o acțiune la apăsare.
   ```matlab
   submit_button = uibutton(grid, 'Text', 'Submit', ...
       'ButtonPushedFcn', @(btn,event) submit_button_callback(...));
   ```

## Explicația Codului

### Structura Inițială

Codul începe prin definirea unei structuri `par` care conține parametrii necesari pentru generarea semnalelor:

```matlab
par = struct;
par.A0 = 0; % Componenta continuă a primului semnal
par.A = 1; % Amplitudinea primului semnal
par.B0 = 0; % Componenta continuă a celui de-al doilea semnal
par.B = 1; % Amplitudinea celui de-al doilea semnal
par.f = 1000; % Frecvența semnalului
par.R1 = 1; % Rezistența 1
par.R2 = 1; % Rezistența 2
par.AMP = 1 + par.R2/par.R1; % Amplificarea
```

### Crearea Feronării și a Controalelor UI

O fereastră principală este creată folosind `uifigure`, iar controalele sunt organizate într-un panou cu ajutorul `uigridlayout`. Controalele includ butoane radio pentru selecția perioadelor și tipului de semnal, un checkbox pentru componenta continuă și câmpuri de editare pentru parametrii numerici.

### Funcția Butonului de Submit

Când utilizatorul apasă butonul "Submit", se apelează funcția `submit_button_callback`, care preia valorile introduse de utilizator și generează semnalele corespunzătoare:

```matlab
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

    % Generarea semnalului în funcție de tipul ales
    if strcmp(grp2.SelectedObject.Text, 'Sinus')
        t = 0:1/(100*par.f):T;
        ya = par.A0 * ckb1.Value + par.A*sin(2*pi*par.f*t);
        yb = par.B0 * ckb1.Value + par.B*sin(2*pi*par.f*t);
    else % Semnal dreptunghiular
        t = 0:1/(100*par.f):T;
        ya = par.A0 * ckb1.Value + par.A*sign(sin(2*pi*par.f*t));
        yb = par.B0 * ckb1.Value + par.B*sign(sin(2*pi*par.f*t));
    end

    % Calcularea semnalului rezultat și limitarea valorilor acestuia
    y = par.AMP*(ya - yb);
    y(y > 25) = 25;
    y(y < -30) = -30;

    % Afișarea semnalelor în graficele corespunzătoare
    plot(axe1, t, y);
    plot(axe2, t, y, t, ya, t, yb);
end
```

### Generarea Semnalului

Funcția calculează semnalele pe baza parametrilor introduși de utilizator și le limitează între anumite valori pentru a evita distorsiunile.
