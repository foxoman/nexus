# Nexus generated file
import db_postgres, options, sequtils, strutils, times
import nexus/core/data_access/data_utils
import nexus/core/data_access/pg_try_insert_id
import nexus/core/types/model_types


# Forward declarations
proc rowToAccountUser*(row: seq[string]):
       AccountUser {.gcsafe.}


# Code
proc countAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string] = @[],
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from account_user"
  var first = true

  for whereField in whereFields:

    var whereClause: string

    if first == false:
      whereClause = "   and " & whereField & " = ?"
    else:
      first = false
      whereClause = " where " & whereField & " = ?"

    selectStatement &= whereClause

  let row = getRow(nexusCoreDbContext.dbConn,
                   sql(selectStatement),
                   whereValues)

  return parseBiggestInt(row[0])


proc countAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from account_user"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  let row = getRow(nexusCoreDbContext.dbConn,
                   sql(selectStatement),
                   whereValues)

  return parseBiggestInt(row[0])


proc createAccountUserReturnsPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountId: Option[int64] = none(int64),
       name: string,
       email: string,
       passwordHash: string,
       passwordSalt: string,
       apiKey: string,
       lastToken: Option[string] = none(string),
       signUpCode: string,
       signUpDate: DateTime,
       passwordResetCode: Option[string] = none(string),
       passwordResetDate: Option[DateTime] = none(DateTime),
       isActive: bool,
       isAdmin: bool,
       isVerified: bool,
       subscriptionStatus: Option[char] = none(char),
       lastLogin: Option[DateTime] = none(DateTime),
       lastUpdate: Option[DateTime] = none(DateTime),
       created: DateTime,
       ignoreExistingPk: bool = false): int64 {.gcsafe.} =

  # Formulate insertStatement and insertValues
  var
    insertValues: seq[string]
    insertStatement = "insert into account_user ("
    valuesClause = ""

  # Field: Account Id
  if accountId != none(int64):
    insertStatement &= "account_id, "
    valuesClause &= "?, "
    insertValues.add($accountId.get)

  # Field: Name
  insertStatement &= "name, "
  valuesClause &= "?" & ", "
  insertValues.add(name)

  # Field: Email
  insertStatement &= "email, "
  valuesClause &= "?" & ", "
  insertValues.add(email)

  # Field: Password Hash
  insertStatement &= "password_hash, "
  valuesClause &= "?" & ", "
  insertValues.add(passwordHash)

  # Field: Password Salt
  insertStatement &= "password_salt, "
  valuesClause &= "?" & ", "
  insertValues.add(passwordSalt)

  # Field: API Key
  insertStatement &= "api_key, "
  valuesClause &= "?" & ", "
  insertValues.add(apiKey)

  # Field: Last Token
  if lastToken != none(string):
    insertStatement &= "last_token, "
    valuesClause &= "?" & ", "
    insertValues.add(lastToken.get)

  # Field: Sign up Code
  insertStatement &= "sign_up_code, "
  valuesClause &= "?" & ", "
  insertValues.add(signUpCode)

  # Field: Sign up Date
  insertStatement &= "sign_up_date, "
  valuesClause &= pgToDateTimeString(signUpDate) & ", "

  # Field: Password Reset Code
  if passwordResetCode != none(string):
    insertStatement &= "password_reset_code, "
    valuesClause &= "?" & ", "
    insertValues.add(passwordResetCode.get)

  # Field: Password Reset Date
  if passwordResetDate != none(DateTime):
    insertStatement &= "password_reset_date, "
    valuesClause &= pgToDateTimeString(passwordResetDate.get) & ", "

  # Field: Is Active
  insertStatement &= "is_active, "
  valuesClause &= "?, "
  insertValues.add($isActive)

  # Field: Is Admin
  insertStatement &= "is_admin, "
  valuesClause &= "?, "
  insertValues.add($isAdmin)

  # Field: Is Verified
  insertStatement &= "is_verified, "
  valuesClause &= "?, "
  insertValues.add($isVerified)

  # Field: Subscription Status
  if subscriptionStatus != none(char):
    insertStatement &= "subscription_status, "
    valuesClause &= "'" & $subscriptionStatus.get & "'" & ", "

  # Field: Last Login
  if lastLogin != none(DateTime):
    insertStatement &= "last_login, "
    valuesClause &= pgToDateTimeString(lastLogin.get) & ", "

  # Field: Last Update
  if lastUpdate != none(DateTime):
    insertStatement &= "last_update, "
    valuesClause &= pgToDateTimeString(lastUpdate.get) & ", "

  # Field: Created
  insertStatement &= "created, "
  valuesClause &= pgToDateTimeString(created) & ", "

  # Remove trailing commas and finalize insertStatement
  if insertStatement[len(insertStatement) - 2 .. len(insertStatement) - 1] == ", ":
    insertStatement = insertStatement[0 .. len(insertStatement) - 3]

  if valuesClause[len(valuesClause) - 2 .. len(valuesClause) - 1] == ", ":
    valuesClause = valuesClause[0 .. len(valuesClause) - 3]

  # Finalize insertStatement
  insertStatement &=
    ") values (" & valuesClause & ")"

  if ignoreExistingPk == true:
    insertStatement &= " on conflict (account_user_id) do nothing"

  # Execute the insert statement and return the sequence values
  return tryInsertNamedID(
    nexusCoreDbContext.dbConn,
    sql(insertStatement),
    "account_user_id",
    insertValues)


