function Trial=act_inter_gait(Trial,camp,alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% funzione per calcolare gli intervalli di attivazione "medi" durante il
% ciclo del passo
%
% input:    Trial-->Struct contenente il trial da esaminare
%           camp-->Numero campioni per il resample
%           alpha-->F_emg/F_kin
%
% output:   Trial-->Struct modificata con l'aggiunta del campo per gli
%                   intervalli di attivazione medi durante il gait cycle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global muscle_code

% Resample affinchè tutti i cicli abbiano lo stesso numero di campioni
for i=1:length(muscle_code)
    for k=1:length(Trial.gait_camp(:,1))
        if length(Trial.act_int.(muscle_code(i)))~=0
            aus=Trial.act_int.(muscle_code(i))((alpha*Trial.gait_camp(k,1)):(alpha*Trial.gait_camp(k,2)));
            aus=resample(aus,camp,length(aus));
            aus(find(aus>0.5))=ones(1,length(find(aus>0.5)));
            aus(find(aus<0.5))=zeros(1,length(find(aus<0.5)));
            % Per ciascun muscolo, gli intervalli di attivazione ricampionati durante ciascun ciclo del passo vengono sommati.
            if k==1
                Trial.act_int_mean.(muscle_code(i))=aus;
            else
                Trial.act_int_mean.(muscle_code(i))=Trial.act_int_mean.(muscle_code(i))+aus;
            end
        else
            Trial.act_int_mean.(muscle_code(i))=zeros(camp,1);
        end
    end
end

% Le somme degli intervalli vengono quindi normalizzate dividendo per la somma massima di tutti i cicli del passo per quel muscolo. 
% Questa normalizzazione fornisce una misura della densità relativa di attivazione per ciascun muscolo durante il ciclo del passo.
for i=1:length(muscle_code)
    Trial.act_int_mean_norm.(muscle_code(i))=Trial.act_int_mean.(muscle_code(i))/max(Trial.act_int_mean.(muscle_code(i)));
end

end
