function gait_camp=estimate_cycles(HEE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione che calcola i campioni di inizio e fine di ogni ciclo del passo.
%   Input:      HEE         --> vettore (n_frame x 1) che contiene le
%                               coordinate z di HEE (marker del tallone destro)
%                               per ogni frame
%                                   
%   Output:     gait_camp   --> matrice (n_cycles x 2) che contiene nella
%                               prima colonna il campione di inizio e nella seconda il campione di fine
%                               di ogni ciclo del passo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[p,locs]=findpeaks(-HEE,'MinPeakDistance', 100);
% locs contiene gli istanti in cui iniziano i cicli di passo.
% Dobbiamo capire quando termina il ciclo di passo
cont=1;
for k=1:(length(locs)-1)
    gait_camp(cont,1)=locs(k);      %gait_camp(:,1) inizio
    gait_camp(cont,2)=locs(k+1);    %gait_camp(:,2) fine
    hasNaN = any(isnan(HEE(locs(k):locs(k+1))));
    if hasNaN
        cont=cont-1;
    end
    cont=cont+1;
end

end