# Nexus generated file
import db_postgres, options, sequtils, strutils, times
import nexus/core/data_access/data_utils
import nexus/core/data_access/pg_try_insert_id
import nexus/core/types/model_types


# Forward declarations
proc rowToInvite*(row: seq[string]):
       Invite {.gcsafe.}


# Code
proc countInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string] = @[],
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from invite"
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


proc countInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string] = @[]): int64 {.gcsafe.} =

  var selectStatement =
    "select count(1)" & 
    "  from invite"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  let row = getRow(nexusCoreDbContext.dbConn,
                   sql(selectStatement),
                   whereValues)

  return parseBiggestInt(row[0])


proc createInviteReturnsPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       fromAccountUserId: int64,
       fromEmail: string,
       fromName: string,
       toEmail: string,
       toName: string,
       sent: Option[DateTime] = none(DateTime),
       created: DateTime,
       ignoreExistingPk: bool = false): int64 {.gcsafe.} =

  # Formulate insertStatement and insertValues
  var
    insertValues: seq[string]
    insertStatement = "insert into invite ("
    valuesClause = ""

  # Field: From Account User Id
  insertStatement &= "from_account_user_id, "
  valuesClause &= "?, "
  insertValues.add($fromAccountUserId)

  # Field: From Email
  insertStatement &= "from_email, "
  valuesClause &= "?" & ", "
  insertValues.add(fromEmail)

  # Field: From Name
  insertStatement &= "from_name, "
  valuesClause &= "?" & ", "
  insertValues.add(fromName)

  # Field: To Email
  insertStatement &= "to_email, "
  valuesClause &= "?" & ", "
  insertValues.add(toEmail)

  # Field: To Name
  insertStatement &= "to_name, "
  valuesClause &= "?" & ", "
  insertValues.add(toName)

  # Field: Sent
  if sent != none(DateTime):
    insertStatement &= "sent, "
    valuesClause &= pgToDateTimeString(sent.get) & ", "

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
    insertStatement &= " on conflict (invite_id) do nothing"

  # Execute the insert statement and return the sequence values
  return tryInsertNamedID(
    nexusCoreDbContext.dbConn,
    sql(insertStatement),
    "invite_id",
    insertValues)


proc createInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       fromAccountUserId: int64,
       fromEmail: string,
       fromName: string,
       toEmail: string,
       toName: string,
       sent: Option[DateTime] = none(DateTime),
       created: DateTime,
       ignoreExistingPk: bool = false,
       copyAllStringFields: bool = true,
       convertToRawTypes: bool = true): Invite {.gcsafe.} =

  var invite = Invite()

  invite.inviteId =
    createInviteReturnsPk(
      nexusCoreDbContext,
      fromAccountUserId,
      fromEmail,
      fromName,
      toEmail,
      toName,
      sent,
      created,
      ignoreExistingPk)

  # Copy all fields as strings
  invite.fromAccountUserId = fromAccountUserId
  invite.fromEmail = fromEmail
  invite.fromName = fromName
  invite.toEmail = toEmail
  invite.toName = toName
  invite.sent = sent
  invite.created = created

  return invite


proc deleteInviteByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       inviteId: int64): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from invite" &
    " where invite_id = ?"

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           inviteId)


proc deleteInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from invite" &
    " where " & whereClause

  return execAffectedRows(
           nexusCoreDbContext.dbConn,
           sql(deleteStatement),
           whereValues)


proc deleteInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var deleteStatement =
    "delete" & 
    "  from invite"

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


proc existsInviteByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       inviteId: int64): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from invite" &
    " where invite_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              $inviteId)

  if row[0] == "":
    return false
  else:
    return true


proc existsInviteByToEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       toEmail: string): bool {.gcsafe.} =

  var selectStatement =
    "select 1" & 
    "  from invite" &
    " where to_email = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              toEmail)

  if row[0] == "":
    return false
  else:
    return true


proc filterInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereClause: string = "",
       whereValues: seq[string] = @[],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): Invites {.gcsafe.} =

  var selectStatement =
    "select invite_id, from_account_user_id, from_email, from_name, to_email, to_name, sent, created" & 
    "  from invite"

  if whereClause != "":
    selectStatement &= " where " & whereClause

  if len(orderByFields) > 0:
    selectStatement &= " order by " & orderByFields.join(", ")

  if limit != none(int):
    selectStatement &= " limit " & $limit.get

  var invites: Invites

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    invites.add(rowToInvite(row))

  return invites


proc filterInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       whereFields: seq[string],
       whereValues: seq[string],
       orderByFields: seq[string] = @[],
       limit: Option[int] = none(int)): Invites {.gcsafe.} =

  var selectStatement =
    "select invite_id, from_account_user_id, from_email, from_name, to_email, to_name, sent, created" & 
    "  from invite"

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

  var invites: Invites

  for row in fastRows(nexusCoreDbContext.dbConn,
                      sql(selectStatement),
                      whereValues):

    invites.add(rowToInvite(row))

  return invites


