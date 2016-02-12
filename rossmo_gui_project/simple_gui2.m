function simple_gui2
% SIMPLE_GUI2 Select a dataset from the popup menu
% click one of the plot-type push buttons
% plots the selected data in the axes.

% Initialize and hide the GUI
f = figure('Visible','off','Position',[360,500,450,285]);

% Construct the components
hsurf = uicontrol('Style','pushbutton',...
    'String','Surf',...
    'Callback',{@surfbutton_callback},...
    'Position',[315,220,70,25]);
hmesh = uicontrol('Style','pushbutton',...
    'String','Mesh',...
    'Callback',{@meshbutton_callback},...
    'Position',[315,180,70,25]);
hcont = uicontrol('Style','pushbutton',...
    'String','Contour',...
    'Callback',{@contbutton_callback},...
    'Position',[315,140,70,25]);
htext = uicontrol('Style','text',...
    'String','Select Data',...
    'Position',[325,90,100,15]);
hpop = uicontrol('Style','popupmenu',...
    'String',{'Peaks','Membrane','Sinc'},...
    'Callback',{@popup_menu_callback},...
    'Position',[300,50,100,25]);
ha = axes('Units','Pixels',...
    'Position',[50,60,200,185]);
align([hsurf,hmesh,hcont,htext,hpop],'Center','None');

% Make Init
set([f,hsurf,hmesh,hcont,htext,hpop],'Units','normalized');
%generate data to plot
peaks_data = peaks(35);
membrane_data = membrane;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2)+eps;
sinc_data = sin(r)./r;
% create a plot in the axes
current_data = peaks_data;
surf(current_data);
%assign a name to the GUI
set(f,'Name','Simple GUI');
%move the GUI to the center
movegui(f,'center');
%make it visible
set(f,'Visible','on');

%pop-up menu callback
    function popup_menu_callback(source,eventdata)
        %determine selected data set
        str = get(source,'String');
        val = get(source,'Value');
        % set current data to selected data set
        switch str{val};
            case 'Peaks'
                current_data = peaks_data;
            case 'Membrane'
                current_data = membrane_data;
            case 'Sinc'
                current_data = sinc_data;
        end
    end
%push button callbacks
    function surfbutton_callback(source,eventdata)
        surf(current_data);
    end
    function meshbutton_callback(source,eventdata)
        mesh(current_data);
    end
    function contbutton_callback(source,eventdata)
        contour(current_data);
    end
end