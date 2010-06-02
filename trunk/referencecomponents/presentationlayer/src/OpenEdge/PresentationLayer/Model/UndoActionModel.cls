/*------------------------------------------------------------------------
    File        : UndoActionModel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 31 11:47:10 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Model.DatasetModel.
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.
using Progress.Lang.Object.

class OpenEdge.PresentationLayer.Model.UndoActionModel inherits DatasetModel :
    define temp-table eAction no-undo before-table eActionBefore
        field RecordKey as character extent 18
        field QueryName as character
        field BufferName as character 
        field ModelService as Object    /* IComponentInfo */
        field UndoActionType as Object /* OpenEdge.PresentationLayer.Presenter.UpdateActionEnum:EnumMember */
        field Order as integer
        index idx1 as primary unique ModelService QueryName BufferName Order
        .
    
    define dataset dsUndoAction for eAction.
                
    constructor public UndoActionModel (poServiceManager as IServiceManager, poComponentInfo as IComponentInfo):
        super(poServiceManager, poComponentInfo).
    end constructor.

    method override protected handle CreateMasterDataset():
        /* no service adapter - all data is local */
        return dataset dsUndoAction:handle.
    end method.
                                        
    method override protected void DoCommitData():
        /* all data is local */
        MasterDataset:write-xml('file', 'UndoActionModel.xml', 
                                yes, /*formatted*/
                                ?,?,?,
                                yes).   /* write BI */
    end method.
        
    method override protected void AssignDefaultValues(pcTable as character, phBuffer as handle):
    end method.

    method override protected void SetBufferCallbacks(pcBufferName as char, phBuffer as handle):
    end method.

end class.