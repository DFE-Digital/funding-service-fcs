namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.WFActivities
{
    using Common;
    using System;
    using System.Collections.Generic;
    using System.Activities;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Xrm.Framework.Test.Unit.Fakes;
    using Microsoft.QualityTools.Testing.Fakes;
    using Microsoft.Xrm.Sdk.Messages.Fakes;
    using Workflow.ContractAllocation;
    using Workflow.Status;


    [TestClass]
    public class GetContractAllocationFromReferenceTest : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private readonly Guid _allocationGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");

        private const string AllocationRef = "ALL-001";

        private const string InputAllocation = "InputAllocation";

        private const string OutputAllocation = "OutputAllocation";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var allocation1 = new Entity(XrmMetadata.ContractAllocation);
            allocation1.Id = _allocationGuid;
            allocation1.Attributes[XrmMetadata.StatusName] = AllocationRef;

            var allocationCollection = new EntityCollection();
            allocationCollection.Entities.Add(allocation1);

            Context = ShimsContext.Create();

            var allocationResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => allocationCollection
            };
         
            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq => allocationResponse;

            var inputs = new Dictionary<string, object>
            {
                { InputAllocation, AllocationRef }
            };

            Inputs = inputs;

            Activity activity = new GetContractAllocationFromReference();

            return activity;
        }

        [TestCleanup]
        public void DisposeShims()
        {
            Context.Dispose();
            Context = null;
        }

        #endregion

        #region Test

        [TestMethod, TestCategory("UnitTest")]
        public void RunGetContractAllocationFromReferenceNoException()
        {
            base.Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNull(Error);
            Assert.AreEqual(((EntityReference)Outputs[OutputAllocation]).Id, _allocationGuid, "The guid returned by the workflow activity is incorrect");
        }

        #endregion
    }
}
