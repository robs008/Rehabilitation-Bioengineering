function data=act_inter_gait_tot(data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per calcolare gli intervalli di attivazione muscolare "medi" per
% un soggetto (media tra i 3 trial)
% 
% input:    data--> Struct contenente i dati del soggetto
%
% output:   data--> Struct modificata con l'aggiunta del campo per gli
%                   intervalli di attivazione
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global field_name
global muscle_code

% Per ciascun muscolo, gli intervalli di attivazione medi di ciascuno dei 3 trial vengono sommati.
for k=1:3
    for n=1:length(muscle_code)
        if k==1
            data.act_inter_tot.(muscle_code(n))=data.(field_name(k+1)).act_int_mean.(muscle_code(n));
        else
            data.act_inter_tot.(muscle_code(n))=data.act_inter_tot.(muscle_code(n))+data.(field_name(k+1)).act_int_mean.(muscle_code(n));
        end
    end
end

% Le somme degli intervalli vengono quindi normalizzate dividendo per la somma massima di tutti i cicli del passo per quel muscolo. 
% Questa normalizzazione fornisce una misura della densità relativa di attivazione per ciascun muscolo durante il ciclo del passo.
for n=1:length(muscle_code)
    data.act_inter_tot_norm.(muscle_code(n))=data.act_inter_tot.(muscle_code(n))/max(data.act_inter_tot.(muscle_code(n)));
end
end



