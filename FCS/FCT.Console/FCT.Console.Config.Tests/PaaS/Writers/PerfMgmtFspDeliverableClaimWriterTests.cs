namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System;
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Validation;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using SFA.FCT.PerformanceManagementDomain.DataStore;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PerfMgmtFspDeliverableClaimWriterTests : TestBase
    {
        private const string FspCodeToInsert = "TFSPC";
        private const int DeliverableCodeToInsert = 1;
        private const string FspDeliverableClaimNameToInsert = "FspDeliverableClaimNameToInsert";
        private const string ClaimReconciliationDeliverableGroupCodeToInsert = "TRAGC";

        private readonly ClaimReconciliationDeliverableGroup _deliverableGroup = new ClaimReconciliationDeliverableGroup(ClaimReconciliationDeliverableGroupCodeToInsert,
            "TestGroupCode", true, false);

        [TestInitialize]
        public void Setup()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                context.ClaimReconciliationDeliverableGroups.Add(_deliverableGroup);

                context.SaveChanges();
            }
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PerformanceManagementDbContext())
            {
                var fspDeliverableClaimsToRemove = new List<FspDeliverableClaim>
                {
                    context.FspDeliverableClaims.Find(FspCodeToInsert, DeliverableCodeToInsert)
                };

                foreach (var ct in fspDeliverableClaimsToRemove.Where(ct => ct != null))
                {
                    context.FspDeliverableClaims.Remove(ct);
                }

                var deliverableGroupsToRemove = new List<ClaimReconciliationDeliverableGroup>()
                {
                    context.ClaimReconciliationDeliverableGroups.Single(c => c.ClaimReconciliationDeliverableGroupCode == ClaimReconciliationDeliverableGroupCodeToInsert)
                };

                foreach (var claimReconciliationAllocationGroup in deliverableGroupsToRemove)
                {
                    context.Entry(claimReconciliationAllocationGroup).State = EntityState.Deleted;
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewFspDeliverableClaim_NewFspDeliverableClaim_IsInserted_InPaasTable()
        {
            //arrange
            List<FundingStreamPeriodDeliverablesSheetType> deliverableClaims = CreateApprovedFspDeliverableClaims();

            // act
            PerfMgmtFspDeliverableClaimWriter.WriteToPaaSDatabase(deliverableClaims, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                Assert.IsNotNull(context.FspDeliverableClaims.Find(FspCodeToInsert, DeliverableCodeToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedFspDeliverableClaim_ExistingFspDeliverableClaim_IsUpdated_InPaasTable()
        {
            // arrange
            //Setup data
            using (var context = new PerformanceManagementDbContext())
            {
                var deliverableClaims = CreateApprovedFspDeliverableClaims();
                var transformedClaims = FspDeliverableClaimTransformer.TransformCollection(deliverableClaims);
                transformedClaims.ForEach(ct =>
                {
                    context.FspDeliverableClaims.Add(ct);
                });

                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newDeliverableClaims = CreateApprovedFspDeliverableClaims();
            newDeliverableClaims[0].AllowClaim = false;

            // act
            PerfMgmtFspDeliverableClaimWriter.WriteToPaaSDatabase(newDeliverableClaims, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var updatedRecord = context.FspDeliverableClaims.Find(FspCodeToInsert, DeliverableCodeToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.IsFalse(updatedRecord.AllowClaim);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aFspDeliverableClaimToBeDeleted_TheFspDeliverableClaim_IsDeleted_InPaasTable()
        {
            // arrange
            var fspDeliverableClaimsToDelete = CreateFspDeliverableClaimsToDelete();
            var transformedClaims = FspDeliverableClaimTransformer.TransformCollection(fspDeliverableClaimsToDelete);

            //Setup data to delete
            using (var context = new PerformanceManagementDbContext())
            {
                transformedClaims.ForEach(fspDeliverableClaimSheetType =>
                {
                    context.FspDeliverableClaims.Add(fspDeliverableClaimSheetType);
                });

                context.SaveChanges();
            }

            // act
            PerfMgmtFspDeliverableClaimWriter.WriteToPaaSDatabase(fspDeliverableClaimsToDelete, WriterBehaviour.Delete);

            // assert
            using (var context = new PerformanceManagementDbContext())
            {
                var deletedRecord = context.FspDeliverableClaims.Find(FspCodeToInsert, DeliverableCodeToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private List<FundingStreamPeriodDeliverablesSheetType> CreateFspDeliverableClaimsToDelete()
        {
            return new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = FspCodeToInsert,
                    DeliverableCode = DeliverableCodeToInsert,
                    ParentDeliverableCode = null,
                    DeliverableName = FspDeliverableClaimNameToInsert,
                    DeliverableRelationshipType = null,
                    AllowProfile = false,
                    AllowActuals = false,
                    PaymentSubnominalCodeProfile = "",
                    PaymentSubnominalCodeReconciliation = "",
                    PaymentSubnominalCodeCapping = "",
                    AllowPayment = false,
                    DeliverableCappingGroup = "DCG",
                    CreatedDate = new DateTime(2016, 1, 1),
                    IsPayable = false,
                    DisplayOrder = 1,
                    PlanningUnit = "",
                    Mandatory = "",
                    ParentDeliverableName = "",
                    FundingStreamPeriodCappingGroupId = null,
                    AllowClaim = true,
                    ClaimReconciliationDeliverableGroupCode = ClaimReconciliationDeliverableGroupCodeToInsert,
                    PolicyStatus = PolicyStatus.Removed
                }
            };
        }

        private static List<FundingStreamPeriodDeliverablesSheetType> CreateApprovedFspDeliverableClaims()
        {
            // arrange
            return new List<FundingStreamPeriodDeliverablesSheetType>
            {
                new FundingStreamPeriodDeliverablesSheetType
                {
                    FundingStreamPeriodCode = FspCodeToInsert,
                    DeliverableCode = DeliverableCodeToInsert,
                    ParentDeliverableCode = null,
                    DeliverableName = FspDeliverableClaimNameToInsert,
                    DeliverableRelationshipType = null,
                    AllowProfile = false,
                    AllowActuals = false,
                    PaymentSubnominalCodeProfile = "",
                    PaymentSubnominalCodeReconciliation = "",
                    PaymentSubnominalCodeCapping = "",
                    AllowPayment = false,
                    DeliverableCappingGroup = "DCG",
                    CreatedDate = new DateTime(2016, 1, 1),
                    IsPayable = false,
                    DisplayOrder = 1,
                    PlanningUnit = "",
                    Mandatory = "",
                    ParentDeliverableName = "",
                    FundingStreamPeriodCappingGroupId = null,
                    AllowClaim = true,
                    ClaimReconciliationDeliverableGroupCode = ClaimReconciliationDeliverableGroupCodeToInsert,
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}