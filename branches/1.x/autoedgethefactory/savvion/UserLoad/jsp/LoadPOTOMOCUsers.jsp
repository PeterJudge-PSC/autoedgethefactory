<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_potomoc")) { 
jdr.addGroup("FinanceManagementGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_potomoc");
} 
if (!jdr.isUserExist("admin@potomoc")) { 
jdr.addUser("admin@potomoc");
user = ((JDBCUser)jdr.getUser("admin@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "potomoc");
user.setAttribute(JDBCRealm.EMAIL, "admin@potomoc.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("admin@potomoc");
} 
if (!jdr.isUserExist("guest@potomoc")) { 
jdr.addUser("guest@potomoc");
user = ((JDBCUser)jdr.getUser("guest@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "potomoc");
user.setAttribute(JDBCRealm.EMAIL, "admin@potomoc.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("guest@potomoc");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_potomoc")) { 
jdr.addGroup("FactoryGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_potomoc");
} 
if (!jdr.isUserExist("factory@potomoc")) { 
jdr.addUser("factory@potomoc");
user = ((JDBCUser)jdr.getUser("factory@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "potomoc");
user.setAttribute(JDBCRealm.EMAIL, "admin@potomoc.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("factory@potomoc");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_potomoc")) { 
jdr.addGroup("FinanceManagementGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_potomoc");
} 
if (!jdr.isUserExist("lob_manager@potomoc")) { 
jdr.addUser("lob_manager@potomoc");
user = ((JDBCUser)jdr.getUser("lob_manager@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "potomoc");
user.setAttribute(JDBCRealm.EMAIL, "admin@potomoc.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("lob_manager@potomoc");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_potomoc")) { 
jdr.addGroup("FinanceManagementGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_potomoc");
} 
if (!jdr.isUserExist("eric_cooper@potomoc")) { 
jdr.addUser("eric_cooper@potomoc");
user = ((JDBCUser)jdr.getUser("eric_cooper@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Eric");
user.setAttribute(JDBCRealm.LASTNAME, "Cooper");
user.setAttribute(JDBCRealm.EMAIL, "Eric.Cooper@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("eric_cooper@potomoc");
} 
if (!jdr.isUserExist("melissa_roberts@potomoc")) { 
jdr.addUser("melissa_roberts@potomoc");
user = ((JDBCUser)jdr.getUser("melissa_roberts@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Roberts");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Roberts@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("melissa_roberts@potomoc");
} 
if (!jdr.isUserExist("keith_marshall@potomoc")) { 
jdr.addUser("keith_marshall@potomoc");
user = ((JDBCUser)jdr.getUser("keith_marshall@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Keith");
user.setAttribute(JDBCRealm.LASTNAME, "Marshall");
user.setAttribute(JDBCRealm.EMAIL, "Keith.Marshall@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("keith_marshall@potomoc");
} 
if (!jdr.isUserExist("amy_palmer@potomoc")) { 
jdr.addUser("amy_palmer@potomoc");
user = ((JDBCUser)jdr.getUser("amy_palmer@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Palmer@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("amy_palmer@potomoc");
} 
if (!jdr.isUserExist("robert_jackson@potomoc")) { 
jdr.addUser("robert_jackson@potomoc");
user = ((JDBCUser)jdr.getUser("robert_jackson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Jackson");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Jackson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("robert_jackson@potomoc");
} 
if (!jdr.isUserExist("melissa_powell@potomoc")) { 
jdr.addUser("melissa_powell@potomoc");
user = ((JDBCUser)jdr.getUser("melissa_powell@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Powell");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Powell@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("melissa_powell@potomoc");
} 
if (!jdr.isUserExist("carol_bing@potomoc")) { 
jdr.addUser("carol_bing@potomoc");
user = ((JDBCUser)jdr.getUser("carol_bing@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Bing");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Bing@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("carol_bing@potomoc");
} 
if (!jdr.isUserExist("evelyn_henderson@potomoc")) { 
jdr.addUser("evelyn_henderson@potomoc");
user = ((JDBCUser)jdr.getUser("evelyn_henderson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Henderson");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Henderson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("evelyn_henderson@potomoc");
} 
if (!jdr.isUserExist("amanda_gonzales@potomoc")) { 
jdr.addUser("amanda_gonzales@potomoc");
user = ((JDBCUser)jdr.getUser("amanda_gonzales@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Gonzales");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Gonzales@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("amanda_gonzales@potomoc");
} 
if (!jdr.isUserExist("sarah_hamilton@potomoc")) { 
jdr.addUser("sarah_hamilton@potomoc");
user = ((JDBCUser)jdr.getUser("sarah_hamilton@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Hamilton");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Hamilton@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("sarah_hamilton@potomoc");
} 
if (!jdr.isUserExist("martha_evans@potomoc")) { 
jdr.addUser("martha_evans@potomoc");
user = ((JDBCUser)jdr.getUser("martha_evans@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Evans@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_potomoc");
grp.addUserMember("martha_evans@potomoc");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_potomoc")) { 
jdr.addGroup("FullfillmentStaffGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_potomoc");
} 
if (!jdr.isUserExist("patrick_peterson@potomoc")) { 
jdr.addUser("patrick_peterson@potomoc");
user = ((JDBCUser)jdr.getUser("patrick_peterson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Patrick");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Patrick.Peterson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("patrick_peterson@potomoc");
} 
if (!jdr.isUserExist("heather_gray@potomoc")) { 
jdr.addUser("heather_gray@potomoc");
user = ((JDBCUser)jdr.getUser("heather_gray@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Gray");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Gray@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("heather_gray@potomoc");
} 
if (!jdr.isUserExist("paul_palmer@potomoc")) { 
jdr.addUser("paul_palmer@potomoc");
user = ((JDBCUser)jdr.getUser("paul_palmer@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Palmer@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("paul_palmer@potomoc");
} 
if (!jdr.isUserExist("barbara_martin@potomoc")) { 
jdr.addUser("barbara_martin@potomoc");
user = ((JDBCUser)jdr.getUser("barbara_martin@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Martin");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Martin@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("barbara_martin@potomoc");
} 
if (!jdr.isUserExist("arthur_bennet@potomoc")) { 
jdr.addUser("arthur_bennet@potomoc");
user = ((JDBCUser)jdr.getUser("arthur_bennet@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Arthur");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Arthur.Bennet@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("arthur_bennet@potomoc");
} 
if (!jdr.isUserExist("diane_shaw@potomoc")) { 
jdr.addUser("diane_shaw@potomoc");
user = ((JDBCUser)jdr.getUser("diane_shaw@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Shaw@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("diane_shaw@potomoc");
} 
if (!jdr.isUserExist("amanda_freeman@potomoc")) { 
jdr.addUser("amanda_freeman@potomoc");
user = ((JDBCUser)jdr.getUser("amanda_freeman@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Freeman");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Freeman@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("amanda_freeman@potomoc");
} 
if (!jdr.isUserExist("diane_gonzales@potomoc")) { 
jdr.addUser("diane_gonzales@potomoc");
user = ((JDBCUser)jdr.getUser("diane_gonzales@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Gonzales");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Gonzales@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("diane_gonzales@potomoc");
} 
if (!jdr.isUserExist("sarah_lewis@potomoc")) { 
jdr.addUser("sarah_lewis@potomoc");
user = ((JDBCUser)jdr.getUser("sarah_lewis@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Lewis@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("sarah_lewis@potomoc");
} 
if (!jdr.isUserExist("melissa_gant@potomoc")) { 
jdr.addUser("melissa_gant@potomoc");
user = ((JDBCUser)jdr.getUser("melissa_gant@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Gant");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Gant@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("melissa_gant@potomoc");
} 
if (!jdr.isUserExist("alice_myers@potomoc")) { 
jdr.addUser("alice_myers@potomoc");
user = ((JDBCUser)jdr.getUser("alice_myers@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Myers");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Myers@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_potomoc");
grp.addUserMember("alice_myers@potomoc");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_potomoc")) { 
jdr.addGroup("SalesrepGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_potomoc");
} 
if (!jdr.isUserExist("carl_tuner@potomoc")) { 
jdr.addUser("carl_tuner@potomoc");
user = ((JDBCUser)jdr.getUser("carl_tuner@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carl");
user.setAttribute(JDBCRealm.LASTNAME, "Tuner");
user.setAttribute(JDBCRealm.EMAIL, "Carl.Tuner@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("carl_tuner@potomoc");
} 
if (!jdr.isUserExist("lisa_johnson@potomoc")) { 
jdr.addUser("lisa_johnson@potomoc");
user = ((JDBCUser)jdr.getUser("lisa_johnson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Johnson");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Johnson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("lisa_johnson@potomoc");
} 
if (!jdr.isUserExist("richard_carter@potomoc")) { 
jdr.addUser("richard_carter@potomoc");
user = ((JDBCUser)jdr.getUser("richard_carter@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Carter@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("richard_carter@potomoc");
} 
if (!jdr.isUserExist("kelly_martinez@potomoc")) { 
jdr.addUser("kelly_martinez@potomoc");
user = ((JDBCUser)jdr.getUser("kelly_martinez@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Martinez@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("kelly_martinez@potomoc");
} 
if (!jdr.isUserExist("joe_evans@potomoc")) { 
jdr.addUser("joe_evans@potomoc");
user = ((JDBCUser)jdr.getUser("joe_evans@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joe");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Joe.Evans@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("joe_evans@potomoc");
} 
if (!jdr.isUserExist("nancy_shaw@potomoc")) { 
jdr.addUser("nancy_shaw@potomoc");
user = ((JDBCUser)jdr.getUser("nancy_shaw@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Shaw@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("nancy_shaw@potomoc");
} 
if (!jdr.isUserExist("amanda_foster@potomoc")) { 
jdr.addUser("amanda_foster@potomoc");
user = ((JDBCUser)jdr.getUser("amanda_foster@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Foster");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Foster@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("amanda_foster@potomoc");
} 
if (!jdr.isUserExist("mary_simmons@potomoc")) { 
jdr.addUser("mary_simmons@potomoc");
user = ((JDBCUser)jdr.getUser("mary_simmons@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Simmons@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("mary_simmons@potomoc");
} 
if (!jdr.isUserExist("janet_wallace@potomoc")) { 
jdr.addUser("janet_wallace@potomoc");
user = ((JDBCUser)jdr.getUser("janet_wallace@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Wallace");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Wallace@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("janet_wallace@potomoc");
} 
if (!jdr.isUserExist("donna_gray@potomoc")) { 
jdr.addUser("donna_gray@potomoc");
user = ((JDBCUser)jdr.getUser("donna_gray@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Gray");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Gray@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("donna_gray@potomoc");
} 
if (!jdr.isUserExist("heather_martinez@potomoc")) { 
jdr.addUser("heather_martinez@potomoc");
user = ((JDBCUser)jdr.getUser("heather_martinez@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Martinez@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_potomoc");
grp.addUserMember("heather_martinez@potomoc");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_potomoc")) { 
jdr.addGroup("FactoryGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_potomoc");
} 
if (!jdr.isUserExist("justin_perry@potomoc")) { 
jdr.addUser("justin_perry@potomoc");
user = ((JDBCUser)jdr.getUser("justin_perry@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Justin");
user.setAttribute(JDBCRealm.LASTNAME, "Perry");
user.setAttribute(JDBCRealm.EMAIL, "Justin.Perry@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("justin_perry@potomoc");
} 
if (!jdr.isUserExist("susan_bennet@potomoc")) { 
jdr.addUser("susan_bennet@potomoc");
user = ((JDBCUser)jdr.getUser("susan_bennet@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Bennet@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("susan_bennet@potomoc");
} 
if (!jdr.isUserExist("eric_anderson@potomoc")) { 
jdr.addUser("eric_anderson@potomoc");
user = ((JDBCUser)jdr.getUser("eric_anderson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Eric");
user.setAttribute(JDBCRealm.LASTNAME, "Anderson");
user.setAttribute(JDBCRealm.EMAIL, "Eric.Anderson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("eric_anderson@potomoc");
} 
if (!jdr.isUserExist("susan_woods@potomoc")) { 
jdr.addUser("susan_woods@potomoc");
user = ((JDBCUser)jdr.getUser("susan_woods@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Woods@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("susan_woods@potomoc");
} 
if (!jdr.isUserExist("richard_ramirez@potomoc")) { 
jdr.addUser("richard_ramirez@potomoc");
user = ((JDBCUser)jdr.getUser("richard_ramirez@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Ramirez");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Ramirez@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("richard_ramirez@potomoc");
} 
if (!jdr.isUserExist("margaret_sullivan@potomoc")) { 
jdr.addUser("margaret_sullivan@potomoc");
user = ((JDBCUser)jdr.getUser("margaret_sullivan@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Sullivan@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("margaret_sullivan@potomoc");
} 
if (!jdr.isUserExist("mary_sullivan@potomoc")) { 
jdr.addUser("mary_sullivan@potomoc");
user = ((JDBCUser)jdr.getUser("mary_sullivan@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Sullivan@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("mary_sullivan@potomoc");
} 
if (!jdr.isUserExist("amanda_simpson@potomoc")) { 
jdr.addUser("amanda_simpson@potomoc");
user = ((JDBCUser)jdr.getUser("amanda_simpson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amanda");
user.setAttribute(JDBCRealm.LASTNAME, "Simpson");
user.setAttribute(JDBCRealm.EMAIL, "Amanda.Simpson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("amanda_simpson@potomoc");
} 
if (!jdr.isUserExist("brenda_crawford@potomoc")) { 
jdr.addUser("brenda_crawford@potomoc");
user = ((JDBCUser)jdr.getUser("brenda_crawford@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Brenda");
user.setAttribute(JDBCRealm.LASTNAME, "Crawford");
user.setAttribute(JDBCRealm.EMAIL, "Brenda.Crawford@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("brenda_crawford@potomoc");
} 
if (!jdr.isUserExist("alice_evans@potomoc")) { 
jdr.addUser("alice_evans@potomoc");
user = ((JDBCUser)jdr.getUser("alice_evans@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Evans@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("alice_evans@potomoc");
} 
if (!jdr.isUserExist("mary_ford@potomoc")) { 
jdr.addUser("mary_ford@potomoc");
user = ((JDBCUser)jdr.getUser("mary_ford@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Ford");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Ford@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_potomoc");
grp.addUserMember("mary_ford@potomoc");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_potomoc")) { 
jdr.addGroup("FinanceStaffGroup_potomoc"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_potomoc");
} 
if (!jdr.isUserExist("greg_wallace@potomoc")) { 
jdr.addUser("greg_wallace@potomoc");
user = ((JDBCUser)jdr.getUser("greg_wallace@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Wallace");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Wallace@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("greg_wallace@potomoc");
} 
if (!jdr.isUserExist("greg_murphy@potomoc")) { 
jdr.addUser("greg_murphy@potomoc");
user = ((JDBCUser)jdr.getUser("greg_murphy@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Murphy@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("greg_murphy@potomoc");
} 
if (!jdr.isUserExist("margaret_webbs@potomoc")) { 
jdr.addUser("margaret_webbs@potomoc");
user = ((JDBCUser)jdr.getUser("margaret_webbs@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Webbs");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Webbs@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("margaret_webbs@potomoc");
} 
if (!jdr.isUserExist("robert_long@potomoc")) { 
jdr.addUser("robert_long@potomoc");
user = ((JDBCUser)jdr.getUser("robert_long@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Long@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("robert_long@potomoc");
} 
if (!jdr.isUserExist("linda_wallace@potomoc")) { 
jdr.addUser("linda_wallace@potomoc");
user = ((JDBCUser)jdr.getUser("linda_wallace@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Wallace");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Wallace@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("linda_wallace@potomoc");
} 
if (!jdr.isUserExist("carol_johnson@potomoc")) { 
jdr.addUser("carol_johnson@potomoc");
user = ((JDBCUser)jdr.getUser("carol_johnson@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Carol");
user.setAttribute(JDBCRealm.LASTNAME, "Johnson");
user.setAttribute(JDBCRealm.EMAIL, "Carol.Johnson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("carol_johnson@potomoc");
} 
if (!jdr.isUserExist("helen_baker@potomoc")) { 
jdr.addUser("helen_baker@potomoc");
user = ((JDBCUser)jdr.getUser("helen_baker@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Baker@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("helen_baker@potomoc");
} 
if (!jdr.isUserExist("ann_black@potomoc")) { 
jdr.addUser("ann_black@potomoc");
user = ((JDBCUser)jdr.getUser("ann_black@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Black");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Black@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("ann_black@potomoc");
} 
if (!jdr.isUserExist("jessica_gray@potomoc")) { 
jdr.addUser("jessica_gray@potomoc");
user = ((JDBCUser)jdr.getUser("jessica_gray@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Gray");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Gray@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("jessica_gray@potomoc");
} 
if (!jdr.isUserExist("ann_ramirez@potomoc")) { 
jdr.addUser("ann_ramirez@potomoc");
user = ((JDBCUser)jdr.getUser("ann_ramirez@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Ramirez");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Ramirez@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("ann_ramirez@potomoc");
} 
if (!jdr.isUserExist("melissa_powell@potomoc")) { 
jdr.addUser("melissa_powell@potomoc");
user = ((JDBCUser)jdr.getUser("melissa_powell@potomoc"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Powell");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Powell@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_potomoc");
grp.addUserMember("melissa_powell@potomoc");
} 
%> 
</html>