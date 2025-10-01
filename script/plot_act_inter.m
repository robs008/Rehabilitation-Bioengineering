function plot_act_inter(data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per plottare i dati relativi alle attivazioni muscolari del
% soggetto preso in esame
%
% input:    data-->Struct contenente i dati del soggetto
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global muscle_code

figure
l=length(data.act_inter_tot_norm.(muscle_code(1)));
for k=1:length(muscle_code)
    subplot(length(muscle_code),1,k);
    plot((0:l-1)/(l-1)*100,data.act_inter_tot_norm.(muscle_code(k)));
    ylabel(muscle_code(k));
    if k==1
        title('EMG activation interval');
    end
    if k==length(muscle_code)
         xlabel('Gait cycle %');
    end
end

end