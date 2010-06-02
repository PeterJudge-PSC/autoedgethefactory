/*------------------------------------------------------------------------
    File        : UITypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Apr 23 15:08:30 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.UITypeEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.System.UITypeEnum:
    
    define static public property Chui as EnumMember no-undo get. private set.
    define static public property AblGui as EnumMember no-undo get. private set.
    define static public property DotNetGui as EnumMember no-undo get. private set.
    define static public property RiaGui as EnumMember no-undo get. private set.
    define static public property Current as EnumMember no-undo get. private set.
    
    constructor static UITypeEnum():
        assign UITypeEnum:Chui = new EnumMember('Chui')
               UITypeEnum:AblGui = new EnumMember('AblGui')
               UITypeEnum:DotNetGui = new EnumMember('DotNetGui')
               UITypeEnum:RiaGui = new EnumMember('RiaGui')
               
               UITypeEnum:Current = UITypeEnum:DotNetGui. 
               
    end constructor.
    
end class.