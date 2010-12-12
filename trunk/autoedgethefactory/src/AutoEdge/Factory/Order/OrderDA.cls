/** ------------------------------------------------------------------------
    File        : OrderDA
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 08 16:22:31 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.DataAccess.StandardDataAccess.
using OpenEdge.Lang.Collections.IMap.

class AutoEdge.Factory.Order.OrderDA inherits StandardDataAccess: 
    
    constructor public OrderDA (input poDataSources as IMap):
		super (input poDataSources).
	end constructor.
		
	constructor public OrderDA (  ):
		super ().
	end constructor.
	
    /** Resolves a table name from the Business Entity into a physical table name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The table name in the datasource. */
    method override public character ResolveTableName (input pcBETable as character):
        /* this DA assumes there's a direct mapping from eOrder to Order (or from any e<Table> to <Table>, really) */
        return substring(pcBETable, 2).
    end method.
    
    /** Resolves a field name from the Business Entity into a physical field name in the
        DataSource.
        
        @param character The business entity's table name (usually from the IServiceRequest/ITableRequest).
        @return character The field name in the datasource. */    
    method override public character ResolveFieldName(input pcBETable as character, input pcBEField as character):
        return pcBEField.       
    end method.
    
end class.