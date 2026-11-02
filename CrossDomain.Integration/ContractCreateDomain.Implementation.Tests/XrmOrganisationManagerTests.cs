namespace ContractCreateDomain.Implementation.Tests
{
    using System;
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Messages;
    using Microsoft.Xrm.Sdk.Query;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Exceptions;
    using SFA.FCT.CrossDomain.Integration.Entities;

    [TestClass]
    public class XrmOrganisationManagerTests
    {
        private IOrganizationService _orgService;
        private Guid _statusGuid;
        private Guid _teamGuid;
        private Guid _createOrgGuid;
        protected static IDisposable Context { get; set; }

        [TestInitialize]
        public void SetupTests()
        {
            // Create Guids
            _statusGuid = Guid.NewGuid();
            _teamGuid = Guid.NewGuid();
            _createOrgGuid = Guid.NewGuid();

            // Create entities for mock response

            var orgEntity = new Entity("account")
            {
                ["name"] = "Test Organisation",
                ["sfa_ukprn"] = "10000238",
                ["accountid"] = Guid.NewGuid(),
                ["caseload.sfa_caseloadid"] = new AliasedValue("sfa_caseload", "sfa_caseloadid", new Guid())
            };

            var statusEntity = new Entity("sfa_status")
            {
                ["sfa_statusid"] = _statusGuid, 
                ["sfa_name"] = "Active"
            };

            var teamEntity = new Entity("team")
            {
                ["teamid"] = _teamGuid, 
                ["name"] = "Unassigned"
            };

            #region Mock Responses
            var orgList = new List<Entity> { orgEntity };
            var orgCollection = new EntityCollection(orgList)
            {
                EntityName = "account"
            };

            var orgResponse = new RetrieveMultipleResponse();
            orgResponse.Results.Add(nameof(orgResponse.EntityCollection), orgCollection);

            var statusList = new List<Entity> { statusEntity };
            var statusCollection = new EntityCollection(statusList)
            {
                EntityName = "sfa_status"
            };

            var statusResponse = new RetrieveMultipleResponse();
            statusResponse.Results.Add(nameof(statusResponse.EntityCollection), statusCollection);

            var teamList = new List<Entity> { teamEntity };
            var teamCollection = new EntityCollection(teamList)
            {
                EntityName = "team"
            };

            var teamResponse = new RetrieveMultipleResponse();
            teamResponse.Results.Add(
                nameof(teamResponse.EntityCollection), 
                teamCollection);

            // Create Null Responses
            var orgEmptyResponse = new RetrieveMultipleResponse();
            orgEmptyResponse.Results.Add(
                nameof(orgEmptyResponse.EntityCollection), 
                new EntityCollection());

            var statusEmptyResponse = new RetrieveMultipleResponse();
            statusEmptyResponse.Results.Add(
                nameof(statusEmptyResponse.EntityCollection), 
                new EntityCollection());

            var teamEmptyResponse = new RetrieveMultipleResponse();
            teamEmptyResponse.Results.Add(
                nameof(teamEmptyResponse.EntityCollection), 
                new EntityCollection());
            #endregion

            #region Mock Response Items

            // Create the response items

            var orgResponseItem = new ExecuteMultipleResponseItem
            {
                Response = orgResponse
            };

            var statusResponseItem = new ExecuteMultipleResponseItem
            {
                Response = statusResponse
            };

            var teamResponseItem = new ExecuteMultipleResponseItem
            {
                Response = teamResponse
            };

            var orgEmptyResponseItem = new ExecuteMultipleResponseItem
            {
                Response = orgEmptyResponse
            };

            var statusEmptyResponseItem = new ExecuteMultipleResponseItem
            {
                Response = statusEmptyResponse
            };

            var teamEmptyResponseItem = new ExecuteMultipleResponseItem
            {
                Response = teamEmptyResponse
            };

            #endregion

            #region Mock ExecuteMultipleRequests

            // create the Item Collections
            var xmrItemCollection = new ExecuteMultipleResponseItemCollection
            {
                        orgResponseItem,
                        statusResponseItem,
                        teamResponseItem
                    };

            var xmrEmptyItemCollection = new ExecuteMultipleResponseItemCollection
            {
                        orgEmptyResponseItem,
                        statusEmptyResponseItem,
                        teamEmptyResponseItem
                    };

            // Create the ExecuteMultipleResponses

            var xmr = new ExecuteMultipleResponse();
            xmr.Results.Add(nameof(xmr.Responses), xmrItemCollection);

            var xmrEmpty = new ExecuteMultipleResponse();
            xmrEmpty.Results.Add(nameof(xmrEmpty.Responses), xmrEmptyItemCollection);
            #endregion

            #region Mock IOrganisationService

            var orgService = new Mock<IOrganizationService>();

            OrganizationResponse GetResponse(OrganizationRequest orgReq)
            {
                if (orgReq is ExecuteMultipleRequest && ((QueryByAttribute) ((RetrieveMultipleRequest) ((ExecuteMultipleRequest) orgReq).Requests[1]).Query).Values[0].ToString() == "NullStatus")
                {
                    return xmrEmpty;
                }
                else if (orgReq is ExecuteMultipleRequest)
                {
                    return xmr;
                }
                else
                {
                    return null;
                }
            }

            orgService.Setup(os => os.Execute(It.IsAny<OrganizationRequest>()))
                .Returns<OrganizationRequest>(GetResponse);

            orgService.Setup(os => os.Create(It.IsAny<Entity>()))
                .Returns<Entity>(e => e.LogicalName == "account" ? _createOrgGuid : Guid.Empty);

            _orgService = orgService.Object;

            #endregion
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetReference_WhenOrgStatusTeamExistShouldReturnCollection()
        {
            // Arrange
            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            xrmOrgMgr.GetReferenceData("10000238", "Active", "Unassigned");

            // Assert
            Assert.IsTrue(xrmOrgMgr.ReferenceData.Count == 3, "The reference data was not succesfully parsed");
            Assert.IsTrue(xrmOrgMgr.ReferenceData[0].LogicalName == "account",
                "The reference data is not correct, expected account record");
            Assert.IsTrue(xrmOrgMgr.ReferenceData[1].LogicalName == "sfa_status",
                "The reference data is not correct, expected sfa_status record");
            Assert.IsTrue(xrmOrgMgr.ReferenceData[2].LogicalName == "team",
                "The reference data is not correct, expected team record");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateOrg_WhenOrganisationDoesntExist_ShouldReturnGuidWithNoException()
        {
            // Arrange
            const string ukprn = "10000239";
            var org = new ContractOrganisation
            {
                UKPRN = ukprn,
                Name = "Test Organisation",
                Status = "Active",
                OrganisationId = "ORG1"
            };

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            var createdOrgGuid = xrmOrgMgr.CreateOrganisationIfNotExists(org);

            // Assert
            Assert.AreEqual(createdOrgGuid, _createOrgGuid, "The organisation ID does not match the expected value");

        }

        [TestMethod, TestCategory("UnitTest")]
        public void CreateOrg_WhenStatusReferenceIsMissingInCRM_ShouldThrowArgumentNullException()
        {
            // Arrange
            const string ukprn = "10000239";
            var org = new ContractOrganisation
            {
                OrganisationId = "ORG1",
                UKPRN = ukprn,
                Name = "Test Organisation",
                Status = "Not Active"
            };

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            try
            {
                var createdOrgGuid = xrmOrgMgr.CreateOrganisationIfNotExists(org);

                // Assert
                Assert.Fail("An exception was not raised for an missing piece of reference data");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.IsTrue(ex.Message ==
                              "Value cannot be null.\r\nParameter name: The Reference Data does not contain an entry for the entity sfa_status with field sfa_name=Not Active",
                    "Exception was thrown but message was incorrect.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateOrg_WhenStatusReferenceIsMissingInCRM_ShouldThrowArgumentNullException()
        {
            // Arrange
            const string ukprn = "10000238";

            var org = new organisation
            {
                organisationId = "1",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = ukprn,
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName { organisationName = "Test Organisation" }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Not Active"
                        }
                    }
                }
            };

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            try
            {
                xrmOrgMgr.UpdateOrganisation(org);

                // Assert
                Assert.Fail("An exception was not raised for an missing piece of reference data");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.IsTrue(ex.Message ==
                    "Value cannot be null.\r\nParameter name: The Reference Data does not contain an entry for the entity sfa_status with field sfa_name=Not Active",
                    "Exception was thrown but message was incorrect.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetRefSettings_WithNullRefDataShouldThrowArgumentNullException()
        {
            // Arrange
            const string ukprn = "10000300";

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            try
            {
                xrmOrgMgr.GetSettingFromRefData("account", "sfa_ukprn", "accountid", ukprn);
                // Assert
                Assert.Fail("An exception was not raised for null reference data");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.IsTrue(ex.Message == "Value cannot be null.\r\nParameter name: The Reference Data has not been set for the XrmOrganisationManager",
                    "Exception was thrown but message was incorrect.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetRefSettings_WithEmptyRefDataShouldThrowArgumentNullException()
        {
            // Arrange
            const string ukprn = "10000300";

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };
            xrmOrgMgr.ReferenceData = new List<Entity>();

            // Act
            try
            {
                xrmOrgMgr.GetSettingFromRefData("account", "sfa_ukprn", "accountid", ukprn);

                // Assert
                Assert.Fail("An exception was not raised for null reference data");
            }
            catch (ArgumentNullException ex)
            {
                // Assert
                Assert.IsTrue(ex.Message == "Value cannot be null.\r\nParameter name: The Reference Data has not been set for the XrmOrganisationManager",
                    "Exception was thrown but message was incorrect.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateOrg_WhenOrganisationExists_ShouldReturnNoException()
        {
            bool exceptionThrown = false;
            string exceptionMessage = string.Empty;

            // Arrange
            const string ukprn = "10000238";

            var org = new organisation
            {
                organisationId = "1",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = ukprn,
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName { organisationName = "Test Organisation" }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active"
                        }
                    }
                }
            };

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            try
            {
                // Act
                xrmOrgMgr.UpdateOrganisation(org);

            }
            catch (Exception ex)
            {
                exceptionThrown = true;
                exceptionMessage = ex.Message;
            }
            finally
            {
                // Assert
                Assert.IsFalse(exceptionThrown, "An exception was thown: " + exceptionMessage);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void UpdateOrg_WhenOrgDoesntExist_ShouldThrowOrganisationDoesntExistException()
        {
            // Arrange
            const string ukprn = "10000300";

            var org = new organisation
            {
                organisationId = "1",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = ukprn,
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName { organisationName = "Test Organisation" }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active"
                        }
                    }
                }
            };

            var xrmOrgMgr = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            // Act
            try
            {
                xrmOrgMgr.UpdateOrganisation(org);
                // Assert
                Assert.Fail("An exception was not raised for an existing organisation");
            }
            catch (OrganisationDoesntExistException ex)
            {
                // Assert
                Assert.IsTrue(ex.Message ==
                    "The organisation was not updated because an organisation with ukprn " + ukprn + " doesn't exist.",
                    "Exception was thrown but message was incorrect.");
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExtractUkprnFromOrganisation_ShouldReturnUkprnFromOrganisation()
        {
            //arrange
            var organisation = new organisation
            {
                organisationId = "1",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = "10000300",
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                    },
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = "124762",
                        organisationIdentifierType = organisationIdentifierType.UPIN
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName { organisationName = "Test Organisation" }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active"
                        }
                    }
                }
            };

            var xrmOrganisationManager = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            //act
            var ukprn = xrmOrganisationManager.ExtractUkprnFromOrganisation(organisation);

            //assert
            Assert.AreEqual("10000300", ukprn, "The UKPRN was not extracted from the Organisation.");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ExtractStatusFromOrganisation_ShouldReturnLegalStatusFromOrganisation()
        {
            //arrange
            var organisation = new organisation
            {
                organisationId = "1",
                organisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                {
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = "10000300",
                        organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                    },
                    new organisationIdentifiersOrganisationIdentifier
                    {
                        organisationIdentifier = "124762",
                        organisationIdentifierType = organisationIdentifierType.UPIN
                    }
                },
                organisationNames = new List<organisationNamesOrganisationName>
                {
                    new organisationNamesOrganisationName { organisationName = "Test Organisation" }
                },
                organisationStatusRelationships = new List<organisationStatusRelationshipsOrganisationStatusRelationship>
                {
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = "Active",
                            organisationStatusScheme = organisationStatusSchemeType.LEGAL
                        }
                    },
                    new organisationStatusRelationshipsOrganisationStatusRelationship
                    {
                        organisationStatus = new organisationStatusRelationshipsOrganisationStatusRelationshipOrganisationStatus
                        {
                            organisationStatus = ""
                        }
                    }
                }
            };

            var xrmOrganisationManager = new XrmOrganisationManager
            {
                OrgService = _orgService
            };

            //act
            var status = xrmOrganisationManager.ExtractStatusFromOrganisation(organisation);

            //assert
            Assert.AreEqual("Active", status, "The Organisation Status was not extracted from the Organisation.");
        }
    }
}
