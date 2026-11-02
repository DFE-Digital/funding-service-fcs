namespace Datafix.Tests.Automation.Releases.R85
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    using System.Linq;
    using System;

    public class MigrateOrgServiceDataRowsFromOrgDbToPaaSDb : RunSqlFileIntoDb, IApplyDataFix
    {
        public string Release => "R85";

        public int StoryNumber => 28858;

        public string Name => "Migrate org service data rows from org db to PaaS db";

        public int Order => 1;

        public static string NewOrganisationConnectionString => ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;

        private static string OldOrganisationConnectionString => ConfigurationManager.ConnectionStrings["organisationDomainDatabaseOld"].ConnectionString;

        public void ApplyDataFix()
        {
            var dataFixDescription = $" dataFix - {Release}. {StoryNumber} - {Name}.";
            Console.WriteLine("Starting" + dataFixDescription);

            if (NewOrganisationTableIsEmpty())
            {
                var organisations = GetOrganisationRows().ToList();
                Console.WriteLine($"Adding {organisations.Count} rows to [organisation].[Organisation] table");

                organisations.ForEach(AddOrganisation);
                Console.WriteLine($"{organisations.Count} rows added to [organisation].[Organisation] table");
            }
            else
            {
                Console.WriteLine("No action taken - rows already exist in [organisation].[Organisation] table");
            }

            Console.WriteLine("Completed" + dataFixDescription);
        }

        private static bool NewOrganisationTableIsEmpty()
        {
            var connectionString = NewOrganisationConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = "SELECT COUNT(*) FROM [organisation].[Organisation];";
                return connection.ExecuteScalar<int>(sql) == 0;
            }
        }

        private static IReadOnlyCollection<OrganisationDto> GetOrganisationRows()
        {
            var connectionString = OldOrganisationConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SELECT [OrganisationId]
                                          ,[Ukprn]
                                          ,[Upin]
                                          ,[SequenceNumber]
                                          ,[TradingName]
                                          ,[CreatedDate]
                                          ,[CompanyRegistrationNumber]
                                          ,[HasUkrlpBeenCalledSuccessfully]
                                          ,[CharityNumber]
                                          ,[Status]
                                          ,[Type]
                                          ,[Address_Line1] 
                                          ,[Address_Line2] 
                                          ,[Address_Line3] 
                                          ,[Address_Line4] 
                                          ,[Address_Town] 
                                          ,[Address_County] 
                                          ,[Address_Postcode] 
                                      FROM [dbo].[Organisations];";

                // Used a dto due to CreatedDate not been in the model.
                // Also, populating the Address class that is within
                // Organisation class was problematic with Dapper

                return connection.Query<OrganisationDto>(sql).ToList();
            }
        }

        private static void AddOrganisation(OrganisationDto organisation)
        {
            var connectionString = NewOrganisationConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                const string sql = @"SET IDENTITY_INSERT [organisation].[Organisation] ON

                                     INSERT INTO [Organisation].[Organisation]
                                               ([OrganisationId]
                                               ,[Ukprn]
                                               ,[Upin]
                                               ,[SequenceNumber]
                                               ,[TradingName]
                                               ,[CreatedDate]
                                               ,[CompanyRegistrationNumber]
                                               ,[CharityNumber]
                                               ,[HasUkrlpBeenCalledSuccessfully]
                                               ,[Status]
                                               ,[Type]
                                               ,[Address_Line1]
                                               ,[Address_Line2]
                                               ,[Address_Line3]
                                               ,[Address_Line4]
                                               ,[Address_Town]
                                               ,[Address_County]
                                               ,[Address_Postcode])
                                         VALUES
                                               (@OrganisationId
                                               ,@Ukprn
                                               ,@Upin
                                               ,@SequenceNumber
                                               ,@TradingName
                                               ,@CreatedDate
                                               ,@CompanyRegistrationNumber
                                               ,@CharityNumber
                                               ,@HasUkrlpBeenCalledSuccessfully
                                               ,@Status
                                               ,@Type
                                               ,@Address_Line1
                                               ,@Address_Line2
                                               ,@Address_Line3
                                               ,@Address_Line4
                                               ,@Address_Town
                                               ,@Address_County
                                               ,@Address_Postcode);

                                     SET IDENTITY_INSERT [organisation].[Organisation] OFF";

                connection.Execute(sql, new
                {
                    organisation.OrganisationId,
                    organisation.Ukprn,
                    organisation.Upin,
                    organisation.SequenceNumber,
                    organisation.TradingName,
                    organisation.CreatedDate,
                    organisation.CompanyRegistrationNumber,
                    organisation.CharityNumber,
                    organisation.HasUkrlpBeenCalledSuccessfully,
                    organisation.Status,
                    organisation.Type,
                    organisation.Address_Line1,
                    organisation.Address_Line2,
                    organisation.Address_Line3,
                    organisation.Address_Line4,
                    organisation.Address_Town,
                    organisation.Address_County,
                    organisation.Address_Postcode
                });
            }
        }

    }
}

    