proc getInviteByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       inviteId: int64): Option[Invite] {.gcsafe.} =

  var selectStatement =
    "select invite_id, from_account_user_id, from_email, from_name, to_email, to_name, sent, created" & 
    "  from invite" &
    " where invite_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              inviteId)

  if row[0] == "":
    return none(Invite)

  return some(rowToInvite(row))


proc getInviteByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       inviteId: string): Option[Invite] {.gcsafe.} =

  var selectStatement =
    "select invite_id, from_account_user_id, from_email, from_name, to_email, to_name, sent, created" & 
    "  from invite" &
    " where invite_id = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              inviteId)

  if row[0] == "":
    return none(Invite)

  return some(rowToInvite(row))


proc getInviteByToEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       toEmail: string): Option[Invite] {.gcsafe.} =

  var selectStatement =
    "select invite_id, from_account_user_id, from_email, from_name, to_email, to_name, sent, created" & 
    "  from invite" &
    " where to_email = ?"

  let row = getRow(
              nexusCoreDbContext.dbConn,
              sql(selectStatement),
              toEmail)

  if row[0] == "":
    return none(Invite)

  return some(rowToInvite(row))


proc getOrCreateInviteByToEmail*(
       nexusCoreDbContext: NexusCoreDbContext,
       fromAccountUserId: int64,
       fromEmail: string,
       fromName: string,
       toEmail: string,
       toName: string,
       sent: Option[DateTime],
       created: DateTime): Invite {.gcsafe.} =

  let invite =
        getInviteByToEmail(
          nexusCoreDbContext,
          toEmail)

  if invite != none(Invite):
    return invite.get

  return createInvite(
           nexusCoreDbContext,
           fromAccountUserId,
           fromEmail,
           fromName,
           toEmail,
           toName,
           sent,
           created)


proc rowToInvite*(row: seq[string]):
       Invite {.gcsafe.} =

  var invite = Invite()

  invite.inviteId = parseBiggestInt(row[0])
  invite.fromAccountUserId = parseBiggestInt(row[1])
  invite.fromEmail = row[2]
  invite.fromName = row[3]
  invite.toEmail = row[4]
  invite.toName = row[5]

  if row[6] != "":
    invite.sent = some(parsePgTimestamp(row[6]))
  else:
    invite.sent = none(DateTime)

  invite.created = parsePgTimestamp(row[7])

  return invite


proc truncateInvite*(
       nexusCoreDbContext: NexusCoreDbContext,
       cascade: bool = false) =

  if cascade == false:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table invite restart identity;"))

  else:
    exec(nexusCoreDbContext.dbConn,
         sql("truncate table invite restart identity cascade;"))


proc updateInviteSetClause*(
       invite: Invite,
       setFields: seq[string],
       updateStatement: var string,
       updateValues: var seq[string]) {.gcsafe.} =

  updateStatement =
    "update invite" &
    "   set "

  for field in setFields:

    if field == "invite_id":
      updateStatement &= "       invite_id = ?,"
      updateValues.add($invite.inviteId)

    elif field == "from_account_user_id":
      updateStatement &= "       from_account_user_id = ?,"
      updateValues.add($invite.fromAccountUserId)

    elif field == "from_email":
      updateStatement &= "       from_email = ?,"
      updateValues.add(invite.fromEmail)

    elif field == "from_name":
      updateStatement &= "       from_name = ?,"
      updateValues.add(invite.fromName)

    elif field == "to_email":
      updateStatement &= "       to_email = ?,"
      updateValues.add(invite.toEmail)

    elif field == "to_name":
      updateStatement &= "       to_name = ?,"
      updateValues.add(invite.toName)

    elif field == "sent":
      if invite.sent != none(DateTime):
        updateStatement &= "       sent = " & pgToDateTimeString(invite.sent.get) & ","
      else:
        updateStatement &= "       sent = null,"

    elif field == "created":
        updateStatement &= "       created = " & pgToDateTimeString(invite.created) & ","

  updateStatement[len(updateStatement) - 1] = ' '



proc updateInviteByPk*(
       nexusCoreDbContext: NexusCoreDbContext,
       invite: Invite,
       setFields: seq[string],
       exceptionOnNRowsUpdated: bool = true): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateInviteSetClause(
    invite,
    setFields,
    updateStatement,
    updateValues)

  updateStatement &= " where invite_id = ?"

  updateValues.add($invite.inviteId)

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


proc updateInviteByWhereClause*(
       nexusCoreDbContext: NexusCoreDbContext,
       invite: Invite,
       setFields: seq[string],
       whereClause: string,
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateInviteSetClause(
    invite,
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


proc updateInviteByWhereEqOnly*(
       nexusCoreDbContext: NexusCoreDbContext,
       invite: Invite,
       setFields: seq[string],
       whereFields: seq[string],
       whereValues: seq[string]): int64 {.gcsafe.} =

  var
    updateStatement: string
    updateValues: seq[string]

  updateInviteSetClause(
    invite,
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


