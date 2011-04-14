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

using OpenEdge.CommonInfrastructure.Common.IConnectionParameters.

class OpenEdge.CommonInfrastructure.Common.ConnectionParameters implements IConnectionParameters: 
    /** This property contains a nicely-formatted string for use by the
        ABL CONNECT statement or method. */ 
    define public property Options as longchar no-undo get. set.
    
	constructor public ConnectionParameters():
	    
    end constructor.
    
    /** The Connection Manager will call GetConnectionString() on this 
        object, which returns a nicely-formatted string for use by the
        ABL CONNECT statement. 
        
        @return character A useable string of connection parameters. */
    method public longchar GetConnectionString():
        return this-object:Options.
    end method.
    
end class.