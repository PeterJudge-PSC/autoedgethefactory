/** ------------------------------------------------------------------------
    File        : DBConnectionParameters
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 20 09:19:47 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.Connection.ConnectionParameters.
using OpenEdge.Lang.Assert.

class OpenEdge.CommonInfrastructure.Common.Connection.DBConnectionParameters inherits ConnectionParameters:    
    define public property LogicalName as character no-undo get. protected set.
    define public property PhysicalName as character no-undo get. protected set.
    
	constructor public DBConnectionParameters(input pcPhysicalName as character,
	                                          input pcLogicalName as character,
	                                          input pcOptions as longchar):
		super(pcOptions).
		
        Assert:ArgumentNotNullOrEmpty(pcPhysicalName, 'Database physical name').
		Assert:ArgumentNotNullOrEmpty(pcLogicalName, 'Database logical name').
		
        assign PhysicalName = pcPhysicalName
               LogicalName = pcLogicalName.
	end constructor.
	
	method override public longchar GetConnectionString():
	    return substitute(' -db &1 ', PhysicalName)
	         + substitute(' -ld &1 ', LogicalName)
	         + super:GetConnectionString().
	end method.
	
end class.