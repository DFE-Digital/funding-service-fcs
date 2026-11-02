namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.DocumentsDomain.DataStore;
    using SFA.FCT.DocumentsDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class DocumentsDomainFspDeliverableWriterTests
    {
        private const string CodeKey = "MCHTEST1";

        [TestInitialize]
        public void Setup()
        {
            CleanUp();
            FundingStreamPeriod fsp = new FundingStreamPeriod(
                fundingStreamPeriodCode: CodeKey,
                summaryOfFundingDisplayName: string.Empty,
                displayOrder: 1,
                shouldGenerateFundingAgreement: true,
                shouldUseContractAllocationDescription: true,
                template: string.Empty,
                extraPagesTemplate: string.Empty,
                fspGroupCode: null,
                fundingAgreementDisplayName: null);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FundingStreamPeriods.Add(fsp);
                context.SaveChanges();
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new DocumentsDomainDbContext())
            {
                FundingStreamPeriod fsp = context.FundingStreamPeriods.Find(CodeKey);
                if (fsp != null)
                {
                    // SQL cascade delete setup between FundingStreamPeriod and FSPDeliverable
                    // so don't need to specifically delete the FSPDeliverable record(s)
                    context.FundingStreamPeriods.Remove(fsp);
                    context.SaveChanges();
                }
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainFSPDeliverableWriter_NewDocumentsDomainFSPDeliverable()
        {
            // Arrange
            const int deliverableCode = 1;
            const bool allowProfile = false;
            const bool displayOnFundingAgreement = false;
            const bool mandatoryOnFundingAgreement = false;
            const int displayOrderOnFundingAgreement = 99;
            const bool allowCustomDescription = false;
            const bool shouldDisplayValue = false;
            const bool shouldDisplayVolumeAndUnitCost = false;
            const string displayNameOnSummaryOfFunding = "displayNameOnSummaryOfFunding";
            const string displayNameOnFundingAgreement = "displayNameOnFundingAgreement";
            const bool displayOnSummaryOfFunding = false; 

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = CodeKey,
                AllowProfile = allowProfile,
                DisplayOnFundingAgreement = displayOnFundingAgreement,
                MandatoryOnFundingAgreement = mandatoryOnFundingAgreement,
                DisplayOrderOnFundingAgreement = displayOrderOnFundingAgreement,
                AllowCustomDescription = allowCustomDescription,
                ShouldDisplayValue = shouldDisplayValue,
                ShouldDisplayVolumeAndUnitCost = shouldDisplayVolumeAndUnitCost,
                DisplayNameOnSummaryOfFunding = displayNameOnSummaryOfFunding,
                DisplayNameOnFundingAgreement = displayNameOnFundingAgreement,
                DisplayOnSummaryOfFunding = displayOnSummaryOfFunding,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedfundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            DocumentsDomainFSPDeliverableWriter.WriteToPaaSDatabase(updatedfundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new DocumentsDomainDbContext())
            {
                FSPDeliverable testedFspDeliverable = context.FSPDeliverables.Find(deliverableCode, CodeKey);
                
                Assert.IsNotNull(testedFspDeliverable);
                Assert.AreEqual(allowProfile, testedFspDeliverable.AllowProfile, "Incorrect AllowProfile");
                Assert.AreEqual(displayOnFundingAgreement, testedFspDeliverable.DisplayOnFundingAgreement, "Incorrect DisplayOnFundingAgreement");
                Assert.AreEqual(mandatoryOnFundingAgreement, testedFspDeliverable.MandatoryOnFundingAgreement, "Incorrect MandatoryOnFundingAgreement");
                Assert.AreEqual(displayOrderOnFundingAgreement, testedFspDeliverable.DisplayOrderOnFundingAgreement, "Incorrect DisplayOrderOnFundingAgreement");
                Assert.AreEqual(allowCustomDescription, testedFspDeliverable.AllowCustomDescription, "Incorrect AllowCustomDescription");
                Assert.AreEqual(shouldDisplayValue, testedFspDeliverable.ShouldDisplayValue, "Incorrect ShouldDisplayValue");
                Assert.AreEqual(shouldDisplayVolumeAndUnitCost, testedFspDeliverable.ShouldDisplayVolumeAndUnitCost, "Incorrect ShouldDisplayVolumeAndUnitCost");
                Assert.AreEqual(displayNameOnSummaryOfFunding, testedFspDeliverable.DisplayNameOnSummaryOfFunding, "Incorrect DisplayNameOnSummaryOfFunding");
                Assert.AreEqual(displayNameOnFundingAgreement, testedFspDeliverable.DisplayNameOnFundingAgreement, "Incorrect DisplayNameOnFundingAgreement");
                Assert.AreEqual(displayOnSummaryOfFunding, testedFspDeliverable.DisplayOnSummaryOfFunding, "Incorrect DisplayOnSummaryOfFunding");
            }
        }
        
        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainFSPDeliverableWriter_UpdateDocumentsDomainFSPDeliverable()
        {
            // Arrange
            const int deliverableCode = 1;

            FSPDeliverable beforeFspDeliverable = new FSPDeliverable(
                deliverableCode: deliverableCode,
                fundingStreamPeriodCode: CodeKey,
                allowProfile: true,
                displayOnFundingAgreement: true,
                mandatoryOnFundingAgreement: true,
                displayOrderOnFundingAgreement: 0,
                allowCustomDescription: true,
                shouldDisplayValue: true,
                shouldDisplayVolumeAndUnitCost: true,
                displayNameOnSummaryOfFunding: "before_displayNameOnSummaryOfFunding",
                displayNameOnFundingAgreement: "before_displayNameOnFundingAgreement",
                displayOnSummaryOfFunding: true);
            
            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPDeliverables.Add(beforeFspDeliverable);
                context.SaveChanges();
            }

            const bool allowProfile = false;
            const bool displayOnFundingAgreement = false;
            const bool mandatoryOnFundingAgreement = false;
            const int displayOrderOnFundingAgreement = 99;
            const bool allowCustomDescription = false;
            const bool shouldDisplayValue = false;
            const bool shouldDisplayVolumeAndUnitCost = false;
            const string displayNameOnSummaryOfFunding = "displayNameOnSummaryOfFunding";
            const string displayNameOnFundingAgreement = "displayNameOnFundingAgreement";
            const bool displayOnSummaryOfFunding = false;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = CodeKey,
                AllowProfile = allowProfile,
                DisplayOnFundingAgreement = displayOnFundingAgreement,
                MandatoryOnFundingAgreement = mandatoryOnFundingAgreement,
                DisplayOrderOnFundingAgreement = displayOrderOnFundingAgreement,
                AllowCustomDescription = allowCustomDescription,
                ShouldDisplayValue = shouldDisplayValue,
                ShouldDisplayVolumeAndUnitCost = shouldDisplayVolumeAndUnitCost,
                DisplayNameOnSummaryOfFunding = displayNameOnSummaryOfFunding,
                DisplayNameOnFundingAgreement = displayNameOnFundingAgreement,
                DisplayOnSummaryOfFunding = displayOnSummaryOfFunding,
                PolicyStatus = PolicyStatus.Approved
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedfundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            DocumentsDomainFSPDeliverableWriter.WriteToPaaSDatabase(updatedfundingStreamPeriodDeliverables, WriterBehaviour.AddOrUpdate);

            // Assert
            using (var context = new DocumentsDomainDbContext())
            {
                FSPDeliverable testedFspDeliverable = context.FSPDeliverables.Find(deliverableCode, CodeKey);

                Assert.IsNotNull(testedFspDeliverable);
                Assert.AreEqual(allowProfile, testedFspDeliverable.AllowProfile, "Incorrect AllowProfile");
                Assert.AreEqual(displayOnFundingAgreement, testedFspDeliverable.DisplayOnFundingAgreement, "Incorrect DisplayOnFundingAgreement");
                Assert.AreEqual(mandatoryOnFundingAgreement, testedFspDeliverable.MandatoryOnFundingAgreement, "Incorrect MandatoryOnFundingAgreement");
                Assert.AreEqual(displayOrderOnFundingAgreement, testedFspDeliverable.DisplayOrderOnFundingAgreement, "Incorrect DisplayOrderOnFundingAgreement");
                Assert.AreEqual(allowCustomDescription, testedFspDeliverable.AllowCustomDescription, "Incorrect AllowCustomDescription");
                Assert.AreEqual(shouldDisplayValue, testedFspDeliverable.ShouldDisplayValue, "Incorrect ShouldDisplayValue");
                Assert.AreEqual(shouldDisplayVolumeAndUnitCost, testedFspDeliverable.ShouldDisplayVolumeAndUnitCost, "Incorrect ShouldDisplayVolumeAndUnitCost");
                Assert.AreEqual(displayNameOnSummaryOfFunding, testedFspDeliverable.DisplayNameOnSummaryOfFunding, "Incorrect DisplayNameOnSummaryOfFunding");
                Assert.AreEqual(displayNameOnFundingAgreement, testedFspDeliverable.DisplayNameOnFundingAgreement, "Incorrect DisplayNameOnFundingAgreement");
                Assert.AreEqual(displayOnSummaryOfFunding, testedFspDeliverable.DisplayOnSummaryOfFunding, "Incorrect DisplayOnSummaryOfFunding");
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void DocumentsDomainFSPDeliverableWriter_DeleteExistingDocumentsDomainFSPDeliverable()
        {
            // Arrange
            const int deliverableCode = 1;

            FSPDeliverable fspDeliverable = new FSPDeliverable(
                deliverableCode: deliverableCode,
                fundingStreamPeriodCode: CodeKey,
                allowProfile: true,
                displayOnFundingAgreement: true,
                mandatoryOnFundingAgreement: true,
                displayOrderOnFundingAgreement: 0,
                allowCustomDescription: true,
                shouldDisplayValue: true,
                shouldDisplayVolumeAndUnitCost: true,
                displayNameOnSummaryOfFunding: "before_displayNameOnSummaryOfFunding",
                displayNameOnFundingAgreement: "before_displayNameOnFundingAgreement",
                displayOnSummaryOfFunding: true);

            using (var context = new DocumentsDomainDbContext())
            {
                context.FSPDeliverables.Add(fspDeliverable);
                context.SaveChanges();
            }

            const bool allowProfile = false;
            const bool displayOnFundingAgreement = false;
            const bool mandatoryOnFundingAgreement = false;
            const int displayOrderOnFundingAgreement = 99;
            const bool allowCustomDescription = false;
            const bool shouldDisplayValue = false;
            const bool shouldDisplayVolumeAndUnitCost = false;
            const string displayNameOnSummaryOfFunding = "displayNameOnSummaryOfFunding";
            const string displayNameOnFundingAgreement = "displayNameOnFundingAgreement";
            const bool displayOnSummaryOfFunding = false;

            FundingStreamPeriodDeliverablesSheetType fundingStreamPeriodDeliverablesSheetTypeEntry = new FundingStreamPeriodDeliverablesSheetType
            {
                DeliverableCode = deliverableCode,
                FundingStreamPeriodCode = CodeKey,
                AllowProfile = allowProfile,
                DisplayOnFundingAgreement = displayOnFundingAgreement,
                MandatoryOnFundingAgreement = mandatoryOnFundingAgreement,
                DisplayOrderOnFundingAgreement = displayOrderOnFundingAgreement,
                AllowCustomDescription = allowCustomDescription,
                ShouldDisplayValue = shouldDisplayValue,
                ShouldDisplayVolumeAndUnitCost = shouldDisplayVolumeAndUnitCost,
                DisplayNameOnSummaryOfFunding = displayNameOnSummaryOfFunding,
                DisplayNameOnFundingAgreement = displayNameOnFundingAgreement,
                DisplayOnSummaryOfFunding = displayOnSummaryOfFunding,
                PolicyStatus = PolicyStatus.Removed
            };

            List<FundingStreamPeriodDeliverablesSheetType> updatedfundingStreamPeriodDeliverables = new List<FundingStreamPeriodDeliverablesSheetType>
            {
                fundingStreamPeriodDeliverablesSheetTypeEntry
            };

            // Act
            DocumentsDomainFSPDeliverableWriter.WriteToPaaSDatabase(updatedfundingStreamPeriodDeliverables, WriterBehaviour.Delete);

            // Assert
            using (var context = new DocumentsDomainDbContext())
            {
                FSPDeliverable testedFspDeliverable = context.FSPDeliverables.Find(deliverableCode, CodeKey);

                Assert.IsNull(testedFspDeliverable);
            }
        }
    }
}