/*------------------------------------------------------------------------
    File        : TaskDetailForm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Nov 24 11:43:26 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Client.Common.EnterpriseServices.CurrentTask.
using AutoEdge.Factory.Client.Common.PresentationLayer.ITaskListManager.

using OpenEdge.EnterpriseServices.BizLogic.WorkFlowWebService.
using OpenEdge.Lang.Assert.

using Progress.Windows.Form.
using Progress.Lang.Error. 

class AutoEdge.Factory.Client.Order.PresentationLayer.TaskDetailForm inherits Form: 
    
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable savvionTaskDetailUC1 as AutoEdge.Factory.Client.Common.PresentationLayer.SavvionTaskDetailUC no-undo.

    define public property TaskListManager as ITaskListManager no-undo get. private set.
    define public property CurrentTask as CurrentTask no-undo get. private set.
    define public property SessionId as character no-undo get. private set.
    
    constructor public TaskDetailForm(input poTaskListManager as ITaskListManager,
                                      input poCurrentTask as CurrentTask):
        this-object().
        
        Assert:ArgumentNotNull(poCurrentTask, 'Current task').
        Assert:ArgumentNotNull(poTaskListManager, 'Task List Manager').
        
        assign TaskListManager = poTaskListManager
               CurrentTask = poCurrentTask.
        
        TaskListManager:SetTaskDataSlots(CurrentTask).
        
        savvionTaskDetailUC1:SetTask(CurrentTask, TaskListManager).        
    end constructor.
        
    constructor public TaskDetailForm (  ):
        super().
        InitializeComponent().
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.

    method private void InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:savvionTaskDetailUC1 = new AutoEdge.Factory.Client.Common.PresentationLayer.SavvionTaskDetailUC().
        this-object:SuspendLayout().
        /*  */
        /* savvionTaskDetailUC1 */
        /*  */
        this-object:savvionTaskDetailUC1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:savvionTaskDetailUC1:Location = new System.Drawing.Point(0, 0).
        this-object:savvionTaskDetailUC1:Name = "savvionTaskDetailUC1".
        this-object:savvionTaskDetailUC1:Size = new System.Drawing.Size(595, 344).
        this-object:savvionTaskDetailUC1:TabIndex = 1.
        /*  */
        /* TaskDetailForm */
        /*  */
        this-object:ClientSize = new System.Drawing.Size(595, 344).
        this-object:Controls:Add(this-object:savvionTaskDetailUC1).
        this-object:Name = "TaskDetailForm".
        this-object:Text = "TaskDetailForm".
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    destructor public TaskDetailForm ( ):

        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.

    end destructor.
    
end class.