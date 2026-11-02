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
    using Workflow.Status;

    [TestClass]
    public class GetStatusFromNameInvalidPluginExecutionException : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private const string InReviewStatusValue = "In Review";
        private const string UnassignedStatusValue = "Unassigned";
        private const string InputStatus = "InputStatus";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var Status1 = new Entity(XrmMetadata.Status);
            Status1.Id = Guid.NewGuid();
            Status1.Attributes[XrmMetadata.StatusName] = InReviewStatusValue;

            var Status2 = new Entity(XrmMetadata.Status);
            Status2.Id = Guid.NewGuid();
            Status2.Attributes[XrmMetadata.StatusName] = UnassignedStatusValue;

            var StatusCollection = new EntityCollection();
            StatusCollection.Entities.AddRange(Status1, Status2);

            Context = ShimsContext.Create();

            var StatusResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => StatusCollection
            };
         
            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
            {
                return StatusResponse;
            };

            var inputs = new Dictionary<string, object>
            {
                { InputStatus, InReviewStatusValue }
            };

            Inputs = inputs;

            Activity activity = new GetStatusFromName();

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
        public void RunGetStatusFromNameInvalidPluginExecutionException()
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
