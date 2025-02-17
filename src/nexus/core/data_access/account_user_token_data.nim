# Nexus generated file
import db_postgres, options, sequtils, strutils, times
import nexus/core/data_access/data_utils
import nexus/core/types/model_types


# Forward declarations
proc rowToAccountUserToken*(row: seq[string]):
       AccountUserToken {.gcsafe.}


# Code
proc countAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string] = @[],
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from account_user_token"
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


proc countAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from account_user_token"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  let row = getRow(nexusCoreDbContext.dbConn,
                   sql(selectStatement),
                   whereValues)

  return parseBiggestInt(row[0])


proc createAccountUserTokenReturnsPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64,
       uniqueHash: string,
       token: string,
       created: DateTime,
       deleted: Option[DateTime] = none(DateTime),
       ignoreExistingPk: bool = false): int64 {.gcsafe.} =

  # Formulate insertStatement and insertValues
  var
    insertValues: seq[string]
    insertStatement = "insert into account_user_token ("
    valuesClause = ""

  # Field: Account User Id
  insertStatement &= "account_user_id, "
  valuesClause &= "?, "
  insertValues.add($accountUserId)

  # Field: Unique Hash
  insertStatement &= "unique_hash, "
  valuesClause &= "?" & ", "
  insertValues.add(uniqueHash)

  # Field: Token
  insertStatement &= "token, "
  valuesClause &= "?" & ", "
  insertValues.add(token)

  # Field: Created
  insertStatement &= "created, "
  valuesClause &= pgToDateTimeString(created) & ", "

  # Field: Deleted
  if deleted != none(DateTime):
    insertStatement &= "deleted, "
    valuesClause &= pgToDateTimeString(deleted.get) & ", "

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
  exec(
    nexusCoreDbContext.dbConn,
    sql(insertStatement),
    insertValues)

  return accountUserId


proc createAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64,
       uniqueHash: string,
       token: string,
       created: DateTime,
       deleted: Option[DateTime] = none(DateTime),
       ignoreExistingPk: bool = false,
       copyAllStringFields: bool = true,
       convertToRawTypes: bool = true): AccountUserToken {.gcsafe.} =

  var accountUserToken = AccountUserToken()

  accountUserToken.accountUserId =
    createAccountUserTokenReturnsPk(
      nexusCoreDbContext,
      accountUserId,
      uniqueHash,
      token,
      created,
      deleted,
      ignoreExistingPk)

  # Copy all fields as strings
  accountUserToken.uniqueHash = uniqueHash
  accountUserToken.token = token
  accountUserToken.created = created
  accountUserToken.deleted = deleted

  return accountUserToken


proc deleteAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user_token" &
    " where account_user_id = ?"

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           accountUserId)


proc deleteAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user_token" &
    " where " & whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           whereValues)


proc deleteAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from account_user_token"

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


proc existsAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user_token" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              $accountUserId)

  if row[0] == "":
    return false
  else:
    return true


proc existsAccountUserTokenByUniqueHash*(
       nexusCoreDbContext: NexusCoreDbContext,
       uniqueHash: string): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user_token" &
    " where unique_hash = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              uniqueHash)

  if row[0] == "":
    return false
  else:
    return true


proc existsAccountUserTokenByToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       token: string): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from account_user_token" &
    " where token = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              token)

  if row[0] == "":
    return false
  else:
    return true


proc filterAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string = "",
       whereValues: seq[string] = @[],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): AccountUserTokens {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  if len(orderByFields) > 0:
    selectStatement &= " order by " & orderByFields.join(", ")

  if limit != none(int):
    selectStatement &= " limit " & $limit.get

  var accountUserTokens: AccountUserTokens

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    accountUserTokens.add(rowToAccountUserToken(row))

  return accountUserTokens


proc filterAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): AccountUserTokens {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token"

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

  var accountUserTokens: AccountUserTokens

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    accountUserTokens.add(rowToAccountUserToken(row))

  return accountUserTokens


proc getAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64): Option[AccountUserToken] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              accountUserId)

  if row[0] == "":
    return none(AccountUserToken)

  return some(rowToAccountUserToken(row))


proc getAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: string): Option[AccountUserToken] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token" &
    " where account_user_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              accountUserId)

  if row[0] == "":
    return none(AccountUserToken)

  return some(rowToAccountUserToken(row))


proc getAccountUserTokenByUniqueHash*(
       nexusCoreDbContext: NexusCoreDbContext,
       uniqueHash: string): Option[AccountUserToken] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token" &
    " where unique_hash = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              uniqueHash)

  if row[0] == "":
    return none(AccountUserToken)

  return some(rowToAccountUserToken(row))


