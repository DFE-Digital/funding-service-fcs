using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Xrm.Sdk.Query;
using System.Threading.Tasks;
using System.Collections;
using Microsoft.Xrm.Sdk.Messages;

namespace ContractCreateDomain.Integration.XrmService.Tests.DataFix
{

    [TestClass]
    public class UKPRNDataFixForFCRInCRM : IntegrationTestBase
    {
        private const string CrmConnectionString = @"<INSERT CRM CONNECTION STRING>";

        #region Setup
        private int recordsProcessed = 0;
        #endregion


        [TestMethod, TestCategory("DataFix_R30")]
        public void ApplyUKPRNDataFixForFCRInCRM()
        {
            try
            {
                OrganizationService service = new OrganizationService(GetConnection());
                CrmOrganizationServiceContext _xrmContext = new CrmOrganizationServiceContext(service);

                List<Entity> fcrsToBeProcessed = GetFundingClaimReconcillationRecords(_xrmContext);
                UpdateUKPRNReference(fcrsToBeProcessed, _xrmContext, service);


            }
            catch (Exception)
            {
                Assert.Fail();
            }

        }

        #region  Function Calls
        private IOrganizationService GetConnection()
        {
            var xrmConnection =
               CrmConnection.Parse(CrmConnectionString);

            return new OrganizationService(xrmConnection);
        }

        private List<Entity> GetFundingClaimReconcillationRecords(CrmOrganizationServiceContext xrmContext)
        {

            List<Entity> fcrRecords = (from fcr in xrmContext.CreateQuery("sfa_fundingclaimreconciliation")
                                         where (fcr["sfa_providerid"] != null) 
                                         select fcr).ToList();

            return fcrRecords;

        }

        private void UpdateUKPRNReference(List<Entity> fcrsToBeProcessed, CrmOrganizationServiceContext xrmContext, OrganizationService service)
        {
            recordsProcessed = 0;
            foreach (Entity fcr in fcrsToBeProcessed)
            {
                recordsProcessed++;
                EntityReference providerRef = (EntityReference)fcr.GetAttributeValue("sfa_providerid");
                if (providerRef != null)
                {
                    string UKPRN = GetProviderUKPRN(providerRef.Id, xrmContext);
                    if (UKPRN != null)
                    {
                        Entity fcrToUpdate = new Entity("sfa_fundingclaimreconciliation");
                        fcrToUpdate.Id = fcr.Id;
                        fcrToUpdate.Attributes["sfa_ukprn"] = UKPRN;
                        service.Update(fcrToUpdate);

                        //update associated fcr allocations
                        List<Entity> fcrAllocationRecords = GetAssociatedFCRAllocationRecords(xrmContext,fcr.Id);
                        if ((fcrAllocationRecords != null) && (fcrAllocationRecords.Any()))
                        {
                            foreach (Entity fcrallocation in fcrAllocationRecords)
                            {
                                Entity fcrAllocationToUpdate = new Entity("sfa_fcrallocation");
                                fcrAllocationToUpdate.Id = fcrallocation.Id;
                                fcrAllocationToUpdate.Attributes["sfa_ukprn"] = UKPRN;
                                service.Update(fcrAllocationToUpdate);

                            }

                        }
                    }
                }
            }
        }

        private string GetProviderUKPRN(Guid providerId, CrmOrganizationServiceContext xrmContext)
        {
            string ukprn = (from a in xrmContext.CreateQuery("account")
                            where ((Guid)a["accountid"] == providerId)
                            select (string)a["sfa_ukprn"]).FirstOrDefault();

            return ukprn;
        }

        private List<Entity> GetAssociatedFCRAllocationRecords(CrmOrganizationServiceContext xrmContext,Guid fcrId)
        {

            List<Entity> fcrAllocationRecords = (from fcrallocation in xrmContext.CreateQuery("sfa_fcrallocation")
                                       where ((Guid)fcrallocation["sfa_fundingclaimreconciliationid"] == fcrId)
                                       select fcrallocation).ToList();

            return fcrAllocationRecords;

        }

        #endregion    

    }
}
