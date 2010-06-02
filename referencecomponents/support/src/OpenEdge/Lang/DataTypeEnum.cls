/*------------------------------------------------------------------------
    File        : DataType
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Mar 16 13:44:09 EDT 2009
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.
  
using OpenEdge.Lang.*.
using Progress.Lang.*.

class OpenEdge.Lang.DataTypeEnum final:
    define public static property Default            as EnumMember no-undo get. private set.
    define public static property None               as EnumMember no-undo get. private set.
    
    /* ABL Primitives */
    define public static property Character          as EnumMember no-undo get. private set.
    define public static property CharacterArray     as EnumMember no-undo get. private set.
    define public static property LongChar           as EnumMember no-undo get. private set.
    define public static property LongCharArray      as EnumMember no-undo get. private set.
    define public static property Integer            as EnumMember no-undo get. private set.
    define public static property IntegerArray       as EnumMember no-undo get. private set.
    define public static property Int64              as EnumMember no-undo get. private set.
    define public static property Int64Array         as EnumMember no-undo get. private set.
    define public static property Decimal            as EnumMember no-undo get. private set.
    define public static property DecimalArray       as EnumMember no-undo get. private set.
    define public static property Logical            as EnumMember no-undo get. private set.
    define public static property LogicalArray       as EnumMember no-undo get. private set.
    define public static property Rowid              as EnumMember no-undo get. private set.
    define public static property RowidArray         as EnumMember no-undo get. private set.
    define public static property Recid              as EnumMember no-undo get. private set.
    define public static property RecidArray         as EnumMember no-undo get. private set.
    define public static property Date               as EnumMember no-undo get. private set.
    define public static property DateArray          as EnumMember no-undo get. private set.
    define public static property Datetime           as EnumMember no-undo get. private set.
    define public static property DatetimeArray      as EnumMember no-undo get. private set.
    define public static property DatetimeTZ         as EnumMember no-undo get. private set.
    define public static property DatetimeTZArray    as EnumMember no-undo get. private set.
    define public static property Raw                as EnumMember no-undo get. private set.
    define public static property RawArray           as EnumMember no-undo get. private set.
    define public static property Memptr             as EnumMember no-undo get. private set.
    define public static property MemptrArray        as EnumMember no-undo get. private set.
    define public static property Handle             as EnumMember no-undo get. private set.
    define public static property HandleArray        as EnumMember no-undo get. private set.
    define public static property BLOB               as EnumMember no-undo get. private set.
    define public static property CLOB               as EnumMember no-undo get. private set.
    define public static property ComHandle          as EnumMember no-undo get. private set.
    define public static property ComHandleArray     as EnumMember no-undo get. private set.
    
    /* Data structures */
    define public static property Dataset            as EnumMember no-undo get. private set.
    define public static property Buffer             as EnumMember no-undo get. private set.
    define public static property TempTable          as EnumMember no-undo get. private set.

    /* User-defined types */
    define public static property ProgressLangObject as EnumMember no-undo get. private set.
    define public static property Class              as EnumMember no-undo get. private set.
    define public static property ClassArray         as EnumMember no-undo get. private set.
    
    constructor static DataTypeEnum():
        DataTypeEnum:None = new EnumMember(01, '').
        DataTypeEnum:Character = new EnumMember(02, 'Character').
        DataTypeEnum:CharacterArray = new EnumMember(03, 'Character Extent').
        DataTypeEnum:LongChar = new EnumMember(04, 'Longchar').
        DataTypeEnum:LongCharArray = new EnumMember(05, 'Longchar Extent').
        DataTypeEnum:Integer = new EnumMember(06, 'Integer').
        DataTypeEnum:IntegerArray = new EnumMember(07, 'Integer Extent').
        DataTypeEnum:Int64 = new EnumMember(08, 'Int64').
        DataTypeEnum:Int64Array = new EnumMember(09, 'Int64 Extent').
        DataTypeEnum:Decimal = new EnumMember(10, 'Decimal').
        DataTypeEnum:DecimalArray = new EnumMember(11, 'Decimal Extent').
        DataTypeEnum:Logical = new EnumMember(12, 'Logical').
        DataTypeEnum:LogicalArray = new EnumMember(13, 'Logical Extent').
        DataTypeEnum:Rowid = new EnumMember(14, 'Rowid').
        DataTypeEnum:RowidArray = new EnumMember(15, 'Rowid Extent').
        DataTypeEnum:Recid = new EnumMember(16, 'Recid').
        DataTypeEnum:RecidArray = new EnumMember(17, 'Recid Extent').
        DataTypeEnum:Date = new EnumMember(18, 'Date').
        DataTypeEnum:DateArray = new EnumMember(19, 'Date Extent').
        DataTypeEnum:Datetime = new EnumMember(20, 'Datetime').
        DataTypeEnum:DatetimeArray = new EnumMember(21, 'Datetime Extent').
        DataTypeEnum:DatetimeTZ = new EnumMember(22, 'Datetime-TZ').
        DataTypeEnum:DatetimeTZArray = new EnumMember(23, 'Datetime-TZ Extent').
        DataTypeEnum:Raw = new EnumMember(24, 'Raw').
        DataTypeEnum:RawArray = new EnumMember(25, 'Raw Extent').
        DataTypeEnum:Memptr = new EnumMember(26, 'Memptr').
        DataTypeEnum:MemptrArray = new EnumMember(27, 'Memptr Extent').
        DataTypeEnum:Handle = new EnumMember(28, 'Handle').
        DataTypeEnum:HandleArray = new EnumMember(29, 'Handle Extent').
        DataTypeEnum:Class = new EnumMember(30, 'Class &1').
        DataTypeEnum:ClassArray = new EnumMember(31, 'Class &1 Extent').
        DataTypeEnum:ProgressLangObject = new EnumMember(32, 'Progress.Lang.Object').
        DataTypeEnum:BLOB = new EnumMember(33, 'BLOB').
        DataTypeEnum:CLOB = new EnumMember(34, 'CLOB').
        DataTypeEnum:ComHandle = new EnumMember(35, 'Com-Handle').
        DataTypeEnum:ComHandleArray = new EnumMember(36, 'Com-Handle Extent').
        DataTypeEnum:Dataset = new EnumMember(37, 'Dataset').
        DataTypeEnum:Buffer = new EnumMember(38, 'Buffer').
        DataTypeEnum:TempTable = new EnumMember(39, 'Temp-Table').
        
        DataTypeEnum:Default = DataTypeEnum:Character.
    end constructor.
    
    method static public EnumMember EnumFromValue(piDataType as integer):
        define variable oMember as EnumMember no-undo.
        
        case piDataType:
            when DataTypeEnum:None:Value               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:Value          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:Value     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:Value           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:Value      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:Value            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:Value       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:Value              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:Value         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:Value            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:Value       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:Value            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:Value       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:Value              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:Value         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:Value              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:Value         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:Value               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:Value          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:Value           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:Value      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:Value         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:Value    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:Value                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:Value           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:Value             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:Value        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:Value             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:Value        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:Value              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:Value         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:Value then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:Value               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:Value               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:Value          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:Value     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:Value            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:Value             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:Value          then oMember = DataTypeEnum:TempTable.
        end case.
                
        return oMember.        
    end method.
    
    method static public EnumMember EnumFromString(pcDataType as character):
        define variable oMember as EnumMember no-undo.
        
        case pcDataType:
            when DataTypeEnum:None:ToString()               then oMember = DataTypeEnum:None.
            when DataTypeEnum:Character:ToString()          then oMember = DataTypeEnum:Character.
            when DataTypeEnum:CharacterArray:ToString()     then oMember = DataTypeEnum:CharacterArray.
            when DataTypeEnum:Longchar:ToString()           then oMember = DataTypeEnum:LongChar.
            when DataTypeEnum:LongcharArray:ToString()      then oMember = DataTypeEnum:LongCharArray.
            when DataTypeEnum:Integer:ToString()            then oMember = DataTypeEnum:Integer.
            when DataTypeEnum:IntegerArray:ToString()       then oMember = DataTypeEnum:IntegerArray.
            when DataTypeEnum:Int64:ToString()              then oMember = DataTypeEnum:Int64.
            when DataTypeEnum:Int64Array:ToString()         then oMember = DataTypeEnum:Int64Array.
            when DataTypeEnum:Decimal:ToString()            then oMember = DataTypeEnum:Decimal.
            when DataTypeEnum:DecimalArray:ToString()       then oMember = DataTypeEnum:DecimalArray.
            when DataTypeEnum:Logical:ToString()            then oMember = DataTypeEnum:Logical.
            when DataTypeEnum:LogicalArray:ToString()       then oMember = DataTypeEnum:LogicalArray.
            when DataTypeEnum:Rowid:ToString()              then oMember = DataTypeEnum:Rowid.
            when DataTypeEnum:RowidArray:ToString()         then oMember = DataTypeEnum:RowidArray.
            when DataTypeEnum:Recid:ToString()              then oMember = DataTypeEnum:Recid.
            when DataTypeEnum:RecidArray:ToString()         then oMember = DataTypeEnum:RecidArray.
            when DataTypeEnum:Date:ToString()               then oMember = DataTypeEnum:Date.
            when DataTypeEnum:DateArray:ToString()          then oMember = DataTypeEnum:DateArray.
            when DataTypeEnum:Datetime:ToString()           then oMember = DataTypeEnum:Datetime.
            when DataTypeEnum:DatetimeArray:ToString()      then oMember = DataTypeEnum:DatetimeArray.
            when DataTypeEnum:DatetimeTZ:ToString()         then oMember = DataTypeEnum:DatetimeTZ.
            when DataTypeEnum:DatetimeTZArray:ToString()    then oMember = DataTypeEnum:DatetimeTZArray.
            when DataTypeEnum:Raw:ToString()                then oMember = DataTypeEnum:Raw.
            when DataTypeEnum:RawArray:ToString()           then oMember = DataTypeEnum:RawArray.
            when DataTypeEnum:Memptr:ToString()             then oMember = DataTypeEnum:Memptr.
            when DataTypeEnum:MemptrArray:ToString()        then oMember = DataTypeEnum:MemptrArray.
            when DataTypeEnum:Handle:ToString()             then oMember = DataTypeEnum:Handle.
            when DataTypeEnum:HandleArray:ToString()        then oMember = DataTypeEnum:HandleArray.
            when DataTypeEnum:Class:ToString()              then oMember = DataTypeEnum:Class.
            when DataTypeEnum:ClassArray:ToString()         then oMember = DataTypeEnum:ClassArray.
            when DataTypeEnum:ProgressLangObject:ToString() then oMember = DataTypeEnum:ProgressLangObject.
            when DataTypeEnum:BLOB:ToString()               then oMember = DataTypeEnum:BLOB.
            when DataTypeEnum:CLOB:ToString()               then oMember = DataTypeEnum:CLOB.
            when DataTypeEnum:ComHandle:ToString()          then oMember = DataTypeEnum:ComHandle.
            when DataTypeEnum:ComHandleArray:ToString()     then oMember = DataTypeEnum:ComHandleArray.
            when DataTypeEnum:Dataset:ToString()            then oMember = DataTypeEnum:Dataset.
            when DataTypeEnum:Buffer:ToString()             then oMember = DataTypeEnum:Buffer.
            when DataTypeEnum:TempTable:ToString()          then oMember = DataTypeEnum:TempTable.
        end case.
                
        return oMember.   
    end method.

    method static public logical IsPrimitive(poDataType as EnumMember):
        define variable lPrimitive as logical no-undo.
        
        case poDataType:
            when DataTypeEnum:Class or
            when DataTypeEnum:ClassArray or
            when DataTypeEnum:ProgressLangObject or
            when DataTypeEnum:None then 
                lPrimitive = false.
            otherwise
                lPrimitive = true.
        end case.
        
        return lPrimitive.
    end method.
    
    method static public logical IsArray(poDataType as EnumMember):
        return (entry(num-entries(poDataType:Name, ' '), poDataType:Name, ' ') eq 'extent').
    end method.
    
end class.