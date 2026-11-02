namespace ContractCreateDomain.Integration.XrmService.Tests.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Client;
    using Microsoft.Xrm.Client.Services;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.ContractCreateDomain.Integration.XrmService.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    [TestClass]
    public class FundingStreamDeliverablePeriodRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamDeliverablePeriodRepository_GetFundingStreamDeliverables_When()
        {
            // arrange
            const string fspDelName = "FundingStreamPeriodDeliverable-CreateFundingStreamPeriodDeliverable-1";
            const string fspPeriodCode = "FundingStreamPeriod-CreateFundingStreamPeriodDeliverable-1";
            DeleteFundingStreamDeliverable(fspDelName);
            DeleteFundingStreamPeriod(fspPeriodCode);
            IOrganizationService organizationService = GetConnection();
            CreateFundingStreamPeriodDeliverable(fspDelName, fspPeriodCode);

            FundingStreamDeliverablePeriodRepository fundingStreamDeliverablePeriodRepository = new FundingStreamDeliverablePeriodRepository();

            // act
            IReadOnlyCollection<sfa_fundingstreamperioddeliverable> fundingStreamPeriodDeliverables;
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                fundingStreamPeriodDeliverables = fundingStreamDeliverablePeriodRepository.GetFundingStreamPeriodDeliverables(xrmContext,fspPeriodCode);
            }

            // assert
            Assert.AreEqual(1, fundingStreamPeriodDeliverables.Count);
            Assert.IsTrue(fundingStreamPeriodDeliverables.Any(f => f.sfa_name == fspDelName));

            // clean-up (see 21922)
            DeleteFundingStreamDeliverable(fspDelName);
            DeleteFundingStreamPeriod(fspPeriodCode);
        }

        private static void CreateFundingStreamPeriodDeliverable(string fspDelName, string fspCode)
        {
            var organizationService = GetConnection();

            sfa_fundingstreamperioddeliverable fundingStreamPeriodDeliverable = new sfa_fundingstreamperioddeliverable
            {
                sfa_name = fspDelName,
                sfa_FundingStreamPeriodId = CreateFundingStreamPeriod(fspCode)
            };

            Guid guid = organizationService.Create(fundingStreamPeriodDeliverable);

            var fspDelRetrieved = (sfa_fundingstreamperioddeliverable)organizationService.Retrieve(sfa_fundingstreamperioddeliverable.EntityLogicalName, guid, new ColumnSet(true));
            fspDelRetrieved.sfa_name = fspDelName;
            organizationService.Update(fspDelRetrieved);
        }

        private static EntityReference CreateFundingStreamPeriod(string fspCode)
        {
            sfa_fundingstreamperiod fundingstreamperiod = new sfa_fundingstreamperiod
            {
                sfa_fundingstreamperiodcode = fspCode
            };
            IOrganizationService organizationService = GetConnection();
            return new EntityReference(sfa_fundingstreamperiod.EntityLogicalName, organizationService.Create(fundingstreamperiod));
        }

        private static void DeleteFundingStreamDeliverable(string fspDelName)
        {
            IOrganizationService organizationService = GetConnection();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                List<Guid> guids = xrmContext.sfa_fundingstreamperioddeliverableSet.Where(fsp => fsp.sfa_name == fspDelName).Select(fsp => fsp.Id).ToList();

                guids.ForEach(fsp =>
                {
                    organizationService.Delete(sfa_fundingstreamperioddeliverable.EntityLogicalName,fsp);
                });
            }
        }

        private static void DeleteFundingStreamPeriod(string fspPeriod)
        {
            IOrganizationService organizationService = GetConnection();
            using (var xrmContext = new XrmServiceContext(organizationService))
            {
                List<Guid> guids =
                    xrmContext.sfa_fundingstreamperiodSet.Where(fsp => fsp.sfa_fundingstreamperiodcode == fspPeriod)
                        .Select(fsp => fsp.Id)
                        .ToList();

                guids.ForEach(fsp =>
                {
                    organizationService.Delete(sfa_fundingstreamperiod.EntityLogicalName, fsp);
                });
            }
        }

        private static IOrganizationService GetConnection()
        {
            var xrmConnection =
               CrmConnection.Parse(ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString);

            return new OrganizationService(xrmConnection);
        }
    }
}
