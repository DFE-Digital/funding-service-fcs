using SFA.FCT.Contracts.AcceptanceTests;
namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using Castle.Core.Internal;
    using Dapper;
    using Extensions;
    using OrganisationDomain.Integration.DataStore;
    using OrganisationDomain.Integration.DataStore.Model;
    
    public static class OrganisationRepository
    {
        public static Organisation FindByUkprn(int ukprn)
        {
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                return context.Organisations.SingleOrDefault(o => o.Ukprn == ukprn);
            }
        }

        public static void RemoveRangeByUkprn(IEnumerable<int> ukprns)
        {
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.RemoveWhere(o => ukprns.Contains(o.Ukprn));
                context.SaveChanges();
            }
        }

        public static void AddOrUpdateOrganisationForUkprn(int ukprn, Action<Organisation> setValues)
        {
            using (OrganisationDomainDbContext context = new OrganisationDomainDbContext())
            {
                context.Organisations.Where(o => o.Ukprn == ukprn).ToList().ForEach(r => context.Organisations.Remove(r));
                context.SaveChanges();
                int impliedOrgId = GetImpliedOrgId(ukprn);
                Organisation organisation = context.Organisations.SingleOrDefault(o => o.OrganisationId == impliedOrgId); ;

                if (organisation == null)
                {
                    InsertOrgWithOrgId(ukprn, setValues);
                }
                else
                {
                    setValues(organisation);
                    context.SaveChanges();
                }
            }
        }

        private static int GetImpliedOrgId(int ukprn)
        {
            return ukprn - 10000000;
        }
       
        private static void InsertOrgWithOrgId(int ukprn, Action<Organisation> setValues)
        {
            string connectionString = SFA.FCT.Contracts.AcceptanceTests.SqlConnectionStringProvider.Get("organisationDomainDatabase");

            Organisation organisation = new Organisation();
            setValues(organisation);

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Execute(@"SET IDENTITY_INSERT [Organisation].[Organisation] ON");

                string sql = @"SET IDENTITY_INSERT [Organisation].[Organisation] ON insert into [Organisation].[Organisation] ([OrganisationId]
      ,[Ukprn]
      ,[Upin]
      ,[SequenceNumber]
      ,[TradingName]
    
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
      ,[Address_Postcode])
	  values(@id, @ukprn, @upin, @sequenceNumber, @name, @companyReg, @hasUkrlp, @charityNumber, @status, @type, @addressLine1, @addressLine2, @addressLine3, @addressLine4, @town, @county, @postcode);";

                var values =
                    new 
                    {
                        id = GetImpliedOrgId(ukprn),
                        ukprn = ukprn,
                        upin = organisation.Upin,
                        sequenceNumber = organisation.SequenceNumber,
                        name = organisation.TradingName,
                        companyReg = organisation.CompanyRegistrationNumber,
                        hasUkrlp = organisation.HasUkrlpBeenCalledSuccessfully,
                        charityNumber = organisation.CharityNumber,
                        status = organisation.Status,
                        type = organisation.Type,
                        addressLine1 = organisation.Address.Line1,
                        addressLine2 = organisation.Address.Line2,
                        addressLine3 = organisation.Address.Line3,
                        addressLine4 = organisation.Address.Line4,
                        town = organisation.Address.Town,
                        county = organisation.Address.County,
                        postcode = organisation.Address.Postcode
                    };

                connection.Execute(sql, values);
            }
        }
    }
}
