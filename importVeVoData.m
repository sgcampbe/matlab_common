function props = importVeVoData(fname)
% This function retrieves data from exported VeVo2100 report files (CSV is
% the format).  It does so by looking at the first column and extracting
% data only from those which match specified tags (see list herein).  If
% new properties are desired, they must be added to this list with the
% associated column numbers that indicate the type of data (units, avg,
% standard deviation, etc).

% The template contains one row for each desired quantity to extract.  The
% first entry in each row denotes the matlab 'props' struct field name (has
% acceptable matlab field name properties, i.e. no symbols).  The second
% column contains the string that will match the property's row in the VeVo
% CSV file.  The third column specifies the 'mode' (i.e. M-mode, PW Doppler, PW Tissue)
% for the given line, the fourth column specifies the VeVo file column number 
% containing the units specification.  Fifth column specifies the column
% number containing the average value for the property.  The sixth column,
% if not empty, specifies the VeVo column number containing the standard
% deviation of the measured value, if multiple measurements were taken.

template = {...
    
            
            
            %Measurements:
            'Aprime_IVS',   'MV IVS A''',  'PW Tissue Doppler Mode',  4,5,6; ...   %
            'Eprime_IVS',   'MV IVS E''',  'PW Tissue Doppler Mode',   4,5,6; ...%
            'Aprime_LW',   'MV LW A''',  'PW Tissue Doppler Mode',   4,5,6; ...   %
            'Eprime_LW',   'MV LW E''',  'PW Tissue Doppler Mode',   4,5,6; ...%
            'ET_TD',    'ET',   'PW Tissue Doppler Mode',   4,5,6; ...%
            'IVCT_TD',  'IVCT', 'PW Tissue Doppler Mode',   4,5,6; ... %
            'IVRT_TD',  'IVRT', 'PW Tissue Doppler Mode',   4,5,6; ... %
            'A', 'MV A', 'PW Doppler Mode',          4,5,6; ...   %
            'E', 'MV E', 'PW Doppler Mode',          4,5,6; ...   %
            'Decel_MV',    'MV Decel','PW Doppler Mode', 4,5,6; ... %
            
            %Calculations:
            'MV_Area','MV Area (simplified)',''  2,3,[]; ...
            'MV_EtoA', 'MV E/A', '',          2,3,[]; ...   
            'IVS_AprimeOverEprime', 'MV IVS A''/E''',  '',         2,3,[]; ...   
            'IVS_EprimeOverAprime', 'MV IVS E''/A''',  '',         2,3,[]; ... 
            'LW_AprimeOverEprime', 'MV LW A''/E''',  '',          2,3,[]; ...
            'LW_EprimeOverAprime', 'MV LW E''/A''',  '',          2,3,[]; ...
            'MV_PHT','MV PHT (simplified)', '',          2,3,[]; ...
            
            %Measurements:
            'Ao_d', 'AoV Diam', 'B-Mode',                      4,5,6;...
            'AoV_VTI',  'VTI',  'AoV VTI',                     4,5,6;...
            'AoV_Mean_Vel', 'Mean Vel', 'AoV VTI',             4,5,6;...
            'AoV_Mean_Grad',    'Mean Grad',    'AoV VTI',     4,5,6;...
            'AoV_Peak_Vel', 'Peak Vel', 'AoV VTI',             4,5,6;...
            'AoV_Peak_Grad',    'Peak Grad',    'AoV VTI',     4,5,6;...
            'LVOT_VTI', 'VTI',  'LVOT VTI',                    4,5,6;...
            'LVOT_Mean_Vel',    'Mean Vel', 'LVOT VTI',        4,5,6;...
            'LVOT_Mean_Grad',   'Mean Grad',    'LVOT VTI',    4,5,6;...
            'LVOT_Peak_Vel',    'Peak Vel', 'LVOT VTI',        4,5,6;...
            'LVOT_Peak_Grad',   'Peak Grad',    'LVOT VTI',    4,5,6;...          
            
            %Calculations:
            'AoV_CO','AoV CO','mL/min',                              2,3,[];...
            'AoV_SV','AoV SV','uL',                              2,3,[];...
            
            %Measurements:
            'IVSd',     'IVS;d',    'AM-Mode',               4,5,6; ...   
            'IVSs',     'IVS;s',    'AM-Mode',               4,5,6; ...   
            'LVIDd',    'LVID;d',   'AM-Mode',               4,5,6; ...   
            'LVIDs',    'LVID;s',   'AM-Mode',               4,5,6; ...   
            'LWd',    'LW;d',   'AM-Mode',                   4,5,6; ...   
            'LWs',    'LW;s',   'AM-Mode',                   4,5,6; ...   
            
            %Measurement: PSLAX
            'Ao_Sinus','Ao Sinus','B-Mode',                    4,5,6;...
            
            
            'HR_lax','Heart Rate','AM-Mode',                    4,5,6;...
            'diameter_s_lax','Diameter;s','AM-Mode',           4,5,6;...
            'diameter_d_lax','Diameter;d','AM-Mode',           4,5,6;...
            'vols_lax','Volume;s','AM-Mode',                   4,5,6;...
            'vold_lax','Volume;d','AM-Mode',                 4,5,6;...
            'SV_lax','Stroke Volume','AM-Mode',                4,5,6;...
            'EF_lax','Ejection Fraction','AM-Mode',            4,5,6;...           
            'FS_lax','Fractional Shortening','AM-Mode',        4,5,6;...
            'CO_lax','Cardiac Output','AM-Mode',               4,5,6;...            
            'LVmass_lax','LV Mass','AM-Mode',                  4,5,6;...
            'LVmasscorr_lax','LV Mass Cor','AM-Mode',          4,5,6;...    
            
            
            %Measurements; SAX
            
            'HR_sax','Heart Rate','M-Mode',                    4,5,6;...
            'diameter_s_sax','Diameter;s','M-Mode',           4,5,6;...
            'diameter_d_sax','Diameter;d','M-Mode',           4,5,6;...
            'vols_sax','Volume;s','M-Mode',                   4,5,6;...
            'vold_sax','Volume;d','M-Mode',                 4,5,6;...
            'SV_sax','Stroke Volume','M-Mode',                4,5,6;...
            'EF_sax','Ejection Fraction','M-Mode',            4,5,6;...           
            'FS_sax','Fractional Shortening','M-Mode',        4,5,6;...
            'CO_sax','Cardiac Output','M-Mode',               4,5,6;...            
            'LVmass_sax','LV Mass','M-Mode',                  4,5,6;...
            'LVmasscorr_sax','LV Mass Cor','M-Mode',          4,5,6;...               
            


            %Measurements
            'ao_t1','ao t1','PW Doppler Mode', 4,5,[];...
            'ao_t2','ao t2','PW Doppler Mode', 4,5,[];...
            'ao_t3','ao t3','PW Doppler Mode', 4,5,[];...
            'ao_t4','ao t4','PW Doppler Mode', 4,5,[];...
            'brac_t1','brac t1','PW Doppler Mode', 4,5,[];...
            'brac_t2','brac t2','PW Doppler Mode', 4,5,[];...
            'brac_t3','brac t3','PW Doppler Mode', 4,5,[];...
            'brac_t4','brac t4','PW Doppler Mode', 4,5,[];...
            'LV_L','length pslax lv dia','B-Mode', 4,5,[];...
            'An_root_Area1','root area sax diastole 1','B-Mode', 4,5,[];...
            'An_root_Area2','root area sax diastole 2','B-Mode', 4,5,[];...
            'An_root_Area3','root area sax diastole 3','B-Mode', 4,5,[];...
            'PW_dist','Traced Distance','B-Mode',4,5,[];...
            'asc_ao_dia','asc ao dia','AM-Mode',4,5,[];...
            'asc_ao_sys','asc ao sys','AM-Mode',4,5,[];...
            'asc_ao_vel','asc ao vel','AM-Mode',4,5,[];...
            
            
            
            %From consc vs anes
            %Measurements
            'EndoArea_d','ENDOarea;d','B-Mode',           4,5,6;...
            'EndoArea_s','ENDOarea;s','B-Mode',           4,5,6;...
            'EpiArea_d','EPIarea;d','B-Mode',           4,5,6;...
            'EpiArea_s','EPIarea;s','B-Mode',           4,5,6;...            
            %Calculations
            'a_d','a;d','mm',                       2,3,[];...
            'b_d','b;d','mm',                       2,3,[];...
            'EndoAreaChange','Endocardial Area Change','mm2',2,3,[];...
            'Endo_FAC','Endocardial FAC','%',           2,3,[];...
            'T_d','T;d','mm',                   2,3,[];...
            
            %Other information
            'weight', 'Weight', '', [],2, [];...
            'height', 'Height', '',  [],2,[];...
            'age', 'Age', '', [], 2,[];...
            'sex', 'Sex', '',  [], 2,[];...
            'strain', 'Strain', '', [], 2, [];...
                     
            'baseapexdist', 'baseapex', 'B-Mode',         4, 5, []};
        