proc getAccountUserTokenByToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       token: string): Option[AccountUserToken] {.gcsafe.} =

  var selectStatement =
    "select account_user_id, unique_hash, token, created, deleted" & 
    "  from account_user_token" &
    " where token = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              token)

  if row[0] == "":
    return none(AccountUserToken)

  return some(rowToAccountUserToken(row))


proc getOrCreateAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64,
       uniqueHash: string,
       token: string,
       created: DateTime,
       deleted: Option[DateTime]): AccountUserToken {.gcsafe.} =

  let accountUserToken =
        getAccountUserTokenByPK(
          nexusCoreDbContext,
          accountUserId)

  if accountUserToken != none(AccountUserToken):
    return accountUserToken.get

  return createAccountUserToken(
           nexusCoreDbContext,
           accountUserId,
           uniqueHash,
           token,
           created,
           deleted)


proc getOrCreateAccountUserTokenByUniqueHash*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64,
       uniqueHash: string,
       token: string,
       created: DateTime,
       deleted: Option[DateTime]): AccountUserToken {.gcsafe.} =

  let accountUserToken =
        getAccountUserTokenByUniqueHash(
          nexusCoreDbContext,
          uniqueHash)

  if accountUserToken != none(AccountUserToken):
    return accountUserToken.get

  return createAccountUserToken(
           nexusCoreDbContext,
           accountUserId,
           uniqueHash,
           token,
           created,
           deleted)


proc getOrCreateAccountUserTokenByToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserId: int64,
       uniqueHash: string,
       token: string,
       created: DateTime,
       deleted: Option[DateTime]): AccountUserToken {.gcsafe.} =

  let accountUserToken =
        getAccountUserTokenByToken(
          nexusCoreDbContext,
          token)

  if accountUserToken != none(AccountUserToken):
    return accountUserToken.get

  return createAccountUserToken(
           nexusCoreDbContext,
           accountUserId,
           uniqueHash,
           token,
           created,
           deleted)


proc rowToAccountUserToken*(row: seq[string]):
       AccountUserToken {.gcsafe.} =

  var accountUserToken = AccountUserToken()

  accountUserToken.accountUserId = parseBiggestInt(row[0])
  accountUserToken.uniqueHash = row[1]
  accountUserToken.token = row[2]
  accountUserToken.created = parsePgTimestamp(row[3])

  if row[4] != "":
    accountUserToken.deleted = some(parsePgTimestamp(row[4]))
  else:
    accountUserToken.deleted = none(DateTime)


  return accountUserToken


proc truncateAccountUserToken*(
       nexusCoreDbContext: NexusCoreDbContext,
       cascade: bool = false) =

  if cascade == false:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table account_user_token restart identity;"))

  else:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table account_user_token restart identity cascade;"))


proc updateAccountUserTokenSetClause*(
       accountUserToken: AccountUserToken,
       setFields: seq[string],
       updateStatement: var string,
       updateValues: var seq[string]) {.gcsafe.} =

  updateStatement =
    "update account_user_token" &
    "   set "

  for field in setFields:

    if field == "account_user_id":
      updateStatement &= "       account_user_id = ?,"
      updateValues.add($accountUserToken.accountUserId)

    elif field == "unique_hash":
      updateStatement &= "       unique_hash = ?,"
      updateValues.add(accountUserToken.uniqueHash)

    elif field == "token":
      updateStatement &= "       token = ?,"
      updateValues.add(accountUserToken.token)

    elif field == "created":
        updateStatement &= "       created = " & pgToDateTimeString(accountUserToken.created) & ","

    elif field == "deleted":
      if accountUserToken.deleted != none(DateTime):
        updateStatement &= "       deleted = " & pgToDateTimeString(accountUserToken.deleted.get) & ","
      else:
        updateStatement &= "       deleted = null,"

  updateStatement[len(updateStatement) - 1] = ' '



proc updateAccountUserTokenByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserToken: AccountUserToken,
       setFields: seq[string],
       exceptionOnNRowsUpdated: bool = true): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserTokenSetClause(
    account_user_token,
    setFields,
    updateStatement,
    updateValues)

  updateStatement &= " where account_user_id = ?"

  updateValues.add($accountUserToken.accountUserId)

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


proc updateAccountUserTokenByWhereClause*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserToken: AccountUserToken,
       setFields: seq[string],
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserTokenSetClause(
    account_user_token,
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


proc updateAccountUserTokenByWhereEqOnly*(
       nexusCoreDbContext: NexusCoreDbContext,
       accountUserToken: AccountUserToken,
       setFields: seq[string],
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateAccountUserTokenSetClause(
    account_user_token,
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


