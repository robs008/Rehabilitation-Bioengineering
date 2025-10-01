function [loc_ref]= calc_references(traj,Antro)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funzione per il calcolo dei sistemi di riferimento anatomici
% 
% input:    traj-->struct contenente le coordinate dei marker (x,y,z) per ogni frame
%           Antro-->struct contenente le misure antropometriche del soggetto
%
% output:   loc_ref-->struct contenente le informazioni relative ai sistemi
%                       di riferimento anatomici:
%                                                O-->origine del sistema di riferimento
%                                                x-->asse antero-posteriore
%                                                y-->asse medio-laterale
%                                                z-->asse infero-superiore
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mm=10; % Diametro dei marker in mm

frame=length(traj.LANK(:,1)); % Numero di frame
for k=1:frame

    % Sistema di riferimento tecnico pelvi
    loc_ref.pelvis.O(k,:)=(traj.LASI(k,:)+traj.RASI(k,:))/2;
    loc_ref.pelvis.y(k,:)=(traj.LASI(k,:)-traj.RASI(k,:)-loc_ref.pelvis.O(k,:))./norm(traj.LASI(k,:)-traj.RASI(k,:)-loc_ref.pelvis.O(k,:));
    % SACR può non essere presente come marker, in questi casi viene
    % calcolato come punto medio tra RPSI e LPSI
    if ~isfield(traj, 'SACR')
        c=(traj.RPSI(k,:)+traj.LPSI(k,:))/2; % c è una coordinata di supporto per indicare la posizione del marker SARC
    else
        c=traj.SACR(k,:);
    end
    % vettore di supporto
    v=c-loc_ref.pelvis.O(k,:);
    loc_ref.pelvis.z(k,:)=cross(loc_ref.pelvis.y(k,:),v)./norm(cross(loc_ref.pelvis.y(k,:),v));
    loc_ref.pelvis.x(k,:)=cross(loc_ref.pelvis.y(k,:),loc_ref.pelvis.z(k,:));
    % Sistema di riferimento anatomico pelvi
    a=0.5;
    b=0.314;
    AsisTrocDist=0.1288*Antro.leg_length-48.56;
    C=Antro.leg_length*0.115-15.3;
    aa=Antro.LASI_RASI_dist/2;
    LHJC=[ C*cos(a)*sin(b)-(AsisTrocDist+mm)*cos(b), -(C*sin(a)-aa), -C*cos(a)*cos(b)-(AsisTrocDist+mm)*sin(b) ];
    RHJC=[ C*cos(a)*sin(b)-(AsisTrocDist+mm)*cos(b), (C*sin(a)-aa), -C*cos(a)*cos(b)-(AsisTrocDist+mm)*sin(b) ];
    O=loc_ref.pelvis.O(k,:);
    LHJC=O+LHJC;    % Sistema di riferimento del laboratorio
    RHJC=O+RHJC;    % Sistema di riferimento del laboratorio
    loc_ref.pelvis.O(k,:)=(LHJC+RHJC)/2;

    % Sistema di riferimento anatomico coscia
    % Sinistra
    KneeOs=(mm+Antro.knee_width)/2;
    loc_ref.femur_left.O(k,:)=chordPiG(traj.LTHI(k,:),LHJC,traj.LKNE(k,:),KneeOs);
    loc_ref.femur_left.z(k,:)=(LHJC-loc_ref.femur_left.O(k,:))./norm(LHJC-loc_ref.femur_left.O(k,:));
    loc_ref.femur_left.x(k,:)=cross(LHJC-traj.LKNE(k,:),traj.LTHI(k,:)-traj.LKNE(k,:))./norm(cross(LHJC-traj.LKNE(k,:),traj.LTHI(k,:)-traj.LKNE(k,:)));
    loc_ref.femur_left.y(k,:)=cross(loc_ref.femur_left.z(k,:),loc_ref.femur_left.x(k,:));
    % Destra
    loc_ref.femur_right.O(k,:)=chordPiG(traj.RTHI(k,:),RHJC,traj.RKNE(k,:),KneeOs);
    loc_ref.femur_right.z(k,:)=(RHJC-loc_ref.femur_right.O(k,:))./norm(RHJC-loc_ref.femur_right.O(k,:));
    loc_ref.femur_right.x(k,:)=cross(RHJC-traj.RKNE(k,:),traj.RTHI(k,:)-traj.RKNE(k,:))./norm(cross(RHJC-traj.RKNE(k,:),traj.RTHI(k,:)-traj.RKNE(k,:)));
    loc_ref.femur_right.y(k,:)=cross(loc_ref.femur_right.z(k,:),loc_ref.femur_right.x(k,:));

    % Sistema di riferimento anatomico tibia (torsioned)
    % Sinistra
    AnkleOs=(mm+Antro.ankle_width)/2;
    loc_ref.shank_left.O(k,:)=chordPiG(traj.LTIB(k,:),loc_ref.femur_left.O(k,:),traj.LANK(k,:),AnkleOs);
    loc_ref.shank_left.z(k,:)=(loc_ref.femur_left.O(k,:)-loc_ref.shank_left.O(k,:))./norm(loc_ref.femur_left.O(k,:)-loc_ref.shank_left.O(k,:));
    loc_ref.shank_left.x(k,:)=cross(loc_ref.femur_left.O(k,:)-loc_ref.shank_left.O(k,:),traj.LTIB(k,:)-loc_ref.shank_left.O(k,:))./norm(cross(loc_ref.femur_left.O(k,:)-loc_ref.shank_left.O(k,:),traj.LTIB(k,:)-loc_ref.shank_left.O(k,:)));
    loc_ref.shank_left.y(k,:)=cross(loc_ref.shank_left.z(k,:),loc_ref.shank_left.x(k,:));
    % Destra
    loc_ref.shank_right.O(k,:)=chordPiG(traj.RTIB(k,:),loc_ref.femur_right.O(k,:),traj.RANK(k,:),AnkleOs);
    loc_ref.shank_right.z(k,:)=(loc_ref.femur_right.O(k,:)-loc_ref.shank_right.O(k,:))./norm(loc_ref.femur_right.O(k,:)-loc_ref.shank_right.O(k,:));
    loc_ref.shank_right.x(k,:)=cross(loc_ref.femur_right.O(k,:)-loc_ref.shank_right.O(k,:),traj.RTIB(k,:)-loc_ref.shank_right.O(k,:))./norm(cross(loc_ref.femur_right.O(k,:)-loc_ref.shank_right.O(k,:),traj.RTIB(k,:)-loc_ref.shank_right.O(k,:)));
    loc_ref.shank_right.y(k,:)=cross(loc_ref.shank_right.z(k,:),loc_ref.shank_right.x(k,:));

    % Sistema di riferimento anatomico piede
    % Sinistra
    loc_ref.foot_left.O(k,:)=traj.LTOE(k,:);
    loc_ref.foot_left.z(k,:)=(loc_ref.shank_left.O(k,:)-traj.LTOE(k,:))./norm(loc_ref.shank_left.O(k,:)-traj.LTOE(k,:));
    loc_ref.foot_left.y(k,:)=cross(loc_ref.foot_left.z(k,:),loc_ref.femur_left.O(k,:)-traj.LTOE(k,:))./norm(cross(loc_ref.foot_left.z(k,:),loc_ref.femur_left.O(k,:)-traj.LTOE(k,:)));
    loc_ref.foot_left.x(k,:)=cross(loc_ref.foot_left.y(k,:),loc_ref.foot_left.z(k,:));
    % Destra
    loc_ref.foot_right.O(k,:)=traj.RTOE(k,:);
    loc_ref.foot_right.z(k,:)=(loc_ref.shank_right.O(k,:)-traj.RTOE(k,:))./norm(loc_ref.shank_right.O(k,:)-traj.RTOE(k,:));
    loc_ref.foot_right.y(k,:)=cross(loc_ref.foot_right.z(k,:),loc_ref.femur_right.O(k,:)-traj.RTOE(k,:))./norm(cross(loc_ref.foot_right.z(k,:),loc_ref.femur_right.O(k,:)-traj.RTOE(k,:)));
    loc_ref.foot_right.x(k,:)=cross(loc_ref.foot_right.y(k,:),loc_ref.foot_right.z(k,:));
end