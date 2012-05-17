<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_chery")) { 
jdr.addGroup("FinanceManagementGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_chery");
} 
if (!jdr.isUserExist("admin@chery")) { 
jdr.addUser("admin@chery");
user = ((JDBCUser)jdr.getUser("admin@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "chery");
user.setAttribute(JDBCRealm.EMAIL, "admin@chery.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("admin@chery");
} 
if (!jdr.isUserExist("guest@chery")) { 
jdr.addUser("guest@chery");
user = ((JDBCUser)jdr.getUser("guest@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "chery");
user.setAttribute(JDBCRealm.EMAIL, "admin@chery.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("guest@chery");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_chery")) { 
jdr.addGroup("FactoryGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_chery");
} 
if (!jdr.isUserExist("factory@chery")) { 
jdr.addUser("factory@chery");
user = ((JDBCUser)jdr.getUser("factory@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "chery");
user.setAttribute(JDBCRealm.EMAIL, "admin@chery.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("factory@chery");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_chery")) { 
jdr.addGroup("FinanceManagementGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_chery");
} 
if (!jdr.isUserExist("lob_manager@chery")) { 
jdr.addUser("lob_manager@chery");
user = ((JDBCUser)jdr.getUser("lob_manager@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "chery");
user.setAttribute(JDBCRealm.EMAIL, "admin@chery.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("lob_manager@chery");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_chery")) { 
jdr.addGroup("FinanceManagementGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_chery");
} 
if (!jdr.isUserExist("patrick_rose@chery")) { 
jdr.addUser("patrick_rose@chery");
user = ((JDBCUser)jdr.getUser("patrick_rose@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Patrick");
user.setAttribute(JDBCRealm.LASTNAME, "Rose");
user.setAttribute(JDBCRealm.EMAIL, "Patrick.Rose@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("patrick_rose@chery");
} 
if (!jdr.isUserExist("brenda_tucker@chery")) { 
jdr.addUser("brenda_tucker@chery");
user = ((JDBCUser)jdr.getUser("brenda_tucker@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Brenda");
user.setAttribute(JDBCRealm.LASTNAME, "Tucker");
user.setAttribute(JDBCRealm.EMAIL, "Brenda.Tucker@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("brenda_tucker@chery");
} 
if (!jdr.isUserExist("robert_watson@chery")) { 
jdr.addUser("robert_watson@chery");
user = ((JDBCUser)jdr.getUser("robert_watson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Watson");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Watson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("robert_watson@chery");
} 
if (!jdr.isUserExist("laura_baker@chery")) { 
jdr.addUser("laura_baker@chery");
user = ((JDBCUser)jdr.getUser("laura_baker@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Baker@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("laura_baker@chery");
} 
if (!jdr.isUserExist("larry_barnes@chery")) { 
jdr.addUser("larry_barnes@chery");
user = ((JDBCUser)jdr.getUser("larry_barnes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Larry");
user.setAttribute(JDBCRealm.LASTNAME, "Barnes");
user.setAttribute(JDBCRealm.EMAIL, "Larry.Barnes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("larry_barnes@chery");
} 
if (!jdr.isUserExist("kelly_price@chery")) { 
jdr.addUser("kelly_price@chery");
user = ((JDBCUser)jdr.getUser("kelly_price@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Price");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Price@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("kelly_price@chery");
} 
if (!jdr.isUserExist("amy_burns@chery")) { 
jdr.addUser("amy_burns@chery");
user = ((JDBCUser)jdr.getUser("amy_burns@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Burns");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Burns@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("amy_burns@chery");
} 
if (!jdr.isUserExist("melissa_roberts@chery")) { 
jdr.addUser("melissa_roberts@chery");
user = ((JDBCUser)jdr.getUser("melissa_roberts@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Roberts");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Roberts@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("melissa_roberts@chery");
} 
if (!jdr.isUserExist("betty_martinez@chery")) { 
jdr.addUser("betty_martinez@chery");
user = ((JDBCUser)jdr.getUser("betty_martinez@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Betty");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "Betty.Martinez@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("betty_martinez@chery");
} 
if (!jdr.isUserExist("nancy_miller@chery")) { 
jdr.addUser("nancy_miller@chery");
user = ((JDBCUser)jdr.getUser("nancy_miller@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Miller");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Miller@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("nancy_miller@chery");
} 
if (!jdr.isUserExist("lisa_walker@chery")) { 
jdr.addUser("lisa_walker@chery");
user = ((JDBCUser)jdr.getUser("lisa_walker@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Walker");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Walker@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_chery");
grp.addUserMember("lisa_walker@chery");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_chery")) { 
jdr.addGroup("SalesrepGroup_chery"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_chery");
} 
if (!jdr.isUserExist("donald_wells@chery")) { 
jdr.addUser("donald_wells@chery");
user = ((JDBCUser)jdr.getUser("donald_wells@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donald");
user.setAttribute(JDBCRealm.LASTNAME, "Wells");
user.setAttribute(JDBCRealm.EMAIL, "Donald.Wells@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("donald_wells@chery");
} 
if (!jdr.isUserExist("heather_sanders@chery")) { 
jdr.addUser("heather_sanders@chery");
user = ((JDBCUser)jdr.getUser("heather_sanders@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Sanders");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Sanders@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("heather_sanders@chery");
} 
if (!jdr.isUserExist("anthony_brooks@chery")) { 
jdr.addUser("anthony_brooks@chery");
user = ((JDBCUser)jdr.getUser("anthony_brooks@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Anthony");
user.setAttribute(JDBCRealm.LASTNAME, "Brooks");
user.setAttribute(JDBCRealm.EMAIL, "Anthony.Brooks@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("anthony_brooks@chery");
} 
if (!jdr.isUserExist("ann_torres@chery")) { 
jdr.addUser("ann_torres@chery");
user = ((JDBCUser)jdr.getUser("ann_torres@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Torres");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Torres@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("ann_torres@chery");
} 
if (!jdr.isUserExist("mike_simmons@chery")) { 
jdr.addUser("mike_simmons@chery");
user = ((JDBCUser)jdr.getUser("mike_simmons@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mike");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Mike.Simmons@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("mike_simmons@chery");
} 
if (!jdr.isUserExist("kelly_crawford@chery")) { 
jdr.addUser("kelly_crawford@chery");
user = ((JDBCUser)jdr.getUser("kelly_crawford@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Crawford");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Crawford@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("kelly_crawford@chery");
} 
if (!jdr.isUserExist("martha_patterson@chery")) { 
jdr.addUser("martha_patterson@chery");
user = ((JDBCUser)jdr.getUser("martha_patterson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Patterson");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Patterson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("martha_patterson@chery");
} 
if (!jdr.isUserExist("susan_sanders@chery")) { 
jdr.addUser("susan_sanders@chery");
user = ((JDBCUser)jdr.getUser("susan_sanders@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Sanders");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Sanders@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("susan_sanders@chery");
} 
if (!jdr.isUserExist("linda_hayes@chery")) { 
jdr.addUser("linda_hayes@chery");
user = ((JDBCUser)jdr.getUser("linda_hayes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Hayes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("linda_hayes@chery");
} 
if (!jdr.isUserExist("sarah_kelly@chery")) { 
jdr.addUser("sarah_kelly@chery");
user = ((JDBCUser)jdr.getUser("sarah_kelly@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Kelly@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("sarah_kelly@chery");
} 
if (!jdr.isUserExist("margaret_hunt@chery")) { 
jdr.addUser("margaret_hunt@chery");
user = ((JDBCUser)jdr.getUser("margaret_hunt@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Hunt");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Hunt@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_chery");
grp.addUserMember("margaret_hunt@chery");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_chery")) { 
jdr.addGroup("FullfillmentStaffGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_chery");
} 
if (!jdr.isUserExist("greg_smith@chery")) { 
jdr.addUser("greg_smith@chery");
user = ((JDBCUser)jdr.getUser("greg_smith@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Smith");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Smith@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("greg_smith@chery");
} 
if (!jdr.isUserExist("heather_palmer@chery")) { 
jdr.addUser("heather_palmer@chery");
user = ((JDBCUser)jdr.getUser("heather_palmer@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Palmer@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("heather_palmer@chery");
} 
if (!jdr.isUserExist("steve_simpson@chery")) { 
jdr.addUser("steve_simpson@chery");
user = ((JDBCUser)jdr.getUser("steve_simpson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Simpson");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Simpson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("steve_simpson@chery");
} 
if (!jdr.isUserExist("susan_geller@chery")) { 
jdr.addUser("susan_geller@chery");
user = ((JDBCUser)jdr.getUser("susan_geller@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Geller");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Geller@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("susan_geller@chery");
} 
if (!jdr.isUserExist("robert_shaw@chery")) { 
jdr.addUser("robert_shaw@chery");
user = ((JDBCUser)jdr.getUser("robert_shaw@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Shaw@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("robert_shaw@chery");
} 
if (!jdr.isUserExist("mary_hunt@chery")) { 
jdr.addUser("mary_hunt@chery");
user = ((JDBCUser)jdr.getUser("mary_hunt@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Hunt");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Hunt@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("mary_hunt@chery");
} 
if (!jdr.isUserExist("jessica_kennedy@chery")) { 
jdr.addUser("jessica_kennedy@chery");
user = ((JDBCUser)jdr.getUser("jessica_kennedy@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Kennedy");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Kennedy@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("jessica_kennedy@chery");
} 
if (!jdr.isUserExist("jessica_robertson@chery")) { 
jdr.addUser("jessica_robertson@chery");
user = ((JDBCUser)jdr.getUser("jessica_robertson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Robertson");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Robertson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("jessica_robertson@chery");
} 
if (!jdr.isUserExist("rebecca_bennet@chery")) { 
jdr.addUser("rebecca_bennet@chery");
user = ((JDBCUser)jdr.getUser("rebecca_bennet@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Bennet@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("rebecca_bennet@chery");
} 
if (!jdr.isUserExist("sarah_graham@chery")) { 
jdr.addUser("sarah_graham@chery");
user = ((JDBCUser)jdr.getUser("sarah_graham@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Sarah");
user.setAttribute(JDBCRealm.LASTNAME, "Graham");
user.setAttribute(JDBCRealm.EMAIL, "Sarah.Graham@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("sarah_graham@chery");
} 
if (!jdr.isUserExist("joyce_long@chery")) { 
jdr.addUser("joyce_long@chery");
user = ((JDBCUser)jdr.getUser("joyce_long@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Long");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Long@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_chery");
grp.addUserMember("joyce_long@chery");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_chery")) { 
jdr.addGroup("FactoryGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_chery");
} 
if (!jdr.isUserExist("paul_bennet@chery")) { 
jdr.addUser("paul_bennet@chery");
user = ((JDBCUser)jdr.getUser("paul_bennet@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Bennet@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("paul_bennet@chery");
} 
if (!jdr.isUserExist("jessica_patterson@chery")) { 
jdr.addUser("jessica_patterson@chery");
user = ((JDBCUser)jdr.getUser("jessica_patterson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Patterson");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Patterson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("jessica_patterson@chery");
} 
if (!jdr.isUserExist("greg_johnson@chery")) { 
jdr.addUser("greg_johnson@chery");
user = ((JDBCUser)jdr.getUser("greg_johnson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Greg");
user.setAttribute(JDBCRealm.LASTNAME, "Johnson");
user.setAttribute(JDBCRealm.EMAIL, "Greg.Johnson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("greg_johnson@chery");
} 
if (!jdr.isUserExist("steve_simpson@chery")) { 
jdr.addUser("steve_simpson@chery");
user = ((JDBCUser)jdr.getUser("steve_simpson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Simpson");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Simpson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("steve_simpson@chery");
} 
if (!jdr.isUserExist("amy_wells@chery")) { 
jdr.addUser("amy_wells@chery");
user = ((JDBCUser)jdr.getUser("amy_wells@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Wells");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Wells@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("amy_wells@chery");
} 
if (!jdr.isUserExist("mary_hughes@chery")) { 
jdr.addUser("mary_hughes@chery");
user = ((JDBCUser)jdr.getUser("mary_hughes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Hughes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("mary_hughes@chery");
} 
if (!jdr.isUserExist("rebecca_smith@chery")) { 
jdr.addUser("rebecca_smith@chery");
user = ((JDBCUser)jdr.getUser("rebecca_smith@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Smith");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Smith@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("rebecca_smith@chery");
} 
if (!jdr.isUserExist("donna_hayes@chery")) { 
jdr.addUser("donna_hayes@chery");
user = ((JDBCUser)jdr.getUser("donna_hayes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Hayes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("donna_hayes@chery");
} 
if (!jdr.isUserExist("helen_shaw@chery")) { 
jdr.addUser("helen_shaw@chery");
user = ((JDBCUser)jdr.getUser("helen_shaw@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Shaw");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Shaw@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("helen_shaw@chery");
} 
if (!jdr.isUserExist("rebecca_butler@chery")) { 
jdr.addUser("rebecca_butler@chery");
user = ((JDBCUser)jdr.getUser("rebecca_butler@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Butler");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Butler@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("rebecca_butler@chery");
} 
if (!jdr.isUserExist("ann_tuner@chery")) { 
jdr.addUser("ann_tuner@chery");
user = ((JDBCUser)jdr.getUser("ann_tuner@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Ann");
user.setAttribute(JDBCRealm.LASTNAME, "Tuner");
user.setAttribute(JDBCRealm.EMAIL, "Ann.Tuner@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_chery");
grp.addUserMember("ann_tuner@chery");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_chery")) { 
jdr.addGroup("FinanceStaffGroup_chery"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_chery");
} 
if (!jdr.isUserExist("barbara_barnes@chery")) { 
jdr.addUser("barbara_barnes@chery");
user = ((JDBCUser)jdr.getUser("barbara_barnes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Barnes");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Barnes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("barbara_barnes@chery");
} 
if (!jdr.isUserExist("arthur_nelson@chery")) { 
jdr.addUser("arthur_nelson@chery");
user = ((JDBCUser)jdr.getUser("arthur_nelson@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Arthur");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Arthur.Nelson@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("arthur_nelson@chery");
} 
if (!jdr.isUserExist("julie_freeman@chery")) { 
jdr.addUser("julie_freeman@chery");
user = ((JDBCUser)jdr.getUser("julie_freeman@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Julie");
user.setAttribute(JDBCRealm.LASTNAME, "Freeman");
user.setAttribute(JDBCRealm.EMAIL, "Julie.Freeman@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("julie_freeman@chery");
} 
if (!jdr.isUserExist("justin_collins@chery")) { 
jdr.addUser("justin_collins@chery");
user = ((JDBCUser)jdr.getUser("justin_collins@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Justin");
user.setAttribute(JDBCRealm.LASTNAME, "Collins");
user.setAttribute(JDBCRealm.EMAIL, "Justin.Collins@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("justin_collins@chery");
} 
if (!jdr.isUserExist("donald_brooks@chery")) { 
jdr.addUser("donald_brooks@chery");
user = ((JDBCUser)jdr.getUser("donald_brooks@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donald");
user.setAttribute(JDBCRealm.LASTNAME, "Brooks");
user.setAttribute(JDBCRealm.EMAIL, "Donald.Brooks@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("donald_brooks@chery");
} 
if (!jdr.isUserExist("amy_simmons@chery")) { 
jdr.addUser("amy_simmons@chery");
user = ((JDBCUser)jdr.getUser("amy_simmons@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Simmons@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("amy_simmons@chery");
} 
if (!jdr.isUserExist("susan_perry@chery")) { 
jdr.addUser("susan_perry@chery");
user = ((JDBCUser)jdr.getUser("susan_perry@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Perry");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Perry@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("susan_perry@chery");
} 
if (!jdr.isUserExist("diane_gray@chery")) { 
jdr.addUser("diane_gray@chery");
user = ((JDBCUser)jdr.getUser("diane_gray@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Diane");
user.setAttribute(JDBCRealm.LASTNAME, "Gray");
user.setAttribute(JDBCRealm.EMAIL, "Diane.Gray@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("diane_gray@chery");
} 
if (!jdr.isUserExist("nancy_tucker@chery")) { 
jdr.addUser("nancy_tucker@chery");
user = ((JDBCUser)jdr.getUser("nancy_tucker@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Tucker");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Tucker@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("nancy_tucker@chery");
} 
if (!jdr.isUserExist("mary_holmes@chery")) { 
jdr.addUser("mary_holmes@chery");
user = ((JDBCUser)jdr.getUser("mary_holmes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Holmes");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Holmes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("mary_holmes@chery");
} 
if (!jdr.isUserExist("kelly_hughes@chery")) { 
jdr.addUser("kelly_hughes@chery");
user = ((JDBCUser)jdr.getUser("kelly_hughes@chery"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Kelly");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Kelly.Hughes@rothcars.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_chery");
grp.addUserMember("kelly_hughes@chery");
} 
%> 
</html>