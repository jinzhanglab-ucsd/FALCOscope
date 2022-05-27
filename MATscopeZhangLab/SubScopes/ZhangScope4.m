classdef ZhangScope4 < ZhangScopes
    % Subclass of Scope that makes certain behavior specific to the
    % Zhang Lab Scope4.
    
    properties
        
    end
    
    
    
    methods
        %% Devices Method
        
        function hardwareAF(Scp,AcqData)
            % Overloadable method to use the hardware for autofocus
            
%             Scp.mmc.enableContinuousFocus(true);
%             t0=now;
%             while ~Scp.mmc.isContinuousFocusLocked && (now-t0)*24*3600 < Scp.autofocusTimeout
%                 pause(Scp.autofocusTimeout/1000)
%             end
%             if (now-t0)*24*3600 > Scp.autofocusTimeout
%                 msgbox('Out of Focus ! watch out!!!');
%             end
            
            Scp.mmc.setProperty('Core','AutoFocus','ZeissDefiniteFocus');
            Scp.mmc.setProperty('ZeissDefiniteFocus','Focus Method', 'Last Position');
%             Scp.mmc.fullFocus();
            Scp.mmc.fullFocus()
%             fprintf('did full focus \n');
            Scp.mmc.waitForDevice('ZeissFocusAxis')
            Scp.mmc.sleep(1)
            

        end
        
    end
    
    
end