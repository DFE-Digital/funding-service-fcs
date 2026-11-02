namespace Datafix.Tests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Reflection;
    using Dapper;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;

    [TestClass]
    public class OrganisationTableSanitize
    {
        [TestMethod, TestCategory("Datafix_R63")]
        public void OrganisationTable_ShouldHaveFormattedAddresses()
        {
            IReadOnlyCollection<OrganisationAddress> organisationAddresses = GetOrgAddresses();

            organisationAddresses.ForEach(SanitizeAddress);

            var changedAddresses = organisationAddresses.Where(o => o.HasChanged);

            changedAddresses.ForEach(UpdateOrganisationAddress);
        }

        private void SanitizeAddress(OrganisationAddress organisationAddress)
        {
            if (organisationAddress.County.IsAllUpperCase())
            {
                organisationAddress.County = organisationAddress.County.ToPascalCase();

                organisationAddress.HasChanged = true;
            }

            string[] propertiesThatNeedApostropheCheck = { "Line1", "Line2", "Line3", "Line4", "Town" };

            IEnumerable<PropertyInfo> propertiesToCheck = typeof(OrganisationAddress).GetProperties()
                .Where(p => propertiesThatNeedApostropheCheck.Contains(p.Name));

            propertiesToCheck.ForEach(p =>
            {
                var propertyValue = p.GetValue(organisationAddress) as string;
                if (propertyValue.HasUpperCaseAfterApostropheMistake())
                {
                    p.SetValue(organisationAddress, propertyValue.ChangeCharacterAfterApostropheToLower());
                    organisationAddress.HasChanged = true;
                }
            });
        }

        private void UpdateOrganisationAddress(OrganisationAddress organisationAddress)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql = @"update [dbo].[Organisations] set [Address_Line1] = @line1
                             ,[Address_Line2] = @line2
                             ,[Address_Line3] = @line3
                             ,[Address_Line4] = @line4
                             ,[Address_Town] = @town
                             ,[Address_County] = @county
                             where [OrganisationId] = @id";

                connection.Execute(sql, new { line1 = organisationAddress.Line1,
                    line2 = organisationAddress.Line2,
                    line3 = organisationAddress.Line3,
                    line4 = organisationAddress.Line4,
                    town = organisationAddress.Town,
                    county = organisationAddress.County,
                    id = organisationAddress.OrganisationId
                });
            }
        }

        private IReadOnlyCollection<OrganisationAddress> GetOrgAddresses()
        {
            string connectionString = ConfigurationManager.ConnectionStrings["organisationDomainDatabase"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                string sql = $@"SELECT [OrganisationId]
                              ,[Address_Line1] Line1
                              ,[Address_Line2] Line2
                              ,[Address_Line3] Line3
                              ,[Address_Line4] Line4
                              ,[Address_Town] Town
                              ,[Address_County] County
                          FROM [dbo].[Organisations]";

                return connection.Query<OrganisationAddress>(sql).ToList();
            }
        }

        private class OrganisationAddress
        {
            public int OrganisationId { get; set; }

            public string Line1 { get; set; }
            
            public string Line2 { get; set; }
            
            public string Line3 { get; set; }
            
            public string Line4 { get; set; }
            
            public string Town { get; set; }

            public string County { get; set; }

            public bool HasChanged { get; set; }
        }
    }
}
