function sihex_gui
% SIHEX_GUI
%   Plots SiHex seismicity map, histogram or GR relation
%   Makes simple analysis of the data.
%   Edit the Mc value to change the completeness magnitude for GR
%   calculation.
%   Edit the Mw value to calculate the number of events greater than this
%   value occur per year.
%   

%-------------------------------------------------------------------------
% Initialization tasks
close all
clear all
addpath './seismicity'

% figure init
fh = figure('Visible','off',...
    'Position',[400,200,800,600],...
    'MenuBar','none',...
    'Name','SiHex Display and Analysis',...
    'NumberTitle','off',...
    'Resize','off',...
    'Toolbar','none');

% set up SiHex variables
seismicity = setUpSiHex;
doGutenbergRichter;

% world maps
world = loadWorldMap;

%-------------------------------------------------------------------------
% Construct the components
ph_plot = uipanel('Parent',fh,...
    'Position',[.75,.55,.2,.4],...
    'Title','Ploting');
ph_mag = uipanel('Parent',fh,...
    'Position',[.75,.05,.2,.45],...
    'Title','Analysis');
ha = axes('Parent',fh,...
    'Units','Normalized',...
    'Position',[.065,.065,.65,.85]);



% plot options
ch_plotS = uicontrol('Parent',ph_plot,...
    'Style','pushbutton',...
    'String','Seismicity',...
    'Callback',{@S_plot},...
    'Position',[20,160,120,50]...
    );
ch_plotH = uicontrol('Parent',ph_plot,...
    'Style','pushbutton',...
    'String','Histogram',...
    'Callback',{@H_plot},...
    'Position',[20,90,120,50]...
    );
ch_plotGR = uicontrol('Parent',ph_plot,...
    'Style','pushbutton',...
    'String','Gutenberg-Richter',...
    'Callback',{@GR_plot},...
    'Position',[20,20,120,50]...
    );


% analysis panel

ch_B_text = uicontrol('Parent',ph_mag,...
    'Style','text',...
    'String',['b-value = ',num2str(seismicity.b,'%.2f')],...
    'Position',[20,200,120,25]...
    );
ch_MC_text = uicontrol('Parent',ph_mag,...
    'Style','text',...
    'String','Mc =',...
    'Position',[20,100,50,20]...
    );
ch_MC_edit = uicontrol('Parent',ph_mag,...
    'Style','edit',...
    'String',num2str(seismicity.mc),...
    'Callback',{@MC_edit},...
    'Position',[80,100,50,25]...
    );
ch_M_text = uicontrol('Parent',ph_mag,...
    'Style','text',...
    'String','Mw >',...
    'Position',[20,60,50,20]...
    );
ch_M_edit = uicontrol('Parent',ph_mag,...
    'Style','edit',...
    'String',num2str(seismicity.mvalue),...
    'Callback',{@M_edit},...
    'Position',[80,60,50,25]...
    );

ch_N_text = uicontrol('Parent',ph_mag,...
    'Style','text',...
    'String',[num2str(seismicity.yearlyEvents,'%.2f'),' events / year'],...
    'Position',[20,20,120,30]...
    );


