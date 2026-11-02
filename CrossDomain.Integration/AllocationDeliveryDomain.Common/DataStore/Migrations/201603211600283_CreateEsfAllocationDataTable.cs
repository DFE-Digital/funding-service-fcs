namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateEsfAllocationDataTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.EsfAllocationData",
                c => new
                    {
                        ContractNumber = c.String(nullable: false, maxLength: 128),
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 128),
                        TenderSpecReference = c.String(),
                        LotReference = c.String(),
                        SpecificationTitle = c.String(),
                        AwardReference = c.String(),
                        ActivityDescription = c.String(),
                        InvestmentPriority = c.String(),
                        LEPCode = c.String(),
                        LEPName = c.String(),
                        RegionType = c.String(),
                        AgreementNumber = c.String(),
                        LearningRatePremium = c.String(),
                    })
                .PrimaryKey(t => new { t.ContractNumber, t.ContractAllocationNumber });
            
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.EsfAllocationData");
        }
    }
}
