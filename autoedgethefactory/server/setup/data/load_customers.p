/*------------------------------------------------------------------------
    File        : load_customers.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 09:19:48 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
routine-level on error undo, throw.


/* ********************  Preprocessor Definitions  ******************** */
function getRandom returns character (input cValueList as character):

    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, '|') .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, '|') .
        else return cValueList.
end function.

/* ***************************  Main Block  *************************** */
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cLastNames as character no-undo.
define variable cMiddleNames as character no-undo.
define variable cFirstNamesMale as character no-undo.
define variable cFirstNamesFemale as character no-undo.
define variable cSalutationsMale as character no-undo.
define variable cSalutationsFemale as character no-undo.
define variable cNotes as character no-undo.
define variable cEmailAddress as character no-undo.

define variable iNumAddresses as integer no-undo.
define buffer childTenant for Tenant.

define query qryAddresses for AddressDetail scrolling.

iMax = 10.

cLastNames = "Miller|Anderson|Higgins|Gant|Jones|Smith|Johnson|Moore|Taylor|Jackson|Harris|Martin|Garcia|Martinez|Robinson|Lewis|Lee|Walker|Baker|Nelson|Carter|Roberts|Tuner|Parker|Evans|Collins|Stewart|Murphy|Cooper|Richardson|Cox|Howard|Geller|Bing|Ward|Torres|Peterson|Gray|Ramirez|James|Watson|Brooks|Kelly|Sanders|Price|Bennet|Wood|Barnes|Ross|Henderson|Coleman|Jenkins|Perry|Powell|Long|Patterson|Hughes|Flores|Washington|Butler|Simmons|Foster|Gonzales|Alexander|Hayes|Myers|Ford|Hamilton|Graham|Sullivan|Wallace|Woods|West|Jordan|Reynolds|Marshall|Freeman|Wells|Webbs|Simpson|Stevens|Tucker|Porter|Hunter|Hicks|Crawford|Kennedy|Burns|Shaw|Holmes|Robertson|Hunt|Black|Palmer|Rose|Spencer|Pierce|Wagner".
cMiddleNames = "A.|B.|M.|N.|L.||".
cFirstNamesMale = "John|Robert|Mike|David|Richard|Thomas|Chris|Paul|Mark|Donald|Steve|Anthony|Larry|Frank|Scott|Eric|Greg|Patrick|Peter|Carl|Arthur|Joe|Jack|Justin|Keith".
cFirstNamesFemale = "Mary|Linda|Barbara|Susan|Margaret|Lisa|Nancy|Betty|Helen|Donna|Carol|Laura|Sarah|Jessica|Melissa|Brenda|Amy|Rebecca|Martha|Amanda|Janet|Ann|Joyce|Diane|Alice|Julie|Heather|Evelyn|Kelly".
cSalutationsMale = "Mr.|Mr.|Mr.|Mr.|Mr.|Mr.|Dr.".
cSalutationsFemale = "Ms.|Miss|Ms.|Miss|Ms.|Miss|Dr.".
cNotes = "Some note|Another note|No note|||||".
cEmailAddress = "@hootmail.customer.aetf|@gleemail.customer.aetf|@wahoo.customer.aetf|@ayowl.customer.aetf".

open query qryAddresses preselect each AddressDetail.
iNumAddresses = query qryAddresses:num-results - 1.

for each Tenant:
    
    /* only want customers of brands */
    if Tenant.ParentTenantId eq '' then next.    
    if can-find(first childTenant where childTenant.ParentTenantId = Tenant.TenantId) then next.    
    
    do iLoop = 1 to iMax:   
        create Customer.
        assign iLoop = iLoop + 1 
               Customer.CustNum = iLoop
               Customer.Balance = random(0, 25000)
               Customer.Comments = getRandom(cNotes)
               Customer.CreditLimit = random(0, 25000)
               Customer.CustomerId = guid(generate-uuid)
               Customer.Discount = random(0, 11)
               Customer.Language = 'EN-US'
               Customer.PrimaryLocaleId = Tenant.LocaleId
               Customer.SalesrepId = ''
               Customer.TenantId = Tenant.TenantId
               Customer.Terms = ''.
        
        if iLoop mod 2 eq 0 then        
            Customer.Name = getRandom(cFirstNamesFemale) + ' ' + getRandom(cMiddleNames) + ' ' + getRandom(cLastNames).
        else
            Customer.Name = getRandom(cFirstNamesMale) + ' ' + getRandom(cMiddleNames) + ' ' + getRandom(cLastNames).
        
        reposition qryAddresses to row random(0, iNumAddresses).
        get next qryAddresses no-lock.
    
        run AddCustomerAddress(
                'billing',
                Customer.TenantId,
                Customer.CustomerId,
                AddressDetail.AddressDetailId).
                        
        run AddCustomerContact(
                'email-home',
                Customer.TenantId, 
                Customer.CustomerId,
                trim(entry(1, Customer.Name, ' ')) + getRandom(cEmailAddress)).
        
        run AddCustomerContact(
                'phone-mobile',
                Customer.TenantId, 
                Customer.CustomerId,
                substitute('&1-555-&2',
                           random(201, 979),
                           random(1000, 9999))).
    
    end.
end.

procedure AddCustomerContact:
    define input parameter pcContactType as character no-undo.
    define input parameter pcTenantId as longchar no-undo.
    define input parameter pcCustomerId as character no-undo.
    define input parameter pcContactDetail as character no-undo.

    find first ContactDetail where ContactDetail.Detail eq pcContactDetail no-lock no-error.
    if not available ContactDetail then
    do:
        create ContactDetail.
        assign ContactDetail.ContactDetailId = guid(generate-uuid)
               ContactDetail.Detail = pcContactDetail.
    end.

    find ContactType where ContactType.Name = pcContactType no-lock.
           
    create CustomerContact.
    assign CustomerContact.ContactDetailId = ContactDetail.ContactDetailId
           CustomerContact.CustomerId = pcCustomerId
           CustomerContact.TenantId = pcTenantId
           CustomerContact.ContactType = ContactType.Name.
end procedure.

procedure AddCustomerAddress:
    define input parameter pcAddressType as character no-undo.
    define input parameter pcTenantId as longchar no-undo.
    define input parameter pcCustomerId as character no-undo.
    define input parameter pcAddressDetailId as character no-undo.
    
    find AddressType where  AddressType.AddressType eq pcAddressType no-lock.
    
    create CustomerAddress.
    assign CustomerAddress.AddressDetailId = pcAddressDetailId
           CustomerAddress.AddressType = AddressType.AddressType
           CustomerAddress.CustomerId = pcCustomerId
           CustomerAddress.TenantId = pcTenantId.
end procedure.    



