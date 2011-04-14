/** ------------------------------------------------------------------------
    File        : load_injectabl_modules.p
    Purpose     : InjectABL module loader for DataAccess layer

    Syntax      :

    Description : Loads InjectABL modules 


    Author(s)   : pjudge
    Created     : Mon Dec 13 13:40:24 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.DataAccess.InjectABL.DataAccessModule.
using OpenEdge.DataSource.InjectABL.DataSourcesModule.
using OpenEdge.Core.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/
poKernel:Load(new DataAccessModule()).
poKernel:Load(new DataSourcesModule()).

/** -- eof -- **/