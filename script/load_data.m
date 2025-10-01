function data=load_data(percorso)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per caricare i dati del soggetto
% input:    percorso--> stringa contenente il percorso in cui sono salvati
%                       i dati
% output:   data--> struct contenente tutti i dati
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ottieni la lista dei file .mat nella cartella
files = dir(fullfile(percorso, '*.mat'));

% Inizializza la struct
data = struct();
field_name=["Trial1";"Trial2";"Trial3"];
% Loop attraverso tutti i file .mat
for i = 1:length(files)
    % Carica il file .mat
    file = files(i);
    file_path = fullfile(percorso, file.name);
    loaded_data = load(file_path);
    if i~=1
        % Assegna le variabili alla struct
        data.(field_name(i-1)) = loaded_data;
    else
        data = loaded_data;
    end
end

end