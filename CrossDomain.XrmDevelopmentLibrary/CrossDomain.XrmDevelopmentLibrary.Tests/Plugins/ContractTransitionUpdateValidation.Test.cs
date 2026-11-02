using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.QualityTools.Testing.Fakes;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Messages.Fakes;
using Xrm.Framework.Test.Unit.Fakes;
using Microsoft.Xrm.Sdk.Query;
using global::CrossDomain.XrmDevelopmentLibrary.Plugins;
using SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Common;


namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins
{
    [TestClass]
    public class ContractTransitionUpdateValidationTest : PluginUnitTest
    {
        protected static IDisposable Context { get; set; }


        [TestMethod, TestCategory("PluginTest")]       
        public void ApprovalTypeValidationUnitTest()
        {
           
                Test();
               
           

        }

        #region SetupTests

        [TestInitialize]
        public void SetupTests()
        {
            SetPluginEvent("sfa_contract", "Update", Xrm.Framework.Test.Unit.SdkMessageProcessingStepImage.PreValidation);

            Entity targetEntity = new Entity("sfa_contract")
            {
                Id = new Guid("D649F257-86CE-E511-940E-000D3AB03A58")
              };

            targetEntity.Attributes["sfa_nextaction"] = new EntityReference("sfa_transition", new Guid("0666AE82-0712-E611-9414-000D3AB03A58"));
          
            SetTarget(targetEntity);         


            Context = ShimsContext.Create();

            OrganizationServiceStub.RetrieveStringGuidColumnSet = (entityName, id, columns) =>
            {
                switch (entityName)
                {
                    case "sfa_contract":
                        var fakecontract = new Entity("sfa_contract");
                        fakecontract.Attributes["sfa_nextaction"] = new EntityReference("sfa_transition", new Guid("0666AE82-0712-E611-9414-000D3AB03A58"));
                        fakecontract.Attributes["sfa_fundingtype"] = new EntityReference("sfa_fundingtype",Guid.NewGuid());
                        fakecontract.Attributes["sfa_periodid"] = new EntityReference("sfa_period", Guid.NewGuid());
                        return fakecontract;
                    case "sfa_transition":
                        var faketransition = new Entity("sfa_transition");
                        faketransition.Attributes["sfa_name"] = "Initiate Manual Publish To Provider";
                        return faketransition;
                   
                    default:
                        return null;
                }
            
            };


            var FTFP = new Entity("sfa_fundingtypefundingperiod")
            {
                Id = Guid.NewGuid()
            };
            FTFP["sfa_approvaltype"] = new OptionSetValue(229660000);
      
            var ftfpCollectionUnfiltered = new EntityCollection();
            ftfpCollectionUnfiltered.Entities.AddRange(FTFP);

            var ftfpResponseUnfiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => ftfpCollectionUnfiltered
            };

          
            OrganizationServiceStub.ExecuteOrganizationRequest = (query) => 
            {
                EntityCollection entities = new EntityCollection();


                if (query is RetrieveMultipleRequest &&
                    (((QueryExpression)((RetrieveMultipleRequest)query).Query).EntityName == "sfa_fundingtypefundingperiod"))
                {
                    return ftfpResponseUnfiltered;
                }

                return null;                

            };

            OrganizationServiceStub.RetrieveMultipleQueryBase = (query) =>
            {
                EntityCollection entities = new EntityCollection();

                if (query is QueryExpression && ((QueryExpression)query).EntityName == "sfa_fundingtypefundingperiod")
                {
                    Entity ftfp = new Entity("sfa_fundingtypefundingperiod");
                    ftfp["sfa_approvaltype"] = new OptionSetValue(229660000);
                    entities.Entities.Add(ftfp);
                }
                return entities;
            };

           
        }

        [TestCleanup]
        public void DisposeShims()
        {
            Context.Dispose();
            Context = null;
        }

        #endregion
        
        #region Verify

        protected override void Verify()
        {

            //if (Error is InvalidPluginExecutionException)
            //{
            //   Assert.IsFalse(Error.Message.Equals("This contract has been restricted to set next action to INITATE MANUAL PUBLISH TO PROVIDER."), 
            //        "Web service call is not authorised");
            //}

            Assert.IsNotNull(Error);
            Assert.IsInstanceOfType(Error, typeof(InvalidPluginExecutionException), "The exception thrown was not of type InvalidPluginExecutionException");
            Assert.IsTrue(Error.Message.Equals("INITIATE MANUAL PUBLICATION TO PROVIDER is is not permitted for this type of contract"),
                  "Incorrect Message Returned");
        }

        #endregion

        protected override IPlugin SetupPlugin()
        {
            var plugin = new ContractTransitionUpdateValidation();

            return plugin;
        }
    }
}