proc createAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountId: Option[int64] = none(int64),
       name: string,
       email: string,
       passwordHash: string,
       passwordSalt: string,
       apiKey: string,
       lastToken: Option[string] = none(string),
       signUpCode: string,
       signUpDate: DateTime,
       passwordResetCode: Option[string] = none(string),
       passwordResetDate: Option[DateTime] = none(DateTime),
       isActive: bool,
       isAdmin: bool,
       isVerified: bool,
       subscriptionStatus: Option[char] = none(char),
       lastLogin: Option[DateTime] = none(DateTime),
       lastUpdate: Option[DateTime] = none(DateTime),
       created: DateTime,
       ignoreExistingPk: bool = false,
       copyAllStringFields: bool = true,
       convertToRawTypes: bool = true): AccountUser {.gcsafe.} =

  var accountUser = AccountUser()

  accountUser.accountUserId =
    createAccountUserReturnsPk(
      nexusCoreDbContext,
      accountId,
      name,
      email,
      passwordHash,
      passwordSalt,
      apiKey,
      lastToken,
      signUpCode,
      signUpDate,
      passwordResetCode,
      passwordResetDate,
      isActive,
      isAdmin,
      isVerified,
      subscriptionStatus,
      lastLogin,
      lastUpdate,
      created,
      ignoreExistingPk)

  # Copy all fields as strings
  accountUser.accountId = accountId
  accountUser.name = name
  accountUser.email = email
  accountUser.passwordHash = passwordHash
  accountUser.passwordSalt = passwordSalt
  accountUser.apiKey = apiKey
  accountUser.lastToken = lastToken
  accountUser.signUpCode = signUpCode
  accountUser.signUpDate = signUpDate
  accountUser.passwordResetCode = passwordResetCode
  accountUser.passwordResetDate = passwordResetDate
  accountUser.isActive = isActive
  accountUser.isAdmin = isAdmin
  accountUser.isVerified = isVerified
  accountUser.subscriptionStatus = subscriptionStatus
  accountUser.lastLogin = lastLogin
  accountUser.lastUpdate = lastUpdate
  accountUser.created = created

  return accountUser


proc deleteAccountUserByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user" &
    " where account_user_id = ?"

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           accountUserId)


proc deleteAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user" &
    " where " & whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           whereValues)


proc deleteAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user"

  var first = true

  for whereField in whereFields:

    var whereClause: string

    if first == false:
      whereClause = "   and " & whereField & " = ?"
    else:
      first = false
      whereClause = " where " & whereField & " = ?"

    deleteStatement &= whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           whereValues)


proc existsAccountUserByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              $accountUserId)

  if row[0] == "":
    return false
  else:
    return true


proc existsAccountUserByEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       email: string): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user" &
    " where email = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              email)

  if row[0] == "":
    return false
  else:
    return true


proc existsAccountUserByAPIKey*(
       nexusCoreDbContext: NexusCoreDbContext,
       apiKey: string): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user" &
    " where api_key = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              apiKey)

  if row[0] == "":
    return false
  else:
    return true


proc existsAccountUserByLastToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       lastToken: Option[string]): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user" &
    " where last_token = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              lastToken)

  if row[0] == "":
    return false
  else:
    return true


