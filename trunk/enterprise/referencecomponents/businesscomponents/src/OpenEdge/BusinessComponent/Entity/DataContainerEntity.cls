/** ------------------------------------------------------------------------
    File        : DataContainerEntity
    Purpose     : Facade to a  IDataContainer that's a decorator for a IBusinessEntity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 20 16:01:07 EDT 2011
    Notes       : * Allows us to navigate and update a Business Entity externally
                    without having knowledge of, or access to the PDS/TT/whatever
                    directly.
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.BusinessComponent.Entity.BusinessEntity.
using OpenEdge.BusinessComponent.Entity.BusinessEntityDecorator.

using OpenEdge.Core.DataContainer.IDataContainer.
using OpenEdge.Core.DataContainer.IDataContainerQuery.
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.
using OpenEdge.Core.DataContainer.DataContainerActionEnum.
using OpenEdge.Core.System.IQueryDefinition.

using OpenEdge.Lang.Collections.IMap.
using Progress.Lang.Object.

class OpenEdge.BusinessComponent.Entity.DataContainerEntity inherits BusinessEntityDecorator
        implements IDataContainer:
    
    define protected property DataContainer as IDataContainer no-undo get. private set.
    
    define public property DataContainerQueries as IMap no-undo
        get():
            return DataContainer:DataContainerQueries.
        end get.
    
    constructor public DataContainerEntity(input poBusinessEntity as IBusinessEntity):
        super(input poBusinessEntity).
        
        DataContainer = cast(DecoratedBusinessEntity, BusinessEntity):CreateDataContainer().
    end constructor.
    
    method public IDataContainerQuery CreateQuery( input pcQueryName as character, input pcTableName as character ):
        return DataContainer:CreateQuery(pcQueryName, pcTableName).
    end method.
    
    method public IDataContainerQuery CreateQuery( input poQueryDefinition as IQueryDefinition, input phQuery as handle, input pcQueryName as character ):
        return DataContainer:CreateQuery(poQueryDefinition, phQuery, pcQueryName).
    end method.
    
    method public IDataContainerQuery CreateQuery(input pcQueryName as character, input poQueryDefinition as IQueryDefinition):
        return DataContainer:CreateQuery(pcQueryName, poQueryDefinition).
    end method.
    
    method public character AddRecord(input pcTableName as character):
        return DataContainer:AddRecord(pcTableName).
    end method.

    method public character AddChildRecord(input pcTableName as character,
                                           input pcParentTableName as character,
                                           input pcParentRecordKey as character):
        return DataContainer:AddChildRecord(pcTableName, pcParentTableName, pcParentRecordKey).                                               
    end method.
        
    method public void SaveRecord(input pcTableName as character, input pcRecordKey as character ):
        DataContainer:SaveRecord(pcTableName, pcRecordKey).
    end method.
    
    method public void DeleteRecord( input pcTableName as character, input pcRecordKey as character ):
        DataContainer:DeleteRecord(pcTableName, pcRecordKey).
    end method.
    
    method public void ValidateField(input poAction as DataContainerActionEnum, input pcTableName as character, input pcRecordKey as character, input pcFieldName as character):
        DataContainer:ValidateField(poAction, pcTableName, pcRecordKey, pcFieldName).
    end method.
    
    method public void ValidateRow( input poAction as DataContainerActionEnum, input pcTableName as character, input pcRecordKey as character ):
        DataContainer:ValidateRow(poAction, pcTableName, pcRecordKey).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pcValue as character ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pcValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pcValue as character extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pcValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pcValue as longchar ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pcValue).    
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pcValue as longchar extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pcValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output phValue as handle ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output phValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output phValue as handle extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output phValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output piValue as integer ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output piValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output piValue as integer extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output piValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output piValue as int64 ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output piValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output piValue as int64 extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output piValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pdValue as decimal ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pdValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output pdValue as decimal extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output pdValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as date ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as date extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as datetime ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as datetime extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).    
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as datetime-tz ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output ptValue as datetime-tz extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output ptValue).    
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output prValue as raw ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output prValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output prValue as raw extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output prValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output poValue as  Object ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output poValue).
    end method.
    
    method public void GetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, output poValue as  Object extent ):
        DataContainer:GetValue(pcTableName, pcRecordKey, pcFieldName, output poValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pcValue as character ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pcValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pcValue as character extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pcValue).    
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pcValue as longchar ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pcValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pcValue as longchar extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pcValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input phValue as handle ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, phValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input phValue as handle extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, phValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input piValue as integer ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, piValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input piValue as integer extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, piValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input piValue as int64 ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, piValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input piValue as int64 extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, piValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pdValue as decimal ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pdValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input pdValue as decimal extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, pdValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as date ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as date extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).    
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as datetime ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as datetime extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as datetime-tz ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input ptValue as datetime-tz extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, ptValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input prValue as raw ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, prValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input prValue as raw extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, prValue).
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input poValue as  Object ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, poValue).    
    end method.
    
    method public character SetValue( input pcTableName as character, input pcRecordKey as character, input pcFieldName as character, input poValue as  Object extent ):
        return DataContainer:SetValue(pcTableName, pcRecordKey, pcFieldName, poValue).
    end method.
    
end class.