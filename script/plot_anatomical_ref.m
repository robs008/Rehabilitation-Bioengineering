function plot_anatomical_ref(Trial)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per plottare l'avanzamento temporale dei sistemi di riferimento anatomici 
% durante la deambulazione per il singolo trial.
%
% Input:    Trial--> Struct contenente i dati del trial.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global markers
global segments
global coords

% x-->rosso
% y-->blu
% z-->verde
col={'r','b','g'};

% fattore di scala per rendere visibili i vettori
scale_factor=100;
for m=1:length(segments)
    for n=1:length(coords)
            Trial.loc_ref.(segments{m}).(coords{n})=scale_factor*Trial.loc_ref.(segments{m}).(coords{n});
    end
end

figure
t=1;
xlim([-4000 6000])
ylim([0 2000])
zlim([-400 2000])
axis equal
for m=1:length(segments)
    xlim([-4000 6000])
    ylim([0 2000])
    zlim([-400 2000])
    axis equal
    xlabel('x'); ylabel('y');  zlabel('z')
    hx(m)=quiver3(Trial.loc_ref.(segments{m}).O(t,1),Trial.loc_ref.(segments{m}).O(t,2),Trial.loc_ref.(segments{m}).O(t,3),Trial.loc_ref.(segments{m}).(coords{1})(t,1),Trial.loc_ref.(segments{m}).(coords{1})(t,2),Trial.loc_ref.(segments{m}).(coords{1})(t,3),'Color',col{1});
    hold on;
    hy(m)=quiver3(Trial.loc_ref.(segments{m}).O(t,1),Trial.loc_ref.(segments{m}).O(t,2),Trial.loc_ref.(segments{m}).O(t,3),Trial.loc_ref.(segments{m}).(coords{2})(t,1),Trial.loc_ref.(segments{m}).(coords{2})(t,2),Trial.loc_ref.(segments{m}).(coords{2})(t,3),'Color',col{2});
    hold on;
    hz(m)=quiver3(Trial.loc_ref.(segments{m}).O(t,1),Trial.loc_ref.(segments{m}).O(t,2),Trial.loc_ref.(segments{m}).O(t,3),Trial.loc_ref.(segments{m}).(coords{3})(t,1),Trial.loc_ref.(segments{m}).(coords{3})(t,2),Trial.loc_ref.(segments{m}).(coords{3})(t,3),'Color',col{3});
    hold on;
    
end

for t=1:size(Trial.traj.(markers{1}),1)
    axis equal
    xlim([-4000 6000])
    zlim([0 2000])
    ylim([-400 2000])
    for m=1:length(segments)
        set(hx(m), 'XData', Trial.loc_ref.(segments{m}).O(t,1), 'YData', Trial.loc_ref.(segments{m}).O(t,2), 'ZData', Trial.loc_ref.(segments{m}).O(t,3), ...
            'UData', Trial.loc_ref.(segments{m}).(coords{1})(t,1), 'VData', Trial.loc_ref.(segments{m}).(coords{1})(t,2), 'WData', Trial.loc_ref.(segments{m}).(coords{1})(t,3));
        set(hy(m), 'XData', Trial.loc_ref.(segments{m}).O(t,1), 'YData', Trial.loc_ref.(segments{m}).O(t,2), 'ZData', Trial.loc_ref.(segments{m}).O(t,3), ...
            'UData', Trial.loc_ref.(segments{m}).(coords{2})(t,1), 'VData', Trial.loc_ref.(segments{m}).(coords{2})(t,2), 'WData', Trial.loc_ref.(segments{m}).(coords{2})(t,3));
        set(hz(m), 'XData', Trial.loc_ref.(segments{m}).O(t,1), 'YData', Trial.loc_ref.(segments{m}).O(t,2), 'ZData', Trial.loc_ref.(segments{m}).O(t,3), ...
            'UData', Trial.loc_ref.(segments{m}).(coords{3})(t,1), 'VData', Trial.loc_ref.(segments{m}).(coords{3})(t,2), 'WData', Trial.loc_ref.(segments{m}).(coords{3})(t,3));
    end
    drawnow limitrate
end

end