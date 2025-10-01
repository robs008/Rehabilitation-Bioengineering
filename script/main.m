%% TESINA
%clc;
close all;
clear all;

global markers
global segments
global joints
global sides
global Direction
global muscle_code
global coords
global field_name

Direction= {'flexion';'adduction';'internal_rotation'};

markers= {'LASI'; 'RASI'; 'LPSI'; 'RPSI';'LTHI'; 'LKNE'; 'LTIB'; 'LANK'; 'LHEE'; 'LTOE'; ...
    'RTHI'; 'RKNE'; 'RTIB'; 'RANK'; 'RHEE'; 'RTOE'};

segments= {'pelvis'; 'femur_left'; 'femur_right'; 'shank_left'; 'shank_right'; 'foot_left'; 'foot_right'};

joints={'Hip_left'; 'Hip_right'; 'Knee_left'; 'Knee_right'; 'Ankle_left'; 'Ankle_right'};

coords= {'x'; 'y'; 'z'};

sides= {'left'; 'right'};

muscle_code=["RRF","RVL","RST","RBF","RTA"];

field_name=["Antro";"Trial1";"Trial2";"Trial3"];

%% Caricamento dati
% Percorso della cartella contenente i dati
percorso="C:\Users\Roberto\Desktop\Università\Bioingegneria della riabilitazione\Tesina\tesina_BR_2023_2024\signals";

% soggetto sano
percorso_sano=strcat(percorso,"\SBJ05");
data_sano=load_data(percorso_sano);

% soggetto post ictus 1
percorso_ictus_1=strcat(percorso,"\TVC03");
data_ictus_1=load_data(percorso_ictus_1);

% soggetto post ictus 2
percorso_ictus_2=strcat(percorso,"\TVC13");
data_ictus_2=load_data(percorso_ictus_2);


%% Dati utili
f_kin=100;
f_emg=1000;
camp_kin=120;
alpha=f_emg/f_kin;
camp_emg=camp_kin*alpha;


for i=1:3

    % 1) Calcolo angoli artcolari di anca, ginocchio e caviglia

    % 1.1) Calcolo sistemi di riferimento anatomici

    % soggetto sano
    data_sano.(field_name(i+1)).loc_ref= calc_references(data_sano.(field_name(i+1)).traj,data_sano.(field_name(1)));
    
    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)).loc_ref= calc_references(data_ictus_1.(field_name(i+1)).traj,data_ictus_1.(field_name(1)));

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)).loc_ref= calc_references(data_ictus_2.(field_name(i+1)).traj,data_ictus_2.(field_name(1)));
    


    % 1.2) Calcolo angoli articolari

    % soggetto sano
    data_sano.(field_name(i+1)).loc_ang= calc_ang(data_sano.(field_name(i+1)).loc_ref);
    
    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)).loc_ang= calc_ang(data_ictus_1.(field_name(i+1)).loc_ref);

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)).loc_ang=calc_ang(data_ictus_2.(field_name(i+1)).loc_ref);



    % 2) Identificazione dei cicli del passo

    % soggetto sano
    data_sano.(field_name(i+1)).gait_camp= estimate_cycles(data_sano.(field_name(i+1)).traj.RHEE(:,3));
    
    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)).gait_camp= estimate_cycles(data_ictus_1.(field_name(i+1)).traj.RHEE(:,3));

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)).gait_camp=estimate_cycles(data_ictus_2.(field_name(i+1)).traj.RHEE(:,3));



    % 3) Valutazione degli angoli articolari medi con relativa variabilità sul ciclo precedentemente stimato per ogni trial

    % soggetto sano
    data_sano.(field_name(i+1)) = cal_ang_gait(data_sano.(field_name(i+1)),camp_kin);

    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)) = cal_ang_gait(data_ictus_1.(field_name(i+1)),camp_kin);

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)) = cal_ang_gait(data_ictus_2.(field_name(i+1)),camp_kin);


    % 4) Valutazione andamento medio e variabilità delle attivazioni muscolari su tutti i cicli

    % soggetto sano
    data_sano.(field_name(i+1)) = act_inter(data_sano.(field_name(i+1)),f_emg,8,1.2);

    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)) = act_inter(data_ictus_1.(field_name(i+1)),f_emg,15,1.2);

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)) = act_inter(data_ictus_2.(field_name(i+1)),f_emg,15,1.2);



    % 4.1) Calcolo intervalli di attivazione medi sul ciclo precedentemente stimato per ogni trial

    % soggetto sano
    data_sano.(field_name(i+1)) = act_inter_gait(data_sano.(field_name(i+1)),camp_emg,alpha);

    % soggetto post ictus 1
    data_ictus_1.(field_name(i+1)) = act_inter_gait(data_ictus_1.(field_name(i+1)),camp_emg,alpha);

    % soggetto post ictus 2
    data_ictus_2.(field_name(i+1)) = act_inter_gait(data_ictus_2.(field_name(i+1)),camp_emg,alpha);

end

% 5.1) Calcolo angoli articolari medi sul ciclo precedentemente stimato per ogni soggetto

% soggetto sano
data_sano = cal_ang_gait_tot(data_sano);

% soggetto post ictus 1
data_ictus_1 = cal_ang_gait_tot(data_ictus_1);

% soggetto post ictus 2
data_ictus_2 = cal_ang_gait_tot(data_ictus_2);


% 5.2) Calcolo intervalli di attivazione medi sul ciclo precedentemente stimato per ogni soggetto

% soggetto sano
data_sano = act_inter_gait_tot(data_sano);

% soggetto post ictus 1
data_ictus_1 = act_inter_gait_tot(data_ictus_1);

% soggetto post ictus 2
data_ictus_2 = act_inter_gait_tot(data_ictus_2);

%% Plot 
% sistemi di riferimento anatomici

% Scegliere il trial e il soggetto che si desidera plottare per evitare di
% appesantire inutilmente il codice.

% Esempio: primo trial del soggetto sano.
plot_anatomical_ref(data_sano.Trial1);


%% angoli articolari

% Scegliere il soggetto che si desidera plottare per evitare di appesantire inutilmente il codice.

% Esempio: soggetto sano.
plot_ang(data_sano);


%% intervalli di attivazione

% Scegliere il soggetto che si desidera plottare per evitare di appesantire inutilmente il codice.

% Esempio: soggetto sano.
plot_act_inter(data_sano);
plot_act_inter_trial(data_sano.Trial1);
plot_act_inter_trial(data_sano.Trial2);
plot_act_inter_trial(data_sano.Trial3);







