namespace AllocationDeliveryDomain.Endpoint.Tests.ContractUnderTerminationEndpoint.Services
{
    using System.Collections.Generic;
    using Endpoint.ContractUnderTerminationEndpoint.Services;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    [TestClass]
    public class AllocationActualsMapperTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void AllocationActualsMapper_ShouldMapToContractAllocationActualsType()
        {
            var adpActualAudit = new AllocationDeliverablePeriodActualAudit
            {
                ActualValue = 10f,
                ActualVolume = 50L,
                CollectionReturnCode = "CRC",
                CollectionType = "CT",
                CollectionReturnPeriod = 1,
                Period = "201801",
                ContractAllocationNumber = "Alloc1",
                ContractNumber = "Contract1",
                PeriodTypeCode = "PT",
                Ukprn = "12345678",
                OrganisationId = "ORG0000001",
                FundingStreamPeriodCode = "FSP1516",
                ContractVersion = 1,
                ContractSubVersion = 0,
                DeliverableCode = 1,
                UopCode = "UOP"
            };

            var actualsSummary = new List<ActualsSummaryType>
            {
                new ActualsSummaryType
                {
                    ActualValue = 10m,
                    ActualVolume = 50,
                    DeliverableCode = 1,
                    Period = "201801",
                    PeriodType = new PeriodTypeType
                    {
                        PeriodTypeCode = "ABC"
                    }
                }
            };

            var mapped = AllocationActualsMapper.Map(adpActualAudit, actualsSummary);

            Assert.AreSame(actualsSummary, mapped.ActualsSummary, "Actuals Summary should be the same");
            Assert.AreEqual(adpActualAudit.FundingStreamPeriodCode, mapped.FundingStreamPeriodCode);
            Assert.AreEqual(adpActualAudit.CollectionReturnCode, mapped.CollectionReturnCode);
            Assert.AreEqual(adpActualAudit.CollectionType, mapped.CollectionType);
            Assert.AreEqual(adpActualAudit.ContractAllocationNumber, mapped.ContractAllocationNumber);
            Assert.AreEqual(adpActualAudit.ContractNumber, mapped.ContractReference.ContractNumber);
            Assert.AreEqual(adpActualAudit.ContractVersion, mapped.ContractReference.ContractVersionNumber);
            Assert.AreEqual(adpActualAudit.ContractSubVersion, mapped.ContractReference.ContractSubVersionNumber);
            Assert.AreEqual(adpActualAudit.Ukprn,
                mapped.ContractorReference.AlternativeOrganisationIdentifiers[0].organisationIdentifier);
            Assert.AreEqual(organisationIdentifierType.UKPROVIDERREFERENCENUMBER,
                mapped.ContractorReference.AlternativeOrganisationIdentifiers[0].organisationIdentifierType);
            Assert.AreEqual(adpActualAudit.UopCode, mapped.UoPCode);
        }
    }
}