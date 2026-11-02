namespace ContractCreateDomain.Tests.Unit_Tests
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using Optional;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Services;
    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class PreviousContractMergerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsUpdateDraftAndLatestVersionPresent_ShouldReturnSuccessAndMergeLatestValues()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft
                        }
                    }
                }
            };

            PreviousContract lastApprovedContract = new PreviousContract(null, null, null, null, null, null, null);
            PreviousContract latestContract = new PreviousContract(
                DateTime.Parse("2018-08-01"),
                DateTime.Parse("2019-07-31"),
                "ESFA-12345",
                null,
                "Latest Contract Description",
                "Contract for Services",
                new List<PreviousAllocation>());

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(lastApprovedContract.Some);
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.Some(latestContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            AssertContractValuesAreEqualToPreviousVersion(latestContract, contractRequest);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsUpdateDraftAndLatestVersionNotPresent_ShouldReturnFailureAndPopulateErrorInfo()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    correlationId = Guid.NewGuid().ToString(),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft
                        }
                    }
                },
                errorInfo = null
            };

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractNotFound, mergeResult, "Unexpected merge result");
            Assert.AreEqual(1, contractRequest.errorInfo.Count, "Unexpected number of errors returned");

            errorInfoType errorInfo = contractRequest.errorInfo.Single();
            Assert.AreEqual(contractRequest.contract.correlationId, errorInfo.correlationId, "Unexpected correlation id returned in error info, expected Master Contract correlation id");
            Assert.AreEqual(errorInfoTypeLevel.Contract, errorInfo.level, "Unexpected error level id returned in error info");
            Assert.AreEqual("Cannot find matching draft contract to update", errorInfo.Value, "Unexpected message returned in error info");
            Assert.AreEqual(ErrorSeverity.Standard, errorInfo.Severity, "Unexpected severity returned in error info");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsAmendmentAndLastApprovedVersionPresent_ShouldReturnSuccessAndMergeLastApprovedValues()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.Amendment
                        }
                    }
                }
            };

            PreviousContract lastApprovedContract = new PreviousContract(
                DateTime.Parse("2018-08-01"),
                DateTime.Parse("2019-07-31"),
                "ESFA-12345",
                "Notification",
                "Latest Contract Description",
                "Contract for Services",
                new List<PreviousAllocation>());
            PreviousContract latestContract = new PreviousContract(null, null, null, null, null, null, null);

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.Some(lastApprovedContract));
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.Some(latestContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            AssertContractValuesAreEqualToPreviousVersion(lastApprovedContract, contractRequest);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsAmendmentAndLastApprovedVersionNotPresent_ShouldReturnFailureAndPopulateErrorInfoWithUDC020Message()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    correlationId = Guid.NewGuid().ToString(),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.Amendment
                        }
                    }
                }
            };

            PreviousContract latestContract = new PreviousContract(null, null, null, null, null, null, null);

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.Some(latestContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractNotFound, mergeResult, "Unexpected merge result");
            Assert.AreEqual(1, contractRequest.errorInfo.Count, "Unexpected number of errors returned");

            errorInfoType errorInfo = contractRequest.errorInfo.Single();
            Assert.AreEqual(contractRequest.contract.correlationId, errorInfo.correlationId, "Unexpected correlation id returned in error info, expected Master Contract correlation id");
            Assert.AreEqual(errorInfoTypeLevel.Contract, errorInfo.level, "Unexpected error level id returned in error info");
            Assert.AreEqual(new ContractAmendmentMustHaveExistingApprovedOrWithdrawnContractRule().ErrorMessage, errorInfo.Value, "UDC-020 message was not returned in error info");
            Assert.AreEqual(ErrorSeverity.Standard, errorInfo.Severity, "Unexpected severity returned in error info");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsUpdateDraftAmendmentAndLatestVersionPresent_ShouldReturnSuccessAndMergeLatestValues()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraftAmendment
                        }
                    }
                }
            };

            PreviousContract lastApprovedContract = new PreviousContract(null, null, null, null, null, null, null);
            PreviousContract latestContract = new PreviousContract(
                DateTime.Parse("2018-08-01"),
                DateTime.Parse("2019-07-31"),
                "ESFA-12345",
                "Notification",
                "Latest Contract Description",
                "Contract for Services",
                new List<PreviousAllocation>());

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.Some(lastApprovedContract));
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.Some(latestContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            
            Assert.AreEqual(latestContract.ContractStartDate, contractRequest.contract.contracts.Single().startDate, "Unexpected contract start date");
            Assert.AreEqual(latestContract.ContractEndDate, contractRequest.contract.contracts.Single().endDate, "Unexpected contract end date");
            Assert.AreEqual(latestContract.MasterContractReferenceNumber, contractRequest.contract.contractNumber, "Unexpected master contract number");
            Assert.AreEqual(ParseAmendmentType("Notification"), contractRequest.contract.contracts.Single().amendmentType, "Unexpected amendment type");
            Assert.AreEqual(latestContract.ContractDescription, contractRequest.contract.contracts.Single().description, "Unexpected contract description");
            Assert.AreEqual(latestContract.ContractType, contractRequest.contract.contracts.Single().contractType1, "Unexpected contract type");
            Assert.AreEqual(latestContract.ContractStartDate, contractRequest.contract.startDate, "Unexpected contract start date on master");
            Assert.AreEqual(latestContract.ContractEndDate, contractRequest.contract.endDate, "Unexpected contract end date master");
            Assert.AreEqual(ParseAmendmentType(latestContract.AmendmentType), contractRequest.contract.amendmentType, "Unexpected amendmentType end date master");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsUpdateDraftAmendmentAndLatestVersionNotPresent_ShouldReturnFailureAndPopulateErrorInfo()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    correlationId = Guid.NewGuid().ToString(),
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraftAmendment
                        }
                    }
                }
            };

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractNotFound, mergeResult, "Unexpected merge result");
            Assert.AreEqual(1, contractRequest.errorInfo.Count, "Unexpected number of errors returned");

            errorInfoType errorInfo = contractRequest.errorInfo.Single();
            Assert.AreEqual(contractRequest.contract.correlationId, errorInfo.correlationId, "Unexpected correlation id returned in error info, expected Master Contract correlation id");
            Assert.AreEqual(errorInfoTypeLevel.Contract, errorInfo.level, "Unexpected error level id returned in error info");
            Assert.AreEqual("Cannot find matching draft contract to update", errorInfo.Value, "Unexpected message returned in error info");
            Assert.AreEqual(ErrorSeverity.Standard, errorInfo.Severity, "Unexpected severity returned in error info");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_WhenIntentIsNotSupported_ShouldThrowArgumentOutOfRangeException()
        {
            // arrange
            bool threwExpectedException = false;

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.New
                        }
                    }
                }
            };

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(Mock.Of<IPreviousContractRepository>());

            // act
            try
            {
                previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);
            }
            catch (ArgumentOutOfRangeException)
            {
                threwExpectedException = true;
            }

            Assert.IsTrue(threwExpectedException, "Expected exception not thrown");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldNotMergeOptionalFieldsFromPreviousContractOverNonEmptyValues()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contractNumber = "SPREADSHEET-12345",
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft,
                            startDate = DateTime.Parse("2018-09-01"),
                            endDate = DateTime.Parse("2019-06-30"),
                            description = "Spreadsheet Contract Description",
                            amendmentType = amendmentType.Notification,
                            contractType1 = "Contract for New Services"
                        }
                    }
                }
            };

            PreviousContract lastApprovedContract = new PreviousContract(null, null, null, null, null, null, null);
            PreviousContract latestContract = new PreviousContract(
                DateTime.Parse("2018-08-01"),
                DateTime.Parse("2019-07-31"),
                "ESFA-12345",
                "Variation",
                "Latest Contract Description",
                "Contract for Services",
                new List<PreviousAllocation>());

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.Some(lastApprovedContract));
            repositoryMock.Setup(m => m.GetLatestContract(It.IsAny<string>())).Returns(Option.Some(latestContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(DateTime.Parse("2018-09-01"), contractRequest.contract.contracts.Single().startDate, "Unexpected contract start date");
            Assert.AreEqual(DateTime.Parse("2019-06-30"), contractRequest.contract.contracts.Single().endDate, "Unexpected contract end date");
            Assert.AreEqual("SPREADSHEET-12345", contractRequest.contract.contractNumber, "Unexpected master contract number");
            Assert.AreEqual(amendmentType.Notification, contractRequest.contract.contracts.Single().amendmentType, "Unexpected amendment type");
            Assert.AreEqual("Spreadsheet Contract Description", contractRequest.contract.contracts.Single().description, "Unexpected contract description");
            Assert.AreEqual("Contract for New Services", contractRequest.contract.contracts.Single().contractType1, "Unexpected contract type");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldReturnFailureWhenMultipleChildContractsInContractRequestContainsSingleFailingMerge()
        {
            // arrange
            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType { CRMIntent = intent.UpdateDraft },
                        new contractType { CRMIntent = intent.UpdateDraft }
                    }
                }
            };

            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();
            repositoryMock.Setup(m => m.GetLastApprovedContract(It.IsAny<string>())).Returns(Option.None<PreviousContract>());
            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(new PreviousContract(null, null, null, "None", null, null, null)))
                .Returns(Option.None<PreviousContract>());

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractNotFound, mergeResult, "Unexpected merge result");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldUpdateAllocationWhenAllocationFieldsAreNull()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                }
                            }
                        }
                    }
                }
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: "amend",
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            PreviousAllocation prevAllocation = previousContract.PreviousAllocations.First();
            var allocPassedIn = contractRequest.contract.contracts.First().contractAllocations.First();
            Assert.AreEqual(prevAllocation.StartDate, allocPassedIn.startDate, "The startDate has not been set");
            Assert.AreEqual(prevAllocation.EndDate, allocPassedIn.endDate, "The endDate has not been set");
            Assert.AreEqual(prevAllocation.FundingStreamCode, allocPassedIn.fundingStreamCode, "The fundingStreamCode has not been set");
            Assert.AreEqual(prevAllocation.FundingStreamPeriodCode, allocPassedIn.fundingStreamPeriodCode, "The fundingStreamPeriodCode has not been set");
            Assert.AreEqual(prevAllocation.LepName, allocPassedIn.LEPName, "The LEPName has not been set");
            Assert.AreEqual(prevAllocation.LepCode, allocPassedIn.LEPCode, "The LEPCode has not been set");
            Assert.AreEqual(prevAllocation.TenderSpecReference, allocPassedIn.tenderSpecificationReference, "The tenderSpecificationReference has not been set");
            Assert.AreEqual(prevAllocation.LotReference, allocPassedIn.lotReference, "The lotReference has not been set");
            Assert.AreEqual(prevAllocation.TenderAwardReference, allocPassedIn.tenderAwardReference, "The tenderAwardReference has not been set");
            Assert.AreEqual(prevAllocation.ActivityDescription, allocPassedIn.activityDescription, "The activityDescription has not been set");
            Assert.AreEqual(prevAllocation.AllocationDescription, allocPassedIn.description, "The description has not been set");
            Assert.AreEqual(null, allocPassedIn.amendmentReason, "The amendmentReason has not been set");
            Assert.AreEqual(prevAllocation.InvestmentPriority, allocPassedIn.investmentPriority, "The investmentPriority has not been set");
            Assert.AreEqual(prevAllocation.AgreementNumber, allocPassedIn.agreementNumber, "The agreementNumber has not been set");
            Assert.AreEqual(prevAllocation.SpecificationTitle, allocPassedIn.specificationTitle, "The specificationTitle has not been set");
            Assert.AreEqual(prevAllocation.RegionType, allocPassedIn.regionType, "The regionType has not been set");
            Assert.AreEqual(prevAllocation.LearningRatePremium, allocPassedIn.learningRatePremium, "The learningRatePremium has not been set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldLeaveAllocationAsIsWhenAllocationFieldsAreNotNull()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: "amend",
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            var prevAllocation = previousContract.PreviousAllocations.First();
            var allocPassedIn = contractRequest.contract.contracts.First().contractAllocations.First();
            Assert.AreEqual(prevAllocation.ActivityDescription, allocPassedIn.activityDescription, "The ActivityDescription has not been set");
            Assert.AreEqual(prevAllocation.FundingStreamCode, allocPassedIn.fundingStreamCode, "The fundingStreamCode has not been set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldNotCopyAmendmentTypeIfIntentIsNotAmendment()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraft,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: "amend",
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(amendmentType.None, contractRequest.contract.contracts.First().amendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldCopyAmendmentTypeIfIntentIsAmendment()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.Amendment,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: "amend",
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLastApprovedContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(amendmentType.Variation, contractRequest.contract.contracts.First().amendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldCopyAmendmentTypeIfIntentIsUpdateDraftAmendment()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraftAmendment,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: "amend",
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(amendmentType.Variation, contractRequest.contract.contracts.First().amendmentType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldCopyAmendmentReasonIfIntentIsUpdateDraftAmendment()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";
            const string amendmentReason = "Test";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.UpdateDraftAmendment,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1,
                                    amendmentReason = string.Empty
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: amendmentReason,
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLatestContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(amendmentReason, contractRequest.contract.contracts.First().contractAllocations.First().amendmentReason, "The amendment reason has not been set");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PreviousContractMerger_ShouldNotCopyAmendmentReasonIfIntentIsAmendment()
        {
            // arrange
            const string allocationNumber1 = "alloc 1";
            const string amendmentReason = "Test";

            contractRequestType contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            CRMIntent = intent.Amendment,
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = allocationNumber1
                                    // todo: add fields
                                }
                            }
                        }
                    }
                },
                errorInfo = null
            };

            PreviousContract previousContract = new PreviousContract(null, null, null, amendmentType: "Variation", contractDescription: null, contractType: null, previousAllocations: new List<PreviousAllocation>
            {
                new PreviousAllocation(allocationNumber: allocationNumber1,
                    startDate: new DateTime(2018, 08, 01),
                    endDate: new DateTime(2019, 7, 31),
                    fundingStreamCode: "FS1",
                    fundingStreamPeriodCode: "FSP1",
                    lepName: "lep",
                    lepCode: "lepCode",
                    tenderSpecReference: "tsr",
                    lotReference: "lr",
                    tenderAwardReference: "tar",
                    activityDescription: "act_d",
                    allocationDescription: "alloc_d",
                    amendmentReason: amendmentReason,
                    investmentPriority: "ip",
                    agreementNumber: "aggNum",
                    specificationTitle: "st",
                    regionType: "rt",
                    learningRatePremium: "lrp")
            });
            Mock<IPreviousContractRepository> repositoryMock = new Mock<IPreviousContractRepository>();

            repositoryMock.SetupSequence(m => m.GetLastApprovedContract(It.IsAny<string>()))
                .Returns(Option.Some(previousContract));

            PreviousContractMerger previousContractMerger = new PreviousContractMerger(repositoryMock.Object);

            // act
            PreviousContractMergeResult mergeResult = previousContractMerger.MergeOptionalFieldsFromPreviousContract(contractRequest);

            // assert
            Assert.AreEqual(PreviousContractMergeResult.PreviousContractMerged, mergeResult, "Unexpected merge result");
            Assert.AreEqual(null, contractRequest.contract.contracts.First().contractAllocations.First().amendmentReason, "The amendment reason has been set");
        }

        private static void AssertContractValuesAreEqualToPreviousVersion(PreviousContract expected, contractRequestType actual)
        {
            Assert.AreEqual(expected.ContractStartDate, actual.contract.contracts.Single().startDate, "Unexpected contract start date");
            Assert.AreEqual(expected.ContractEndDate, actual.contract.contracts.Single().endDate, "Unexpected contract end date");
            Assert.AreEqual(expected.MasterContractReferenceNumber, actual.contract.contractNumber, "Unexpected master contract number");
            Assert.AreEqual(ParseAmendmentType(expected.AmendmentType), actual.contract.contracts.Single().amendmentType, "Unexpected amendment type");
            Assert.AreEqual(expected.ContractDescription, actual.contract.contracts.Single().description, "Unexpected contract description");
            Assert.AreEqual(expected.ContractType, actual.contract.contracts.Single().contractType1, "Unexpected contract type");
            Assert.AreEqual(expected.ContractStartDate, actual.contract.startDate, "Unexpected contract start date on master");
            Assert.AreEqual(expected.ContractEndDate, actual.contract.endDate, "Unexpected contract end date master");
            Assert.AreEqual(ParseAmendmentType(expected.AmendmentType), actual.contract.amendmentType, "Unexpected amendmentType end date master");
        }

        private static amendmentType ParseAmendmentType(string amendmentType)
        {
            if (!string.IsNullOrEmpty(amendmentType))
            {
                return (amendmentType)Enum.Parse(typeof(amendmentType), amendmentType);
            }

            return SFA.FCT.CrossDomain.Integration.Entities.ContractRequest.amendmentType.None;
        }
    }
}
