namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.WFActivities
{
    using System;
    using System.Activities;
    using System.Collections.Generic;
    using Common;
    using Microsoft.QualityTools.Testing.Fakes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Client;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Messages.Fakes;
    using Microsoft.Xrm.Sdk.Query;
    using Workflow.Common;
    using Xrm.Framework.Test.Unit.Fakes;

    [TestClass]
    public class XrmWorkflowActivityHelpersTest : WFActivityUnitTest
    {
        private Guid _newAssigneeUserGuid = new Guid("807d314d-4bef-4e58-8e5b-3b0a93e4c7fa");
        private readonly Guid _organisationGuid = new Guid("0380e049-6872-4562-9630-1c5ff30085ef");
        private readonly Guid _unassignedTeamGuid = new Guid("e6b7106f-df30-4a1e-8a3d-6d43593afca5");
        private readonly string _unassignedTeamName = "Unassigned";
        protected static IDisposable Context { get; set; }

        [TestInitialize]
        public void SetupTests()
        {
            var teamReference = new EntityReference(XrmMetadata.Team, _unassignedTeamGuid);

            var contract1 = new Entity();
            contract1.Id = Guid.NewGuid();
            contract1.Attributes[XrmMetadata.Owner] = teamReference;
            contract1.Attributes[XrmMetadata.ContractNumber] = "10000001";
            contract1.Attributes[XrmMetadata.State] = 0;

            var contract2 = new Entity();
            contract2.Id = Guid.NewGuid();
            contract2.Attributes[XrmMetadata.Owner] = new EntityReference(XrmMetadata.SystemUser, Guid.NewGuid());
            contract2.Attributes[XrmMetadata.ContractNumber] = "10000002";
            contract2.Attributes[XrmMetadata.State] = 0;

            var contract3 = new Entity();
            contract3.Id = Guid.NewGuid();
            contract3.Attributes[XrmMetadata.Owner] = teamReference;
            contract3.Attributes[XrmMetadata.ContractNumber] = "10000003";
            contract3.Attributes[XrmMetadata.State] = 1;

            var contract4 = new Entity();
            contract4.Id = Guid.NewGuid();
            contract4.Attributes[XrmMetadata.Owner] = teamReference;
            contract4.Attributes[XrmMetadata.ContractNumber] = "10000004";
            contract4.Attributes[XrmMetadata.State] = 0;

            var contract5 = new Entity();
            contract5.Id = Guid.NewGuid();
            contract5.Attributes[XrmMetadata.Owner] = new EntityReference(XrmMetadata.SystemUser, Guid.NewGuid());
            contract5.Attributes[XrmMetadata.ContractNumber] = "10000005";
            contract5.Attributes[XrmMetadata.State] = 0;

            var contract6 = new Entity();
            contract6.Id = Guid.NewGuid();
            contract6.Attributes[XrmMetadata.Owner] = teamReference;
            contract6.Attributes[XrmMetadata.ContractNumber] = "10000006";
            contract6.Attributes[XrmMetadata.State] = 1;

            var contract7 = new Entity();
            contract7.Id = Guid.NewGuid();
            contract7.Attributes[XrmMetadata.Owner] = teamReference;
            contract7.Attributes[XrmMetadata.ContractNumber] = "10000007";
            contract7.Attributes[XrmMetadata.State] = 1;

            var contract8 = new Entity();
            contract8.Id = Guid.NewGuid();
            contract8.Attributes[XrmMetadata.Owner] = new EntityReference(XrmMetadata.SystemUser, Guid.NewGuid());
            contract8.Attributes[XrmMetadata.ContractNumber] = "10000008";
            contract8.Attributes[XrmMetadata.State] = 1;

            var contract9 = new Entity();
            contract9.Id = Guid.NewGuid();
            contract9.Attributes[XrmMetadata.Owner] = teamReference;
            contract9.Attributes[XrmMetadata.ContractNumber] = "10000009";
            contract9.Attributes[XrmMetadata.State] = 1;

            var task1 = new Entity(XrmMetadata.Task);
            task1.Id = Guid.NewGuid();
            task1.Attributes[XrmMetadata.Owner] = teamReference;

            var task2 = new Entity(XrmMetadata.Task);
            task2.Id = Guid.NewGuid();
            task2.Attributes[XrmMetadata.Owner] = new EntityReference(XrmMetadata.SystemUser, Guid.NewGuid());

            var task3 = new Entity(XrmMetadata.Task);
            task3.Id = Guid.NewGuid();
            task3.Attributes[XrmMetadata.Owner] = teamReference;

            var taskCollectionUnfiltered = new EntityCollection();
            taskCollectionUnfiltered.Entities.AddRange(task1, task2, task3);

            var taskCollectionFiltered = new EntityCollection();
            taskCollectionFiltered.Entities.AddRange(task1, task3);

            var taskCollectionOpenFiltered = new EntityCollection();
            taskCollectionOpenFiltered.Entities.Add(task1);

            var contractCollectionUnfiltered = new EntityCollection();
            contractCollectionUnfiltered.Entities.AddRange(contract1, contract2, contract3, contract4, contract5,
                contract6, contract7, contract8, contract9);

            var contractCollectionFiltered = new EntityCollection();
            contractCollectionFiltered.Entities.AddRange(contract1, contract3);

            var team = new Entity(XrmMetadata.Team);
            team.Id = _unassignedTeamGuid;
            team.Attributes["name"] = _unassignedTeamName;

            var teamCollection = new EntityCollection();
            teamCollection.Entities.Add(team);

            var emptyTeamCollection = new EntityCollection();

            Context = ShimsContext.Create();

            var contractResponseUnfiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => contractCollectionUnfiltered
            };

            var contractResponseFiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => contractCollectionFiltered
            };

            var taskResponseUnfiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => taskCollectionUnfiltered
            };

            var taskResponseOpenFiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => taskCollectionOpenFiltered
            };

            var taskResponseFiltered = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => taskCollectionFiltered
            };

            var teamResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => teamCollection
            };

            var emptyTeamResponse = new ShimRetrieveMultipleResponse
            {
                EntityCollectionGet = () => emptyTeamCollection
            };

            OrganizationServiceStub.ExecuteOrganizationRequest = orgReq =>
            {
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression) ((RetrieveMultipleRequest) orgReq).Query).EntityName == XrmMetadata.Contract))
                {
                    var query = (QueryExpression) ((RetrieveMultipleRequest) orgReq).Query;

                    if (query.Criteria.Conditions.Count == 1)
                    {
                        return contractResponseUnfiltered;
                    }
                    return contractResponseFiltered;
                }
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression) ((RetrieveMultipleRequest) orgReq).Query).EntityName == XrmMetadata.Task))
                {
                    var query = (QueryExpression) ((RetrieveMultipleRequest) orgReq).Query;

                    if (query.Criteria.Filters.Count > 0 && query.Criteria.Filters[0].Filters.Count > 0 &&
                        query.Criteria.Filters[0].Filters[0].Conditions.Count == 2)
                    {
                        return taskResponseOpenFiltered;
                    }
                    if (query.Criteria.Filters.Count > 0 && query.Criteria.Filters[0].Conditions.Count == 2)
                    {
                        return taskResponseFiltered;
                    }
                    return taskResponseUnfiltered;
                }
                if (orgReq is RetrieveMultipleRequest &&
                    (((QueryExpression)((RetrieveMultipleRequest)orgReq).Query).EntityName == XrmMetadata.Team))
                {
                    var query = (QueryExpression) ((RetrieveMultipleRequest) orgReq).Query;

                    if ((string) query.Criteria.Conditions[0].Values[0] == _unassignedTeamName)
                    {
                        return teamResponse;
                    }
                    return emptyTeamResponse;
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

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryContractsWithTeamCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var contracts = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.Owner, new EntityReference(XrmMetadata.Team, _unassignedTeamGuid));

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                contracts = xrmHelpers.GetChildGuids(XrmMetadata.Contract, XrmMetadata.ProviderName,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(contracts.Count, 2, "An incorrect number of contracts were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryContractsWithoutTeamCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var contracts = new List<Guid>();
            var filterList = new Dictionary<string, object>();

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                contracts = xrmHelpers.GetChildGuids(XrmMetadata.Contract, XrmMetadata.ProviderName,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(contracts.Count, 9, "An incorrect number of contracts were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryContractsWithActiveStatusFilterCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var contracts = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.State, 0);

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                contracts = xrmHelpers.GetChildGuids(XrmMetadata.Contract, XrmMetadata.ProviderName,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(contracts.Count, 2, "An incorrect number of contracts were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryContractsWithActiveStatusAndTeamFilterCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var contracts = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.Owner, new EntityReference(XrmMetadata.Team, _unassignedTeamGuid));
            filterList.Add(XrmMetadata.State, 0);

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                contracts = xrmHelpers.GetChildGuids(XrmMetadata.Contract, XrmMetadata.ProviderName,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(contracts.Count, 2, "An incorrect number of contracts were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTasksWithTeamCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var tasks = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.Owner, new EntityReference(XrmMetadata.Team, _unassignedTeamGuid));

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                tasks = xrmHelpers.GetChildGuids(XrmMetadata.Task, XrmMetadata.Regarding,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(tasks.Count, 3, "An incorrect number of tasks were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTasksWithoutTeamCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var tasks = new List<Guid>();
            var filterList = new Dictionary<string, object>();

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                tasks = xrmHelpers.GetChildGuids(XrmMetadata.Task, XrmMetadata.Regarding,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(tasks.Count, 3, "An incorrect number of tasks were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTasksWithTeamAndFilterCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var tasks = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.Owner, new EntityReference(XrmMetadata.Team, _unassignedTeamGuid));


            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                tasks = xrmHelpers.GetChildGuids(XrmMetadata.Task, XrmMetadata.Regarding,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(tasks.Count, 3, "An incorrect number of tasks were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTasksWithoutTeamAndFilterCorrectRecordsShouldBeReturned()
        {
            // Arrange
            var tasks = new List<Guid>();
            var filterList = new Dictionary<string, object>();
            filterList.Add(XrmMetadata.State, new OptionSetValue(0));

            // Act
            using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
            {
                var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                tasks = xrmHelpers.GetChildGuids(XrmMetadata.Task, XrmMetadata.Regarding,
                    new EntityReference(XrmMetadata.Organisation, _organisationGuid), filterList);
            }

            // Assert
            Assert.AreEqual(tasks.Count, 3, "An incorrect number of tasks were returned by the query");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTeamWithCorrectNameOneRecordReturned()
        {
            // Arrange
            var team = new EntityReference();

            try
            {
                // Act
                using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
                {
                    var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                    team = xrmHelpers.GetTeamReference(_unassignedTeamName);
                }

                // Assert
                Assert.AreEqual(team.Id, _unassignedTeamGuid, "Team Guid is incorrect");
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                // Assert
                Assert.Fail("An exception was thrown for a valid team name");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void WhenQueryTeamWithInCorrectNameThrowsArgumentNullException()
        {
            // Arrange
            var team = new EntityReference();

            try
            {
                // Act
                using (var xrmContext = new OrganizationServiceContext(OrganizationServiceStub))
                {
                    var xrmHelpers = new XrmWorkflowActivityHelpers(xrmContext);
                    team = xrmHelpers.GetTeamReference("Invalid name");
                }

                Assert.Fail("An exception was now thrown for an invalid team");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.AreEqual(ex.Message,
                    "The required team is not present in Dynamics CRM\r\nParameter name: teamName",
                    "An exception was thrown but has an incorrect message");
            }
            catch (Exception ex)
            {
                Assert.Fail("An exception was thrown but not of the correct type: " + ex.Message);
            }
        }

        #region Abstract Members

        protected override Activity SetupActivity()
        {
            return null;
        }

        protected override void Verify()
        {
        }

        #endregion
    }
}