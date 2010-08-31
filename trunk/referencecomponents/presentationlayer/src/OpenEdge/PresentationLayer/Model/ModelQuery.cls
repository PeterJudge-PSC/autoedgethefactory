/** ------------------------------------------------------------------------
    File        : ModelQuery
    Purpose     : Specialisation of Query class for MVP Model
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 26 15:05:18 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.*.
using OpenEdge.Core.System.*.
using Progress.Lang.*.

class OpenEdge.PresentationLayer.Model.ModelQuery inherits Query
        implements IModelQuery:
    
    /* Events */
    define public event QueryOpened       signature void (poQuery as IModelQuery, poArgs as EventArgs).
    define public event QueryClosed       signature void (poQuery as IModelQuery, poArgs as EventArgs).
    define public event QueryRepositioned signature void (poQuery as IModelQuery, poArgs as EventArgs).
    
    define public property Model as IModel no-undo get. protected set.
    define public property QueryName as character no-undo get. protected set.
    define public property NumSelectedRows as integer no-undo get. protected set. 
     
    define private variable mhBaseQueryHandle as handle no-undo. 
    
    /* In some cases we use this object to store prebuilt queries, such as a 
       ProDataSet's top-nav-query; in this case, we have a query handle already 
       and this is considereed prebuilt. We can change and (re)open the query,
       but the handle stays the same, and cannot be changed, nor can the buffers 
       in the query.
       
       The Query object does not support the changing of the QueryHandle.
     */
    constructor public ModelQuery (poModel as IModel,
                                   pcName as character,
                                   phQueryHandle as handle,
                                   poQueryDefinition as IQueryDefinition):
        
        /* A Model is always aTableOwner */
        super(cast(poModel, ITableOwner), poQueryDefinition).
        
        if (pcName eq ? or pcName = '') then
        do: 
           if valid-handle(phQueryHandle) then
               pcName = string(phQueryHandle).
           else 
               /* need /something/ */
               pcName = string(int(this-object)).
        end.
        assign Model = poModel
               mhBaseQueryHandle = phQueryHandle 
               QueryHandle = phQueryHandle
               QueryName = pcName 
               
               /* we already have a working query */
               BuildQuery = not valid-handle(phQueryHandle).
    end constructor.
    
    constructor public ModelQuery (poModel as IModel,
                                   pcName as character,
                                   poQueryDefinition as IQueryDefinition):
        
        this-object(poModel,pcName,?,poQueryDefinition).  
    end constructor.
    
    /* these are protected since only an IQuery object can publish
       the events. also encapsulated since the cloned query won't
       cause a publish. */
    method protected void OnQueryOpen(phQuery as handle):
        if phQuery eq QueryHandle then
            this-object:QueryOpened:publish(this-object, EventArgs:Empty).
    end method.
    
    method protected void OnQueryClose(phQuery as handle):
        if phQuery eq QueryHandle then
            this-object:QueryClosed:publish(this-object, EventArgs:Empty).
    end method.

    method protected void OnQueryRepos(phQuery as handle):
        if phQuery eq QueryHandle then
            this-object:QueryRepositioned:publish(this-object, EventArgs:Empty).
    end method.
    
    method override protected void OpenQuery(phQuery as handle):
        super:OpenQuery(phQuery).
        if valid-handle(phQuery) and phQuery eq QueryHandle then
        do:
            OnQueryOpen(phQuery).
        end.
    end method.
    
    method override protected logical CloseQuery(phQuery as handle):
        define variable lOk as log no-undo.
        lOk = super:CloseQuery(phQuery).
        if lOk and phQuery eq QueryHandle then                
            OnQueryClose(phQuery).
        return lOk. 
    end method.
    
    method override protected logical RepositionQuery(phQuery as handle, piRow as int):
        if super:RepositionQuery(phQuery,piRow) then
        do:
            if phQuery eq QueryHandle then  
                OnQueryRepos(phQuery).
            return true.
        end.
        else 
            return false. 
    end method.
    
    method override protected logical RepositionQuery (phQuery as handle, prRecord as rowid extent):
        if super:RepositionQuery(phQuery,prRecord) then
        do:
            if phQuery eq QueryHandle then  
                OnQueryRepos(phQuery).
            return true.
        end.
        else 
            return false. 
    end method.
    
    /* parameter is number of row selection, not query ordinal */
    method public char extent GetSelectedRowKey(piRow as int):
    end method.    
        
    method public void ClearSelection():
    end method.
            
    method public void SelectRow(pcRowKey as char extent).
    end method.
    
    method public void SelectCurrentRow().    
    end method.
    
    method public void DeselectRow(pcRowKey as char extent).
    end method.
    
    method public void DeselectCurrentRow().
    end method.
    
    /* Allows the DatasetModel to use the queries created by
       the ProBindingSource if it needs to. DatasetModel:CreateDefaultQUeries()
       creates a bunch of queries based on the relations; the PBS uses the same
       queries (the PDS' relation queries) as a basis for its' own 'smaller'/individual
       queries when its working in a heirachical grid like the UlraControls' UltraGrid.
       
       The query definitions will stay the same for all queries on a relation - so you won't be able
       to sort customer 1's orders differently from customer 2's in the same grid - but we're
       going to use that single query def for all the individual queries, and will do so by pushing 
       the actual query in use in to this object. 
     */
    method public void SetQueryHandle(phQuery as handle):
        QueryHandle = phQuery.
    end method.
    
    method public void ResetQueryHandle():
        QueryHandle = mhBaseQueryHandle.
    end method.
    
end class.
