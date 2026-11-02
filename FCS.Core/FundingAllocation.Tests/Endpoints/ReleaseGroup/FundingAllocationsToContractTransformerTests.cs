namespace FundingAllocation.Tests.Endpoints.ReleaseGroup
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DataStore.Model;
    using FundingAllocation.Dto;
    using FundingAllocation.Endpoints.ReleaseGroup;
    using FundingAllocation.Endpoints.ReleaseGroup.Repositories;
    using FundingAllocation.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    [TestClass]
    public class FundingAllocationsToContractTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationsToContractTransformer_ShouldReturnPopulatedContract()
        {
            // arrange
            const string contractNumber = "EDSK-10";
            const string masterContractNumber = "ESFA-11";
            const string allocationReferencePrefix = "1619ED";
            const int allocationNumber = 12;
            const int contractingOrgUkprn = 1234;
            const decimal plannedValueJan = 42m;
            const decimal plannedValueFeb = 52m;
            const string contractType = "Conditions of Funding (Grant) (College)";
            const string fundingType = "EDSK";
            const string fcsFundingPeriod = "AY2021";
            const string fspGroup = "16-19ED2021";
            const string deliverableName = "some name";
            const int deliverableDisplayOrder = 4;
            int deliverableCode = 20;
            const string fsCode = "fs code";
            const int contractVersionNumber = 999;
            DateTime startDate = new DateTime(2021, 8, 1, 0,0,0, DateTimeKind.Utc);
            DateTime endDate = startDate.AddYears(1).AddDays(-1);

            FundingAllocation fundingAllocation = new FundingAllocation(
                "", "", "AS-2021", "CFS-FUNDING_STREAM",
                contractingOrgUkprn.ToString(), -1, -1, -1,
                1, 1)
            {
                ProviderFundingAllocations =
                {
                    new ProviderFundingAllocation("", "")
                    {
                        ProviderFunding = new ProviderFunding("", contractingOrgUkprn, "FURTH", "01GFE")
                        {
                            FundingAllocationLines =
                            {
                                new FundingAllocationLine("", "Line1")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202201, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202202, plannedValueFeb)
                                    }
                                },
                                new FundingAllocationLine("", "Line2")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202201, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202202, plannedValueFeb)
                                    }
                                }
                            }
                        }
                    }
                }
            };

            Mock<ICfsToFcsCodeMappingService> cfsToFcsCodeMappingServiceMock = new Mock<ICfsToFcsCodeMappingService>();
            cfsToFcsCodeMappingServiceMock.Setup(s => s.GetFspCodeDeliverable(It.IsAny<ProviderFundingInfo>()))
                .ReturnsAsync(new FspCodeDeliverable("1619ED2021", deliverableCode++, deliverableName, deliverableDisplayOrder, fsCode, allocationReferencePrefix));

            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepMock.Setup(r => r.GetFspStartAndEndDate(It.IsAny<string>()))
                .ReturnsAsync((startDate, endDate));

            FundingAllocationsToContractTransformer transformer = new FundingAllocationsToContractTransformer(
                cfsToFcsCodeMappingServiceMock.Object, fundingStreamPeriodRepMock.Object);

            var totalContractValue = (plannedValueJan + plannedValueFeb) * 2;

            // act
            var contract = transformer.CreateContractFrom(new List<FundingAllocation> {fundingAllocation},
                contractNumber, masterContractNumber,
                new ContractItemsMappingResult(fundingType, fcsFundingPeriod, fspGroup, contractType), contractVersionNumber,
                fsp => allocationNumber).Result;

            // assert
            Assert.AreEqual(contractNumber, contract.ChildContract().contractNumber, "The child contract number is not correct");
            Assert.AreEqual("2021", contract.ChildContract().period.period1, "The child contract period is not correct");
            Assert.AreEqual(contractingOrgUkprn, contract.ChildContract().contractor.ukprn, "The child contract ukprn is not correct");
            Assert.AreEqual(contractingOrgUkprn, contract.contractor.ukprn, "The master contract ukprn is not correct");
            Assert.AreEqual(contractVersionNumber, contract.ChildContract().contractVersionNumber, "The child contract version number is not correct");
            Assert.AreEqual(1, contract.ChildContract().contractAllocations.Count, "The number of allocations is not correct");
            Assert.AreEqual(totalContractValue, contract.ChildContract().contractValue, "The contractValue is not correct");
            Assert.AreEqual(contractType, contract.ChildContract().contractType1, "The contractType1 is not correct");
            Assert.AreEqual(fundingType, contract.ChildContract().fundingType.fundingTypeCode, "The fundingTypeCode is not correct");
            Assert.AreEqual(fundingType, contract.fundingType.fundingTypeCode, "The fundingTypeCode is not correct on the master");
            Assert.AreEqual(true, contract.ChildContract().DocumentationRequired, "The DocumentationRequired is not correct on the child contract");
            var allocation = contract.ChildContract().contractAllocations[0];
            Assert.AreEqual(2, allocation.contractDeliverables.Count, "The number of deliverables is not correct");
            Assert.AreEqual(string.Empty, allocation.DeliveryOrganisation, "The deliverable org is not correct");
            Assert.AreEqual(totalContractValue, allocation.maximumContractValue, "The allocation maximumContractValue is not correct");
            Assert.AreEqual($"{allocationReferencePrefix}-{allocationNumber}", allocation.contractAllocationNumber, "The contractAllocationNumber is not correct");
            Assert.AreEqual("2021", allocation.period.period1, "The allocation period is not correct");
            var deliverable = allocation.contractDeliverables.First();
            Assert.AreEqual(20, deliverable.deliverable.deliverableCode, "The deliverableCode is not correct");
            Assert.AreEqual(deliverableName, deliverable.deliverable.deliverableName, "The deliverableName is not correct");
            Assert.AreEqual(12, deliverable.contractDeliverablePeriods.Count, "The number of contractDeliverablePeriods is not correct");
            Assert.AreEqual(totalContractValue/2, deliverable.plannedValue, "The plannedValue for the deliverable is not correct");
            Assert.AreEqual(deliverableDisplayOrder, deliverable.DisplayOrder, "The DisplayOrder for the deliverable is not correct");
            var dpJan = deliverable.contractDeliverablePeriods
                .SingleOrDefault(dp => dp.year == 2022 && dp.period == 1);
            Assert.IsNotNull(dpJan, "The contract does not contain a period for 2021 Jan");
            Assert.AreEqual("Jan-22", dpJan.periodName, "The periodName is not correct");
            Assert.AreEqual(plannedValueJan, dpJan.plannedValue, "The plannedValueJan is not correct");
            Assert.AreEqual(202201, dpJan.displayOrder, "The displayOrder for dpJan is not correct");
            var dpFeb = deliverable.contractDeliverablePeriods
                .SingleOrDefault(dp => dp.year == 2022 && dp.period == 2);
            Assert.AreEqual(plannedValueFeb, dpFeb.plannedValue, "The plannedValueFeb is not correct");
            Assert.AreEqual(202202, dpFeb.displayOrder, "The displayOrder for dpFeb is not correct");
            Assert.AreEqual(startDate, contract.ChildContract().startDate, "The startDate on the child contract is not right");
            Assert.AreEqual(endDate, contract.ChildContract().endDate, "The endDate on the child contract is not right");
            Assert.AreEqual(startDate, contract.startDate, "The startDate on the master contract is not right");
            Assert.AreEqual(endDate, contract.endDate, "The endDate on the master contract is not right");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void FundingAllocationsToContractTransformer_ShouldReturnPopulatedAllocations()
        {
            // arrange
            const string allocationReferencePrefix = "1619ED";
            const int allocationNumber = 12;
            const int contractingOrgUkprn = 1234;
            const decimal plannedValueJan = 42m;
            const decimal plannedValueFeb = 52m;
            const string contractType = "Conditions of Funding (Grant) (College)";
            const string fundingType = "EDSK";
            const string fcsFundingPeriod = "AY2021";
            const string fspGroup = "16-19ED2021";
            const string deliverableName = "some name";
            const int deliverableDisplayOrder = 4;
            int deliverableCode = 20;
            const string fsCode = "fs code";
            const string fspCode = "1619ED2021";
            DateTime fspStartDate = new DateTime(2021, 8, 1, 0, 0, 0, DateTimeKind.Utc);
            DateTime fspEndDate = new DateTime(2022, 7, 31, 0, 0, 0, DateTimeKind.Utc);

            FundingAllocation fundingAllocation = new FundingAllocation(
                "", "", "AS-2021", "CFS-FUNDING_STREAM",
                contractingOrgUkprn.ToString(), -1, -1, -1,
                1, 1)
            {
                ProviderFundingAllocations =
                {
                    new ProviderFundingAllocation("", "")
                    {
                        ProviderFunding = new ProviderFunding("", contractingOrgUkprn, "FURTH", "01GFE")
                        {
                            FundingAllocationLines =
                            {
                                new FundingAllocationLine("", "Line1")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202201, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202202, plannedValueFeb)
                                    }
                                },
                                new FundingAllocationLine("", "Line2")
                                {
                                    FundingAllocationProfilePeriods =
                                    {
                                        new FundingAllocationProfilePeriod("", "", 202201, plannedValueJan),
                                        new FundingAllocationProfilePeriod("", "", 202202, plannedValueFeb)
                                    }
                                }
                            }
                        }
                    }
                }
            };

            Mock<ICfsToFcsCodeMappingService> cfsToFcsCodeMappingServiceMock = new Mock<ICfsToFcsCodeMappingService>();
            cfsToFcsCodeMappingServiceMock.Setup(s => s.GetFspCodeDeliverable(It.IsAny<ProviderFundingInfo>()))
                .ReturnsAsync(new FspCodeDeliverable(fspCode, deliverableCode++, deliverableName,
                    deliverableDisplayOrder, fsCode, allocationReferencePrefix));
            Mock<IFundingStreamPeriodRepository> fundingStreamPeriodRepMock = new Mock<IFundingStreamPeriodRepository>();
            fundingStreamPeriodRepMock.Setup(r => r.GetFspStartAndEndDate(It.IsAny<string>()))
                .ReturnsAsync((fspStartDate, fspEndDate));

            FundingAllocationsToContractTransformer transformer = new FundingAllocationsToContractTransformer(
                cfsToFcsCodeMappingServiceMock.Object, fundingStreamPeriodRepMock.Object);

            var totalContractValue = (plannedValueJan + plannedValueFeb) * 2;

            // act
            var contractAllocations = transformer.CreateAllocationsFrom(
                contractingOrgUkprn,
                new List<FundingAllocation> { fundingAllocation },
                new ContractItemsMappingResult(fundingType, fcsFundingPeriod, fspGroup, contractType),
                fsp => allocationNumber).Result;

            // assert
            Assert.AreEqual(1, contractAllocations.Count, "The number of allocations is not correct");
            var allocation = contractAllocations.First();
            Assert.AreEqual(2, allocation.contractDeliverables.Count, "The number of deliverables is not correct");
            Assert.AreEqual(string.Empty, allocation.DeliveryOrganisation, "The deliverable org is not correct");
            Assert.AreEqual(totalContractValue, allocation.maximumContractValue, "The allocation maximumContractValue is not correct");
            Assert.AreEqual($"{allocationReferencePrefix}-{allocationNumber}", allocation.contractAllocationNumber, "The contractAllocationNumber is not correct");
            Assert.AreEqual("2021", allocation.period.period1, "The allocation period is not correct");
            Assert.AreEqual(fspCode, allocation.period.fundingStreamPeriods.First().fundingStreamPeriodCode, "The allocation period FSP is not correct");
            var deliverable = allocation.contractDeliverables.First();
            Assert.AreEqual(20, deliverable.deliverable.deliverableCode, "The deliverableCode is not correct");
            Assert.AreEqual(deliverableName, deliverable.deliverable.deliverableName, "The deliverableName is not correct");
            Assert.AreEqual(12, deliverable.contractDeliverablePeriods.Count, "The number of contractDeliverablePeriods is not correct");
            Assert.AreEqual(totalContractValue / 2, deliverable.plannedValue, "The plannedValue for the deliverable is not correct");
            Assert.AreEqual(deliverableDisplayOrder, deliverable.DisplayOrder, "The DisplayOrder for the deliverable is not correct");
            var dpJan = deliverable.contractDeliverablePeriods 
                .SingleOrDefault(dp => dp.year == 2022 && dp.period == 1);
            Assert.IsNotNull(dpJan, "The contract does not contain a period for 2021 Jan");
            Assert.AreEqual("Jan-22", dpJan.periodName, "The periodName is not correct");
            Assert.AreEqual(plannedValueJan, dpJan.plannedValue, "The plannedValueJan is not correct");
            Assert.AreEqual(202201, dpJan.displayOrder, "The displayOrder for dpJan is not correct");
            var dpFeb = deliverable.contractDeliverablePeriods
                .SingleOrDefault(dp => dp.year == 2022 && dp.period == 2);
            Assert.AreEqual(plannedValueFeb, dpFeb.plannedValue, "The plannedValueFeb is not correct");
            Assert.AreEqual(202202, dpFeb.displayOrder, "The displayOrder for dpFeb is not correct");
        }
    }
}