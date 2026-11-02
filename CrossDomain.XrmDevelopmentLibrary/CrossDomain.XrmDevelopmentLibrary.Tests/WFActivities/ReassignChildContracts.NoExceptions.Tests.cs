using System;
using System.Activities;
using System.Collections.Generic;
using System.ServiceModel;
using Microsoft.Crm.Sdk.Messages;
using Microsoft.QualityTools.Testing.Fakes;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Xrm.Sdk;
using Microsoft.Xrm.Sdk.Messages;
using Microsoft.Xrm.Sdk.Messages.Fakes;
using Microsoft.Xrm.Sdk.Query;
using SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Workflow.Organisations;
namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.WFActivities
{
    using System.Diagnostics.Contracts;
    using Common;
    using Xrm.Framework.Test.Unit.Fakes;

    [TestClass]
    public class OrganisationAssignmentSuccesfulNoException : WFActivityUnitTest
    {

        private const string InputOrganisation = "InputOrganisation";
        private const string InputTeam = "InputTeam";
        private const string InputSystemUser = "InputSystemUser";
        private const string InputUpdateContractOwner = "InputUpdateContractOwner";
        private const string InputUpdateTaskOwner = "InputUpdateTaskOwner";
        protected static IDisposable Context { get; set; }

        #region Test

        [TestMethod, TestCategory("UnitTest")]
        public void OrgUpdateSuccesfulNoExceptionThrown()
        {
            Test();
        }

        #endregion

        #region Verify

        protected override void Verify()
        {
            Assert.IsNull(Error);
        }

        #endregion

        #region Instance Variables

        private readonly Guid _unassignedTeamGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");
        private readonly string _unassignedTeamName = "Unassigned";
        private readonly Guid _organisationGuid = new Guid("0380e049-6872-4562-9630-1c5ff30085ef");
        private readonly Guid _newAssigneeUserGuid = new Guid("807d314d-4bef-4e58-8e5b-3b0a93e4c7fa");

      

        #endregion

        #region Setup

        [TestInitialize]
        public void SetupTests()
        {
            var teamReference = new EntityReference(XrmMetadata.Team, _unassignedTeamGuid);

            var contract1 = new Entity(XrmMetadata.Contract);
            contract1.Id = Guid.NewGuid();
            contract1.Attributes[XrmMetadata.Owner] = teamReference;
            contract1.Attributes[XrmMetadata.ContractNumber] = "10000001";

            var contract2 = new Entity(XrmMetadata.Contract);
            contract2.Id = Guid.NewGuid();
            contract2.Attributes[XrmMetadata.Owner] = new EntityReference(XrmMetadata.SystemUser, Guid.NewGuid());
            contract2.Attributes[XrmMetadata.ContractNumber] = "10000002";

            var contract3 = new Entity(XrmMetadata.Contract);
            contract3.Id = Guid.NewGuid();
            contract3.Attributes[XrmMetadata.Owner] = teamReference;
            contract3.Attributes[XrmMetadata.ContractNumber] = "10000003";

            var contractCollectionUnfiltered = new EntityCollection();
            contractCollectionUnfiltered.Entities.AddRange(contract1, contract2, contract3);

            var team = new Entity(XrmMetadata.Team);
            team.Id = _unassignedTeamGuid;
            team.Attributes[XrmMetadata.TeamName] = _unassignedTeamName;

            var teamCollection = new EntityCollection();
            teamCollection.Entities.Add(team);

            Context = ShimsContext.Create();

            var contractResponseUnfiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => contractCollectionUnfiltered
            };

            var teamResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => teamCollection
            };

            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
            {
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression)((RetrieveMultipleRequest)orgReq).Query).EntityName == XrmMetadata.Contract))
                {
                    return contractResponseUnfiltered;
                }
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression)((RetrieveMultipleRequest)orgReq).Query).EntityName == XrmMetadata.Team))
                {
                    return teamResponse;
                }
                if (orgReq is AssignRequest)
                {
                    if (((AssignRequest) orgReq).Assignee.Id != _newAssigneeUserGuid)
                    {
                        throw new FaultException<OrganizationServiceFault>(new OrganizationServiceFault());
                    }
                    return null;
                }
                return null;
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
                { InputOrganisation, new EntityReference(XrmMetadata.Organisation, _organisationGuid) },
                { InputTeam, _unassignedTeamName },
                { InputSystemUser, new EntityReference(XrmMetadata.SystemUser, _newAssigneeUserGuid) },
                { InputUpdateContractOwner, true },
                { InputUpdateTaskOwner, true }
            };

            Inputs = inputs;

            Activity activity = new ReassignChildContracts();

            return activity;
        }

        #endregion
    }
}