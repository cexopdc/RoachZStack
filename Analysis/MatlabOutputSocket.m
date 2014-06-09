classdef MatlabOutputSocket < handle
    %MATLABOUTPUTSOCKET Create a MATLAB OutputSocket
    %
    %   Wraps the JAVA OutputSocket within a MATLAB classdef to ensure proper
    %   cleanup of the Java socket object
    %
    %   Usage :
    %
    %     output_socket = MatlabOutputSocket(1234);    
    %
    %     % Write a string out
    %     output_socket.write(int8(sprintf('Hi there how are you?\r\n'))); 
    %
    %     % Write some raw data out
    %     output_socket.write(rand(4, 'single'));
    %
    %   For more details see:
    %   http://iheartmatlab.blogspot.com/2010/06/non-blocking-output-socket.html
    
    properties (SetAccess = private, GetAccess = private)
        m_output_socket     % Java OutputSocket
    end
    
    methods
        %=======================================================================
        % Description : Construct a MATLAB output socket object on the specified
        %               port
        %=======================================================================
        function obj = MatlabOutputSocket(port)
            obj.m_output_socket = OutputSocket(port);
        end
        
        %=======================================================================
        % Description : Write the supplied data to the socket. Assumes data
        %               consists non-complex numeric data types only. If this is
        %               not the case then serialise appropriately before passing
        %               this method. 
        %               
        %               ie - socket.write(int8('Hello World'));
        %=======================================================================
        function write(obj, data)
            % write the data as a stream of 8 bit values
            obj.m_output_socket.write(typecast(data, 'int8'));
        end
        
        %=======================================================================
        % Description : Close the output socket and all connected clients
        %=======================================================================
        function close(obj)
            obj.m_output_socket.close();
        end
    end
    
    methods (Access = private)
        %=======================================================================
        % Description : On deletion of mOutputSocket, close Java output socket
        %               and explicitly reset
        %=======================================================================
        function delete(obj)
            obj.m_output_socket.close();
            obj.m_output_socket = 0;
        end
    end
end