proc filterAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string = "",
       whereValues: seq[string] = @[],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): AccountUsers {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  if len(orderByFields) > 0:
    selectStatement &= " order by " & orderByFields.join(", ")

  if limit != none(int):
    selectStatement &= " limit " & $limit.get

  var accountUsers: AccountUsers

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    accountUsers.add(rowToAccountUser(row))

  return accountUsers


proc filterAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): AccountUsers {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user"

  var first = true

  for whereField in whereFields:

    var whereClause: string

    if first == false:
      whereClause = "   and " & whereField & " = ?"
    else:
      first = false
      whereClause = " where " & whereField & " = ?"

    selectStatement &= whereClause

  if len(orderByFields) > 0:
    selectStatement &= " order by " & orderByFields.join(", ")

  if limit != none(int):
    selectStatement &= " limit " & $limit.get

  var accountUsers: AccountUsers

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    accountUsers.add(rowToAccountUser(row))

  return accountUsers


proc getAccountUserByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): Option[AccountUser] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              accountUserId)

  if row[0] == "":
    return none(AccountUser)

  return some(rowToAccountUser(row))


proc getAccountUserByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: string): Option[AccountUser] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              accountUserId)

  if row[0] == "":
    return none(AccountUser)

  return some(rowToAccountUser(row))


proc getAccountUserByEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       email: string): Option[AccountUser] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user" &
    " where email = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              email)

  if row[0] == "":
    return none(AccountUser)

  return some(rowToAccountUser(row))


proc getAccountUserByAPIKey*(
       nexusCoreDbContext: NexusCoreDbContext,
       apiKey: string): Option[AccountUser] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user" &
    " where api_key = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              apiKey)

  if row[0] == "":
    return none(AccountUser)

  return some(rowToAccountUser(row))


proc getAccountUserByLastToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       lastToken: string): Option[AccountUser] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, account_id, name, email, password_hash, password_salt, api_key, last_token," & 
    "       sign_up_code, sign_up_date, password_reset_code, password_reset_date, is_active, is_admin," &
    "       is_verified, subscription_status, last_login, last_update, created" &
    "  from account_user" &
    " where last_token = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              lastToken)

  if row[0] == "":
    return none(AccountUser)

  return some(rowToAccountUser(row))


proc getAPIKeyFromAccountUserByPK*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): Option[string] =

  var selectStatement =
    "select api_key" & 
    "  from account_user" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              accountUserId)

  if row[0] == "":
    return none(string)

  return some(row[0])

proc getOrCreateAccountUserByEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountId: Option[int64],
       name: string,
       email: string,
       passwordHash: string,
       passwordSalt: string,
       apiKey: string,
       lastToken: Option[string],
       signUpCode: string,
       signUpDate: DateTime,
       passwordResetCode: Option[string],
       passwordResetDate: Option[DateTime],
       isActive: bool,
       isAdmin: bool,
       isVerified: bool,
       subscriptionStatus: Option[char],
       lastLogin: Option[DateTime],
       lastUpdate: Option[DateTime],
       created: DateTime): AccountUser {.gcsafe.} =

  let accountUser =
        getAccountUserByEmail(
          nexusCoreDbContext,
          email)

  if accountUser != none(AccountUser):
    return accountUser.get

  return createAccountUser(
           nexusCoreDbContext,
           accountId,
           name,
           email,
           passwordHash,
           passwordSalt,
           apiKey,
           lastToken,
           signUpCode,
           signUpDate,
           passwordResetCode,
           passwordResetDate,
           isActive,
           isAdmin,
           isVerified,
           subscriptionStatus,
           lastLogin,
           lastUpdate,
           created)


proc getOrCreateAccountUserByAPIKey*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountId: Option[int64],
       name: string,
       email: string,
       passwordHash: string,
       passwordSalt: string,
       apiKey: string,
       lastToken: Option[string],
       signUpCode: string,
       signUpDate: DateTime,
       passwordResetCode: Option[string],
       passwordResetDate: Option[DateTime],
       isActive: bool,
       isAdmin: bool,
       isVerified: bool,
       subscriptionStatus: Option[char],
       lastLogin: Option[DateTime],
       lastUpdate: Option[DateTime],
       created: DateTime): AccountUser {.gcsafe.} =

  let accountUser =
        getAccountUserByAPIKey(
          nexusCoreDbContext,
          apiKey)

  if accountUser != none(AccountUser):
    return accountUser.get

  return createAccountUser(
           nexusCoreDbContext,
           accountId,
           name,
           email,
           passwordHash,
           passwordSalt,
           apiKey,
           lastToken,
           signUpCode,
           signUpDate,
           passwordResetCode,
           passwordResetDate,
           isActive,
           isAdmin,
           isVerified,
           subscriptionStatus,
           lastLogin,
           lastUpdate,
           created)


proc getOrCreateAccountUserByLastToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountId: Option[int64],
       name: string,
       email: string,
       passwordHash: string,
       passwordSalt: string,
       apiKey: string,
       lastToken: string,
       signUpCode: string,
       signUpDate: DateTime,
       passwordResetCode: Option[string],
       passwordResetDate: Option[DateTime],
       isActive: bool,
       isAdmin: bool,
       isVerified: bool,
       subscriptionStatus: Option[char],
       lastLogin: Option[DateTime],
       lastUpdate: Option[DateTime],
       created: DateTime): AccountUser {.gcsafe.} =

  let accountUser =
        getAccountUserByLastToken(
          nexusCoreDbContext,
          lastToken)

  if accountUser != none(AccountUser):
    return accountUser.get

  return createAccountUser(
           nexusCoreDbContext,
           accountId,
           name,
           email,
           passwordHash,
           passwordSalt,
           apiKey,
           some(lastToken),
           signUpCode,
           signUpDate,
           passwordResetCode,
           passwordResetDate,
           isActive,
           isAdmin,
           isVerified,
           subscriptionStatus,
           lastLogin,
           lastUpdate,
           created)


proc rowToAccountUser*(row: seq[string]):
       AccountUser {.gcsafe.} =

  var accountUser = AccountUser()

  accountUser.accountUserId = parseBiggestInt(row[0])

  if row[1] != "":
    accountUser.accountId = some(parseBiggestInt(row[1]))
  else:
    accountUser.accountId = none(int64)

  accountUser.name = row[2]
  accountUser.email = row[3]
  accountUser.passwordHash = row[4]
  accountUser.passwordSalt = row[5]
  accountUser.apiKey = row[6]

  if row[7] != "":
    accountUser.lastToken = some(row[7])
  else:
    accountUser.lastToken = none(string)

  accountUser.signUpCode = row[8]
  accountUser.signUpDate = parsePgTimestamp(row[9])

  if row[10] != "":
    accountUser.passwordResetCode = some(row[10])
  else:
    accountUser.passwordResetCode = none(string)

  if row[11] != "":
    accountUser.passwordResetDate = some(parsePgTimestamp(row[11]))
  else:
    accountUser.passwordResetDate = none(DateTime)

  accountUser.isActive = parsePgBool(row[12])
  accountUser.isAdmin = parsePgBool(row[13])
  accountUser.isVerified = parsePgBool(row[14])

  if row[15] != "":
    accountUser.subscriptionStatus = some(row[15][0])
  else:
    accountUser.subscriptionStatus = none(char)

  if row[16] != "":
    accountUser.lastLogin = some(parsePgTimestamp(row[16]))
  else:
    accountUser.lastLogin = none(DateTime)

  if row[17] != "":
    accountUser.lastUpdate = some(parsePgTimestamp(row[17]))
  else:
    accountUser.lastUpdate = none(DateTime)

  accountUser.created = parsePgTimestamp(row[18])

  return accountUser


proc truncateAccountUser*(
       nexusCoreDbContext: NexusCoreDbContext,
       cascade: bool = false) =

  if cascade == false:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table account_user restart identity;"))

  else:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table account_user restart identity cascade;"))


