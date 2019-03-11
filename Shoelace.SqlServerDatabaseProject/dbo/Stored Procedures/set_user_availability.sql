
CREATE PROCEDURE [dbo].[set_user_availability]
		@mongo_id varchar(50),
		@is_available bit = 1
		
As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================

Begin

----Begin test script

----End test script



UPDATE [dbo].[user]
	SET [is_available] = @is_available,
	[date_updated] = GETUTCDATE()
WHERE mongo_id = @mongo_id
End


