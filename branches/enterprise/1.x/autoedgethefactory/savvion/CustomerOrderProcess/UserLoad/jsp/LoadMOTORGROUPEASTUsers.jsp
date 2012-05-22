<html>
<%@page import="com.tdiinc.userManager.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<jsp:useBean id="jdr" class="com.tdiinc.userManager.JDBCRealm" scope="session" />
<% 
JDBCGroup grp;
JDBCUser user;
String[] attrNames;
Hashtable attrs;
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_motorgroupeast")) { 
jdr.addGroup("FinanceManagementGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_motorgroupeast");
} 
if (!jdr.isUserExist("admin@motorgroupeast")) { 
jdr.addUser("admin@motorgroupeast");
user = ((JDBCUser)jdr.getUser("admin@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "admin");
user.setAttribute(JDBCRealm.LASTNAME, "motorgroupeast");
user.setAttribute(JDBCRealm.EMAIL, "admin@motorgroupeast.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("admin@motorgroupeast");
} 
if (!jdr.isUserExist("guest@motorgroupeast")) { 
jdr.addUser("guest@motorgroupeast");
user = ((JDBCUser)jdr.getUser("guest@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "guest");
user.setAttribute(JDBCRealm.LASTNAME, "motorgroupeast");
user.setAttribute(JDBCRealm.EMAIL, "admin@motorgroupeast.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("guest@motorgroupeast");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_motorgroupeast")) { 
jdr.addGroup("FactoryGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_motorgroupeast");
} 
if (!jdr.isUserExist("factory@motorgroupeast")) { 
jdr.addUser("factory@motorgroupeast");
user = ((JDBCUser)jdr.getUser("factory@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "factory");
user.setAttribute(JDBCRealm.LASTNAME, "motorgroupeast");
user.setAttribute(JDBCRealm.EMAIL, "admin@motorgroupeast.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("factory@motorgroupeast");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_motorgroupeast")) { 
jdr.addGroup("FinanceManagementGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_motorgroupeast");
} 
if (!jdr.isUserExist("lob_manager@motorgroupeast")) { 
jdr.addUser("lob_manager@motorgroupeast");
user = ((JDBCUser)jdr.getUser("lob_manager@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "lob_manager");
user.setAttribute(JDBCRealm.LASTNAME, "motorgroupeast");
user.setAttribute(JDBCRealm.EMAIL, "admin@motorgroupeast.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("lob_manager@motorgroupeast");
} 
if (!jdr.isGroupExist("FinanceStaffGroup")) { jdr.addGroup("FinanceStaffGroup"); } 
if (!jdr.isGroupExist("FinanceStaffGroup_motorgroupeast")) { 
jdr.addGroup("FinanceStaffGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup");
grp.addGroupMember("FinanceStaffGroup_motorgroupeast");
} 
if (!jdr.isUserExist("john_evans@motorgroupeast")) { 
jdr.addUser("john_evans@motorgroupeast");
user = ((JDBCUser)jdr.getUser("john_evans@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Evans");
user.setAttribute(JDBCRealm.EMAIL, "John.Evans@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("john_evans@motorgroupeast");
} 
if (!jdr.isUserExist("linda_torres@motorgroupeast")) { 
jdr.addUser("linda_torres@motorgroupeast");
user = ((JDBCUser)jdr.getUser("linda_torres@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Torres");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Torres@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("linda_torres@motorgroupeast");
} 
if (!jdr.isUserExist("arthur_gant@motorgroupeast")) { 
jdr.addUser("arthur_gant@motorgroupeast");
user = ((JDBCUser)jdr.getUser("arthur_gant@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Arthur");
user.setAttribute(JDBCRealm.LASTNAME, "Gant");
user.setAttribute(JDBCRealm.EMAIL, "Arthur.Gant@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("arthur_gant@motorgroupeast");
} 
if (!jdr.isUserExist("laura_geller@motorgroupeast")) { 
jdr.addUser("laura_geller@motorgroupeast");
user = ((JDBCUser)jdr.getUser("laura_geller@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Geller");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Geller@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("laura_geller@motorgroupeast");
} 
if (!jdr.isUserExist("steve_webbs@motorgroupeast")) { 
jdr.addUser("steve_webbs@motorgroupeast");
user = ((JDBCUser)jdr.getUser("steve_webbs@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Webbs");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Webbs@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("steve_webbs@motorgroupeast");
} 
if (!jdr.isUserExist("mary_kelly@motorgroupeast")) { 
jdr.addUser("mary_kelly@motorgroupeast");
user = ((JDBCUser)jdr.getUser("mary_kelly@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Kelly");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Kelly@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("mary_kelly@motorgroupeast");
} 
if (!jdr.isUserExist("margaret_simmons@motorgroupeast")) { 
jdr.addUser("margaret_simmons@motorgroupeast");
user = ((JDBCUser)jdr.getUser("margaret_simmons@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Simmons");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Simmons@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("margaret_simmons@motorgroupeast");
} 
if (!jdr.isUserExist("janet_watson@motorgroupeast")) { 
jdr.addUser("janet_watson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("janet_watson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Watson");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Watson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("janet_watson@motorgroupeast");
} 
if (!jdr.isUserExist("evelyn_palmer@motorgroupeast")) { 
jdr.addUser("evelyn_palmer@motorgroupeast");
user = ((JDBCUser)jdr.getUser("evelyn_palmer@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Evelyn");
user.setAttribute(JDBCRealm.LASTNAME, "Palmer");
user.setAttribute(JDBCRealm.EMAIL, "Evelyn.Palmer@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("evelyn_palmer@motorgroupeast");
} 
if (!jdr.isUserExist("mary_richardson@motorgroupeast")) { 
jdr.addUser("mary_richardson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("mary_richardson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Mary");
user.setAttribute(JDBCRealm.LASTNAME, "Richardson");
user.setAttribute(JDBCRealm.EMAIL, "Mary.Richardson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("mary_richardson@motorgroupeast");
} 
if (!jdr.isUserExist("rebecca_hayes@motorgroupeast")) { 
jdr.addUser("rebecca_hayes@motorgroupeast");
user = ((JDBCUser)jdr.getUser("rebecca_hayes@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Hayes@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceStaffGroup_motorgroupeast");
grp.addUserMember("rebecca_hayes@motorgroupeast");
} 
if (!jdr.isGroupExist("FinanceManagementGroup")) { jdr.addGroup("FinanceManagementGroup"); } 
if (!jdr.isGroupExist("FinanceManagementGroup_motorgroupeast")) { 
jdr.addGroup("FinanceManagementGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup");
grp.addGroupMember("FinanceManagementGroup_motorgroupeast");
} 
if (!jdr.isUserExist("robert_sullivan@motorgroupeast")) { 
jdr.addUser("robert_sullivan@motorgroupeast");
user = ((JDBCUser)jdr.getUser("robert_sullivan@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Sullivan@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("robert_sullivan@motorgroupeast");
} 
if (!jdr.isUserExist("barbara_butler@motorgroupeast")) { 
jdr.addUser("barbara_butler@motorgroupeast");
user = ((JDBCUser)jdr.getUser("barbara_butler@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Butler");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Butler@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("barbara_butler@motorgroupeast");
} 
if (!jdr.isUserExist("david_hamilton@motorgroupeast")) { 
jdr.addUser("david_hamilton@motorgroupeast");
user = ((JDBCUser)jdr.getUser("david_hamilton@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "David");
user.setAttribute(JDBCRealm.LASTNAME, "Hamilton");
user.setAttribute(JDBCRealm.EMAIL, "David.Hamilton@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("david_hamilton@motorgroupeast");
} 
if (!jdr.isUserExist("rebecca_jordan@motorgroupeast")) { 
jdr.addUser("rebecca_jordan@motorgroupeast");
user = ((JDBCUser)jdr.getUser("rebecca_jordan@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Jordan");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Jordan@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("rebecca_jordan@motorgroupeast");
} 
if (!jdr.isUserExist("richard_howard@motorgroupeast")) { 
jdr.addUser("richard_howard@motorgroupeast");
user = ((JDBCUser)jdr.getUser("richard_howard@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Richard");
user.setAttribute(JDBCRealm.LASTNAME, "Howard");
user.setAttribute(JDBCRealm.EMAIL, "Richard.Howard@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("richard_howard@motorgroupeast");
} 
if (!jdr.isUserExist("amy_ross@motorgroupeast")) { 
jdr.addUser("amy_ross@motorgroupeast");
user = ((JDBCUser)jdr.getUser("amy_ross@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Amy");
user.setAttribute(JDBCRealm.LASTNAME, "Ross");
user.setAttribute(JDBCRealm.EMAIL, "Amy.Ross@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("amy_ross@motorgroupeast");
} 
if (!jdr.isUserExist("heather_nelson@motorgroupeast")) { 
jdr.addUser("heather_nelson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("heather_nelson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Heather");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Heather.Nelson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("heather_nelson@motorgroupeast");
} 
if (!jdr.isUserExist("martha_bennet@motorgroupeast")) { 
jdr.addUser("martha_bennet@motorgroupeast");
user = ((JDBCUser)jdr.getUser("martha_bennet@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Bennet@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("martha_bennet@motorgroupeast");
} 
if (!jdr.isUserExist("lisa_sanders@motorgroupeast")) { 
jdr.addUser("lisa_sanders@motorgroupeast");
user = ((JDBCUser)jdr.getUser("lisa_sanders@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Lisa");
user.setAttribute(JDBCRealm.LASTNAME, "Sanders");
user.setAttribute(JDBCRealm.EMAIL, "Lisa.Sanders@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("lisa_sanders@motorgroupeast");
} 
if (!jdr.isUserExist("jessica_alexander@motorgroupeast")) { 
jdr.addUser("jessica_alexander@motorgroupeast");
user = ((JDBCUser)jdr.getUser("jessica_alexander@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Jessica");
user.setAttribute(JDBCRealm.LASTNAME, "Alexander");
user.setAttribute(JDBCRealm.EMAIL, "Jessica.Alexander@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("jessica_alexander@motorgroupeast");
} 
if (!jdr.isUserExist("donna_peterson@motorgroupeast")) { 
jdr.addUser("donna_peterson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("donna_peterson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Peterson");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Peterson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FinanceManagementGroup_motorgroupeast");
grp.addUserMember("donna_peterson@motorgroupeast");
} 
if (!jdr.isGroupExist("FactoryGroup")) { jdr.addGroup("FactoryGroup"); } 
if (!jdr.isGroupExist("FactoryGroup_motorgroupeast")) { 
jdr.addGroup("FactoryGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FactoryGroup");
grp.addGroupMember("FactoryGroup_motorgroupeast");
} 
if (!jdr.isUserExist("david_martinez@motorgroupeast")) { 
jdr.addUser("david_martinez@motorgroupeast");
user = ((JDBCUser)jdr.getUser("david_martinez@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "David");
user.setAttribute(JDBCRealm.LASTNAME, "Martinez");
user.setAttribute(JDBCRealm.EMAIL, "David.Martinez@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("david_martinez@motorgroupeast");
} 
if (!jdr.isUserExist("helen_alexander@motorgroupeast")) { 
jdr.addUser("helen_alexander@motorgroupeast");
user = ((JDBCUser)jdr.getUser("helen_alexander@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Alexander");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Alexander@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("helen_alexander@motorgroupeast");
} 
if (!jdr.isUserExist("steve_murphy@motorgroupeast")) { 
jdr.addUser("steve_murphy@motorgroupeast");
user = ((JDBCUser)jdr.getUser("steve_murphy@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Steve");
user.setAttribute(JDBCRealm.LASTNAME, "Murphy");
user.setAttribute(JDBCRealm.EMAIL, "Steve.Murphy@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("steve_murphy@motorgroupeast");
} 
if (!jdr.isUserExist("janet_james@motorgroupeast")) { 
jdr.addUser("janet_james@motorgroupeast");
user = ((JDBCUser)jdr.getUser("janet_james@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "James");
user.setAttribute(JDBCRealm.EMAIL, "Janet.James@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("janet_james@motorgroupeast");
} 
if (!jdr.isUserExist("john_woods@motorgroupeast")) { 
jdr.addUser("john_woods@motorgroupeast");
user = ((JDBCUser)jdr.getUser("john_woods@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Woods");
user.setAttribute(JDBCRealm.EMAIL, "John.Woods@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("john_woods@motorgroupeast");
} 
if (!jdr.isUserExist("joyce_nelson@motorgroupeast")) { 
jdr.addUser("joyce_nelson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("joyce_nelson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Nelson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("joyce_nelson@motorgroupeast");
} 
if (!jdr.isUserExist("laura_martin@motorgroupeast")) { 
jdr.addUser("laura_martin@motorgroupeast");
user = ((JDBCUser)jdr.getUser("laura_martin@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Martin");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Martin@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("laura_martin@motorgroupeast");
} 
if (!jdr.isUserExist("susan_hughes@motorgroupeast")) { 
jdr.addUser("susan_hughes@motorgroupeast");
user = ((JDBCUser)jdr.getUser("susan_hughes@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Hughes");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Hughes@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("susan_hughes@motorgroupeast");
} 
if (!jdr.isUserExist("laura_bennet@motorgroupeast")) { 
jdr.addUser("laura_bennet@motorgroupeast");
user = ((JDBCUser)jdr.getUser("laura_bennet@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Laura");
user.setAttribute(JDBCRealm.LASTNAME, "Bennet");
user.setAttribute(JDBCRealm.EMAIL, "Laura.Bennet@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("laura_bennet@motorgroupeast");
} 
if (!jdr.isUserExist("margaret_alexander@motorgroupeast")) { 
jdr.addUser("margaret_alexander@motorgroupeast");
user = ((JDBCUser)jdr.getUser("margaret_alexander@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Alexander");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Alexander@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("margaret_alexander@motorgroupeast");
} 
if (!jdr.isUserExist("helen_johnson@motorgroupeast")) { 
jdr.addUser("helen_johnson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("helen_johnson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Helen");
user.setAttribute(JDBCRealm.LASTNAME, "Johnson");
user.setAttribute(JDBCRealm.EMAIL, "Helen.Johnson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FactoryGroup_motorgroupeast");
grp.addUserMember("helen_johnson@motorgroupeast");
} 
if (!jdr.isGroupExist("SalesrepGroup")) { jdr.addGroup("SalesrepGroup"); } 
if (!jdr.isGroupExist("SalesrepGroup_motorgroupeast")) { 
jdr.addGroup("SalesrepGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("SalesrepGroup");
grp.addGroupMember("SalesrepGroup_motorgroupeast");
} 
if (!jdr.isUserExist("paul_coleman@motorgroupeast")) { 
jdr.addUser("paul_coleman@motorgroupeast");
user = ((JDBCUser)jdr.getUser("paul_coleman@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Paul");
user.setAttribute(JDBCRealm.LASTNAME, "Coleman");
user.setAttribute(JDBCRealm.EMAIL, "Paul.Coleman@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("paul_coleman@motorgroupeast");
} 
if (!jdr.isUserExist("peter_hicks@motorgroupeast")) { 
jdr.addUser("peter_hicks@motorgroupeast");
user = ((JDBCUser)jdr.getUser("peter_hicks@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Peter");
user.setAttribute(JDBCRealm.LASTNAME, "Hicks");
user.setAttribute(JDBCRealm.EMAIL, "Peter.Hicks@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("peter_hicks@motorgroupeast");
} 
if (!jdr.isUserExist("donna_stewart@motorgroupeast")) { 
jdr.addUser("donna_stewart@motorgroupeast");
user = ((JDBCUser)jdr.getUser("donna_stewart@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Donna");
user.setAttribute(JDBCRealm.LASTNAME, "Stewart");
user.setAttribute(JDBCRealm.EMAIL, "Donna.Stewart@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("donna_stewart@motorgroupeast");
} 
if (!jdr.isUserExist("patrick_baker@motorgroupeast")) { 
jdr.addUser("patrick_baker@motorgroupeast");
user = ((JDBCUser)jdr.getUser("patrick_baker@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Patrick");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Patrick.Baker@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("patrick_baker@motorgroupeast");
} 
if (!jdr.isUserExist("melissa_anderson@motorgroupeast")) { 
jdr.addUser("melissa_anderson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("melissa_anderson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Anderson");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Anderson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("melissa_anderson@motorgroupeast");
} 
if (!jdr.isUserExist("susan_flores@motorgroupeast")) { 
jdr.addUser("susan_flores@motorgroupeast");
user = ((JDBCUser)jdr.getUser("susan_flores@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Flores");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Flores@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("susan_flores@motorgroupeast");
} 
if (!jdr.isUserExist("barbara_stewart@motorgroupeast")) { 
jdr.addUser("barbara_stewart@motorgroupeast");
user = ((JDBCUser)jdr.getUser("barbara_stewart@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Stewart");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Stewart@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("barbara_stewart@motorgroupeast");
} 
if (!jdr.isUserExist("alice_moore@motorgroupeast")) { 
jdr.addUser("alice_moore@motorgroupeast");
user = ((JDBCUser)jdr.getUser("alice_moore@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Moore");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Moore@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("alice_moore@motorgroupeast");
} 
if (!jdr.isUserExist("joyce_lewis@motorgroupeast")) { 
jdr.addUser("joyce_lewis@motorgroupeast");
user = ((JDBCUser)jdr.getUser("joyce_lewis@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Joyce");
user.setAttribute(JDBCRealm.LASTNAME, "Lewis");
user.setAttribute(JDBCRealm.EMAIL, "Joyce.Lewis@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("joyce_lewis@motorgroupeast");
} 
if (!jdr.isUserExist("melissa_johnson@motorgroupeast")) { 
jdr.addUser("melissa_johnson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("melissa_johnson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Melissa");
user.setAttribute(JDBCRealm.LASTNAME, "Johnson");
user.setAttribute(JDBCRealm.EMAIL, "Melissa.Johnson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("melissa_johnson@motorgroupeast");
} 
if (!jdr.isUserExist("margaret_ramirez@motorgroupeast")) { 
jdr.addUser("margaret_ramirez@motorgroupeast");
user = ((JDBCUser)jdr.getUser("margaret_ramirez@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Margaret");
user.setAttribute(JDBCRealm.LASTNAME, "Ramirez");
user.setAttribute(JDBCRealm.EMAIL, "Margaret.Ramirez@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("SalesrepGroup_motorgroupeast");
grp.addUserMember("margaret_ramirez@motorgroupeast");
} 
if (!jdr.isGroupExist("FullfillmentStaffGroup")) { jdr.addGroup("FullfillmentStaffGroup"); } 
if (!jdr.isGroupExist("FullfillmentStaffGroup_motorgroupeast")) { 
jdr.addGroup("FullfillmentStaffGroup_motorgroupeast"); grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup");
grp.addGroupMember("FullfillmentStaffGroup_motorgroupeast");
} 
if (!jdr.isUserExist("nancy_carter@motorgroupeast")) { 
jdr.addUser("nancy_carter@motorgroupeast");
user = ((JDBCUser)jdr.getUser("nancy_carter@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Nancy");
user.setAttribute(JDBCRealm.LASTNAME, "Carter");
user.setAttribute(JDBCRealm.EMAIL, "Nancy.Carter@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("nancy_carter@motorgroupeast");
} 
if (!jdr.isUserExist("david_hayes@motorgroupeast")) { 
jdr.addUser("david_hayes@motorgroupeast");
user = ((JDBCUser)jdr.getUser("david_hayes@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "David");
user.setAttribute(JDBCRealm.LASTNAME, "Hayes");
user.setAttribute(JDBCRealm.EMAIL, "David.Hayes@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("david_hayes@motorgroupeast");
} 
if (!jdr.isUserExist("alice_bing@motorgroupeast")) { 
jdr.addUser("alice_bing@motorgroupeast");
user = ((JDBCUser)jdr.getUser("alice_bing@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Alice");
user.setAttribute(JDBCRealm.LASTNAME, "Bing");
user.setAttribute(JDBCRealm.EMAIL, "Alice.Bing@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("alice_bing@motorgroupeast");
} 
if (!jdr.isUserExist("john_hunt@motorgroupeast")) { 
jdr.addUser("john_hunt@motorgroupeast");
user = ((JDBCUser)jdr.getUser("john_hunt@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "John");
user.setAttribute(JDBCRealm.LASTNAME, "Hunt");
user.setAttribute(JDBCRealm.EMAIL, "John.Hunt@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("john_hunt@motorgroupeast");
} 
if (!jdr.isUserExist("robert_nelson@motorgroupeast")) { 
jdr.addUser("robert_nelson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("robert_nelson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Robert");
user.setAttribute(JDBCRealm.LASTNAME, "Nelson");
user.setAttribute(JDBCRealm.EMAIL, "Robert.Nelson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("robert_nelson@motorgroupeast");
} 
if (!jdr.isUserExist("janet_harris@motorgroupeast")) { 
jdr.addUser("janet_harris@motorgroupeast");
user = ((JDBCUser)jdr.getUser("janet_harris@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Janet");
user.setAttribute(JDBCRealm.LASTNAME, "Harris");
user.setAttribute(JDBCRealm.EMAIL, "Janet.Harris@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("janet_harris@motorgroupeast");
} 
if (!jdr.isUserExist("rebecca_jackson@motorgroupeast")) { 
jdr.addUser("rebecca_jackson@motorgroupeast");
user = ((JDBCUser)jdr.getUser("rebecca_jackson@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Rebecca");
user.setAttribute(JDBCRealm.LASTNAME, "Jackson");
user.setAttribute(JDBCRealm.EMAIL, "Rebecca.Jackson@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("rebecca_jackson@motorgroupeast");
} 
if (!jdr.isUserExist("barbara_jenkins@motorgroupeast")) { 
jdr.addUser("barbara_jenkins@motorgroupeast");
user = ((JDBCUser)jdr.getUser("barbara_jenkins@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Barbara");
user.setAttribute(JDBCRealm.LASTNAME, "Jenkins");
user.setAttribute(JDBCRealm.EMAIL, "Barbara.Jenkins@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("barbara_jenkins@motorgroupeast");
} 
if (!jdr.isUserExist("martha_foster@motorgroupeast")) { 
jdr.addUser("martha_foster@motorgroupeast");
user = ((JDBCUser)jdr.getUser("martha_foster@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Martha");
user.setAttribute(JDBCRealm.LASTNAME, "Foster");
user.setAttribute(JDBCRealm.EMAIL, "Martha.Foster@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("martha_foster@motorgroupeast");
} 
if (!jdr.isUserExist("susan_sullivan@motorgroupeast")) { 
jdr.addUser("susan_sullivan@motorgroupeast");
user = ((JDBCUser)jdr.getUser("susan_sullivan@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Susan");
user.setAttribute(JDBCRealm.LASTNAME, "Sullivan");
user.setAttribute(JDBCRealm.EMAIL, "Susan.Sullivan@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("susan_sullivan@motorgroupeast");
} 
if (!jdr.isUserExist("linda_baker@motorgroupeast")) { 
jdr.addUser("linda_baker@motorgroupeast");
user = ((JDBCUser)jdr.getUser("linda_baker@motorgroupeast"));
user.setAttribute(JDBCRealm.PASSWORD, "letmein");
user.setAttribute(JDBCRealm.FIRSTNAME, "Linda");
user.setAttribute(JDBCRealm.LASTNAME, "Baker");
user.setAttribute(JDBCRealm.EMAIL, "Linda.Baker@motorgroupeast.com.aetf");
grp = (JDBCGroup)jdr.getGroup("FullfillmentStaffGroup_motorgroupeast");
grp.addUserMember("linda_baker@motorgroupeast");
} 
%> 
</html>