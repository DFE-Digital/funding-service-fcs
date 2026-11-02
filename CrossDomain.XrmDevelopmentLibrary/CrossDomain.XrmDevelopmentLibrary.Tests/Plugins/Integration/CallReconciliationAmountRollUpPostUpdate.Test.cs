using System;
using Microsoft.Xrm.Sdk;
using Xrm.Framework.Test.Integration;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk.Query;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins.Integration
{
    [TestClass]
    public class CallReconciliationAmountRollUpPostUpdate : PluginIntegrationTest
    {

        private Guid fcrId = Guid.Empty;
        private Guid fcrAllocation1Id = Guid.Empty;
        private Guid fcrAllocation2Id = Guid.Empty;
        protected override OrganizationRequest SetupTriggerRequest()
        {

            //create a fcr

            var fcr = new Entity("sfa_fundingclaimreconciliation");
            fcr["sfa_name"] = "Reconciliation Amount Rollup Post Integration Test FCR Record";
            fcr["sfa_reconciliationvalue"] = 100.00m;
            fcrId = OrganizationService.Create(fcr);

            //create a fcrallocation
            var fcra1 = new Entity("sfa_fcrallocation");
            fcra1["sfa_name"] = "Reconciliation Amount Rollup Post Integration Test FCR Record 1";
            fcra1["sfa_fundingclaimreconciliationid"] = new EntityReference("sfa_fundingclaimreconciliation", fcrId);
            fcra1["sfa_reconciliationvalue"] = 100.00m;
            fcrAllocation1Id = OrganizationService.Create(fcra1);

            //create a fcrallocation
            var fcra2 = new Entity("sfa_fcrallocation");
            fcra2["sfa_name"] = "Reconciliation Amount Rollup Post Integration Test FCR Record 2";
            fcra2["sfa_fundingclaimreconciliationid"] = new EntityReference("sfa_fundingclaimreconciliation", fcrId);
            fcrAllocation2Id = OrganizationService.Create(fcra2);


            //Update FCRAllocation
            var updateFCRA = new Entity("sfa_fcrallocation");
            updateFCRA.Id = fcrAllocation2Id;
            updateFCRA["sfa_reconciliationvalue"] = 200.00m;

            UpdateRequest request = new UpdateRequest();
            request.Target = updateFCRA;
            return request;
        }

        [TestMethod, TestCategory("Sync Integration Plugin Test")]
        public void RunReconciliationAmountRollUpPostUpdate()
        {
            base.Test();
        }

        protected override void Verify()
        {
            //Retrieve FCR record and verify the sum is rollup from FCRA1 and FCRA2 and equals to 300.00
             var fcr = OrganizationService.Retrieve("sfa_fundingclaimreconciliation", fcrId, new ColumnSet(new string[] { "sfa_reconciliationvalue" }));
             Assert.AreEqual(300.00m, (decimal)fcr["sfa_reconciliationvalue"]);


        }

        protected override void CleanUp()
        {
            OrganizationService.Delete("sfa_fundingclaimreconciliation", fcrId);

            base.CleanUp();

        }

    }
}
