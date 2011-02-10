/** ------------------------------------------------------------------------
    File        : IModelQuery
    Purpose     : A query that's specialised fore use by a Model
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Jan 26 15:03:49 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

using OpenEdge.PresentationLayer.Model.IModelQuery.
using OpenEdge.PresentationLayer.Model.IModel.
using OpenEdge.PresentationLayer.Common.ModelActionEventArgs.

using OpenEdge.CommonInfrastructure.Common.IComponent.

using OpenEdge.Core.System.EventArgs.

interface OpenEdge.PresentationLayer.Model.IModelQuery: /* inherits IQuery */

    /** (mandatory) The Model on which this query operates. */
    define public property Model as IModel no-undo get. /* protected set */
     
    /** (mandatory) A user-friendly name of the query */
    define public property QueryName as character no-undo get. /*protected set.*/
    
    /** (derived) The nu */
    define public property NumSelectedRows as integer no-undo get. /*protected set.*/
    
    /** Does this query object require a Reopen() call? A query might be flagged as such 
        by a Model when new data is added from a busines entity (or even locally) in 
        batch/bundle mode. */
    define public property RequiresReopen  as logical no-undo get. set.
    
    /* See notes in OpenEdge.PresentationLayer.Model.ModelQuery.cls */
    method public void SetQueryHandle(phQuery as handle).
    method public void ResetQueryHandle().
    
    /* parameter is number of row selection, not query ordinal */
    method public char extent GetSelectedRowKey(piRow as int).
        
    method public void ClearSelection().
    method public void SelectRow(pcRowKey as char extent).
    method public void SelectCurrentRow().    
    method public void DeselectRow(pcRowKey as char extent).
    method public void DeselectCurrentRow().

end interface.