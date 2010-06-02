/*------------------------------------------------------------------------
    File        : SDOModel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue May 19 12:19:42 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.Model.
using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Common.ModelErrorEventArgs.

using OpenEdge.CommonInfrastructure.Common.IServiceManager. 
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

using OpenEdge.Core.System.IQuery.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.ValueNotSpecifiedError.

class OpenEdge.PresentationLayer.Model.SDOModel abstract
        inherits Model :
    
    define abstract protected property SmartDataObject as character no-undo get. set.
    
    define private variable mhSdo as handle no-undo.
    
    method override protected void AfterCommitData(  ):
    end method.

    method override protected void AssignDefaultValues(pcTable as character, phBuffer as handle ):
        /* SDO does this */
    end method.
    
     method public logical CloseQuery( input pcQuery as character ):
        return dynamic-function('closeQuery' in mhSdo).
    end method.

     method override protected handle GetBufferHandle( input pcTable as character ):
        /* SDO only has ever one table. */
        return dynamic-function('GetRowObject' in mhSdo).
    end method.
    
    constructor public SDOModel(poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.
    
    method public logical GetFirst( input pcQuery as character ):
        define variable oQuery as IQuery no-undo.
        
        run fetchFirst in mhSDO.
        
        oQuery = cast(GetQuery(pcQuery), IQuery).
        oQuery:RepositionQuery(oQuery:GetCurrentRowKey()).
        
        return (dynamic-function('rowAvailable' in mhSdo, ?)).
    end method.
    
    method  public logical GetLast( input pcQuery as character ):
        define variable oQuery as IQuery no-undo.
        
        run fetchLast in mhSDO.

        oQuery = cast(GetQuery(pcQuery), IQuery).
        oQuery:RepositionQuery(oQuery:GetCurrentRowKey()).
        
        return (dynamic-function('rowAvailable' in mhSdo, ?)).
    end method.
    
    method  public logical GetNext( input pcQuery as character ):
        define variable oQuery as IQuery no-undo.
        
        run fetchNext in mhSDO.

        oQuery = cast(GetQuery(pcQuery), IQuery).
        oQuery:RepositionQuery(oQuery:GetCurrentRowKey()).
        
        return (dynamic-function('rowAvailable' in mhSdo, ?)).
    end method.
    
    method  public logical GetPrev( input pcQuery as character ):
        define variable oQuery as IQuery no-undo.
        
        run fetchPrev in mhSDO.
        
        oQuery = cast(GetQuery(pcQuery), IQuery).
        oQuery:RepositionQuery(oQuery:GetCurrentRowKey()).
        
        return (dynamic-function('rowAvailable' in mhSdo, ?)).
    end method.
    
    method override public IModelQuery CreateQuery(poQueryDefinition as IQueryDefinition,
                                            phQuery as handle,
                                            pcQuery as char):
        define variable oQueryDefinition as IQueryDefinition no-undo.
        
        phQuery = dynamic-function('GetDataHandle' in mhSdo).
        pcQuery = string(phQuery).
        
        oQueryDefinition = new QueryDefinition().
        oQueryDefinition:AddBuffer('RowObject').
        
        /* we still need to register this query as a ModelQuery */        
        return super:CreateQuery(oQueryDefinition, phQuery, pcQuery).
    end method.
                
    method override public void Initialize():
        define variable cSdoFile as character no-undo.
        define variable cServerFileName as character no-undo.
        
        /* We kinda need the SDO name ... */        
        if this-object:SmartDataObject eq '' then
            undo, throw new ValueNotSpecifiedError('SmartDataObject').
        
        super:Initialize().
        
        /* start SDO */
        cSDOFile = entry(1, this-object:SmartDataObject, '.') + '_cl.w'.
        run value(this-object:SmartDataObject) persistent set mhSDO no-error.
    
        dynamic-function('setOpenOnInit' in mhSdo, false).
        dynamic-function('setLogicalObjectName' in mhSDO, this-object:SmartDataObject). 
        
        run initializeObject in mhSDO.
                
    end method.
    
    method  public void OpenQuery( input pcQuery as character ):
       dynamic-function('openQuery' in mhSdo).    
    end method.
    
    method override public void DestroyComponent ():
        super:DestroyComponent().
                
        run destroyObject in mhSdo no-error.
        if valid-handle(mhSdo) then
            delete object mhSdo no-error.
        mhSdo = ?.
    end method.
            
    method override public void FetchData():
        dynamic-function('openQuery' in mhSdo).
    end method.
                    
    method override public void CollectChanges():
    end method.
                                                
    /* Operations */
    method override protected char DoAddRecord(pcBufferName as char):
        define variable cNewRecordKey as character no-undo.
        
        dynamic-function('addRow' in mhSdo, '').
        
/*        cast(GetQuery(pcQuery), IQuery):GetCurrentRowKey().*/
        return cNewRecordKey. 
    end method.
            
    /** Assign parent values based on the relation a (child) buffer is part of.
     **/
    method override protected void AssignKeyValues (pcTable as char, phBuffer as handle):
        /* SDO does this itself */
    end method.
    
    method override protected void DoCommitData():
        define variable cUndoRowids                 as character     no-undo.
        define variable cErrorList                  as character     no-undo.
        
        /*
            OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
            OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."
        */
        run bufferCommit in mhSDO (output cErrorList, output cUndoRowids) no-error.
                
        if cUndoRowids ne '' then
            ErrorBuffer = 'RowObject'.
    end method.
        
    method override public ModelErrorEventArgs ProcessModelErrors (pcBuffer as char):
        define variable hChangeBuffer              as handle                    no-undo.
        define variable hChangeBefore              as handle                    no-undo.
        define variable hChangeAfter               as handle                    no-undo.
        define variable hMasterBuffer              as handle                    no-undo.
        define variable hMasterBefore              as handle                    no-undo.
        define variable hMasterAfter               as handle                    no-undo.
        define variable hQuery                     as handle                    no-undo.
        define variable oModelErrorEventArgs as ModelErrorEventArgs no-undo.
        
        oModelErrorEventArgs = new ModelErrorEventArgs(pcBuffer).
        /*
        oModelErrorEventArgs:AddErrorRecord(
                            hChangeAfter:rowid,
                            BufferHelper:BufferCompare(hMasterAfter, hChangeAfter),
                            hChangeAfter:error-string).
        */
        return oModelErrorEventArgs.
    end method.
    
    method override public logical MergeChanges(pcQuery as char):
        /* SDO does this itself */
    end method.
                    
    method override protected void DoDeleteRecord(pcBufferName as char, pcRecordKey as char):
        dynamic-function('deleteRow' in mhSdo, dynamic-function('getRowIdent' in mhSdo) ).
    end method.
    
end class.
