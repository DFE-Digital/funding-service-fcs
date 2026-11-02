namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Tests.Extensions
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common.Models;
    using CrossDomain.Integration.Entities.CorporateContract;
    using DataStore.Repositories;
    using DocumentDefiner.DocumentConfiguration;
    using DocumentDefiner.DocumentPartCreators.Appendix1.Dtos;
    using DocumentDefiner.DocumentPartCreators.Extensions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using FundingStreamPeriod = DataStore.Models.FundingStreamPeriod;

    [TestClass]
    public class ContractExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_ShouldGetProviderName()
        {
            // arrange
            contract contract = new contract
            {
                contractor = new contractor
                {
                    legalName = "Xx"
                }
            };

            // act
            string providerName = contract.GetProviderName();

            // assert
            Assert.AreEqual("XX", providerName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetSharedMasterContractTableInfos_ShouldCorrectNumberOfSharedContracts()
        {
            // arrange
            contract contract = new contract
            {
                period = new period
                {
                    period1 = "2016"
                },
                SharedMasterApprovedContracts = new List<ApprovedContractInfo>
                {
                    new ApprovedContractInfo
                    {
                        StartDate = new DateTime(2018, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        EndDate = new DateTime(),
                        FundingPeriod = "AY1819"
                    },
                    new ApprovedContractInfo
                    {
                        StartDate = new DateTime(2019, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        EndDate = new DateTime(),
                        FundingPeriod = "AY1920"
                    }
                }
            };

            var mockFundingStreamPeriodRepository = new Mock<IFundingStreamPeriodRepository>();
            mockFundingStreamPeriodRepository.Setup(r => r.GetByKey(It.IsAny<string>()))
                .Returns(new FundingStreamPeriod(null, null, 0, true, true, null, null, null, null));

            // act
            IReadOnlyCollection<ContractTableInfo> contractTableInfos = contract.GetSharedMasterContractTableInfos(mockFundingStreamPeriodRepository.Object, Mock.Of<IDocumentConfigurationSource>());

            // assert
            Assert.AreEqual(2, contractTableInfos.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetSharedMasterContractTableInfos_ShouldGetOrderedFsps()
        {
            // arrange
            const string fsp1 = "some fsp";
            const string fsp2 = "some other";
            const string allocationNumber1 = "1";
            const string allocationNumber2 = "2";
            contract contract = new contract
            {
                period = new period
                {
                    period1 = "2016"
                },
                SharedMasterApprovedContracts = new List<ApprovedContractInfo>
                {
                    new ApprovedContractInfo
                    {
                        StartDate = new DateTime(2018, 8, 1, 0, 0, 0, DateTimeKind.Utc),
                        EndDate = new DateTime(),
                        FundingPeriod = "AY1819",
                        Allocations = new List<ApprovedContractAllocationInfo>
                        {
                            new ApprovedContractAllocationInfo
                            {
                                FundingStreamPeriodCode = fsp2,
                                ContractAllocationNumber = allocationNumber2
                            },
                            new ApprovedContractAllocationInfo
                            {
                                FundingStreamPeriodCode = fsp1,
                                ContractAllocationNumber = allocationNumber1
                            },
                        }
                    }
                }
            };

            var mockFundingStreamPeriodRepository = new Mock<IFundingStreamPeriodRepository>();
            mockFundingStreamPeriodRepository.Setup(r => r.GetByKey(It.IsAny<string>()))
                .Returns((string fsp) =>
                {
                    int displayOrder = 1;
                    if (fsp == fsp2)
                    {
                        displayOrder = 2;
                    }
                    return new FundingStreamPeriod(null, null, displayOrder, true, true, null, null, null, null);
                });

            // act
            IReadOnlyCollection<ContractTableInfo> contractTableInfos = contract.GetSharedMasterContractTableInfos(mockFundingStreamPeriodRepository.Object, Mock.Of<IDocumentConfigurationSource>());

            var firstAllocationRow = contractTableInfos.Single().AllocationRowTypes[0];
            var secondAllocationRow = contractTableInfos.Single().AllocationRowTypes[1];
            // assert
            Assert.AreEqual(allocationNumber1, firstAllocationRow.MergeFields.Single(f => f.Name == "Column2").Value,  "The first row is incorrect");
            Assert.AreEqual(allocationNumber2, secondAllocationRow.MergeFields.Single(f => f.Name == "Column2").Value, "The second row is incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetSharedMasterContractTableInfos_ShouldGetOfWhichDeliverableLines()
        {
            // arrange
            contract contract = new contract
            {
                SharedMasterApprovedContracts = new List<ApprovedContractInfo>
                {
                    new ApprovedContractInfo
                    {
                        ContractNumber = "AEBP-821",
                        MasterContractNumber = "ESFA-821",
                        StartDate = new DateTime(2019, 08, 01),
                        EndDate = new DateTime(2020, 07, 31),
                        FundingType = "AEB",
                        FundingPeriod = "AY1920",
                        Allocations = new List<ApprovedContractAllocationInfo>
                        {
                            new ApprovedContractAllocationInfo
                            {
                                ContractAllocationNumber = "AERS-1029",
                                FundingStreamPeriodCode = "AEB-PRS1920",
                                PlannedValueEnvelope1 = 0.00M,
                                PlannedValueEnvelope2 = 3627.00M,
                                TotalPlannedValue = 3627.00M,
                                Deliverables = new List<ApprovedContractDeliverableInfo>
                                {
                                    new ApprovedContractDeliverableInfo
                                    {
                                        DeliverableCode = 1,
                                        PlannedValueEnvelope1 = 250.00M,
                                        PlannedValueEnvelope2 = null,
                                        TotalPlannedValue = 1000.00M
                                    },
                                    new ApprovedContractDeliverableInfo
                                    {
                                        DeliverableCode =  2,
                                        PlannedValueEnvelope1 = 500M,
                                        PlannedValueEnvelope2 = 1500M,
                                        TotalPlannedValue = 2000.00M
                                    }
                                }
                            }
                        }
                    }
                }
            };

            var fundingStreamPeriodRepositoryMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepositoryMock
                .Setup(r => r.GetByKey(It.IsAny<string>()))
                .Returns(new FundingStreamPeriod(null, null, 0, true, true, null, null, null, null));

            var documentConfigurationSourceMock = new Mock<IDocumentConfigurationSource>();
            documentConfigurationSourceMock
                .Setup(m => m.ShouldDisplayDeliverableOnSummaryOfFunding("AEB-PRS1920", 1))
                .Returns(true);
            documentConfigurationSourceMock
                .Setup(m => m.ShouldDisplayDeliverableOnSummaryOfFunding("AEB-PRS1920", 2))
                .Returns(false);
            documentConfigurationSourceMock
                .Setup(m => m.GetDeliverableNameForSummaryOfFunding("AEB-PRS1920", 1))
                .Returns("Deliverable 1 Name for Summary of Funding");

            // act
            IReadOnlyCollection<ContractTableInfo> contractTableInfos = contract.GetSharedMasterContractTableInfos(
                fundingStreamPeriodRepositoryMock.Object, documentConfigurationSourceMock.Object);

            // assert
            Assert.AreEqual(2, contractTableInfos.Single().AllocationRowTypes.Count,
                "Unexpected number of rows returned");

            RowType ofWhichDeliverableRow = contractTableInfos.Single().AllocationRowTypes[1];
            Assert.AreEqual(5, ofWhichDeliverableRow.MergeFields.Count,
                "Unexpected number of mergefields for 'of which' row");
            Assert.IsTrue(ofWhichDeliverableRow.MergeFields.Single(mf => mf.Name == "Column1").Value.Contains("Deliverable 1 Name for Summary of Funding"),
                "Deliverable Name for Summary of Funding not present in mergefield");
            Assert.AreEqual(string.Empty, ofWhichDeliverableRow.MergeFields.Single(mf => mf.Name == "Column2").Value,
                "Allocation number column was not empty");
            Assert.AreEqual("£250", ofWhichDeliverableRow.MergeFields.Single(mf => mf.Name == "Column3").Value,
                "PlannedValueEnvelope1 not present in mergefield");
            Assert.IsNull(ofWhichDeliverableRow.MergeFields.Single(mf => mf.Name == "Column4").Value,
                "PlannedValueEnvelope2 not present mergefield as null");
            Assert.AreEqual("£1,000", ofWhichDeliverableRow.MergeFields.Single(mf => mf.Name == "Column5").Value,
                "TotalPlannedValue not present in mergefield");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetSharedMasterContractsTotal_ShouldReturnCorrectValue_WhenThereAreOtherContracts()
        {
            // arrange
            contract contract = new contract
            {
                SharedMasterApprovedContracts = new List<ApprovedContractInfo>
                {
                    new ApprovedContractInfo
                    {
                        Allocations = new List<ApprovedContractAllocationInfo>
                        {
                            new ApprovedContractAllocationInfo
                            {
                                TotalPlannedValue = 10
                            }
                        }
                    },
                    new ApprovedContractInfo
                    {
                        Allocations = new List<ApprovedContractAllocationInfo>
                        {
                            new ApprovedContractAllocationInfo
                            {
                                TotalPlannedValue = 11
                            }
                        }
                    }
                }
            };

            // act
            decimal total = contract.GetSharedMasterContractsTotal();

            // assert
            Assert.AreEqual(21, total);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetSharedMasterContractsTotal_ShouldReturnCorrectValue_WhenThereAreNoOtherContracts()
        {
            // arrange
            contract contract = new contract();
          
            // act
            decimal total = contract.GetSharedMasterContractsTotal();

            // assert
            Assert.AreEqual(0, total);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetAebFinancialEnvelopePeriod1_ShouldReturnNovForAY1718()
        {
            // arrange
            contract contract = new contract
            {
                period = new period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1718"
                }
            };

            // act
            string periodOne = contract.GetAebFinancialEnvelopePeriod1();

            // assert
            Assert.AreEqual("Nov 17 - Mar 18", periodOne);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetAebFinancialEnvelopePeriod1_ShouldReturnAugForAY1819()
        {
            // arrange
            contract contract = new contract
            {
                period = new period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1819"
                }
            };

            // act
            string periodOne = contract.GetAebFinancialEnvelopePeriod1();

            // assert
            Assert.AreEqual("Aug 18 - Mar 19", periodOne);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetAebFinancialPeriod_ShouldReturnAugForAY1819()
        {
            // arrange
            contract contract = new contract
            {
                period = new period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1819"
                }
            };

            // act
            string periodOne = contract.GetAebFinancialPeriod();

            // assert
            Assert.AreEqual("1 August 2018 to 31 July 2019", periodOne);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractExtensions_GetAebFinancialPeriod_ShouldReturnNovForAY1819()
        {
            // arrange
            contract contract = new contract
            {
                period = new period
                {
                    periodType = new periodTypeType
                    {
                        periodTypeCode = periodTypeCodeType.AY
                    },
                    period1 = "1718"
                }
            };

            // act
            string periodOne = contract.GetAebFinancialPeriod();

            // assert
            Assert.AreEqual("1 November 2017 to 31 July 2018", periodOne);
        }
    }
}
