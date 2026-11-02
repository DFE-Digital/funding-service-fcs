namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.WFActivities
{
    using System;
    using System.Activities;
    using System.Collections.Generic;
    using System.ServiceModel;
    using Microsoft.QualityTools.Testing.Fakes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Messages.Fakes;
    using Microsoft.Xrm.Sdk.Query;
    using Workflow.Organisations;
    using Xrm.Framework.Test.Unit.Fakes;
    using Common;

    [TestClass]
    public class ContractAssignmentTestRetrieveMultipleException : WFActivityUnitTest
    {
        private const string InputContract = "InputContract";
        private const string InputTeam = "InputTeam";
        private const string InputSystemUser = "InputSystemUser";

        #region Test

        [TestMethod, TestCategory("UnitTest")]
        public void WhenRetrieveMultipleReturnsFaultExceptionInvalidPluginExecutionExceptionThrown()
        {
            Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNotNull(Error, "An Exception was not thrown for a FaultException returned by retrievemultiple");
            Assert.IsInstanceOfType(Error, typeof (InvalidPluginExecutionException),
                "The exception thrown was not of type InvalidPluginExecutionException");
        }

        #endregion

        #region Instance Variables

        private const string _errorMsg = "An error occured re-assigning the tasks";

        private readonly Guid _unassignedTeamGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");
        private readonly string _unassignedTeamName = "Unassigned";
        private readonly Guid _contractGuid = new Guid("0380e049-6872-4562-9630-1c5ff30085ef");
        private readonly Guid _newAssigneeUserGuid = new Guid("807d314d-4bef-4e58-8e5b-3b0a93e4c7fa");

        protected static IDisposable Context { get; set; }

        #endregion

        #region Setup

        [TestInitialize]
        public void SetupTests()
        {
            var team = new Entity(XrmMetadata.Team);
            team.Id = _unassignedTeamGuid;
            team.Attributes[XrmMetadata.TeamName] = _unassignedTeamName;

            var teamCollection = new EntityCollection();
            teamCollection.Entities.Add(team);

            Context = ShimsContext.Create();

            var teamResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => teamCollection
            };

            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
            {
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression) ((RetrieveMultipleRequest) orgReq).Query).EntityName == XrmMetadata.Team))
                {
                    return teamResponse;
                }
                throw new FaultException<OrganizationServiceFault>(new OrganizationServiceFault(),
                    new FaultReason("Invalid Query"));
            };
        }


        [TestCleanup]
        public void DisposeShims()
        {
            Context.Dispose();
            Context = null;
        }

        protected override Activity SetupActivity()
        {
            var inputs = new Dictionary<string, object>
            {
                { InputContract, new EntityReference(XrmMetadata.Contract, _contractGuid) },
                { InputTeam, _unassignedTeamName },
                { InputSystemUser, new EntityReference(XrmMetadata.SystemUser, _newAssigneeUserGuid) }
            };

            Inputs = inputs;

            Activity activity = new ReassignChildTasksForContract();

            return activity;
        }

        #endregion
    }
}