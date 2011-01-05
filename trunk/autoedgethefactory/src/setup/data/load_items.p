/*------------------------------------------------------------------------
    File        : load_items.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Mon Dec 20 15:23:50 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Lang.FillModeEnum.

/* ***************************  Definitions  ************************** */
define temp-table ttItemOption no-undo serialize-name 'options'
    field TenantName as character serialize-name 'brand' xml-node-type 'hidden'
    field ItemTypeName as character serialize-name 'type'
    field ParentItemName as character serialize-name  'parentitem'
    field ItemName as character serialize-name  'name'
    index idx1 as primary unique TenantName ParentItemName ItemTypeName ItemName.
    
define temp-table ttItem no-undo serialize-name 'item'
    field TenantName as character serialize-name 'brand' 
    field ItemNum as integer xml-node-type 'attribute' serialize-name 'num'
    field ItemName as character serialize-name  'name'
    field Description as character serialize-name 'description' /* lowercase*/
    field ItemTypeName as character serialize-name 'type'
    field Price as decimal serialize-name 'price' /* lowercase */
    index idx1 as primary unique TenantName ItemNum
    .

define temp-table ttBrand no-undo serialize-name 'brand'
    field TenantName as character serialize-name 'name' xml-node-type 'attribute'
    index idx1 as primary unique TenantName.     
    
define dataset dsVehicles serialize-name 'vehicles'
     for ttBrand, ttItem, ttItemOption
    data-relation for ttBrand, ttItem relation-fields (TenantName, TenantName) nested
    data-relation for ttItem, ttItemOption relation-fields (TenantName, TenantName, ItemName, ParentItemName) nested
    .
        

/* ********************  Preprocessor Definitions  ******************** */

function getRandom returns character (input cValueList as character):
    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, '|') .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, '|') .
        else return cValueList .
end function .

function getRandomID returns character (input cValueList as character):
    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, chr(1)) .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, chr(1)) .
        else return cValueList .
end function .

/* ***************************  Main Block  *************************** */

dataset dsVehicles:read-xml('file', search('setup/data/vehicles.xml'), FillModeEnum:Empty:ToString(), ?, ?).

dataset dsVehicles:write-json('file', session:temp-dir + 'cars.json').

run load_vehicle_items.

/*run load_finished_items.*/

procedure load_vehicle_items:
    define buffer lbItem for Item.
    
    /* create options for the items */
    for each Tenant no-lock:
    
        /* create the generic options */
        for each ttBrand where ttBrand.TenantName = 'all',
            each ttItem where
                 ttItem.TenantName = ttBrand.TenantName,
            first ItemType where
                  ItemType.Name = ttItem.ItemTypeName
                  no-lock:
            create Item.
            assign Item.TenantId    = Tenant.TenantId
                   Item.ItemId      = guid(generate-uuid)
                   Item.ItemTypeId  = ItemType.ItemTypeId
                   Item.ItemNum     = ttItem.ItemNum
                   Item.ItemName    = ttItem.ItemName
                   Item.Price       = ttItem.Price
                   Item.OnHand      = random(1, 50)
                   Item.Allocated   = 0
                   Item.Description = ttItem.Description
                   Item.Weight      = 0
                   Item.MinQty      = 0.
        end.    /* 'all' items */
        
        for each ttBrand where
             ttBrand.TenantName = Tenant.Name, 
        each ttItem where
             ttItem.TenantName = ttBrand.TenantName,
        first ItemType where
              ItemType.Name = ttItem.ItemTypeName
              no-lock.
            /* create the vehicles */                      
            create Item.
            assign Item.TenantId    = Tenant.TenantId
                   Item.ItemId      = guid(generate-uuid)
                   Item.ItemTypeId  = ItemType.ItemTypeId
                   Item.ItemNum     = ttItem.ItemNum
                   Item.ItemName    = ttItem.ItemName
                   Item.Price       = ttItem.Price
                   Item.OnHand      = random(1, 50)
                   Item.Allocated   = 0
                   Item.Description = ttItem.Description
                   Item.Weight      = 0
                   Item.MinQty      = 0.
            
            run associate_generic(Tenant.TenantId, Item.ItemId).
            
            for each ttItemOption where
                     ttItemOption.TenantName = ttItem.TenantName and
                     ttItemOption.ParentItemName = ttItem.ItemName,
                first lbItem where
                      lbItem.ItemName = ttItemOption.ItemName and
                      lbItem.TenantId = Tenant.TenantId
                      no-lock:
                create ItemOption.
                assign ItemOption.ItemId = Item.ItemId
                       ItemOption.ChildItemId = lbItem.ItemId
                       ItemOption.TenantId = Tenant.TenantId. 
            end.    /* item options */
        end.    /* each brand */
    end.    /* each tenant */
end.    /* procedure */

procedure associate_generic:
    define input parameter pcTenantId as character no-undo.
    define input parameter pcVehicleItemId as character no-undo.
    
    define buffer lbttOption for ttItemOption.
    define buffer lbItem for Item.
    define buffer lbttItem for ttItem.
    define buffer lbttBrand for ttBrand.
    define buffer lbItemType for ItemType.
    
    /* create the generic options */
    for each lbttBrand where lbttBrand.TenantName = 'all',
        each lbttItem where
             lbttItem.TenantName = lbttBrand.TenantName,
        first lbItem where
              lbItem.ItemName = lbttItem.ItemName and 
              lbItem.TenantId = pcTenantId
              no-lock:
        
        /* xml should contain engine and fuel combos */
        if can-do('engine,fuel', lbttItem.ItemTypeName) then
            next.
        
        create ItemOption.
        assign ItemOption.ItemId = pcVehicleItemId
               ItemOption.ChildItemId = Item.ItemId
               ItemOption.TenantId = pcTenantId. 
    end.
end procedure.

procedure load_ItemType:
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable cTypes as character no-undo.
    
    cTypes = 'Vehicle|Engine|Fuel|Wheels|Trim-Material|Trim-Colour|Ext-Colour|Moonroof|Accessories'.
    cTypes = replace(cTypes, 'Vehicle', 'Convertible|Coupe|Sedan|SUV|Crossover|Truck|Commercial'). 
    
    iMax = num-entries(cTypes, '|').    
    do iLoop = 1 to iMax:
        create ItemType.
        assign ItemType.ItemTypeId = guid(generate-uuid)
               ItemType.Name = entry(iLoop, cTypes, '|')
               ItemType.Description = 'Items of type ' + ItemType.Name.
    end.
    
end procedure.