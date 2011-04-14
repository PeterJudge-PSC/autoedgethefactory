/* ------------------------------------------------------------------------
    File        : load_all.p
    Purpose     : 

    Syntax      :

    Description : Wrapper around data load procedures.


    Author(s)   : pjudge
    Created     : Tue Dec 14 14:23:42 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

/* available to all */
run setup/data/load_geography.p.
run setup/data/load_statusdetail.p.
run setup/data/load_tenants.p.
run setup/data/load_salesregion.p.

/**/
run setup/data/load_contacts.p.
run setup/data/load_addresses.p.

run setup/data/load_dealers.p.
run setup/data/load_customers.p.
run setup/data/load_employees.p.
/*run setup/data/load_suppliers.p.*/
run setup/data/load_users.p.

/*run setup/data/load_orders.p. */
run setup/data/load_items.p.
