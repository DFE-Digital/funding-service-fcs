namespace SFA.FCT.PMD.PaymentManagment.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PMDPaymentMangementDataStore : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentManagement.AllocationActualsId",
                c => new
                    {
                        CorrelationId = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CorrelationId);
            
            CreateTable(
                "PaymentManagement.ContractApprovedId",
                c => new
                    {
                        CorrelationId = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CorrelationId);
            
            CreateTable(
                "PaymentManagement.PaymentAggregationXRMId",
                c => new
                    {
                        CorrelationId = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CorrelationId);
            
            CreateTable(
                "PaymentManagement.PaymentScheduleId",
                c => new
                    {
                        CorrelationId = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CorrelationId);
            
            CreateTable(
                "PaymentManagement.PaymentScheduleXRMId",
                c => new
                    {
                        CorrelationId = c.Guid(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.CorrelationId);
            
        }
        
        public override void Down()
        {
            DropTable("PaymentManagement.PaymentScheduleXRMId");
            DropTable("PaymentManagement.PaymentScheduleId");
            DropTable("PaymentManagement.PaymentAggregationXRMId");
            DropTable("PaymentManagement.ContractApprovedId");
            DropTable("PaymentManagement.AllocationActualsId");
        }
    }
}
