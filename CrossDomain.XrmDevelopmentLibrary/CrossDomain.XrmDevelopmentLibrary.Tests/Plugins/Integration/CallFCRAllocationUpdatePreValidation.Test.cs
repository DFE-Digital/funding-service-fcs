using System;
using Microsoft.Xrm.Sdk;
using Xrm.Framework.Test.Integration;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins.Integration
{
    [TestClass]
    public class CallFCRAllocationUpdatePreValidation : PluginIntegrationTest
    {
        private Guid fcrId = Guid.Empty;
        private Guid fcrAllocationId = Guid.Empty;
        protected override OrganizationRequest SetupTriggerRequest()
        {
          
            //create a fcr
        
            var fcr = new Entity("sfa_fundingclaimreconciliation");
            fcr["sfa_name"] = "FCR Allocation Update PreValidation Test Test FCR Record";
            fcr["sfa_statuscode"] = new OptionSetValue(229660001);
            fcrId = OrganizationService.Create(fcr);

            //create a fcrallocation
            var fcra = new Entity("sfa_fcrallocation");
            fcra["sfa_name"] = "FCR Allocation Update PreValidation Test FCR Allocation Record";
            fcra["sfa_fundingclaimreconciliationid"] = new EntityReference("sfa_fundingclaimreconciliation", fcrId);
            fcrAllocationId = OrganizationService.Create(fcra);


            //Update FCRAllocation
            var updateFCRA = new Entity("sfa_fcrallocation");
            updateFCRA.Id = fcrAllocationId;
            updateFCRA["sfa_reconciliationvalue"] = 100.00;

            UpdateRequest request = new UpdateRequest();
            request.Target = updateFCRA;
            return request;
        }

        [TestMethod, TestCategory("Sync Integration Plugin Test")]
        public void RunFCRAllocationUpdatePreValidation()
        {  
            base.Test();
        }

        protected override void Verify()
        {
           
            Assert.IsNotNull(Error);
            Assert.IsTrue(Error.Message.Equals("Cannot update this FCR Allocation since its associated Funding Claim Reconciliation record is in 'PUBLISHED' status"),
                  "Incorrect Message Returned");

         
        }

        protected override void CleanUp()
        {
            OrganizationService.Delete("sfa_fundingclaimreconciliation", fcrId);
           
            base.CleanUp();
           
        }

    }
}
