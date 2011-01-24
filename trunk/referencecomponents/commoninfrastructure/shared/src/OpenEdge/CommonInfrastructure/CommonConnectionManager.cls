/** ------------------------------------------------------------------------
    File        : ConnectionManager
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Jan 12 15:46:56 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Service.
using OpenEdge.CommonInfrastructure.IConnectionManager.
using OpenEdge.CommonInfrastructure.CommonConnectionManager.
using OpenEdge.CommonInfrastructure.IComponentInfo.
using OpenEdge.CommonInfrastructure.IServiceManager.
using OpenEdge.CommonInfrastructure.ConnectionTypeEnum.
using OpenEdge.CommonInfrastructure.IConnectionParameters.
using OpenEdge.CommonInfrastructure.IAppServerConnectionParameters.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.CommonInfrastructure.CommonConnectionManager inherits Service
        implements IConnectionManager:

    /** Use this property in lieu of having to say Class:GetClass('....IConnectionManager') every time */
    define static public property IConnectionManagerType as class Class no-undo get. private set.
    
    /* Use a temp-table directly since the key is type+name, and we don't (yet) have a nice way of dealing
       with multi-part keys in our Map collection. */
    define private temp-table ConnectedServices no-undo
        field ConnectionType as Object  /* ConnectionTypeEnum */
        field ConnectionName as character
        field ConnectionParameters as Object    /* IConnectionParameters */
        field ServerHandle as handle
        index idx1 as primary unique ConnectionType ConnectionName.

    constructor static CommonConnectionManager():
        CommonConnectionManager:IConnectionManagerType = Class:GetClass('OpenEdge.CommonInfrastructure.IConnectionManager').
    end constructor.
    
	constructor public CommonConnectionManager(input poComponentInfo as IComponentInfo):
		super (input poComponentInfo).
	end constructor.

	constructor public CommonConnectionManager(input poServiceManager as IServiceManager, input poComponentInfo as IComponentInfo):
		super (input poServiceManager, input poComponentInfo).
	end constructor.

    /** Connects to a server of the given type, with a unique name, for the
        provided parameters.
        
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection
        @param IConnectionParameters A set of parameters for the connection
        @return handle A handle to the server    */
    method public handle Connect(input poConnectionType as ConnectionTypeEnum,
                                 input pcConnectionName as character,
                                 input poParameters as IConnectionParameters):
        define variable hServer as handle no-undo.
        
        RegisterConnection(poConnectionType, pcConnectionName, poParameters).
        
        case poConnectionType:
            when ConnectionTypeEnum:AppServer then ConnectAppServer(pcConnectionName, cast(poParameters, IAppServerConnectionParameters)).
            when ConnectionTypeEnum:Database then ConnectDatabase(pcConnectionName, poParameters).
            when ConnectionTypeEnum:WebService then ConnectWebService(pcConnectionName, poParameters).
            when ConnectionTypeEnum:Socket then ConnectSocket(pcConnectionName, poParameters).
        end case.
        
        hServer = GetConnectionHandle(poConnectionType, pcConnectionName).
        
        return hServer.
    end method.
    
    /** Connects to an AppServer with a unique name, for the
        provided parameters.
        
        @param character The unique name for this connection
        @param IConnectionParameters A set of parameters for the connection */
    method protected void ConnectAppServer(input pcConnectionName as character,
                                           input poParameters as IAppServerConnectionParameters):
        define buffer lbServer for ConnectedServices.

        find lbServer where
             lbServer.ConnectionType = ConnectionTypeEnum:AppServer and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        
        create server lbServer.ServerHandle.
        lbServer.ServerHandle:connect(string(cast(poParameters, IConnectionParameters):GetConnectionString()),
                        poParameters:UserName,
                        poParameters:UserPassword,
                        poParameters:AppServerInfo).
    end method.
    
    /** Connects to a Database server with a unique name, for the
        provided parameters.
        
        @param character The unique name for this connection
        @param IConnectionParameters A set of parameters for the connection */
    
    method protected void ConnectDatabase(input pcConnectionName as character,
                                          input poParameters as IConnectionParameters):
        
        /* we could specialise and have an IDatabaseConnectionParameters interface which has DB name etc */
        connect value(poParameters:GetConnectionString() + ' -ldb ' + pcConnectionName).
    end method.
    
    /** Connects to a WebService server with a unique name, for the
        provided parameters.
        
        @param character The unique name for this connection
        @param IConnectionParameters A set of parameters for the connection */
    method protected void ConnectWebService(input pcConnectionName as character,
                                            input poParameters as IConnectionParameters):
        define buffer lbServer for ConnectedServices.

        find lbServer where
             lbServer.ConnectionType = ConnectionTypeEnum:WebService and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        
        create server lbServer.ServerHandle.
        lbServer.ServerHandle:connect(string(cast(poParameters, IConnectionParameters):GetConnectionString())).
    end method.    

    /** Connects to a Socket server with a unique name, for the
        provided parameters.
        
        @param character The unique name for this connection
        @param IConnectionParameters A set of parameters for the connection */
    method public void ConnectSocket(input pcConnectionName as character,
                                     input poParameters as IConnectionParameters):
        define buffer lbServer for ConnectedServices.

        find lbServer where
             lbServer.ConnectionType = ConnectionTypeEnum:Socket and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        
        create socket lbServer.ServerHandle.
        lbServer.ServerHandle:connect(string(cast(poParameters, IConnectionParameters):GetConnectionString())).
    end method.    
    
    /** Disconnects from the specified connection
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection */
    method public void Disconnect(input poConnectionType as ConnectionTypeEnum,
                                  input pcConnectionName as character):
        define buffer lbServer for ConnectedServices.
        
        if IsConnected(poConnectionType, pcConnectionName) then
        do:
            find lbServer where
                 lbServer.ConnectionType = poConnectionType and
                 lbServer.ConnectionName = pcConnectionName
                 no-error.
            case poConnectionType:
                when ConnectionTypeEnum:Database then
                    disconnect value(pcConnectionName).
                otherwise
                    lbServer.ServerHandle:disconnect().
            end case.
            lbServer.ServerHandle = ?.
        end.
    end method.
    
    /** Indicates whether the connection already exists.
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection */
    method public logical IsConnected(input poConnectionType as ConnectionTypeEnum,
                                      input pcConnectionName as character):
        define variable lConnected as logical no-undo.
        define buffer lbServer for ConnectedServices.
        
        find lbServer where
             lbServer.ConnectionType = poConnectionType and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        if available lbServer then
        case poConnectionType:
            when ConnectionTypeEnum:Database then
                lConnected = connected(pcConnectionName).
            otherwise
            do:
                lConnected = valid-handle(lbServer.ServerHandle).
                if lConnected then
                    lConnected = lbServer.ServerHandle:connected().
            end.
        end case.
        else
            lConnected = false.
        
        return lConnected.
    end method.
    
    /** Rreturns the handle to the specified connection.
    
        @param ConnectionTypeEnum The type of connection
        @param character The unique name for this connection 
        @return handle A handle to the server   */
    method public handle GetConnectionHandle(input poConnectionType as ConnectionTypeEnum,
                                             input pcConnectionName as character):
        define variable hServer as handle no-undo.
        define buffer lbServer for ConnectedServices.

        find lbServer where
             lbServer.ConnectionType = poConnectionType and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        if available lbServer then
            hServer = lbServer.ServerHandle.
        
        return hServer.
    end method.
    
    method protected void RegisterConnection(input poConnectionType as ConnectionTypeEnum,
                                             input pcConnectionName as character,
                                             input poParameters as IConnectionParameters):
        define buffer lbServer for ConnectedServices.

        find lbServer where
             lbServer.ConnectionType = poConnectionType and
             lbServer.ConnectionName = pcConnectionName
             no-error.
        if not available lbServer then
        do:
            create lbServer.
            assign lbServer.ConnectionType = poConnectionType
                   lbServer.ConnectionName = pcConnectionName
                   lbServer.ConnectionParameters = poParameters.
        end.
    end method.

	method override public void DestroyComponent(  ):
	    define buffer lbServer for ConnectedServices.
	    
	    for each lbServer:
	        this-object:Disconnect(
	               cast(lbServer.ConnectionType, ConnectionTypeEnum),
	               lbServer.ConnectionName).
        end.
        
		super:DestroyComponent().
	end method.
	
end class.