/** ------------------------------------------------------------------------
    File        : QueryDefinitionOperationEnum
    Purpose     : Enumeration of operations on a query definition
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Sep 02 14:57:50 EDT 2009
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.System.QueryDefinitionOperationEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.QueryDefinitionOperationEnum final inherits EnumMember: 
    
    define public static property Empty     as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Create    as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Delete    as QueryDefinitionOperationEnum no-undo get. private set.
    define public static property Update    as QueryDefinitionOperationEnum no-undo get. private set.
    
    constructor static QueryDefinitionOperationEnum():
        QueryDefinitionOperationEnum:Empty  = new QueryDefinitionOperationEnum('Empty').
        QueryDefinitionOperationEnum:Create = new QueryDefinitionOperationEnum('Create').
        QueryDefinitionOperationEnum:Delete = new QueryDefinitionOperationEnum('Delete').
        QueryDefinitionOperationEnum:Update = new QueryDefinitionOperationEnum('Update').
    end constructor.

	constructor public QueryDefinitionOperationEnum ( input pcName as character ):
		super (input pcName).
	end constructor.
    
end class.