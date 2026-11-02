namespace OrganisationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Organisation.Organisation",
                c => new
                    {
                        OrganisationId = c.Int(nullable: false, identity: true),
                        Ukprn = c.Int(nullable: false),
                        Upin = c.Int(nullable: false),
                        SequenceNumber = c.Int(nullable: false),
                        TradingName = c.String(nullable: false, maxLength: 255),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                        CompanyRegistrationNumber = c.String(maxLength: 30),
                        HasUkrlpBeenCalledSuccessfully = c.Boolean(nullable: false),
                        CharityNumber = c.String(maxLength: 10),
                        Status = c.String(maxLength: 50),
                        Type = c.String(maxLength: 100),
                        Address_Line1 = c.String(maxLength: 100),
                        Address_Line2 = c.String(maxLength: 100),
                        Address_Line3 = c.String(maxLength: 100),
                        Address_Line4 = c.String(maxLength: 100),
                        Address_Town = c.String(maxLength: 100),
                        Address_County = c.String(maxLength: 100),
                        Address_Postcode = c.String(maxLength: 8),
                    })
                .PrimaryKey(t => t.OrganisationId)
                .Index(t => t.Ukprn, unique: true, name: "IX_Organisation_Ukprn")
                .Index(t => t.Upin, unique: true, name: "IX_Organisation_Upin");
        }

        public override void Down()
        {
            DropIndex("Organisation.Organisation", "IX_Organisation_Upin");
            DropIndex("Organisation.Organisation", "IX_Organisation_Ukprn");
            DropTable("Organisation.Organisation");
        }
    }
}
