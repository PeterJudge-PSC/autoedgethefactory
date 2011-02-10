/** ------------------------------------------------------------------------
    File        : IConnectionParameters
    Purpose     : A general interface for AppServer/DB/etc connection parameters 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 13 10:41:05 EST 2011
    Notes       : 
  ---------------------------------------------------------------------- */
interface OpenEdge.CommonInfrastructure.Common.IConnectionParameters:
    /** This property contains a nicely-formatted string for use by the
        ABL CONNECT statement or method. */ 
    define public property Options as longchar no-undo get. set.
    
    /** The Connection Manager will call GetConnectionString() on this 
        object, which returns a nicely-formatted string for use by the
        ABL CONNECT statement. 
        
        @return character A useable string of connection parameters. */
    method public longchar GetConnectionString().
    
end interface.