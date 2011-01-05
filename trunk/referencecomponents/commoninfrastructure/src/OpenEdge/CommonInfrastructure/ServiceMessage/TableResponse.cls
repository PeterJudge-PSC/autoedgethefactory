/** ------------------------------------------------------------------------
    File        : TableResponse
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Aug 30 20:48:33 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.

using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.TypedMap.
using OpenEdge.Lang.String.
using Progress.Lang.Class.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableResponse
            implements ITableResponse, IExternalizable:
    
    /** (mandatory) The name of the table */  
    define property TableName as character no-undo get. private set.
    
    /** The error texts associated with the request, if any.
        There's an entry in the map for each row that has an error,
        keyed on the RowKey. */
    define public property ErrorText as IMap no-undo get. private set.
    
    /** Whether the service request resulted in an error or not. */
    define public property HasError as logical no-undo
        get():
            /* the flag could have been raised without an associated error text. */
            if not HasError then                
                return (not ErrorText:IsEmpty()).
            else
                return HasError.
        end get.
        set.    
    
    /** The ITableContext (page size retrieved, etc) for this response, if any.
        Typically only Fetch actions will have one of these; Save not so much.  */
    define public property TableContext as ITableContext no-undo get. set.

	constructor public TableResponse(input pcTableName as character ):
		super().
		
		assign TableName = pcTableName
		       HasError = false
		       ErrorText = new TypedMap(
		                  String:Type,
		                  String:Type).
	end constructor.
	
/** IExternalizable **/
    method public void WriteObject(po as ObjectOutputStream):
        po:WriteChar(TableName).
        po:WriteLogical(HasError).
        po:WriteObject(TableContext).
        
        /* Serialize these separately, so we don't carry all the bumpf along. */
        po:WriteObjectArray(ErrorText:KeySet:ToArray()).
        po:WriteObjectArray(ErrorText:Values:ToArray()).
    end method.
    
    method public void ReadObject(po as ObjectInputStream):
        TableName = po:ReadChar().
        HasError = po:ReadLogical().
        TableContext =  cast(po:ReadObject(), ITableContext).
         
        /*ErrorText = cast(po:ReadObject(), IMap).*/
        ErrorText = new TypedMap(
                          String:Type,
                          String:Type).
                          
        cast(ErrorText:KeySet, ICollection):AddArray(po:ReadObjectArray()).
        cast(ErrorText:Values, ICollection):AddArray(po:ReadObjectArray()).
    end method.
    
end class.