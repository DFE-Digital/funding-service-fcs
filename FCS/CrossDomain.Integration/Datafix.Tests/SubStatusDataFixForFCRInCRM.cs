using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Client;
using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Datafix.Tests
{

    [TestClass]
    public class SubStatusDataFixForFCRInCRM 
    {

        #region Setup
        private int recordsProcessed = 0;
        private int PUBLISH_IN_PROGRESS = 229660002;
        private int SUBSTATUS_DRAFT = 229660000;
        private int SUBSTATUS_PUBLISHED = 229660003;
        #endregion


        [TestMethod, TestCategory("DataFix_R32")]
        public void ApplySubStatusDataFixForFCRInCRM()
        {
            try
            {
                OrganizationService service = new OrganizationService(GetConnection());
                CrmOrganizationServiceContext _xrmContext = new CrmOrganizationServiceContext(service);

                List<Entity> fcrsToBeProcessed = GetFundingClaimReconcillationRecords(_xrmContext);
                UpdateFCRSubStatus(fcrsToBeProcessed, service);
                System.Diagnostics.Trace.WriteLine("Total Record Count Processed: " + recordsProcessed);

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
               new CrmConnection("CrmConnectionString");

            return new OrganizationService(xrmConnection);
        }

        private List<Entity> GetFundingClaimReconcillationRecords(CrmOrganizationServiceContext xrmContext)
        {

            List<Entity> fcrRecords = (from fcr in xrmContext.CreateQuery("sfa_fundingclaimreconciliation")
                                         where (fcr["sfa_statuscode"] != null) 
                                         select fcr).ToList();

            return fcrRecords;

        }

        private void UpdateFCRSubStatus(List<Entity> fcrsToBeProcessed, OrganizationService service)
        {
            recordsProcessed = 0;
            foreach (Entity fcr in fcrsToBeProcessed)
            {
                recordsProcessed++;
                int statuscode = fcr.GetAttributeValue<OptionSetValue>("sfa_statuscode").Value;
                var statuslabel = fcr.FormattedValues["sfa_statuscode"].ToString();
                if ((statuscode > 0)&&(statuscode != PUBLISH_IN_PROGRESS))
                { 

                        Entity fcrToUpdate = new Entity("sfa_fundingclaimreconciliation");
                        fcrToUpdate.Id = fcr.Id;

                        if (statuslabel == "Draft")
                        {
                            fcrToUpdate.Attributes["sfa_substatus"] = new OptionSetValue(SUBSTATUS_DRAFT);
                        } else if (statuslabel == "Published")
                        {
                            fcrToUpdate.Attributes["sfa_substatus"] = new OptionSetValue(SUBSTATUS_PUBLISHED);
                        }
                        
                        service.Update(fcrToUpdate);
                }
            }
        }


        #endregion    

    }
}
