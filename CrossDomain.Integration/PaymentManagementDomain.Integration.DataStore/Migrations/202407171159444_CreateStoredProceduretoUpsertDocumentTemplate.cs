namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoUpsertDocumentTemplate : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_DocumentsDomain_UpsertDocumentTemplate", c => new
            {
                TemplateName = c.String(100),
                checksum = c.Binary()

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_DocumentsDomain_UpsertDocumentTemplate");
        }

        private const string StoredProcedureBody = @"DECLARE @templateExist BIT
                                SELECT @templateExist = CAST(CASE WHEN EXISTS (SELECT 1 from  [DocumentsDomain].[UploadedDocumentTemplate] 
		                                                     WHERE [TemplateName] = @templateName)
			                                                     THEN 1 
			                                                     ELSE 0
		                                                     END AS BIT) 
                                IF @templateExist = 1
                                BEGIN
	                                UPDATE [DocumentsDomain].[UploadedDocumentTemplate]
	                                   SET [Checksum] = @checksum
		                                  ,[DateUpLoaded] = GETUTCDATE()
	                                 WHERE [TemplateName] = @templateName
                                END 
                                ELSE 
                                BEGIN
	                                INSERT INTO [DocumentsDomain].[UploadedDocumentTemplate]
                                           ([TemplateName],[Checksum],[DateUpLoaded])
                                     VALUES
                                           (@TemplateName, @checksum, GETUTCDATE())
                                END ";
    }
}
