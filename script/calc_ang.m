function [loc_ang]=calc_ang(loc_ref)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per calcolare gli angoli articolari per le articolazioni
% dell'anca, del ginocchio e della caviglia.
%
% input:    loc_ref-->struct contenente le informazioni relative ai sistemi
%                       di riferimento anatomici
%
% output:   loc_ang-->struct contenente gli angoli articolari per ogni
%                       articolazione
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


frame=length(loc_ref.pelvis.x(:,1)); % Numero di frame
for k=1:frame

    % Anca sinistra
    gRp=[loc_ref.pelvis.x(k,:)',loc_ref.pelvis.z(k,:)',loc_ref.pelvis.y(k,:)'];
    gRd=[loc_ref.femur_left.x(k,:)',loc_ref.femur_left.z(k,:)',loc_ref.femur_left.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Hip_left.adduction(k)=asin(Rj(3,2));
    loc_ang.Hip_left.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Hip_left.adduction(k)));
    loc_ang.Hip_left.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Hip_left.adduction(k)));

    % Anca destra
    gRp=[loc_ref.pelvis.x(k,:)',loc_ref.pelvis.z(k,:)',loc_ref.pelvis.y(k,:)'];
    gRd=[loc_ref.femur_right.x(k,:)',loc_ref.femur_right.z(k,:)',loc_ref.femur_right.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Hip_right.adduction(k)=asin(Rj(3,2));
    loc_ang.Hip_right.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Hip_right.adduction(k)));
    loc_ang.Hip_right.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Hip_right.adduction(k)));
    
    % Ginocchio sinistro
    gRp=[loc_ref.femur_left.x(k,:)',loc_ref.femur_left.z(k,:)',loc_ref.femur_left.y(k,:)'];
    gRd=[loc_ref.shank_left.x(k,:)',loc_ref.shank_left.z(k,:)',loc_ref.shank_left.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Knee_left.adduction(k)=asin(Rj(3,2));
    loc_ang.Knee_left.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Knee_left.adduction(k)));
    loc_ang.Knee_left.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Knee_left.adduction(k)));

    % Ginocchio destro
    gRp=[loc_ref.femur_right.x(k,:)',loc_ref.femur_right.z(k,:)',loc_ref.femur_right.y(k,:)'];
    gRd=[loc_ref.shank_right.x(k,:)',loc_ref.shank_right.z(k,:)',loc_ref.shank_right.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Knee_right.adduction(k)=asin(Rj(3,2));
    loc_ang.Knee_right.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Knee_right.adduction(k)));
    loc_ang.Knee_right.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Knee_right.adduction(k)));

    % Caviglia sinistra
    gRp=[loc_ref.shank_left.x(k,:)',loc_ref.shank_left.z(k,:)',loc_ref.shank_left.y(k,:)'];
    gRd=[loc_ref.foot_left.x(k,:)',loc_ref.foot_left.z(k,:)',loc_ref.foot_left.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Ankle_left.adduction(k)=asin(Rj(3,2));
    loc_ang.Ankle_left.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Ankle_left.adduction(k)));
    loc_ang.Ankle_left.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Ankle_left.adduction(k)));

    % Caviglia destra
    gRp=[loc_ref.shank_right.x(k,:)',loc_ref.shank_right.z(k,:)',loc_ref.shank_right.y(k,:)'];
    gRd=[loc_ref.foot_right.x(k,:)',loc_ref.foot_right.z(k,:)',loc_ref.foot_right.y(k,:)'];
    Rj=gRp'*gRd;
    loc_ang.Ankle_right.adduction(k)=asin(Rj(3,2));
    loc_ang.Ankle_right.internal_rotation(k)=asin(-Rj(3,1)/cos(loc_ang.Ankle_right.adduction(k)));
    loc_ang.Ankle_right.flexion(k)=asin(-Rj(1,2)/cos(loc_ang.Ankle_right.adduction(k)));
end
