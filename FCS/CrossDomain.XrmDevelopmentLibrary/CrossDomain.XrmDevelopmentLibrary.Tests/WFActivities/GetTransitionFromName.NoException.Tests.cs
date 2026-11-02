
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
    public class GetTransitionFromNameTest : WFActivityUnitTest
    {
        protected static IDisposable Context { get; set; }

        #region Instance Variables

        private Guid _reassignGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");

        private const string ReassignStatusValue = "Reassign";
        private const string InputTransition = "InputTransition";
        private const string OutputTransition = "OutputTransition";

        #endregion

        #region Setup

        protected override Activity SetupActivity()
        {
            var transition1 = new Entity(XrmMetadata.Transition);
            transition1.Id = _reassignGuid;
            transition1.Attributes[XrmMetadata.TransitionName] = ReassignStatusValue;

            var transitionCollection = new EntityCollection();
            transitionCollection.Entities.Add(transition1);

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
        public void RunGetTransitionFromNameNoException()
        {
            base.Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNull(Error);
            Assert.AreEqual(((EntityReference)Outputs[OutputTransition]).Id, _reassignGuid, "The guid returned by the workflow activity is incorrect");
        }

        #endregion
    }
}