%-------------------------------------------------------------------------
% Initialization taks (post component creation)
S_plot;
set(fh,'Visible','on');
%-------------------------------------------------------------------------
% Callbacks
% city parameters
    
    function M_edit(source,eventdata)
        seismicity.mvalue = str2double(get(source,'string'));
        if isnan(seismicity.mvalue)
            errordlg('Enter a numeric value','Bad Input','modal');
            return
        end
        doGutenbergRichter;
        set(ch_N_text,'String',...
            [num2str(seismicity.yearlyEvents,'%.2f'),' events / year']);
        S_plot;
    end

    function MC_edit(source,eventdata)
        seismicity.mc = str2double(get(source,'string'));
        if isnan(seismicity.mc)
            errordlg('Enter a numeric value','Bad Input','modal');
            return
        end
        doGutenbergRichter;
        GR_plot;
        set(ch_B_text,'String',...
            ['b-value = ',num2str(seismicity.b,'%.2f')]);
        set(ch_N_text,'String',...
            [num2str(seismicity.yearlyEvents,'%.2f'),' events / year']);
    end

    function H_plot(source,eventdata)
        hold off;
        bins = seismicity.bins(seismicity.gtmv);
        N = seismicity.N(seismicity.gtmv);
        
        bar(bins, N,'histc');
        xlabel('Mw','FontSize',14);
        ylabel('N(M>Mw)','FontSize',14);
        title(['Histogram (1962-2009) Mw > ',num2str(seismicity.mvalue)],...
            'FontSize',16,'FontWeight','bold');
    end

    function GR_plot(source,eventdata)
        hold off;
        bins = seismicity.bins;
        N = seismicity.log10N;
        plot(bins,N,'*');
        xlabel('Mw','FontSize',14);
        ylabel('log10N(M>Mw)','FontSize',14);
        title(['Gutenberg-Richter (1962-2009) Mw > ',num2str(seismicity.mc)],...
            'FontSize',16,'FontWeight','bold');
        % draw the GR line
        hold on;
        m1 = seismicity.mc;
        m2 = max(seismicity.mag);
        y1 = seismicity.a + seismicity.b*m1;
        y2 = seismicity.a + seismicity.b*m2;
        plot([m1,m2],[y1,y2],'r', 'LineWidth',2);
        
    end

    function S_plot(source,eventdata)
        % set limits for France
        LonMin=-8;LonMax=11;
        LatMin=41;LatMax=52;
        m2 = seismicity.mag > seismicity.mvalue & seismicity.mag <= 2;
        m3 = seismicity.mag > seismicity.mvalue & ...
            seismicity.mag > 2 & seismicity.mag <= 3;
        m4 = seismicity.mag > seismicity.mvalue & ...
            seismicity.mag > 3 & seismicity.mag <= 4;
        m5 = seismicity.mag > seismicity.mvalue & ...
            seismicity.mag > 4 & seismicity.mag <= 5;
        m6 = seismicity.mag > seismicity.mvalue & ...
            seismicity.mag > 5;
        hold off;
        plot(world.long,world.lat,'k','LineWidth',2);
        axis([LonMin,LonMax,LatMin,LatMax]);
        xlabel('Longitude E','FontSize',14);
        ylabel('Latitude N','FontSize',14);
        title(['Seismicity (1962-2009) Mw > ',num2str(seismicity.mvalue)],...
            'FontSize',16,'FontWeight','bold');
        
        hold on;
        plot(seismicity.lon(m2),seismicity.lat(m2),'co','MarkerSize',2,...
            'MarkerFaceColor','cyan');
        plot(seismicity.lon(m3),seismicity.lat(m3),'bo','MarkerSize',5,...
            'MarkerFaceColor','blue');
        plot(seismicity.lon(m4),seismicity.lat(m4),'ko','MarkerSize',10,...
            'MarkerFaceColor','green');
        plot(seismicity.lon(m5),seismicity.lat(m5),'ko','MarkerSize',20,...
            'MarkerFaceColor','magenta');
        plot(seismicity.lon(m6),seismicity.lat(m6),'ko','MarkerSize',30,...
            'MarkerFaceColor','red');

    end

%-------------------------------------------------------------------------
% Utility functions
    function world = loadWorldMap
        world = load('LatWorld.mat');
        world_tmp = load('LonWorld.mat');
        world.long = world_tmp.long;
    end

    function seismicity = setUpSiHex
        [latvec, lonvec, mvector] = ...
            readSihexData('SIHEXV2-catalogue-final.txt');
        seismicity.lat = latvec;
        seismicity.lon = lonvec;
        seismicity.mag = mvector;
        seismicity.timespan = 2009-1962+1
        seismicity.mvalue = 1.5;
        seismicity.mc = 1.5;

    end

    function doGutenbergRichter
        [seismicity.log10N,seismicity.bins] = GR(seismicity.mag);
        seismicity.N = 10.^seismicity.log10N;
        seismicity.gtmc = seismicity.bins > seismicity.mc;
        seismicity.gtmv = seismicity.bins > seismicity.mvalue;
        coef = polyfit(seismicity.bins(seismicity.gtmc),...
            seismicity.log10N(seismicity.gtmc), 1);
        seismicity.b = coef(1);
        seismicity.a = coef(2);
        seismicity.yearlyEvents = 10^(seismicity.a + ...
            seismicity.b*seismicity.mvalue) / seismicity.timespan ;

    end

end
