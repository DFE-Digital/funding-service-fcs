namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PMDPaymentScheduleDataStore : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentSchedule.Allocation",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 128),
                        VersionNumber = c.Int(nullable: false),
                        FundingStreamPeriodCode = c.String(),
                        ContractNumber = c.String(),
                        ContractVersionNumber = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.VersionNumber });
            
            CreateTable(
                "PaymentSchedule.DeliverablePayment",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 128),
                        VersionNumber = c.Int(nullable: false),
                        DeliverableCode = c.Int(nullable: false),
                        Period = c.String(nullable: false, maxLength: 128),
                        PeriodTypeCode = c.Int(nullable: false),
                        PlannedVolumne = c.Int(nullable: false),
                        PlannedValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ProfilePaymentAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        CappedPaymentAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        BalancingPaymentAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ReconciliationPaymentAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        NetPaymentAmount = c.Decimal(nullable: false, precision: 18, scale: 2),
                        ActualVolumne = c.Int(nullable: false),
                        ActualValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        CollectionReturnCode = c.String(),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.VersionNumber, t.DeliverableCode, t.Period });
            
            CreateTable(
                "PaymentSchedule.OrganisationIdentifer",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 128),
                        VersionNumber = c.Int(nullable: false),
                        MainOrganisationIdentifier = c.String(nullable: false, maxLength: 128),
                        OrganisationId = c.String(nullable: false, maxLength: 128),
                        OrganisationIdentifierName = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.VersionNumber, t.MainOrganisationIdentifier, t.OrganisationId });
            
            CreateTable(
                "PaymentSchedule.ProvisionIdentifier",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 128),
                        VersionNumber = c.Int(nullable: false),
                        ProvisionIdentifierCode = c.String(nullable: false, maxLength: 128),
                        ProvisionIdentifierName = c.String(),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.VersionNumber, t.ProvisionIdentifierCode });
            
        }
        
        public override void Down()
        {
            DropTable("PaymentSchedule.ProvisionIdentifier");
            DropTable("PaymentSchedule.OrganisationIdentifer");
            DropTable("PaymentSchedule.DeliverablePayment");
            DropTable("PaymentSchedule.Allocation");
        }
    }
}
