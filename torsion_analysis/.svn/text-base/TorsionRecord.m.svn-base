classdef TorsionRecord < handle
    % TORSIONRECORD
    % Author: Stuart Campbell
    % Date Started: 3/8/2012
    % 
    % This class holds data and methods of operating on data sufficient for
    % computing torsion of the left ventricle throughout a cycle.  It does
    % this by loading time series of points tracked in apical and basal LV
    % short axis cines obtained from echocardiography.  This class is
    % arranged such that it can be used by a simple GUI to assist in
    % selection of an appropriate subset of points, and the detection and
    % correction of simple measurement artifacts.

    
    %--------------------------%
    % Private Class Properties %
    %--------------------------%
    
    properties (SetAccess = private)
        agegroup    = '';
        animalnum   = '';
        
        % Properties specific to the echo data set
        flipflag                   = false;         % Set to true if probe was flipped
        time_offset_apex_from_base = 0;             % If there is an obvious delay between records, this can correct
        torsion_tracking_points    = 0;             % Indices to which points will be used to determine the averages, filled in later
        numpts                     = 0;             % Number of tracked points; will be filled in later
        numFrames                  = 0;             % Number of original frames; will be filled in later
        
        % Parameters used in processing
        beats_in_record = 2;                        % This should always be two, but there may be exceptions
        num_norm_t_pts  = 400;                      % The number of time points to interpolate to in order to normalize to R-R intervals
        
        % Specify source and output directories
        basedatadir = '';
        reportdir   = '';
        outputdir   = '';
        
        
        
    end
    
    
    %-------------------------%
    % Public Class Properties %
    %-------------------------%
    
    properties
        data_base  = [];    % Struct that will hold imported VeVo strain data
        data_apex  = [];    % Struct that will hold imported VeVo strain data
        report     = [];    % Struct that will hold global echo data
        
        % Derived quantities
        
        cycle_time = [];    % Time as a fraction of the R-R interval
        
        x_apex     = [];    % Tracked points in cartesian coordinates
        y_apex     = [];
        x_base     = [];
        y_base     = [];
        
        theta_apex = [];    % Points in polar coordinates
        theta_base = [];
        r_apex     = [];
        r_base     = [];
        
        twist      = [];    % Angular twist of apical points relative to corresponding basal points; matrix <numPts by num_norm_t_pts>
        torsion    = [];    % Angular twist of apical points relative to corresponding basal points NORMALIZED by base-apex slice distance; matrix <numPts by num_norm_t_pts>
        
        avg_torsion = [];   % A single LV torsion timecourse created by averaging torsion for the points specified by the property TR.torsion_tracking_points
    end
    
    
    %---------------%
    % Class Methods %
    %---------------%

    methods
        
        %-------------------%
        % Class Constructor %
        %-------------------%
        
        function TR = TorsionRecord( animalnum,agegroup,basedatadir,reportdir,outputdir )
            
            % Store constructor args
            TR.animalnum = animalnum;
            TR.agegroup  = agegroup;
            
            TR.basedatadir = basedatadir;
            TR.reportdir   = reportdir;
            TR.outputdir   = outputdir;
            
            
            % Load, compute, and save
            TR.loadComputeAndSave();
            
        end
        
        
        %-----------------------------------------------------------------%
        function loadRecords( TR )
            % This function loads base and apex records based on
            % predictable file names and folder structure.  It then imports
            % the general Echocardiographic report for the animalnum using
            % the same predictable folder structure.  It performs offsets 
            % and other calculations to the tracked points.  Finally, it
            % time-normalizes the data to the R-R interval using class
            % properties, and stores the results in class data.
            
            
            %--------------------%
            % Load Data from CSV %
            %--------------------%
            
            try
                TR.data_apex = importVeVoStrainData(sprintf('%s%s/%s_APEX.csv', TR.basedatadir, TR.agegroup, TR.animalnum));
                TR.data_base = importVeVoStrainData(sprintf('%s%s/%s_BASE.csv', TR.basedatadir, TR.agegroup, TR.animalnum));
                TR.report    = importVeVoData(sprintf('%s%s/%s.csv', TR.reportdir, TR.agegroup, TR.animalnum));
            catch ferr
                disp(ferr.message)
                fprintf(2, 'One of the loading paths is invalid!  Cannot load files!')
                return
            end
            
            %-------------------------------------------%
            % Check for Identical Tracked Point Numbers %
            %-------------------------------------------%
            
            tp_apex = length(TR.data_apex.numPts);
            tp_base = length(TR.data_base.numPts);
            
            if ~(tp_apex == tp_base)
                fprintf('Apex trackpoints: %d\tBase trackpoints: %d\n\n', tp_apex, tp_base)
                error('The two specified files have different numbers of trackpoints!  Cannot use for analysis!')
            end
            
            
            %------------------------------------------------%
            % Find Average of Traced Points and Apply Offset %
            %------------------------------------------------%

            [offset_apex_x offset_apex_y] = centroid(TR.data_apex.tracepoints.data(:,1), TR.data_apex.tracepoints.data(:,2));
            [offset_base_x offset_base_y] = centroid(TR.data_base.tracepoints.data(:,1), TR.data_base.tracepoints.data(:,2));
            
            offset_apex = mean(TR.data_apex.tracepoints.data);
            offset_base = mean(TR.data_base.tracepoints.data);

            TR.x_apex = TR.data_apex.X.data - offset_apex_x;
            TR.y_apex = TR.data_apex.Y.data - offset_apex_y;

            TR.x_base = TR.data_base.X.data - offset_base_x;
            TR.y_base = TR.data_base.Y.data - offset_base_y;

            
            %------------------%
            % Handle Test Case %
            %------------------%
            % If it's the test case, scale by 100 to make similar dims to
            % real data.
            if strcmp(TR.animalnum, 'test_data')
                TR.x_apex = 100 * TR.x_apex;
                TR.y_apex = 100 * TR.y_apex;
                TR.x_base = 100 * TR.x_base;
                TR.y_base = 100 * TR.y_base;
                
                % Also pre-flip to be flipped in Y just like the records.
                % clear as mud.
                TR.y_apex = TR.y_apex * -1;
                TR.y_base = TR.y_base * -1;
                
            end

            %--------------------%
            % Flip Y Coordinates %
            %--------------------%

            TR.y_apex  = TR.y_apex * -1;
            TR.y_base  = TR.y_base * -1;


            %----------------------------%
            % Flip X coords if necessary %
            %----------------------------%

            if TR.flipflag
                TR.x_apex = TR.x_apex * -1;
                TR.x_base = TR.x_base * -1;
            end

            
            %--------------------------------%
            % Normalize Time to R-R Interval %
            %--------------------------------%
            
            rr_int_apex = TR.data_apex.time.data(end) / TR.beats_in_record;    % [ms] R-R interval
            rr_int_base = TR.data_base.time.data(end) / TR.beats_in_record;    % [ms] R-R interval
            
            rel_t_apex  = TR.data_apex.time.data / rr_int_apex;                % Time normalized to R-R interval
            rel_t_base  = TR.data_base.time.data / rr_int_base;                % Time normalized to R-R interval
            
            %---------------------------------------------------%
            % Interpolate Points Timecourse to Standard Spacing %
            %---------------------------------------------------%
            
            TR.cycle_time = 0:(TR.beats_in_record / (TR.num_norm_t_pts - 1)):TR.beats_in_record;  % Create vector of cycle-relative time points
            
            % Perform interpolations
            [TR.numpts TR.numFrames] = size(TR.x_apex);
            
            TR.torsion_tracking_points = 1:TR.numpts;   % Initialize with all points tracking
            
            temp_x_apex = zeros(TR.numpts, length(TR.cycle_time));
            temp_y_apex = zeros(TR.numpts, length(TR.cycle_time));
            temp_x_base = zeros(TR.numpts, length(TR.cycle_time));
            temp_y_base = zeros(TR.numpts, length(TR.cycle_time));
            
            
            for i = 1:TR.numpts
                temp_x_apex(i,:) = linInterp(TR.cycle_time, rel_t_apex, TR.x_apex(i,:));
                temp_y_apex(i,:) = linInterp(TR.cycle_time, rel_t_apex, TR.y_apex(i,:));
                temp_x_base(i,:) = linInterp(TR.cycle_time, rel_t_base, TR.x_base(i,:));
                temp_y_base(i,:) = linInterp(TR.cycle_time, rel_t_base, TR.y_base(i,:));
            end
            
            % Store in original structures
            TR.x_apex = temp_x_apex;
            TR.y_apex = temp_y_apex;
            TR.x_base = temp_x_base;
            TR.y_base = temp_y_base;
            
            
            %--------------------------------%
            % Convert Points to Polar Coords %
            %--------------------------------%

            [TR.theta_apex TR.r_apex] = cart2pol(TR.x_apex, TR.y_apex);
            [TR.theta_base TR.r_base] = cart2pol(TR.x_base, TR.y_base);

           
            % Convert radians to degrees
            TR.theta_apex = rad2deg(TR.theta_apex);
            TR.theta_base = rad2deg(TR.theta_base);
            
            
            
            
        end

        %-----------------------------------------------------------------%
        function calcTorsion( TR )
            % This function performs the torsion computation

            %------------------%
            % Compute Torsions %
            %------------------%

            TR.twist   = TR.theta_base - TR.theta_apex;
            
            % Reduce to smallest angular differences
            gt180map  = TR.twist >  180;
            ltn180map = TR.twist < -180;
            
            % Compute Twist
            TR.twist(gt180map)  = -360 + TR.twist(gt180map);
            TR.twist(ltn180map) = 360  + TR.twist(ltn180map);
            
            TR.twist   = TR.twist - repmat(TR.twist(:,1), 1, TR.num_norm_t_pts);   % Apply offset for initial angle differences

            % Calc torsion by normalizing by apex-base distance
            baseapexdist = TR.report.baseapexdist.val / 10; % Convert to cm
            TR.torsion   = TR.twist / baseapexdist;
            
            
            %------------------------------------%
            % Perform Average of Selected Points %
            %------------------------------------%

            TR.avg_torsion = mean(TR.torsion(TR.torsion_tracking_points, :), 1);
            
        end
        
        
        %-----------------------------------------------------------------%
        function saveTorsionResult( TR )
            % This function saves the class to disk as a .mat file

            save(fullfile(TR.outputdir, ['torsion_' TR.animalnum '.mat']), 'TR') 
            
        end
        
        
        %-----------------------------------------------------------------%
        function loadComputeAndSave( TR )
            % This function reloads data, reprocesses points, and
            % recalculates torsion.

            % Load data records and time-normalize
            TR.loadRecords()
            
            % Calculate torsion
            TR.calcTorsion()
            
            % Save the result to disk
            TR.saveTorsionResult()
            
        end
        
        
        %-----------------------------------------------------------------%
        function computeAndSave( TR )
            % This is a convenient function that can be called after
            % updates of anything that will affect the torsion calc, like
            % the track points or time offset

            % Calculate torsion
            TR.calcTorsion()
            
            % Save the result to disk
            TR.saveTorsionResult()
            
        end
        
        
        %-----------------------------------------------------------------%
        function updateFlipFlag( TR,value )
            % This function accepts a new vector of point indices, stores
            % them, and re-computes the torsion and average torsion
            % accordingly.

            TR.flipflag = value;                    % Store flipping value
            [sp tp]     = TR.getTrackingPoints();   % Grab points to save them
            TR.loadComputeAndSave();                % Update and save
            TR.updateTrackingPoints(sp);            % Fix tracking points
            
        end
        
        
        %-----------------------------------------------------------------%
        function flipflag = getFlipFlag( TR )
            % This function returns the status of the flipflag

            flipflag = TR.flipflag;
            
        end
        
        
        %-----------------------------------------------------------------%
        function updateTrackingPoints( TR,points )
            % This function accepts a new vector of point indices, stores
            % them, and re-computes the torsion and average torsion
            % accordingly.

            TR.torsion_tracking_points = points;    % Store passed-in points
            TR.computeAndSave();                    % Update and save
            
        end
        
        
        %-----------------------------------------------------------------%
        function [selectedpts, totalpts] = getTrackingPoints( TR )
            
            selectedpts = TR.torsion_tracking_points;
            totalpts    = TR.numpts;
        end
            
            
        %-----------------------------------------------------------------%
        function updateTimeOffset( TR,offset )
            % This function accepts a new time offset, in units of
            % timepoints, applies it to the stored data, and recomputes the
            % torsion.  The offset is for the apex timepoints, relative to
            % time zero for the base.  
            
            oldoffset = TR.time_offset_apex_from_base;
            TR.time_offset_apex_from_base = offset;    % Store passed-in offset
            
            
            % Undo old offset
            TR.x_apex     = circshift(TR.x_apex, [0 -oldoffset]);
            TR.y_apex     = circshift(TR.y_apex, [0 -oldoffset]);
            TR.theta_apex = circshift(TR.theta_apex, [0 -oldoffset]);
            TR.r_apex     = circshift(TR.r_apex, [0 -oldoffset]);
            
            % Apply time offset to apex points
            TR.x_apex     = circshift(TR.x_apex, [0 offset]);
            TR.y_apex     = circshift(TR.y_apex, [0 offset]);
            TR.theta_apex = circshift(TR.theta_apex, [0 offset]);
            TR.r_apex     = circshift(TR.r_apex, [0 offset]);
            
            
            TR.computeAndSave();                       % Update and save
            
        end
        
        
        %-----------------------------------------------------------------%
        function offset = getTimeOffset( TR )
            % This function returns the time offset value

            offset = TR.time_offset_apex_from_base;
            
        end
        
        
            
    end     % ENDMETHODS
end     % ENDCLASS    