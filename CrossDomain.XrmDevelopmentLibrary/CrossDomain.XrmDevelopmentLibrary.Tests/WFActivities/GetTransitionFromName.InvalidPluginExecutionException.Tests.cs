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
    using Workflow.Transition;

    [TestClass]
    public class GetTransitionFromNameInvalidPluginExecutionException : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private const string ReassignStatusValue = "Reassign";
        private const string ApproveStatusValue = "Approve";
        private const string InputTransition = "InputTransition";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var transition1 = new Entity(XrmMetadata.Transition);
            transition1.Id = Guid.NewGuid();
            transition1.Attributes[XrmMetadata.TransitionName] = ReassignStatusValue;

            var transition2 = new Entity(XrmMetadata.Transition);
            transition2.Id = Guid.NewGuid();
            transition2.Attributes[XrmMetadata.TransitionName] = ApproveStatusValue;

            var transitionCollection = new EntityCollection();
            transitionCollection.Entities.AddRange(transition1, transition2);

            Context = ShimsContext.Create();

            var transitionResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => transitionCollection
            };
         
            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
            {
                return transitionResponse;
            };

            var inputs = new Dictionary<string, object>
            {
                { InputTransition, ReassignStatusValue }
            };

            Inputs = inputs;

            Activity activity = new GetTransitionFromName();

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
        public void RunGetTransitionFromNameInvalidPluginExecutionException()
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
