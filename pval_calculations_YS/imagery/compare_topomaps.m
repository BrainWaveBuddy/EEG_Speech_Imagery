clear all; close all; clc;

% load data
load('W_t_struct.mat')
load('W_t.mat')

subjs = W_t_struct;

i = 1;

% divide to first three & last three// CSP

while i < 18;
    subj{i} = subjs{i, 1};
    subj_1{i} = subj{i}(:,1);
    subj_2{i} = subj{i}(:,2);
    subj_3{i} = subj{i}(:,3);
    subj_4{i} = subj{i}(:,4);
    subj_5{i} = subj{i}(:,5);
    subj_6{i} = subj{i}(:,6);
    i = i + 1;
end

% topoplot

a1 = horzcat(subj_1{:})

figure(1)
for II = 1:17
    subplot(5,4,II)
    topoplot(a1(:,II),'channel_locations.loc');
end


% savefig('CSP1.fig')


a2 = horzcat(subj_2{:})

figure(2)
for II = 1:17
    subplot(5,4,II)
    topoplot(a2(:,II),'channel_locations.loc');
end

% savefig('CSP2.fig')

a3 = horzcat(subj_3{:})

figure(3)
for II = 1:17
    subplot(5,4,II)
    topoplot(a3(:,II),'channel_locations.loc');
end

% savefig('CSP3.fig')

a4 = horzcat(subj_4{:})

figure(4)
for II = 1:17
    subplot(5,4,II)
    topoplot(a4(:,II),'channel_locations.loc');
end

% savefig('CSP4.fig')

figure(5)
a5 = horzcat(subj_5{:})

for II = 1:17
    subplot(5,4,II)
    topoplot(a5(:,II),'channel_locations.loc');
end

% savefig('CSP5.fig')

figure(6)
a6 = horzcat(subj_6{:})

for II = 1:17
    subplot(5,4,II)
    topoplot(a6(:,II),'channel_locations.loc');
end

% savefig('CSP6.fig')
p_files = 0

for p_files = 1:6
    str_saveas = sprintf('CSP_imagery_%d', p_files)
    saveas(p_files, str_saveas, 'pdf');
end

%subj_first = subj_first';
%subj_last = subj_last';


% % topoplot
% for p = 1:17
%     plotthis = subj_first{p}
%     figure
%         for II = 1:3
%         subplot(1,3,II)
%         topoplot(plotthis(:,II),'channel_locations.loc');
%         end
% end