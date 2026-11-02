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
    public class GetContractAllocationFromReferenceInvalidPluginExecutionExceptionTest : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private const string AllocationRef = "ALL-001";

        private const string InputAllocation = "InputAllocation";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var allocationCollection = new EntityCollection();
            allocationCollection.Entities.AddRange();

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
        public void RunGetContractAllocationFromReferenceInvalidPluginExecutionException()
        {
            base.Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNotNull(Error);
            Assert.IsInstanceOfType(Error, typeof(InvalidPluginExecutionException), "The exception thrown was not of type InvalidPluginExecutionException");
        }

        #endregion
    }
}
