classdef KeyCell
    properties
        data % A cell array
    end
    
    methods
        % Class Constructor
        function KC = KeyCell( data )
            if iscell(data)
                KC.data = data;
            else
                error('KeyCell must be a cell array!');
            end
        end
        
        % Comparator
        function result = eq( KC, other )
            if ~isa(other, 'KeyCell')
                result = false;
                return
            end
            
            len = length(KC.data);
            
            if len ~= length(other.data)
                result = false;
                return
            end
            
            % Compare entry by entry
            result = zeros(1,len);
            for i = 1:len
                entry = KC.data{i};
                if iscell(entry)
                    error('KeyCell not implemented for nested cells yet!')
                else
                    if length(entry) == length(other.data{i})
                        if entry == other.data{i}
                            result(i) = 1;
                        end
                    end
                end
            end
            
            if result == ones(1,len)
                result = true;
            else
                result = false;
            end
        end
    end
end
