function plot_ang(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per plottare i dati relativi agli angoli articolari del
% soggetto preso in esame
%
% input:    data-->Struct contenente i dati del soggetto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global joints
global Direction

tit_1={'Left Hip'; 'Right Hip'; 'Left Knee'; 'Right Knee'; 'Left Ankle'; 'Right Ankle'};
tit_2={'flexion';'adduction';'internal rotation'};
camp=length(data.angle_tot.(joints{1}).(Direction{1}).mean);
figure
for m=1:2:length(joints)-1
    for n=1:length(Direction)
        subplot(length(joints)/2,length(Direction),(m-1)*3/2+n)
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean,'b',LineWidth=2); hold on;
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean-data.angle_tot.(joints{m}).(Direction{n}).se,'b'); hold on;
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean+data.angle_tot.(joints{m}).(Direction{n}).se,'b');
        xlabel('Gait cycle %'); ylabel('Angle [deg]');
        t=[tit_1{m},' ',tit_2{n}];
        title(t);
    end
end

figure
for m=2:2:length(joints)
    for n=1:length(Direction)
        subplot(length(joints)/2,length(Direction),(m/2-1)*3+n)
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean,'b',LineWidth=2); hold on;
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean-data.angle_tot.(joints{m}).(Direction{n}).se,'b'); hold on;
        plot((1:camp)/camp*100,data.angle_tot.(joints{m}).(Direction{n}).mean+data.angle_tot.(joints{m}).(Direction{n}).se,'b');
        xlabel('Gait cycle %'); ylabel('Angle [deg]');
        t=[tit_1{m},' ',tit_2{n}];
        title(t);
    end
end

end