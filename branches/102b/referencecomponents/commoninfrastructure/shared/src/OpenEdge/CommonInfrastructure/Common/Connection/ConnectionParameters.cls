/** ------------------------------------------------------------------------
    File        : ConnectionParameters
    Purpose     : Generic connection parameters for connecting to a server or socket
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 13 13:04:55 EST 2011
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.IConnectionParameters.

class OpenEdge.CommonInfrastructure.Common.Connection.ConnectionParameters implements IConnectionParameters: 
    /** This property contains a nicely-formatted string for use by the
        ABL CONNECT statement or method. */ 
    define public property Options as longchar no-undo get. set.
    
	constructor public ConnectionParameters():
    end constructor.

    constructor public ConnectionParameters(input pcOptions as longchar):
        this-object:Options = pcOptions.
    end constructor.
    
    /** The Connection Manager will call GetConnectionString() on this 
        object, which returns a nicely-formatted string for use by the
        ABL CONNECT statement. 
        
        @return character A useable string of connection parameters. */
    method public longchar GetConnectionString():
        return this-object:Options.
    end method.
    
end class.