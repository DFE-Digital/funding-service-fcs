//namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.WFActivities
//{
//    using System;
//    using Common;
//    using Microsoft.QualityTools.Testing.Fakes;
//    using Microsoft.VisualStudio.TestTools.UnitTesting;
//    using Microsoft.Xrm.Sdk;
//    using Microsoft.Xrm.Sdk.Messages;
//    using Microsoft.Xrm.Sdk.Messages.Fakes;
//    using Xrm.Framework.Test.Unit.Fakes;
//    using Microsoft.Xrm.Sdk.Query;
//    using global::CrossDomain.XrmDevelopmentLibrary.Plugins;

//    [TestClass]
//    public class CallContractDeliverableDetectDuplicate : PluginUnitTest
//    {
//        protected static IDisposable Context { get; set; }

//        #region Test

//        [TestMethod, TestCategory("IntegrationTest")]
//        public void CallContractManagementServiceThrowsThrown()
//        {
//            Test();
//        }

//        #endregion

//        #region Verify

//        protected override void Verify()
//        {
//            if (Error is InvalidPluginExecutionException)
//            {
//                Assert.AreEqual(OperationStatus.Retry,
//                    ((InvalidPluginExecutionException) Error).Status,
//                    "Operation Status is incorrect");
//                Assert.IsFalse(Error.Message.Contains("Unauthorized"), "Web service call is not authorised");
//            }
//        }

//        #endregion

//        #region Setup

//        [TestInitialize]
//        public void SetupTests()
//        {
//            var parentcontractid = Guid.NewGuid();
//            var contract1 = new Entity(XrmMetadata.Contract)
//            {
//                Id = Guid.NewGuid()
//            };
//            contract1.Attributes[XrmMetadata.ContractNumber] = "10000001";
//            contract1.Attributes["sfa_parentcontractid"] = new EntityReference("sfa_contract", parentcontractid);;

//            var contract2 = new Entity(XrmMetadata.Contract)
//            {
//                Id = Guid.NewGuid()
//            };
//            contract1.Attributes[XrmMetadata.ContractNumber] = "20000001";
//            contract1.Attributes["sfa_contractid"] = new EntityReference("sfa_contract", parentcontractid); ;

//            var contractCollectionUnfiltered = new EntityCollection();
//            contractCollectionUnfiltered.Entities.AddRange(contract1, contract2);

//            Context = ShimsContext.Create();

//            var contractResponseUnfiltered = new ShimRetrieveMultipleResponse
//            {
//                EntityCollectionGet = () => contractCollectionUnfiltered
//            };

//            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
//            {
//                if (orgReq is RetrieveMultipleRequest &&
//                    (((QueryExpression)((RetrieveMultipleRequest)orgReq).Query).EntityName == XrmMetadata.Contract))
//                {
//                    return contractResponseUnfiltered;
//                }

//                return null;
//            };
//        }


//        [TestCleanup]
//        public void DisposeShims()
//        {
//            Context.Dispose();
//            Context = null;
//        }

        
//        #endregion

//        protected override IPlugin SetupPlugin()
//        {
//            var plugin = new ContractDeliverableDetectDuplicate();

//            return plugin;
//        }
//    }
//}