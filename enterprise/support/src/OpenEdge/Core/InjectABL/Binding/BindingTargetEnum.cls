/** ------------------------------------------------------------------------
    File        : BindingTarget
    Purpose     : Enumeration of InjectABL binding target types 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:37:41 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Lang.EnumMember.

class OpenEdge.Core.InjectABL.Binding.BindingTargetEnum inherits EnumMember: 
    /** Indicates that the binding is from a type to itself. **/
    define static public property Self as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from one type to another. **/
    define static public property Type as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a provider. **/
    define static public property Provider as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a callback method. **/
    define static public property Method as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a constant value. **/
    define static public property Constant  as BindingTargetEnum no-undo get. private set.
        
    constructor static BindingTargetEnum():
        BindingTargetEnum:Self = new BindingTargetEnum().
        BindingTargetEnum:Type = new BindingTargetEnum().
        BindingTargetEnum:Provider = new BindingTargetEnum().
        BindingTargetEnum:Method = new BindingTargetEnum().
        BindingTargetEnum:Constant = new BindingTargetEnum().
    end constructor.
    
    constructor public BindingTargetEnum():
        super(?,?).
    end constructor.
        
end class.