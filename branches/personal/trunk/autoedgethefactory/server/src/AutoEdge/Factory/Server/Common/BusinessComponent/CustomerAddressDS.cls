/** ------------------------------------------------------------------------
    File        : CustomerAddressDS
    Purpose     : Customer address detail datasource 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jun 16 11:14:15 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataSource.StandardDataSource.
using OpenEdge.CommonInfrastructure.Common.IComponentInfo.

class AutoEdge.Factory.Server.Common.BusinessComponent.CustomerAddressDS inherits StandardDataSource: 

    define override protected property PrimaryTable as handle no-undo
        get():
            if not valid-handle(PrimaryTable) then
                create buffer PrimaryTable for table buffer AddressDetail:handle.
            
            return PrimaryTable.
        end get.
        set.

	constructor public CustomerAddressDS(input poComponentInfo as IComponentInfo ):
		super (input poComponentInfo).
	end constructor.

end class.