proc updateAccountUserSetClause*(
       accountUser: AccountUser,
       setFields: seq[string],
       updateStatement: var string,
       updateValues: var seq[string]) {.gcsafe.} =

  updateStatement =
    "update account_user" &
    "   set "

  for field in setFields:

    if field == "account_user_id":
      updateStatement &= "       account_user_id = ?,"
      updateValues.add($accountUser.accountUserId)

    elif field == "account_id":
      if accountUser.accountId != none(int64):
        updateStatement &= "       account_id = ?,"
        updateValues.add($accountUser.accountId.get)
      else:
        updateStatement &= "       account_id = null,"

    elif field == "name":
      updateStatement &= "       name = ?,"
      updateValues.add(accountUser.name)

    elif field == "email":
      updateStatement &= "       email = ?,"
      updateValues.add(accountUser.email)

    elif field == "password_hash":
      updateStatement &= "       password_hash = ?,"
      updateValues.add(accountUser.passwordHash)

    elif field == "password_salt":
      updateStatement &= "       password_salt = ?,"
      updateValues.add(accountUser.passwordSalt)

    elif field == "api_key":
      updateStatement &= "       api_key = ?,"
      updateValues.add(accountUser.apiKey)

    elif field == "last_token":
      if accountUser.lastToken != none(string):
        updateStatement &= "       last_token = ?,"
        updateValues.add(accountUser.lastToken.get)
      else:
        updateStatement &= "       last_token = null,"

    elif field == "sign_up_code":
      updateStatement &= "       sign_up_code = ?,"
      updateValues.add(accountUser.signUpCode)

    elif field == "sign_up_date":
        updateStatement &= "       sign_up_date = " & pgToDateTimeString(accountUser.signUpDate) & ","

    elif field == "password_reset_code":
      if accountUser.passwordResetCode != none(string):
        updateStatement &= "       password_reset_code = ?,"
        updateValues.add(accountUser.passwordResetCode.get)
      else:
        updateStatement &= "       password_reset_code = null,"

    elif field == "password_reset_date":
      if accountUser.passwordResetDate != none(DateTime):
        updateStatement &= "       password_reset_date = " & pgToDateTimeString(accountUser.passwordResetDate.get) & ","
      else:
        updateStatement &= "       password_reset_date = null,"

    elif field == "is_active":
        updateStatement &= "       is_active = " & pgToBool(accountUser.isActive) & ","

    elif field == "is_admin":
        updateStatement &= "       is_admin = " & pgToBool(accountUser.isAdmin) & ","

    elif field == "is_verified":
        updateStatement &= "       is_verified = " & pgToBool(accountUser.isVerified) & ","

    elif field == "subscription_status":
      if accountUser.subscriptionStatus != none(char):
        updateStatement &= "       subscription_status = ?,"
        updateValues.add($accountUser.subscriptionStatus.get)
      else:
        updateStatement &= "       subscription_status = null,"

    elif field == "last_login":
      if accountUser.lastLogin != none(DateTime):
        updateStatement &= "       last_login = " & pgToDateTimeString(accountUser.lastLogin.get) & ","
      else:
        updateStatement &= "       last_login = null,"

    elif field == "last_update":
      if accountUser.lastUpdate != none(DateTime):
        updateStatement &= "       last_update = " & pgToDateTimeString(accountUser.lastUpdate.get) & ","
      else:
        updateStatement &= "       last_update = null,"

    elif field == "created":
        updateStatement &= "       created = " & pgToDateTimeString(accountUser.created) & ","

  updateStatement[len(updateStatement) - 1] = ' '



proc updateAccountUserByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUser: AccountUser,
       setFields: seq[string],
       exceptionOnNRowsUpdated: bool = true): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserSetClause(
    account_user,
    setFields,
    updateStatement,
    updateValues)

  updateStatement &= " where account_user_id = ?"

  updateValues.add($accountUser.accountUserId)

  let rowsUpdated = 
        execAffectedRows(
          nexusCoreDbContext.dbConn,
          sql(updateStatement),
          updateValues)

  # Exception on no rows updated
  if rowsUpdated == 0 and
     exceptionOnNRowsUpdated == true:

    raise newException(ValueError,
                       "no rows updated")

  # Return rows updated
  return rowsUpdated


proc updateAccountUserByWhereClause*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUser: AccountUser,
       setFields: seq[string],
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserSetClause(
    account_user,
    setFields,
    updateStatement,
    updateValues)

  if whereClause != "":
    updateStatement &= " where " & whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(updateStatement),
           concat(updateValues,
                  whereValues))


proc updateAccountUserByWhereEqOnly*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUser: AccountUser,
       setFields: seq[string],
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserSetClause(
    account_user,
    setFields,
    updateStatement,
    updateValues)

  var first = true

  for whereField in whereFields:

    var whereClause: string

    if first == false:
      whereClause = "   and " & whereField & " = ?"
    else:
      first = false
      whereClause = " where " & whereField & " = ?"

    updateStatement &= whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(updateStatement),
           concat(updateValues,
                  whereValues))


proc updateAccountUserSetLastLoginByPK*(
       nexusCoreDbContext: NexusCoreDbContext,
       lastLogin: Option[DateTime],
       accountUserId: int64): int64 =

  var updateStatement =
    "update account_user" &
    "   set last_login = ?" &
    " where account_user_id = ?"

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(updateStatement),
           last_login.get,
           account_user_id)
