using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using ContractCreateDomain.Integration.XrmService.Tests.IntegrationTests;
using System;
using System.Collections.Generic;
using System.Linq;

namespace ContractCreateDomain.Integration.XrmService.Tests.DataFix
{
    [TestClass]
    public class UpdateDeliverableAllocReferenceInCRM : IntegrationTestBase
    {
        #region Setup
        private int recordsProcessed = 0;
        #endregion

        #region Test
        [TestMethod, TestCategory("DataFix_R18")]
        public void ApplyDeliverableAllocReferenceFixInCRM()
        {
            try
            {
                OrganizationService service = new OrganizationService(GetConnection());
                CrmOrganizationServiceContext _xrmContext = new CrmOrganizationServiceContext(service);

                List<Entity> relatedDeliverables = GetRelatedDeliverables(_xrmContext);
                UpdateDeliverableReference(relatedDeliverables, _xrmContext, service);

                System.Diagnostics.Debug.WriteLine("Total Record Count Processed: " + recordsProcessed);

            }
            catch (Exception)
            {
                Assert.Fail(); 
            }

        }
        #endregion

        #region  Function Calls
        private IOrganizationService GetConnection()
        {
            var xrmConnection =
               new CrmConnection("CrmConnectionString");

            return new OrganizationService(xrmConnection);
        }

        private List<Entity> GetRelatedDeliverables(CrmOrganizationServiceContext xrmContext)
        {

            List<Entity> deliverables = (from d in xrmContext.CreateQuery("sfa_contractdeliverable")
                                         where ((d["sfa_allocationref"] == null) || (((string)d["sfa_allocationref"]).Equals(string.Empty)))
                                         select d).ToList();

            return deliverables;

        }

        private void UpdateDeliverableReference(List<Entity> relatedDeliverables, CrmOrganizationServiceContext xrmContext, OrganizationService service)
        {
            recordsProcessed = 0;
            foreach (Entity deliverable in relatedDeliverables)
            {
                recordsProcessed++;
                EntityReference allocRef = (EntityReference)deliverable.GetAttributeValue("sfa_contractallocationid");
                if (allocRef != null)
                {
                    string assocAllocNumber = GetAllocationReference(allocRef.Id, xrmContext);                   
                    if (assocAllocNumber != null)
                    {
                        Entity deliverableToUpdate = new Entity("sfa_contractdeliverable");
                        deliverableToUpdate.Id = deliverable.Id;
                        deliverableToUpdate.Attributes["sfa_allocationref"] = assocAllocNumber;
                        service.Update(deliverableToUpdate);
                    }
                }
            }
        }

        private string GetAllocationReference(Guid allocationId, CrmOrganizationServiceContext xrmContext)
        {
            string allocationReference = (from a in xrmContext.CreateQuery("sfa_contractallocation")
                                          where ((Guid)a["sfa_contractallocationid"] == allocationId)
                                          select (string)a["sfa_contractallocationnumber"]).FirstOrDefault();

            return allocationReference;
        }
        #endregion
    }
}
