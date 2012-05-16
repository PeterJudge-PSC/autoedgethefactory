/*------------------------------------------------------------------------------
    File        : loaddf.p 
    Purpose     : Shell procedure for loading a .df file 

    Syntax      : _progress -b -p loaddf.p -params "df-file-path" -db <db> ...

    Description : Call the prodict/load_df.p procedure

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------------*/
  
/* ********************  Call Parameter Definitions  ************************ */

/* *********************  Module Variable Definitions  ********************** */
define variable m_cRetValue             as character initial "" no-undo.
define variable m_cFilePath             as character initial "" no-undo. 

/* ***********************  Preprocessor Definitions  *********************** */

/* ************************* Procedure Settings ***************************** */

/******************************************************************************/
/******************************************************************************/
/* ********************  INTERNAL PROCEDURES/FUNCTIONS ********************** */
/******************************************************************************/
/******************************************************************************/


/******************************************************************************/
/******************************************************************************/
/*********               MAIN  (BLOCK-ZERO)                            ********/
/******************************************************************************/
/******************************************************************************/

if ("" <> session:parameter AND ? <> session:parameter ) then do :
    /* test existance of the .df file .. */
    m_cFilePath = search (session:parameter) no-error. 
    if ( ? <> m_cFilePath ) then do :
        /* Ensure the datbase is connected... */
    message ldbname(1).
        if ( connected ( ldbname(1) ) ) then do :
            run prodict/load_df.p ( input  session:parameter ) no-error. 
            if ( 0 < error-status:num-messages ) then do:
                message "Error loading df file: " + error-status:get-message(1).
            end. else do :
                "Done.".
            end.
        end. else do :
            message "Error: No database is connected.".
        end.
    /* do the load... */
    end. else do :
        message "Error: Cannot find the df file: " + session:parameter.
    end. 
end. else do :
    message "usage: _progres -b -p loaddf.p -param 'df-file-path' -db <db> <options>".
end.

/* Return block-zero status to the caller */
return m_cRetValue.


