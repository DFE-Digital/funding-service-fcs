namespace AllocationDeliveryDomain.Endpoint.Tests.Unit
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Services;
    using SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;

    [TestClass]
    public class SummarisedActualTransformerTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void SummarisedActualTransformer_ShouldTransformToExpectedReportedActual()
        {
            // arrange
            SummarisedActual summarisedActual = new SummarisedActual
            {
                Id = 100,
                CollectionType = "APPS",
                CollectionReturnCode = "APPS01",
                OrganisationId = "ORG00001234",
                FundingStreamPeriodCode = "NONLEVY2019",
                UopCode = "UOP1",
                ContractAllocationNumber = "NLA-1234",
                Period = 201912,
                DeliverableCode = 5,
                ActualVolume = 10,
                ActualValue = 999.99m,
                DataCollectionsId = 123
            };
            
            // act
            ReportedActual reportedActual = SummarisedActualTransformer.ToReportedActual(summarisedActual);

            // assert
            Assert.IsNotNull(reportedActual, "Transformed ReportedActual was null");
            Assert.AreEqual("APPS", reportedActual.CollectionType, "Transformed CollectionType was incorrect");
            Assert.AreEqual("APPS01", reportedActual.CollectionReturnCode, "Transformed CollectionReturnCode was incorrect");
            Assert.AreEqual("ORG00001234", reportedActual.OrganisationId, "Transformed OrganisationId was incorrect");
            Assert.AreEqual("NONLEVY2019", reportedActual.FundingStreamPeriodCode, "Transformed FundingStreamPeriodCode was incorrect");
            Assert.AreEqual("UOP1", reportedActual.UoPCode, "Transformed UoPCode was incorrect");
            Assert.AreEqual("NLA-1234", reportedActual.ContractAllocationNumber, "Transformed ContractAllocationNumber was incorrect");
            Assert.AreEqual("CM", reportedActual.PeriodTypeCode, "Transformed PeriodTypeCode should always be CM");
            Assert.AreEqual("201912", reportedActual.Period, "Transformed Period was incorrect");
            Assert.AreEqual("5", reportedActual.DeliverableCode, "Transformed DeliverableCode was incorrect");
            Assert.AreEqual(10, reportedActual.ActualVolume, "Transformed ActualVolume was incorrect");
            Assert.AreEqual(999.99, reportedActual.ActualValue, "Transformed ActualValue was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void SummarisedActualTransformer_ShouldTransformNullableValuesCorrectly()
        {
            // arrange
            SummarisedActual summarisedActual = new SummarisedActual
            {
                Id = 100,
                CollectionType = "APPS",
                CollectionReturnCode = "APPS01",
                OrganisationId = "ORG00001234",
                FundingStreamPeriodCode = "NONLEVY2019",
                UopCode = null,
                ContractAllocationNumber = null,
                Period = 201912,
                DeliverableCode = 5,
                ActualVolume = null,
                ActualValue = 999.99m,
                DataCollectionsId = 123
            };

            // act
            ReportedActual reportedActual = SummarisedActualTransformer.ToReportedActual(summarisedActual);

            // assert
            Assert.IsNull(reportedActual.UoPCode, "Transformed UoPCode was incorrect");
            Assert.IsNull(reportedActual.ContractAllocationNumber, "Transformed ContractAllocationNumber was incorrect");
            Assert.AreEqual(0, reportedActual.ActualVolume, "Transformed ActualVolume was incorrect");
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToReportedActual_ShouldIgnoreVolumeWhenFspIsSkillsBootcamp()
        {
            // arrange
            var skillsBootFsps = new List<string>
            {
                "SB2022",
                "SB-PAA2022"
            };

            // act
            skillsBootFsps.ForEach(fsp =>
            {
                SummarisedActual summarisedActual = new SummarisedActual
                {
                    Id = 100,
                    CollectionType = "APPS",
                    CollectionReturnCode = "APPS01",
                    OrganisationId = "ORG00001234",
                    FundingStreamPeriodCode = fsp,
                    UopCode = null,
                    ContractAllocationNumber = null,
                    Period = 201912,
                    DeliverableCode = 5,
                    ActualVolume = 11,
                    ActualValue = 999.99m,
                    DataCollectionsId = 123
                };

                ReportedActual reportedActual = SummarisedActualTransformer.ToReportedActual(summarisedActual);

                // assert  
                Assert.AreEqual(0, reportedActual.ActualVolume, "Ignore the ActualVolume if the FSP is one the SB ones.");
            });
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ToReportedActual_ShouldNotVolumeWhenFspIsNotSkillsBootcamp()
        {
            // arrange
            int actualVol = 11;

            SummarisedActual summarisedActual = new SummarisedActual
            {
                Id = 100,
                CollectionType = "APPS",
                CollectionReturnCode = "APPS01",
                OrganisationId = "ORG00001234",
                FundingStreamPeriodCode = "someFsp",
                UopCode = null,
                ContractAllocationNumber = null,
                Period = 201912,
                DeliverableCode = 5,
                ActualVolume = actualVol,
                ActualValue = 999.99m,
                DataCollectionsId = 123
            };

            // act
            ReportedActual reportedActual = SummarisedActualTransformer.ToReportedActual(summarisedActual);

            // assert  
            Assert.AreEqual(actualVol, reportedActual.ActualVolume);
        }
    }
}
