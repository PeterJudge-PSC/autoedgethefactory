 /*------------------------------------------------------------------------
    File        : EmployeeDA
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Nov 15 09:19:22 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAccess.StandardDataAccess.
using OpenEdge.Lang.Collections.TypedMap.

class OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDA inherits StandardDataAccess: 
    
	constructor public EmployeeDA (input poDataSources as TypedMap):
		super (input poDataSources).
	end constructor.

    constructor public EmployeeDA():
        super().
    end constructor.
	
    /** Resolves a table name from the Business Entity into a physical table name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The table name in the datasource. */

    method override public character ResolveTableName (input pcBETable as character):
        /* this DA assumes there's a direct mapping from eEmployee to Employee (or from any e<Table> to <Table>, really) */
        return substring(pcBETable, 2).
    end method.
    
    /** Resolves a field name from the Business Entity into a physical field name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The field name in the datasource. */    
	method override public character ResolveFieldName(input pcBEField as character):
	    return pcBEField.	    
	end method.
	
end class.