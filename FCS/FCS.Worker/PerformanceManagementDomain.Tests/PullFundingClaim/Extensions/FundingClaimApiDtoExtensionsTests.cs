namespace PerformanceManagementDomain.Tests.PullFundingClaim.Extensions
{
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PerformanceManagementDomain.PullFundingClaim.DTOs;
    using PerformanceManagementDomain.PullFundingClaim.Extensions;

    [TestClass]
    public class FundingClaimApiDtoExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void FundingClaimApiDtoExtensions_ShouldCreateModel()
        {
            // arrange
            FundingClaimApiDto dto = new FundingClaimApiDto
            {
                OrganisationIdentifier = "o1",
                ClaimTypeName = "ct1",
                HasBeenSigned = "true",
                Period = "2021",
                PeriodTypeCode = "Final",
                Ukprn = "12345678",
                VersionNumber = 1,
                ContractAllocations = new List<ContractAllocationApiDto>
                {
                    new ContractAllocationApiDto
                    {
                        ContractAllocationNumber = "can1",
                        FundingStreamPeriodCode = "fsp1",
                        MaximumContractValue = 12,
                        DeliverableCodes = new List<DeliverableCodeApiDto>
                        {
                            new DeliverableCodeApiDto
                            {
                                ActualValue = 10,
                                ActualVolume = 11,
                                AdjustmentValue = 12M,
                                DeliverableCodeValue = 1,
                                ForecastValue = 13M,
                                TotalDelivery = 14M
                            }
                        }
                    }
                }
            };

            // act
            var model = dto.ToDataModel();
            // assert
            Assert.AreEqual(dto.OrganisationIdentifier, model.OrganisationIdentifier, "The OrganisationIdentifier is not correct");
            Assert.AreEqual(dto.ClaimTypeName.ToUpper(), model.ClaimTypeName, "The ClaimTypeName is not correct");
            Assert.AreEqual(bool.Parse(dto.HasBeenSigned), model.HasBeenSigned, "The HasBeenSigned is not correct");
            Assert.AreEqual(dto.Period, model.Period, "The Period is not correct");
            Assert.AreEqual(dto.PeriodTypeCode, model.PeriodTypeCode, "The PeriodTypeCode is not correct");
            Assert.AreEqual(int.Parse(dto.Ukprn), model.Ukprn, "The Ukprn is not correct");
            Assert.AreEqual(dto.VersionNumber, model.VersionNumber, "The VersionNumber is not correct");

            var modelAllocation = model.Allocations.Single();
            var dtoAllocation = dto.ContractAllocations.Single();
            Assert.AreEqual(dtoAllocation.FundingStreamPeriodCode, modelAllocation.FundingStreamPeriodCode, "The FundingStreamPeriodCode is not correct");
            Assert.AreEqual(dtoAllocation.ContractAllocationNumber, modelAllocation.ContractAllocationNumber, "The ContractAllocationNumber is not correct");

            var modelDeliverable = modelAllocation.Deliverables.Single();
            var dtoDeliverable = dtoAllocation.DeliverableCodes.Single();
            Assert.AreEqual(dtoDeliverable.ActualValue, modelDeliverable.ActualValue, "The ActualValue is not correct");
            Assert.AreEqual(dtoDeliverable.ForecastValue, modelDeliverable.ForecastValue, "The ForecastValue is not correct");

            Assert.AreEqual(dtoDeliverable.DeliverableCodeValue, modelDeliverable.DeliverableCode, "The DeliverableCode is not correct");
            Assert.AreEqual(dtoDeliverable.ForecastValue, modelDeliverable.ForecastValue, "The ForecastValue is not correct");
            Assert.AreEqual(dtoDeliverable.ActualValue, modelDeliverable.ActualValue, "The ActualValue is not correct");
            Assert.AreEqual(dtoDeliverable.AdjustmentValue, modelDeliverable.AdjustmentValue, "The AdjustmentValue is not correct");
            Assert.AreEqual(dtoDeliverable.TotalDelivery, modelDeliverable.TotalDelivery, "The TotalDelivery is not correct");
            Assert.AreEqual(modelAllocation.Id, modelDeliverable.ContractAllocationId, "The ContractAllocationId on the deliverable is not correct");
        }
    }
}
