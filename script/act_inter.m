function Trial=act_inter(Trial,emg_fsamp,f_env,soglia)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per calcolare gli intervalli di attivazione su tutto il trial 
%
% input:    Trial-->Struct contenente i dati del trial
%           emg_fsamp-->Frequenza di campionamento del segnale emg
%           f_env-->Frequenza filtro passa-basso inviluppo
%           soglia-->soglia da moltiplicare per la deviazione std del
%                    segnale inviluppo per la ricerca degli intervalli di
%                    attivazione
%
% output:   Trial-->Struct contenente i dati del trial con i due campi
%                   aggiuntivi per l'inviluppo e gli istanti di attivazione
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global muscle_code

% PREPROCESSING DEI SEGNALI EMG

% Filtro EMG passa-banda
wn=[20,300]/(emg_fsamp/2);
n=4;
[b,a]=butter(n,wn,'bandpass');

% Filtro Notch a 50Hz per la rimozione dell'interferenza di rete
[cMA,cAR]=rico_mod(0.01,6,50,emg_fsamp);


% Filtraggio dei segnali con controllo dei NaN
for k=1:length(muscle_code)
    sig=Trial.sd_sig.(muscle_code(k));
    ind_nan=find(isnan(sig));
    sig(ind_nan)=0;
    % BANDPASS
    sig=filtfilt(b,a,sig);
    % NOTCH
    Trial.sd_sig_filt.(muscle_code(k))=filtfilt(cMA,cAR,sig);
end



% INVILUPPO

% Rettifica del segnale filtrato
for k=1:length(muscle_code)
    Trial.sd_sig_envelope.(muscle_code(k))=abs(Trial.sd_sig_filt.(muscle_code(k)));
end

% Filtro passa-basso per l'inviluppo
wn=f_env/(emg_fsamp/2);
n=4;
[b,a]=butter(n,wn);

% Filtraggio dei segnali rettificati
for k=1:length(muscle_code)
    Trial.sd_sig_envelope.(muscle_code(k))=filtfilt(b,a,Trial.sd_sig_envelope.(muscle_code(k)));
end


% Ricerca degli intervalli di attivazione muscolari
for i=1:length(muscle_code)    

    th=soglia*std(Trial.sd_sig_envelope.(muscle_code(i)));
    Trial.act_int.(muscle_code(i))=Trial.sd_sig_envelope.(muscle_code(i))>th;
    Trial.act_int.(muscle_code(i))=double(Trial.act_int.(muscle_code(i)));

    interval=0;
    for k=2:length(Trial.act_int.(muscle_code(i)))
        if Trial.act_int.(muscle_code(i))(k-1)==1 && Trial.act_int.(muscle_code(i))(k)==0
            cont=1;
            interval=1;
        end
        if interval==1 && Trial.act_int.(muscle_code(i))(k)==0
            cont=cont+1;
        elseif  interval==1 && Trial.act_int.(muscle_code(i))(k)==1
            interval=0;
            if cont<=50
                Trial.act_int.(muscle_code(i))(k-cont:k-1)=ones(1,cont);
            end
        end
    end
end

end