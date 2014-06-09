//-------------------------------------------------------------------------
// Description : Non-blocking Output Socket
//
// Usage       : output_socket = OutputSocket(port_number);
//
// Assumptions : output_socket.close() is called before clearing when
//               used within MATLAB
//
// Author      : Rodney Thomson
//               http://iheartmatlab.blogspot.com
//-------------------------------------------------------------------------
import java.io.*;
import java.net.*;
import java.util.List;
import java.util.ArrayList;

class OutputSocket
{
    //---------------------------------------------------------------------
    // Description : Create an OutputSocket on the specified port
    //---------------------------------------------------------------------
    public OutputSocket(int port) throws IOException
    {
        m_connection_list        = new ArrayList();
        m_connection_stream_list = new ArrayList();

        try
        {
            // Create the ServerSocket
            m_server_socket = new ServerSocket(port);
            m_server_socket.setSoTimeout(1000); // 1 second
        
            // Create the listening thread and listen for connections
            m_listening_thread = new ListeningThread(m_server_socket, 
                                                     m_connection_list, 
                                                     m_connection_stream_list);
            m_thread           = new Thread(m_listening_thread);
            m_thread.start();
        }
        catch (IOException e)
        {
            // Rethrow the exception
            System.out.println("Could not listen on port " + port);
            throw(e);
        }
    }

    //---------------------------------------------------------------------
    // Description : Cleanup on destruction
    //---------------------------------------------------------------------
    protected void finalize() throws Throwable
    {
        // stop the accepting new connections
        m_listening_thread.stop();
        
        // close any existing connections
        this.close();
        
        // Close the server socket
        m_server_socket.close();
        
        super.finalize();
    }

    //---------------------------------------------------------------------
    // Description : Write the supplied byte array to all connected clients
    //---------------------------------------------------------------------
    public void write(byte[] data)
    {
        // For each connected client, write the data
        for (int i_client = m_connection_list.size()-1; 
                 i_client >= 0; 
                 i_client--)
        {
            // attempt to write the bytes. If a problem exists, then remove
            // Stream/Socket from list
            DataOutputStream stream = 
                (DataOutputStream)m_connection_stream_list.get(i_client);

            try
            {
                stream.write(data, 0, data.length);
            }
            catch (IOException e)
            {
                // An error occured writing to that client. This occurs if
                // the client has disconnected. Remove client from list
                m_connection_list.remove(i_client);
                m_connection_stream_list.remove(i_client);
            }
        }
    }

    //---------------------------------------------------------------------
    // Description : Close the OutputSocket. This closes all client 
    //               connections and stops listening for new connections.
    //---------------------------------------------------------------------
    public void close()
    {
        // stop the listening thread
        m_listening_thread.stop();

        // close off all data streams
        for (int i_ds = 0; i_ds < m_connection_stream_list.size(); i_ds++)
        {
            DataOutputStream stream = 
                (DataOutputStream)m_connection_stream_list.get(i_ds);
            try
            {
                stream.close();            
            }
            catch (IOException e)
            {
                // do nothing
            }
        }
        m_connection_stream_list.clear();

        // close off all sockets
        for (int i_client = 0; 
                 i_client < m_connection_list.size(); 
                 i_client++)
        {
            Socket client = (Socket)m_connection_list.get(i_client);
            try
            {
                client.close();            
            }
            catch (IOException e)
            {
                // do nothing
            }
        }
        m_connection_list.clear();
    }

    private Thread          m_thread;
    private ListeningThread m_listening_thread;
    private ServerSocket    m_server_socket;
    private List            m_connection_list;    
    private List            m_connection_stream_list;    
}

//-------------------------------------------------------------------------
// Description : Helper class that listens for new TCP/IP client 
//               connections on a ServerSocket
//-------------------------------------------------------------------------
class ListeningThread implements Runnable
{
    //---------------------------------------------------------------------
    // Parameters   : server_socket          - ServerSocket to listen on
    //                connection_list        - List of connected client
    //                                         Sockets
    //                connection_stream_list - List of connected client 
    //                                         DataOutputStreams
    //---------------------------------------------------------------------
    public ListeningThread(ServerSocket server_socket, 
                           List         connection_list,
                           List         connection_stream_list)
    {
        this.m_running                = false;
        this.m_server_socket          = server_socket;
        this.m_connection_list        = connection_list;
        this.m_connection_stream_list = connection_stream_list;
    }

    //---------------------------------------------------------------------
    // Description : Called on Thread.start()
    //---------------------------------------------------------------------
    public void run()
    {
        // Loop listening for connections and appending them to the list 
        m_running = true;

        while (m_running)
        {
            try
            {
                // Listen for client connection
                Socket client = m_server_socket.accept();
                
                DataOutputStream output_stream = 
                    new DataOutputStream(client.getOutputStream());

                // Add to the list of connected clients
                m_connection_list.add(client);
                m_connection_stream_list.add(output_stream);
            }
            catch (IOException e)
            {
                // do nothing
            }
        }
    }

    //---------------------------------------------------------------------
    // Description : Stop the thread
    //---------------------------------------------------------------------
    public void stop()
    {
        m_running = false;
    }

    private boolean      m_running;
    private ServerSocket m_server_socket;
    private List         m_connection_list;
    private List         m_connection_stream_list;
}
