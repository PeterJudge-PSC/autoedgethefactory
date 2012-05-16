<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_scubaroo")) { 
jdr.addGroup("FinanceManagementGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_scubaroo");
} 
if (!jdr.isUserExist("admin@scubaroo")) { 
jdr.addUser("admin@scubaroo");
user = ((JDBCUser)jdr.getUser("admin@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "scubaroo");
user.setAttribute(JDBCRealm.EMAIL, "admin@scubaroo.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("admin@scubaroo");
} 
if (!jdr.isUserExist("guest@scubaroo")) { 
jdr.addUser("guest@scubaroo");
user = ((JDBCUser)jdr.getUser("guest@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "scubaroo");
user.setAttribute(JDBCRealm.EMAIL, "admin@scubaroo.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("guest@scubaroo");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_scubaroo")) { 
jdr.addGroup("FactoryGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_scubaroo");
} 
if (!jdr.isUserExist("factory@scubaroo")) { 
jdr.addUser("factory@scubaroo");
user = ((JDBCUser)jdr.getUser("factory@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "scubaroo");
user.setAttribute(JDBCRealm.EMAIL, "admin@scubaroo.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("factory@scubaroo");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_scubaroo")) { 
jdr.addGroup("FinanceManagementGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_scubaroo");
} 
if (!jdr.isUserExist("lob_manager@scubaroo")) { 
jdr.addUser("lob_manager@scubaroo");
user = ((JDBCUser)jdr.getUser("lob_manager@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "scubaroo");
user.setAttribute(JDBCRealm.EMAIL, "admin@scubaroo.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("lob_manager@scubaroo");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_scubaroo")) { 
jdr.addGroup("FinanceStaffGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_scubaroo");
} 
if (!jdr.isUserExist("keith_washington@scubaroo")) { 
jdr.addUser("keith_washington@scubaroo");
user = ((JDBCUser)jdr.getUser("keith_washington@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Keith");
user.setAttribute(JDBCRealm.LASTNAME, "Washington");
user.setAttribute(JDBCRealm.EMAIL, "Keith.Washington@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("keith_washington@scubaroo");
} 
if (!jdr.isUserExist("mary_murphy@scubaroo")) { 
jdr.addUser("mary_murphy@scubaroo");
user = ((JDBCUser)jdr.getUser("mary_murphy@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Murphy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("mary_murphy@scubaroo");
} 
if (!jdr.isUserExist("jack_woods@scubaroo")) { 
jdr.addUser("jack_woods@scubaroo");
user = ((JDBCUser)jdr.getUser("jack_woods@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jack");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Jack.Woods@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("jack_woods@scubaroo");
} 
if (!jdr.isUserExist("nancy_roberts@scubaroo")) { 
jdr.addUser("nancy_roberts@scubaroo");
user = ((JDBCUser)jdr.getUser("nancy_roberts@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Roberts");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Roberts@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("nancy_roberts@scubaroo");
} 
if (!jdr.isUserExist("robert_nelson@scubaroo")) { 
jdr.addUser("robert_nelson@scubaroo");
user = ((JDBCUser)jdr.getUser("robert_nelson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Nelson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("robert_nelson@scubaroo");
} 
if (!jdr.isUserExist("ann_hamilton@scubaroo")) { 
jdr.addUser("ann_hamilton@scubaroo");
user = ((JDBCUser)jdr.getUser("ann_hamilton@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Hamilton");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Hamilton@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("ann_hamilton@scubaroo");
} 
if (!jdr.isUserExist("barbara_peterson@scubaroo")) { 
jdr.addUser("barbara_peterson@scubaroo");
user = ((JDBCUser)jdr.getUser("barbara_peterson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Peterson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("barbara_peterson@scubaroo");
} 
if (!jdr.isUserExist("lisa_baker@scubaroo")) { 
jdr.addUser("lisa_baker@scubaroo");
user = ((JDBCUser)jdr.getUser("lisa_baker@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Baker@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("lisa_baker@scubaroo");
} 
if (!jdr.isUserExist("amy_coleman@scubaroo")) { 
jdr.addUser("amy_coleman@scubaroo");
user = ((JDBCUser)jdr.getUser("amy_coleman@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Coleman");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Coleman@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("amy_coleman@scubaroo");
} 
if (!jdr.isUserExist("barbara_spencer@scubaroo")) { 
jdr.addUser("barbara_spencer@scubaroo");
user = ((JDBCUser)jdr.getUser("barbara_spencer@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Spencer");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Spencer@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("barbara_spencer@scubaroo");
} 
if (!jdr.isUserExist("laura_jones@scubaroo")) { 
jdr.addUser("laura_jones@scubaroo");
user = ((JDBCUser)jdr.getUser("laura_jones@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Jones");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Jones@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_scubaroo");
grp.addUserMember("laura_jones@scubaroo");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_scubaroo")) { 
jdr.addGroup("FullfillmentStaffGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_scubaroo");
} 
if (!jdr.isUserExist("mark_jackson@scubaroo")) { 
jdr.addUser("mark_jackson@scubaroo");
user = ((JDBCUser)jdr.getUser("mark_jackson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mark");
user.setAttribute(JDBCRealm.LASTNAME, "Jackson");
user.setAttribute(JDBCRealm.EMAIL, "Mark.Jackson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("mark_jackson@scubaroo");
} 
if (!jdr.isUserExist("amanda_kennedy@scubaroo")) { 
jdr.addUser("amanda_kennedy@scubaroo");
user = ((JDBCUser)jdr.getUser("amanda_kennedy@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Kennedy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("amanda_kennedy@scubaroo");
} 
if (!jdr.isUserExist("robert_lee@scubaroo")) { 
jdr.addUser("robert_lee@scubaroo");
user = ((JDBCUser)jdr.getUser("robert_lee@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Lee");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Lee@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("robert_lee@scubaroo");
} 
if (!jdr.isUserExist("nancy_howard@scubaroo")) { 
jdr.addUser("nancy_howard@scubaroo");
user = ((JDBCUser)jdr.getUser("nancy_howard@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Howard");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Howard@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("nancy_howard@scubaroo");
} 
if (!jdr.isUserExist("donald_burns@scubaroo")) { 
jdr.addUser("donald_burns@scubaroo");
user = ((JDBCUser)jdr.getUser("donald_burns@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donald");
user.setAttribute(JDBCRealm.LASTNAME, "Burns");
user.setAttribute(JDBCRealm.EMAIL, "Donald.Burns@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("donald_burns@scubaroo");
} 
if (!jdr.isUserExist("julie_parker@scubaroo")) { 
jdr.addUser("julie_parker@scubaroo");
user = ((JDBCUser)jdr.getUser("julie_parker@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Parker");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Parker@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("julie_parker@scubaroo");
} 
if (!jdr.isUserExist("melissa_woods@scubaroo")) { 
jdr.addUser("melissa_woods@scubaroo");
user = ((JDBCUser)jdr.getUser("melissa_woods@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Woods@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("melissa_woods@scubaroo");
} 
if (!jdr.isUserExist("amanda_flores@scubaroo")) { 
jdr.addUser("amanda_flores@scubaroo");
user = ((JDBCUser)jdr.getUser("amanda_flores@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Flores");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Flores@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("amanda_flores@scubaroo");
} 
if (!jdr.isUserExist("amy_peterson@scubaroo")) { 
jdr.addUser("amy_peterson@scubaroo");
user = ((JDBCUser)jdr.getUser("amy_peterson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Peterson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("amy_peterson@scubaroo");
} 
if (!jdr.isUserExist("julie_coleman@scubaroo")) { 
jdr.addUser("julie_coleman@scubaroo");
user = ((JDBCUser)jdr.getUser("julie_coleman@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Coleman");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Coleman@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("julie_coleman@scubaroo");
} 
if (!jdr.isUserExist("sarah_kennedy@scubaroo")) { 
jdr.addUser("sarah_kennedy@scubaroo");
user = ((JDBCUser)jdr.getUser("sarah_kennedy@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Kennedy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_scubaroo");
grp.addUserMember("sarah_kennedy@scubaroo");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_scubaroo")) { 
jdr.addGroup("SalesrepGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_scubaroo");
} 
if (!jdr.isUserExist("patrick_perry@scubaroo")) { 
jdr.addUser("patrick_perry@scubaroo");
user = ((JDBCUser)jdr.getUser("patrick_perry@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Patrick");
user.setAttribute(JDBCRealm.LASTNAME, "Perry");
user.setAttribute(JDBCRealm.EMAIL, "Patrick.Perry@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("patrick_perry@scubaroo");
} 
if (!jdr.isUserExist("ann_walker@scubaroo")) { 
jdr.addUser("ann_walker@scubaroo");
user = ((JDBCUser)jdr.getUser("ann_walker@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Walker");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Walker@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("ann_walker@scubaroo");
} 
if (!jdr.isUserExist("richard_shaw@scubaroo")) { 
jdr.addUser("richard_shaw@scubaroo");
user = ((JDBCUser)jdr.getUser("richard_shaw@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Shaw@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("richard_shaw@scubaroo");
} 
if (!jdr.isUserExist("amy_woods@scubaroo")) { 
jdr.addUser("amy_woods@scubaroo");
user = ((JDBCUser)jdr.getUser("amy_woods@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Woods@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("amy_woods@scubaroo");
} 
if (!jdr.isUserExist("steve_rose@scubaroo")) { 
jdr.addUser("steve_rose@scubaroo");
user = ((JDBCUser)jdr.getUser("steve_rose@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Rose");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Rose@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("steve_rose@scubaroo");
} 
if (!jdr.isUserExist("amanda_stevens@scubaroo")) { 
jdr.addUser("amanda_stevens@scubaroo");
user = ((JDBCUser)jdr.getUser("amanda_stevens@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Stevens");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Stevens@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("amanda_stevens@scubaroo");
} 
if (!jdr.isUserExist("carol_moore@scubaroo")) { 
jdr.addUser("carol_moore@scubaroo");
user = ((JDBCUser)jdr.getUser("carol_moore@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Moore");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Moore@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("carol_moore@scubaroo");
} 
if (!jdr.isUserExist("diane_carter@scubaroo")) { 
jdr.addUser("diane_carter@scubaroo");
user = ((JDBCUser)jdr.getUser("diane_carter@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Carter@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("diane_carter@scubaroo");
} 
if (!jdr.isUserExist("julie_simmons@scubaroo")) { 
jdr.addUser("julie_simmons@scubaroo");
user = ((JDBCUser)jdr.getUser("julie_simmons@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Simmons@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("julie_simmons@scubaroo");
} 
if (!jdr.isUserExist("janet_gray@scubaroo")) { 
jdr.addUser("janet_gray@scubaroo");
user = ((JDBCUser)jdr.getUser("janet_gray@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Gray");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Gray@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("janet_gray@scubaroo");
} 
if (!jdr.isUserExist("alice_holmes@scubaroo")) { 
jdr.addUser("alice_holmes@scubaroo");
user = ((JDBCUser)jdr.getUser("alice_holmes@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Holmes");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Holmes@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_scubaroo");
grp.addUserMember("alice_holmes@scubaroo");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_scubaroo")) { 
jdr.addGroup("FinanceManagementGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_scubaroo");
} 
if (!jdr.isUserExist("mike_simmons@scubaroo")) { 
jdr.addUser("mike_simmons@scubaroo");
user = ((JDBCUser)jdr.getUser("mike_simmons@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mike");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Mike.Simmons@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("mike_simmons@scubaroo");
} 
if (!jdr.isUserExist("donna_bing@scubaroo")) { 
jdr.addUser("donna_bing@scubaroo");
user = ((JDBCUser)jdr.getUser("donna_bing@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Bing");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Bing@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("donna_bing@scubaroo");
} 
if (!jdr.isUserExist("mark_evans@scubaroo")) { 
jdr.addUser("mark_evans@scubaroo");
user = ((JDBCUser)jdr.getUser("mark_evans@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mark");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Mark.Evans@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("mark_evans@scubaroo");
} 
if (!jdr.isUserExist("betty_black@scubaroo")) { 
jdr.addUser("betty_black@scubaroo");
user = ((JDBCUser)jdr.getUser("betty_black@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Betty");
user.setAttribute(JDBCRealm.LASTNAME, "Black");
user.setAttribute(JDBCRealm.EMAIL, "Betty.Black@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("betty_black@scubaroo");
} 
if (!jdr.isUserExist("scott_jordan@scubaroo")) { 
jdr.addUser("scott_jordan@scubaroo");
user = ((JDBCUser)jdr.getUser("scott_jordan@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Scott");
user.setAttribute(JDBCRealm.LASTNAME, "Jordan");
user.setAttribute(JDBCRealm.EMAIL, "Scott.Jordan@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("scott_jordan@scubaroo");
} 
if (!jdr.isUserExist("betty_ross@scubaroo")) { 
jdr.addUser("betty_ross@scubaroo");
user = ((JDBCUser)jdr.getUser("betty_ross@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Betty");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Betty.Ross@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("betty_ross@scubaroo");
} 
if (!jdr.isUserExist("martha_richardson@scubaroo")) { 
jdr.addUser("martha_richardson@scubaroo");
user = ((JDBCUser)jdr.getUser("martha_richardson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Richardson");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Richardson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("martha_richardson@scubaroo");
} 
if (!jdr.isUserExist("julie_holmes@scubaroo")) { 
jdr.addUser("julie_holmes@scubaroo");
user = ((JDBCUser)jdr.getUser("julie_holmes@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Holmes");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Holmes@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("julie_holmes@scubaroo");
} 
if (!jdr.isUserExist("amanda_cox@scubaroo")) { 
jdr.addUser("amanda_cox@scubaroo");
user = ((JDBCUser)jdr.getUser("amanda_cox@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Cox");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Cox@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("amanda_cox@scubaroo");
} 
if (!jdr.isUserExist("carol_wood@scubaroo")) { 
jdr.addUser("carol_wood@scubaroo");
user = ((JDBCUser)jdr.getUser("carol_wood@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Wood");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Wood@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("carol_wood@scubaroo");
} 
if (!jdr.isUserExist("barbara_black@scubaroo")) { 
jdr.addUser("barbara_black@scubaroo");
user = ((JDBCUser)jdr.getUser("barbara_black@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Black");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Black@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_scubaroo");
grp.addUserMember("barbara_black@scubaroo");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_scubaroo")) { 
jdr.addGroup("FactoryGroup_scubaroo"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_scubaroo");
} 
if (!jdr.isUserExist("scott_barnes@scubaroo")) { 
jdr.addUser("scott_barnes@scubaroo");
user = ((JDBCUser)jdr.getUser("scott_barnes@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Scott");
user.setAttribute(JDBCRealm.LASTNAME, "Barnes");
user.setAttribute(JDBCRealm.EMAIL, "Scott.Barnes@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("scott_barnes@scubaroo");
} 
if (!jdr.isUserExist("heather_hunter@scubaroo")) { 
jdr.addUser("heather_hunter@scubaroo");
user = ((JDBCUser)jdr.getUser("heather_hunter@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Hunter");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Hunter@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("heather_hunter@scubaroo");
} 
if (!jdr.isUserExist("david_robinson@scubaroo")) { 
jdr.addUser("david_robinson@scubaroo");
user = ((JDBCUser)jdr.getUser("david_robinson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "David");
user.setAttribute(JDBCRealm.LASTNAME, "Robinson");
user.setAttribute(JDBCRealm.EMAIL, "David.Robinson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("david_robinson@scubaroo");
} 
if (!jdr.isUserExist("amy_martinez@scubaroo")) { 
jdr.addUser("amy_martinez@scubaroo");
user = ((JDBCUser)jdr.getUser("amy_martinez@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Martinez@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("amy_martinez@scubaroo");
} 
if (!jdr.isUserExist("peter_lee@scubaroo")) { 
jdr.addUser("peter_lee@scubaroo");
user = ((JDBCUser)jdr.getUser("peter_lee@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Peter");
user.setAttribute(JDBCRealm.LASTNAME, "Lee");
user.setAttribute(JDBCRealm.EMAIL, "Peter.Lee@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("peter_lee@scubaroo");
} 
if (!jdr.isUserExist("joyce_torres@scubaroo")) { 
jdr.addUser("joyce_torres@scubaroo");
user = ((JDBCUser)jdr.getUser("joyce_torres@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Torres");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Torres@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("joyce_torres@scubaroo");
} 
if (!jdr.isUserExist("helen_hunter@scubaroo")) { 
jdr.addUser("helen_hunter@scubaroo");
user = ((JDBCUser)jdr.getUser("helen_hunter@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Hunter");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Hunter@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("helen_hunter@scubaroo");
} 
if (!jdr.isUserExist("linda_sullivan@scubaroo")) { 
jdr.addUser("linda_sullivan@scubaroo");
user = ((JDBCUser)jdr.getUser("linda_sullivan@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Sullivan@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("linda_sullivan@scubaroo");
} 
if (!jdr.isUserExist("alice_simpson@scubaroo")) { 
jdr.addUser("alice_simpson@scubaroo");
user = ((JDBCUser)jdr.getUser("alice_simpson@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Simpson");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Simpson@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("alice_simpson@scubaroo");
} 
if (!jdr.isUserExist("melissa_cox@scubaroo")) { 
jdr.addUser("melissa_cox@scubaroo");
user = ((JDBCUser)jdr.getUser("melissa_cox@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Cox");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Cox@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("melissa_cox@scubaroo");
} 
if (!jdr.isUserExist("barbara_murphy@scubaroo")) { 
jdr.addUser("barbara_murphy@scubaroo");
user = ((JDBCUser)jdr.getUser("barbara_murphy@scubaroo"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Murphy@merriweatherfieldsnowe.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_scubaroo");
grp.addUserMember("barbara_murphy@scubaroo");
} 
%> 
</html>