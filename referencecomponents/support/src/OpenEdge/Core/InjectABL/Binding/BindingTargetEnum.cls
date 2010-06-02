/*------------------------------------------------------------------------
    File        : BindingTarget
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Mar 02 11:37:41 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.Binding.BindingTargetEnum: 
        /** Indicates that the binding is from a type to itself. **/
        define static public property Self as EnumMember no-undo get. private set.

        /** Indicates that the binding is from one type to another. **/
        define static public property Type as EnumMember no-undo get. private set.

        /** Indicates that the binding is from a type to a provider. **/
        define static public property Provider as EnumMember no-undo get. private set.

        /** Indicates that the binding is from a type to a callback method. **/
        define static public property Method as EnumMember no-undo get. private set.

        /** Indicates that the binding is from a type to a constant value. **/
        define static public property Constant  as EnumMember no-undo get. private set.
        
        constructor static BindingTargetEnum():
            BindingTargetEnum:Self = new EnumMember().
            BindingTargetEnum:Type = new EnumMember().
            BindingTargetEnum:Provider = new EnumMember().
            BindingTargetEnum:Method = new EnumMember().
            BindingTargetEnum:Constant = new EnumMember().
        end constructor.
        
end class.