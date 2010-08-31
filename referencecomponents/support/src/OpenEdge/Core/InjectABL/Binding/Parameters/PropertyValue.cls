/** ------------------------------------------------------------------------
    File        : PropertyValue
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:33 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.Lang.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Core.InjectABL.Binding.Parameters.PropertyValue inherits Parameter:
        
    constructor public PropertyValue(pcName as character, pcValue as character, poType as DataTypeEnum):
        super(pcName, pcValue, input poType).
    end constructor.
        
    constructor public PropertyValue(pcName as character, pcValue as character extent, poType as DataTypeEnum):
        super(pcName, pcValue, input poType).        
    end constructor.
        
    constructor public PropertyValue(pcName as character, pcValue as character ):
        super(pcName, pcValue).
    end constructor.
        
    constructor public PropertyValue(pcName as character, pcValue as character extent ):
        super(pcName, pcValue).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poValue as Object ):
        super(pcName, poValue).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poValue as Object, poDeclaredType as class Class):
        super(pcName, poValue, input poDeclaredType).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poValue as Object extent ):
        super(pcName, poValue).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poValue as Object extent, poDeclaredType as class Class):
        super(pcName, poValue, poDeclaredType).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poType as class Class, poDataType as DataTypeEnum):
        super(pcName, poType, poDataType).
    end constructor.
        
    constructor public PropertyValue(pcName as character, poType as class Class extent, poDataType as DataTypeEnum):
        super(pcName, poType, poDataType).
    end constructor.

    constructor public PropertyValue(pcName as character, poValue as class Class):
        super(pcName, poValue).
    end constructor.
        
end class.