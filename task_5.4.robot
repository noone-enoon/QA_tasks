*** Settings ***
Library  REST  server http://localhost:8000
Library  GetToken.py


*** Variables ***
${X-Auth-Name_1} =  { "X-Auth-Name": "admin" }
${X-Auth-Token_1} =  { "X-Auth-Token": "d82494f05d6917ba02f7aaa29689ccb444bb73f20380876cb05d1f37537b7892"}

${CORRECT_USER} =  { "username": "user", "password": "root", "description": "I am correct user!" }
${CORRECT_LOGIN_EMPTY_PASSWD} =  { "username": "user_with_empty_passwd", "password": "" }
${CORRECT_PASSWD_EMPTY_LOGIN} =  { "username": "", "password": "root" }
${EMPTY_PASSWD_EMPTY_LOGIN} =  { "username": "", "password": "" }
${CHAGNGED_PASSWD} =  { "username": "user", "password": "new_password_for_user" }
${CHAGNGED_DESCRIPTION} =  { "username": "user", "password": "new_password_for_user", "description": "I am user with new description!" }


*** Test Cases ***
TC_1_Getting_help_page
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    GET  /
    Integer  response status  200


TC_2_Create_User_Correct_Login_Empty_Passwd
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    POST  /users  body=${CORRECT_LOGIN_EMPTY_PASSWD}
    Integer  response status  200  201


TC_3_Create_User_Correct_Passwd_Empty_Login
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    POST  /users  body=${CORRECT_PASSWD_EMPTY_LOGIN}
    Integer  response status  200  201


TC_4_Create_User_Empty_Passwd_Empty_Login
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    POST  /users  body=${EMPTY_PASSWD_EMPTY_LOGIN}
    Integer  response status  200  201


TC_5_Create_Valid_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    POST  /users  body=${CORRECT_USER}
    Integer  response status  200  201


TC_6_Get_List_Of_Users
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    GET  /users
    Integer  response status  200


TC_7_Create_Existing_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    POST  /users  body=${CORRECT_USER}
    Integer  response status  200  201


TC_8_Change_User_Password
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    PATCH  /users  body=${CHAGNGED_PASSWD}
    Integer  response status  200  201


TC_9_Change_User_Description
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    PATCH  /users  body=${CHAGNGED_DESCRIPTION}
    Integer  response status  200  201


TC_12_Check_Existing_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    HEAD  /users/user
    Integer  response status  200


TC_13_Check_Non-existing_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    HEAD  /users/non-existing-user
    Integer  response status  400  404


TC_10_Delete_Existing_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    DELETE  /users/user
    Integer  response status  200  202  204


TC_11_Delete_Non-existing_User
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    DELETE  /users/non-existing-user
    Integer  response status  200  202  204


TC_12_Check_Non-existing_User_Who_Was_Deleted
    Set Headers  ${X-Auth-Name_1}
    Set Headers  ${X-Auth-Token_1}
    HEAD  /users/user
    Integer  response status  400  404


TC_13_Auth_With_Illegal_Token
    ${TOKEN}  get token  I  believe
    GET  /  headers={"X-Auth-Name": "a", "X-Auth-Token": "${TOKEN}"}
    Integer  response status  200


TC_14_Auth_With_Token_Of_User_Who_Was_Deleted
    ${TOKEN}  get token  user  new_password_for_user
    GET  /  headers={"X-Auth-Name": "a", "X-Auth-Token": "${TOKEN}"}
    Integer  response status  200


