
CREATE PROCEDURE [dbo].[update_shopify_caching_msg_sequence_number]
		@user_id bigint,
		@message_sequence_number bigint = NULL
		
As
---- =============================================
---- Author:      <Ali Qaryan>
---- Create Date: <Create Date, , >
---- Description: <Description, , >
---- =============================================

Begin

----Begin test script

----End test script



UPDATE [dbo].[shopifyCachingProcess]
	SET [message_sequence_number] = @message_sequence_number
	WHERE user_id = @user_id
End

