% This script plots topographical approximate placement of EEG-recording
% used to generate Fig. 1 of the manuscript: https://ieeexplore.ieee.org/abstract/document/9125958
% Code has been refactored for readability - 2026/03/19 - A.B.Kristensen

addpath('.\utils\')

zer = zeros(300,1);  % Dummy input
figure
topoplot(zer,'channel_locations.loc','electrodes','labels','style','blank','efontsize',13)

% % Figure adjustment
f = gcf; a = gca;
f.Position = [359.6667 41.6667 629.3333 599.3333];

% Change color of figure from light blue to white
f.Color = [1,1,1];

% Adjusting axes limits to include nose and ears in plot
lim = 0.58;     % Manually determined
a.XLim = [-lim, lim];
a.YLim = [-lim, lim];

% Save figure

saveas(f,'plotsAndFigures/BlankTopoplot.png')