function Trial=cal_ang_gait(Trial, camp)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% funzione per calcolare gli angoli articolari medi durante il ciclo del passo
%
% input:    Trial-->Struct contenente il trial da esaminare
%           camp-->Numero campioni per il resample
%
% output:   Trial-->Struct modificata con l'aggiunta del campo per gli
%                   angoli articolari medi durante il gait cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global joints
global Direction

% Resample affinchè tutti i cicli abbiano lo stesso numero di campioni
for m=1:length(joints)
    for n=1:length(Direction)
        for k=1:length(Trial.gait_camp(:,1))
            aus=Trial.loc_ang.(joints{m}).(Direction{n})(Trial.gait_camp(k,1):Trial.gait_camp(k,2));
            if (Trial.gait_camp(k,1)-Trial.gait_camp(k,2))~=camp
                t = linspace(0,1, (Trial.gait_camp(k,2)-Trial.gait_camp(k,1)+1));
                nuovot = linspace(0,1,camp);
                aus = interp1(t, aus, nuovot,"spline");
            end
            % Per ciascuna artcolazione, gli angoli articolari ricampionati durante ciascun ciclo del passo
            % vengono concatenati verticalmente per facilitare l'operazione di media.
            if k==1
                Trial.angle.(joints{m}).(Direction{n}).cycle=[];
            end
            Trial.angle.(joints{m}).(Direction{n}).cycle=[Trial.angle.(joints{m}).(Direction{n}).cycle;aus];
        end
    end
end


% Controllo per gestire i NaN (se presenti)
for m=1:length(joints)
    for n=1:length(Direction)
        noNaN.(joints{m}).(Direction{n})=ones(length(Trial.angle.(joints{m}).(Direction{n}).cycle(:,1)),1);
        for k=1:length(Trial.angle.(joints{m}).(Direction{n}).cycle(:,1))
            hasNaN = any(isnan(Trial.angle.(joints{m}).(Direction{n}).cycle(k,:)));
            if hasNaN
                noNaN.(joints{m}).(Direction{n})(k)=0;
            end
        end
    end
end




end