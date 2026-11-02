namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddModifiedColumnsToContractReqWebJobStatusTable : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractRequest.WebjobStatus","ModifiedBy", c => c.String());
            AddColumn("ContractRequest.WebjobStatus", "ModifiedDate", c => c.DateTime());                   
            
        }
        
        public override void Down()
        {
            DropColumn("ContractRequest.WebjobStatus", "ModifiedBy");
            DropColumn("ContractRequest.WebjobStatus", "ModifiedDate");
        }
    }
}
