/** ------------------------------------------------------------------------
    File        : FormsEnumHelper
    Purpose     : Helper class to translate from .NET GUI enumerations to ABL 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu May 21 14:49:18 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.PresentationLayer.Common.CloseReasonEnum.
using OpenEdge.PresentationLayer.Common.DialogResultEnum.

using System.Windows.Forms.CloseReason.
using System.Windows.Forms.DialogResult.
using Progress.Util.EnumHelper.

class OpenEdge.PresentationLayer.View.GuiForDotNet.FormsEnumHelper   : 

    method static public CloseReasonEnum CloseReasonToABL(poCloseReason as CloseReason):
        define variable oResult as CloseReasonEnum no-undo.
        
        if EnumHelper:AreEqual(poCloseReason, CloseReason:None) then oResult = CloseReasonEnum:None.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:WindowsShutDown) then oResult = CloseReasonEnum:WindowsShutDown.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:MdiFormClosing) then oResult = CloseReasonEnum:MdiFormClosing.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:UserClosing) then oResult = CloseReasonEnum:UserClosing.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:TaskManagerClosing) then oResult = CloseReasonEnum:TaskManagerClosing.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:FormOwnerClosing) then oResult = CloseReasonEnum:FormOwnerClosing.
        else
        if EnumHelper:AreEqual(poCloseReason, CloseReason:ApplicationExitCall) then oResult = CloseReasonEnum:ApplicationExitCall.

        return oResult.
    end method.
    
    method static public DialogResultEnum DialogResultToABL(poDialogResult as DialogResult):
        define variable oResult as DialogResultEnum no-undo.
        
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Abort) then oResult = DialogResultEnum:Abort.
        else 
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Cancel) then oResult = DialogResultEnum:Cancel.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Ignore) then oResult = DialogResultEnum:Ignore.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:No) then oResult = DialogResultEnum:ResultNo.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:None) then oResult = DialogResultEnum:None.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Ok) then oResult = DialogResultEnum:Ok.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Retry) then oResult = DialogResultEnum:Retry.
        else
        if EnumHelper:AreEqual(poDialogResult, DialogResult:Yes) then oResult = DialogResultEnum:ResultYes.        
        
        return oResult.
    end method.                

end class.