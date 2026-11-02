using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.QualityTools.Testing.Fakes;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Messages.Fakes;
using Xrm.Framework.Test.Unit.Fakes;
using Microsoft.Xrm.Sdk.Query;
using global::CrossDomain.XrmDevelopmentLibrary.Plugins;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Plugins
{

    [TestClass]
    public class CallEntityUpdateWithFilter : PluginUnitTest
    {

        protected static IDisposable Context { get; set; }
        protected override IPlugin SetupPlugin()
        {
            var plugin = new EntityUpdateWithFilter();

            return plugin;
        }

        [TestMethod, TestCategory("PluginTest")]
        public void EntityUpdateWithFilterUnitTest()
        {
           Test();
        }


        [TestInitialize]
        public void SetupTests()
        {
            SetPluginEvent("sfa_fundingclaimreconciliation", "Update", Xrm.Framework.Test.Unit.SdkMessageProcessingStepImage.PreValidation);

            Entity targetEntity = new Entity("sfa_fundingclaimreconciliation")
            {
                Id = new Guid("D649F257-86CE-E511-940E-000D3AB03A58")
            };

            targetEntity.Attributes["sfa_fundingclaimreconciliationid"] = 100;
            SetTarget(targetEntity);


            Context = ShimsContext.Create();

            
            OrganizationServiceStub.RetrieveStringGuidColumnSet = (entityName, id, columns) =>
            {
                switch (entityName)
                {
                    case "sfa_fundingclaimreconciliation":
                        var fakefcr = new Entity("sfa_fundingclaimreconciliation");
                        fakefcr.Attributes["sfa_statuscode"] = new OptionSetValue(229660001);
                        return fakefcr;
                  
                    default:
                        return null;
                }

            };
           

            OrganizationServiceStub.RetrieveMultipleQueryBase = (query) =>
            {
                EntityCollection entities = new EntityCollection();

                //if (query is QueryExpression && ((QueryExpression)query).EntityName == "role")
                //{
                //    return null;
                //}
                return entities;
            };


        }

        [TestCleanup]
        public void DisposeShims()
        {
            Context.Dispose();
            Context = null;
        }


        #region Verify

        protected override void Verify()
        {
            Assert.IsNotNull(Error);
            Assert.IsInstanceOfType(Error, typeof(InvalidPluginExecutionException), "The exception thrown was not of type InvalidPluginExecutionException");
            Assert.IsTrue(Error.Message.Equals("Cannot update this Funding Claim Reconciliation since it is in 'PUBLISHED' status"),
                  "Incorrect Message Returned");

        }

        #endregion



    }
}
