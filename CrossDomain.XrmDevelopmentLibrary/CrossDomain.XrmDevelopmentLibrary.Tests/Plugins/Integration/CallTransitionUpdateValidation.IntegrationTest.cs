using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Xrm.Sdk;
using Xrm.Framework.Test.Integration;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins.Integration
{
    [TestClass]
    public class CallTransitionUpdateValidation : PluginIntegrationTest
    {
        protected override OrganizationRequest SetupTriggerRequest()
        {
            //Update Contract
            Entity contract = new Entity("sfa_contract");
            contract.Id = new Guid("{2D5E3B6D-999D-E511-80E4-000D3AB031FE}");
            contract["sfa_nextaction"] = new EntityReference("sfa_transition", new Guid("{0666AE82-0712-E611-9414-000D3AB03A58}"));
            
            UpdateRequest request = new UpdateRequest();
            request.Target = contract;

            


            return request;
        }

        [TestMethod, TestCategory("Sync Integration Plugin Test")]
        public void RunCallTransitionUpdateValidation()
        {
            base.Test();
        }

        protected override void Verify()
        {
           
            Assert.IsNotNull(Error);
           Assert.IsTrue(Error.Message.Equals("Cannot update this Funding Claim Reconciliation since it is in 'PUBLISHED' status"),
                  "Incorrect Message Returned");

           }

        protected override void CleanUp()
        {
            base.CleanUp();

        }

          
    }
}
