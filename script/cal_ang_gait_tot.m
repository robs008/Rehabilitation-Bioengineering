function data=cal_ang_gait_tot(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per calcolare gli angoli articolari medi per un soggetto (media tra i 3 trial)
% 
% input:    data--> Struct contenente i dati del soggetto
%
% output:   data--> Struct modificata con l'aggiunta del campo per gli
%                   angoli articolari
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global joints
global Direction
global field_name

% Concatenazione verticale degli angoli articolari
i=1;
for m=1:length(joints)
    for n=1:length(Direction)
        aus.(joints{m}).(Direction{n})=rad2deg(data.(field_name(i+1)).angle.(joints{m}).(Direction{n}).cycle);
    end
end
for i=2:3
    for m=1:length(joints)
        for n=1:length(Direction)
            aus.(joints{m}).(Direction{n})=[aus.(joints{m}).(Direction{n});rad2deg(data.(field_name(i+1)).angle.(joints{m}).(Direction{n}).cycle)];
        end
    end
end


% Media tra i trial e calcolo dell'errore standard totale
for m=1:length(joints)
    for n=1:length(Direction)
        data.angle_tot.(joints{m}).(Direction{n}).mean=real(mean(aus.(joints{m}).(Direction{n})));
        data.angle_tot.(joints{m}).(Direction{n}).se=std(aus.(joints{m}).(Direction{n}))/sqrt(length(aus.(joints{m}).(Direction{n})(:,1)));
        
    end
end

end