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
    public class GetStatusFromNameTest : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private Guid _inreviewGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");

        private const string InReviewStatusValue = "In Review";
        private const string InputStatus = "InputStatus";
        private const string OutputStatus = "OutputStatus";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var Status1 = new Entity(XrmMetadata.Status);
            Status1.Id = _inreviewGuid;
            Status1.Attributes[XrmMetadata.StatusName] = InReviewStatusValue;

            var StatusCollection = new EntityCollection();
            StatusCollection.Entities.Add(Status1);

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
        public void RunGetStatusFromNameNoException()
        {
            base.Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNull(Error);
            Assert.AreEqual(((EntityReference)Outputs[OutputStatus]).Id, _inreviewGuid, "The guid returned by the workflow activity is incorrect");
        }

        #endregion
    }
}
