namespace ContractManagementDomain.Endpoint.Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    [TestClass]
    public class TerminationActionValidationTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldErrorWhenTheContractIsNotTheLatest()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion:false);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Termination",
                    ["TerminationDate"] = DateTime.Now,
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to initiate contract termination - a draft amendment exists",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldSucceedWhenTheContractIsTheLatest()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DateTime terminationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: terminationDate.AddDays(1));
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Termination",
                    ["TerminationDate"] = DateTime.Now,
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Valid", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                string.Empty,
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldFailWhenMandatoryItemsNotPresent()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, null, null);

            var inputParams = new List<(DateTime? terminationDate, string terminationReason, string errorMsg)>
            {
                ( null, null, "Termination Date must contain a value"),
                ( null, "some reason", "Termination Date must contain a value"),
                ( DateTime.Now, null, "Termination Reason must contain a value" ),
                ( DateTime.Now, "some reason", "Provisional Stop New Starts Date and Provisional Funding Cessation Date must contain values for every contract allocation" ),

            };

            inputParams.ForEach(input =>
            {
                OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
                {
                    Parameters =
                    {
                        ["Target"] = new EntityReference("sfa_contract", contractId),
                        ["ValidationType"] = "Initiate Termination",
                        ["TerminationDate"] = input.terminationDate,
                        ["TerminationReason"] = input.terminationReason
                    }
                };
                // act
                OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

                // assert
                Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
                Assert.AreEqual(input.errorMsg, ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldFailWhenStopNewStartsGreaterThanFundingCessation()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime fundingCessationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, fundingCessationDate.AddDays(1), fundingCessationDate, allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Termination",
                    ["TerminationDate"] = fundingCessationDate.AddDays(2),
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                $"{allocationNumber}: The Provisional Stop New Starts Date must be equal to or earlier than the Provisional Funding Cessation Date, for the same allocation",
                    ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldFailWhenFundingCessationDateOnAllocationGreaterThanTerminationDate()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime terminationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, terminationDate, terminationDate.AddDays(1), allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Termination",
                    ["TerminationDate"] = terminationDate,
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                $"{allocationNumber}: The Provisional Funding Cessation Date must be equal to or earlier than the Termination Date",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateTermination_ShouldFailWhenTerminationDateGreaterThanContractEndDate()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime contractEndDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: contractEndDate);
            CreateAllocation(contractId, contractEndDate, contractEndDate, allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Termination",
                    ["TerminationDate"] = contractEndDate.AddDays(1),
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Warning", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "The Termination Date is after the Contract End Date.Are you sure you wish to continue? Select OK to continue or Cancel to return to the Termination Details.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldErrorWhenTheContractIsNotTheLatest()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: false);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Termination Details",
                    ["TerminationDate"] = DateTime.Now,
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to update termination details - a draft amendment exists",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldSucceedWhenTheContractIsTheLatest()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DateTime terminationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: terminationDate.AddDays(1));
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Termination Details",
                    ["TerminationDate"] = DateTime.Now,
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Valid", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                string.Empty,
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldFailWhenMandatoryItemsNotPresent()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, null, null);

            var inputParams = new List<(DateTime? terminationDate, string terminationReason, string errorMsg)>
            {
                ( null, null, "Termination Date must contain a value"),
                ( null, "some reason", "Termination Date must contain a value"),
                ( DateTime.Now, null, "Termination Reason must contain a value" ),
                ( DateTime.Now, "some reason", "Provisional Stop New Starts Date and Provisional Funding Cessation Date must contain values for every contract allocation" ),

            };

            inputParams.ForEach(input =>
            {
                OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
                {
                    Parameters =
                    {
                        ["Target"] = new EntityReference("sfa_contract", contractId),
                        ["ValidationType"] = "Update Termination Details",
                        ["TerminationDate"] = input.terminationDate,
                        ["TerminationReason"] = input.terminationReason
                    }
                };
                // act
                OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

                // assert
                Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
                Assert.AreEqual(input.errorMsg, ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
            });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldFailWhenStopNewStartsGreaterThanFundingCessation()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime fundingCessationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, fundingCessationDate.AddDays(1), fundingCessationDate, allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Termination Details",
                    ["TerminationDate"] = fundingCessationDate.AddDays(2),
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                $"{allocationNumber}: The Provisional Stop New Starts Date must be equal to or earlier than the Provisional Funding Cessation Date, for the same allocation",
                    ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldFailWhenFundingCessationDateOnAllocationGreaterThanTerminationDate()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime terminationDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            CreateAllocation(contractId, terminationDate, terminationDate.AddDays(1), allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Termination Details",
                    ["TerminationDate"] = terminationDate,
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                $"{allocationNumber}: The Provisional Funding Cessation Date must be equal to or earlier than the Termination Date",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateTerminationDetails_ShouldFailWhenTerminationDateGreaterThanContractEndDate()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            const string allocationNumber = "AN 1";
            DateTime contractEndDate = DateTime.Now;
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: contractEndDate);
            CreateAllocation(contractId, contractEndDate, contractEndDate, allocationNumber);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Termination Details",
                    ["TerminationDate"] = contractEndDate.AddDays(1),
                    ["TerminationReason"] = "Some Reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Warning", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "The Termination Date is after the Contract End Date.Are you sure you wish to continue? Select OK to continue or Cancel to return to the Termination Details.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_CompleteTermination_ShouldErrorWhenTheContractIsNotTheLatest()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: false);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Complete Termination",
                    ["TerminationDate"] = DateTime.Now,
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to complete contract termination - a draft amendment exists",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_CompleteTermination_ShouldSucceedWhenTheContractIsTheLatest()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DateTime terminationDate = DateTime.Now.AddDays(-1);
            const string terminationReason = "Contract Novation";

            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(
                contractNumber,
                isLatestVersion: true,
                contractEndDateOverride: DateTime.Now.AddDays(1),
                terminationDate: terminationDate,
                terminationReason: terminationReason);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Complete Termination",
                    ["TerminationDate"] = terminationDate,
                    ["TerminationReason"] = terminationReason
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Valid", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                string.Empty,
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_CompleteTermination_ShouldErrorWhenTerminationDateIsNotInThePast()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Complete Termination",
                    ["TerminationDate"] = DateTime.Now.AddDays(1),
                    ["TerminationReason"] = "some reason"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to complete contract termination - contract termination date must be in the past",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_CompleteTermination_ShouldErrorWhenUnsavedTerminationDatePresent()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DateTime terminationDate = DateTime.Now.AddDays(-1);
            DateTime modifiedTerminationDate = DateTime.Now.AddDays(-2);
            const string terminationReason = "Contract Novation";

            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(
                contractNumber,
                isLatestVersion: true,
                contractEndDateOverride: DateTime.Now.AddDays(1),
                terminationDate: terminationDate,
                terminationReason: terminationReason);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Complete Termination",
                    ["TerminationDate"] = modifiedTerminationDate,
                    ["TerminationReason"] = terminationReason
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "There are unsaved changes in Termination Details. Check the dates are correct and choose Update Termination Details to save the changes.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_CompleteTermination_ShouldErrorWhenUnsavedTerminationReasonPresent()
        {
            // arrange
            const string contractNumber = "CN2 - Test";
            DateTime terminationDate = DateTime.Now.AddDays(-1);
            const string terminationReason = "Contract Novation";
            const string modifiedTerminationReason = "Deactivated UKPRN";

            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(
                contractNumber,
                isLatestVersion: true,
                contractEndDateOverride: DateTime.Now.AddDays(1),
                terminationDate: terminationDate,
                terminationReason: terminationReason);

            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Complete Termination",
                    ["TerminationDate"] = terminationDate,
                    ["TerminationReason"] = modifiedTerminationReason
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "There are unsaved changes in Termination Details. Check the dates are correct and choose Update Termination Details to save the changes.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateModification_ShouldErrorWhenTheContractIsNotTheLatest()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: false);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Modification"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to initiate contract modification - a draft amendment exists",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateModification_ShouldErrorWhenDefaultStopNewStartsDateIsNotPresent()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Modification"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Default Stop New Starts Date must contain a value",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateModification_ShouldErrorWhenDefaultNewStartsSuspendedReasonIsNotPresent()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Modification",
                    ["StopNewStartsDate"] = DateTime.UtcNow
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Default New Starts Suspended Reason must contain a value",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_InitiateModification_ShouldWarnWhenDefaultStopNewStartsDateLaterThanContractEndDate()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: DateTime.UtcNow);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Modification",
                    ["StopNewStartsDate"] = DateTime.UtcNow.AddDays(1),
                    ["TerminationReason"] = "Contract Novation" // used as 'New Starts Suspended Reason'
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Warning", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "The Default Stop New Starts Date is after the Contract End Date.Are you sure you wish to continue?  Select OK to continue or Cancel to return to the Modification Details.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateModificationDetails_ShouldErrorWhenTheContractIsNotTheLatest()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: false);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Modification Details"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Unable to update modification details - a draft amendment exists",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateModificationDetails_ShouldErrorWhenDefaultStopNewStartsDateIsNotPresent()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Modification Details"
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Default Stop New Starts Date must contain a value",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateModificationDetails_ShouldErrorWhenDefaultNewStartsSuspendedReasonIsNotPresent()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Update Modification Details",
                    ["StopNewStartsDate"] = DateTime.UtcNow
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Error", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "Default New Starts Suspended Reason must contain a value",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void TerminationActionValidation_UpdateModificationDetails_ShouldWarnWhenDefaultStopNewStartsDateLaterThanContractEndDate()
        {
            // arrange
            const string contractNumber = "CN1 - Test";
            DeleteContracts(contractNumber);
            var contractId = CreateTestContract(contractNumber, isLatestVersion: true, contractEndDateOverride: DateTime.UtcNow);
            OrganizationRequest organizationRequest = new OrganizationRequest("sfa_TerminationActionValidation")
            {
                Parameters =
                {
                    ["Target"] = new EntityReference("sfa_contract", contractId),
                    ["ValidationType"] = "Initiate Modification",
                    ["StopNewStartsDate"] = DateTime.UtcNow.AddDays(1),
                    ["TerminationReason"] = "Contract Novation" // used as 'New Starts Suspended Reason'
                }
            };

            // act
            OrganizationResponse results = CrmConnectionFactory.GetRetryOnErrorOrganizationService().Execute(organizationRequest);

            // assert
            Assert.AreEqual("Warning", results.Results["ValidData"], "The 'ValidData' item in the array has the wrong value");
            Assert.AreEqual(
                "The Default Stop New Starts Date is after the Contract End Date.Are you sure you wish to continue?  Select OK to continue or Cancel to return to the Modification Details.",
                ((string)results.Results["ErrorMessage"]).TrimInvisibleChars(), "The 'ErrorMessage' item in the array has the wrong value");
        }

        private static Guid CreateTestContract(
            string contractNumber,
            bool isLatestVersion,
            int version = 1,
            string ukprn = "1111",
            int subVersion = 0,
            DateTime? contractEndDateOverride = null,
            DateTime? terminationDate = null,
            string terminationReason = null
        )
        {
            var organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            sfa_contract contract = new sfa_contract
            {
                sfa_UKPRN = ukprn,
                sfa_number = contractNumber,
                sfa_Version = version,
                sfa_LastApprovedVersion = false,
                sfa_FundingType = GetFundingType(),
                sfa_ProviderName = GetOrgEntityReference(),
                sfa_SubVersion = subVersion,
                sfa_ContractValue = new Money(0),
                sfa_EndDate = contractEndDateOverride ?? DateTime.Now,
                sfa_terminationdate = terminationDate
            };

            if (terminationReason != null)
            {
                sfa_TerminationReasons terminationReasonEnum =
                    (sfa_TerminationReasons)Enum.Parse(typeof(sfa_TerminationReasons), terminationReason.Replace(" ", string.Empty));
                contract.sfa_terminationreason = new OptionSetValue(Convert.ToInt32(terminationReasonEnum));
                contract.sfa_terminationreasonEnum = terminationReasonEnum;
            }

            Guid contractId = organizationService.Create(contract);

            if (isLatestVersion == false)
            {
                organizationService.Update(new sfa_contract
                {
                    Id = contractId,
                    sfa_LatestVersion = false
                });
            }

            return contractId;
        }

        private static void CreateAllocation(Guid contractId, DateTime? stopNewStartsDate,
            DateTime? fundingCessationDate, string allocationNumber = null)
        {
            sfa_contractallocation allocation = new sfa_contractallocation
            {
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_inflightstopnewstartsdate = stopNewStartsDate,
                sfa_inflightterminationdate = fundingCessationDate,
                sfa_contractallocationnumber = allocationNumber
            };

            CrmConnectionFactory.GetRetryOnErrorOrganizationService().Create(allocation);
        }

        private static EntityReference GetFundingType()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.sfa_fundingtypeSet.First().ToEntityReference();
            }
        }

        private static EntityReference GetOrgEntityReference()
        {
            using (var crmContext = new XrmServiceContext(CrmConnectionFactory.GetRetryOnErrorOrganizationService()))
            {
                return crmContext.AccountSet.First().ToEntityReference();
            }
        }

        private static void DeleteContracts(string contractNumber)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (var crmContext = new XrmServiceContext(organizationService))
            {
                crmContext.sfa_contractSet.Where(
                            c => c.sfa_number == contractNumber)
                        .Select(c => c.Id)
                        .ToList()
                        .ForEach(c => organizationService.Delete(sfa_contract.EntityLogicalName, c));
            }
        }
    }
}