try
    bigstr = file2str(fname);
catch msg
    fprintf(2, msg.message);
end

lines = split(bigstr, '\n');

for l = 1:length(lines)
    line = regexprep(lines{l}, '"', '');   % Remove annoying double quote char
    parts = split(line, ',');
    label = parts{1};
    if length(parts) > 3
        vevo_mode = parts{2};
    else
        vevo_mode = '';
    end
    
    % Handle Heart Rate and baseapexdist, which have variable naming
    if strfind(label, 'Heart Rate') % If 'Heart Rate' appears at all in the label...
        label     = 'Heart Rate';
        % vevo_mode = '';
    elseif strfind(label, 'Linear')
        label     = 'Linear 1';
        vevo_mode = 'B-Mode';
    end
    
    % fprintf('%s\n', label);
    
   
    
    
    % Try to match label with template entry
    template_row = find(strcmp(template(:,2), label)); % Gives matching candidate row numbers in template - IGNORING MODE
    if numel(template_row) > 1  % Now we have to try to discriminate by matching mode
        template_row = template_row(strcmp(template(template_row,3), vevo_mode));    % Make sure both the label AND mode match
    end
    
    if ~isempty(template_row)
        % Create new property entry
        props.(template{template_row, 1}) = struct('formatted_name', '', ...
                                                   'units', '', ...
                                                   'val', [], ...
                                                   'std', []);
        
        % Extract values
        props.(template{template_row, 1}).formatted_name = template{template_row, 2};
        
            % Try to extract units unless no column is specified
        if ~isempty(template{template_row, 4})
            props.(template{template_row, 1}).units          = parts{template{template_row, 4}};
        end
        
        if ~isempty(template{template_row, 5})
            if isstrprop(parts{template{template_row, 5}}(1), 'alpha')
                props.(template{template_row, 1}).val            = parts{template{template_row, 5}};
            else
                props.(template{template_row, 1}).val            = str2double(parts{template{template_row, 5}});
            end
        end
        
        if ~isempty(template{template_row, 6})        
            props.(template{template_row, 1}).std            = str2double(parts{template{template_row, 6}});
        end
        
    else    % No matching template entry
        fprintf(2, 'Could not find match for label: %s\n\n', label)
        
    end
    
end



    