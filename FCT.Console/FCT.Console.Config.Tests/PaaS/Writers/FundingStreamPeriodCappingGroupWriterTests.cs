namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using System.Data.Entity.Validation;
    using MoreLinq;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class FundingStreamPeriodCappingGroupWriterTests
    {
        private const string TestFspCode = "FSP_TEST";
        private const string TestDeliverableCappingGroup = "CappingGroup_TEST";

        [TestCleanup, TestInitialize]
        public void CleanUp()
        {
            try
            {
                using (var context = new PaymentManagementPolicyContext())
                {
                    context.PolicyDeliverables.Join(context.CappingGroups, pd => pd.FundingStreamPeriodCappingGroupId, cg => cg.FundingStreamPeriodCappingGroupId, (policyDeliverable, cappingGroup) => new { policyDeliverable, cappingGroup }) 
                        .Where(resultSet => resultSet.cappingGroup.FundingStreamPeriod == TestFspCode)
                        .Select(resultSet => resultSet.policyDeliverable)
                        .ForEach(pd => context.PolicyDeliverables.Remove(pd));
                  
                    var entitiesToRemove = context.CappingGroups.Where(cg => cg.FundingStreamPeriod == TestFspCode).ToList();

                    foreach (var entity in entitiesToRemove)
                    {
                        context.CappingGroups.Remove(entity);
                    }

                    var testFsps = context.PolicyFundingStreamPeriods.Where(fsp => fsp.FundingStreamPeriod == TestFspCode);

                    foreach (var testFsp in testFsps)
                    {
                        context.PolicyFundingStreamPeriods.Remove(testFsp);
                    }

                    context.SaveChanges();
                }
            }
            catch (DbEntityValidationException ex)
            {
                // Retrieve the error messages as a list of strings.
                var errorMessages = ex.EntityValidationErrors
                    .SelectMany(x => x.ValidationErrors)
                    .Select(x => x.ErrorMessage);

                // Join the list to a single string.
                var fullErrorMessage = string.Join("; ", errorMessages);

                // Combine the original exception message with the new one.
                var exceptionMessage = string.Concat(ex.Message, " The validation errors are: ", fullErrorMessage);

                // Throw a new DbEntityValidationException with the improved exception message.
                throw new DbEntityValidationException(exceptionMessage, ex.EntityValidationErrors);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingGroup_ShouldInsertANewCappingGroupWhenTheDomainIdentityDoesNotExist()
        {
            //arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rowsToCreate = CreateRows(TestFspCode, TestDeliverableCappingGroup, PolicyStatus.Approved);

            AddTestFsp();

            // act
            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(rowsToCreate, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                int numMatchingRows = context.CappingGroups.Count(cg => cg.FundingStreamPeriod == TestFspCode &&
                                                                         cg.CappingGroupName ==
                                                                         TestDeliverableCappingGroup);

                Assert.AreEqual(1, numMatchingRows);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingGroup_ShouldUpdateAnExistingCappingGroupWhenTheDomainIdentityExists()
        {
            //arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rowsToCreate = CreateRows(TestFspCode, TestDeliverableCappingGroup, PolicyStatus.Approved);

            AddTestFsp();
            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(rowsToCreate, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rowsToUpdate = CreateRows(TestFspCode, TestDeliverableCappingGroup, PolicyStatus.Approved);

            FundingStreamPeriodCappingGroupSheetType entityToUpdate = rowsToUpdate.Single();
            entityToUpdate.AllowOverDeliveryToBeOffset = true;
            entityToUpdate.AllowUnderDeliveryToBeReUsed = true;
            
            // act

            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(rowsToUpdate, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var matchingRow = context.CappingGroups.Single(cg => cg.FundingStreamPeriod == TestFspCode &&
                                                                         cg.CappingGroupName ==
                                                                         TestDeliverableCappingGroup);

                Assert.AreEqual(true, matchingRow.AllowOverDeliveryToBeOffset);
                Assert.AreEqual(true, matchingRow.AllowUnderDeliveryToBeReUsed);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void FundingStreamPeriodCappingGroup_ShouldDeleteAnExistingCappingGroupWhenTheDomainIdentityExists()
        {
            //arrange
            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rowsToCreate = CreateRows(TestFspCode, TestDeliverableCappingGroup, PolicyStatus.Approved);

            AddTestFsp();
            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(rowsToCreate, WriterBehaviour.AddOrUpdate);

            IEnumerable<FundingStreamPeriodCappingGroupSheetType> rowsToDelete = CreateRows(TestFspCode, TestDeliverableCappingGroup, PolicyStatus.Removed);
            // act
            PolicyCacheFundingStreamPeriodCappingGroupWriter.WriteToPaaSDatabase(rowsToDelete, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                var numMatching = context.CappingGroups.Count(cg => cg.FundingStreamPeriod == TestFspCode &&
                                                                         cg.CappingGroupName ==
                                                                         TestDeliverableCappingGroup);

                Assert.AreEqual(0, numMatching);
            }
        }

        private IEnumerable<FundingStreamPeriodCappingGroupSheetType> CreateRows(string fundingStreamPeriod, string cappingGroupName, PolicyStatus policyStatus)
        {
            return new List<FundingStreamPeriodCappingGroupSheetType>
            {
                new FundingStreamPeriodCappingGroupSheetType
                {
                    PolicyStatus = policyStatus,
                    FundingStreamPeriod = fundingStreamPeriod,
                    CappingGroupName = cappingGroupName,
                    FundingStreamPeriodCappingGroupId = 9
                }
            };
        }

        private void AddTestFsp()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod testPolicyFundingStreamPeriod = new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = TestFspCode,
                    PaymentMethod = PaymentMethod.PayOnActuals
                };

                context.PolicyFundingStreamPeriods.Add(testPolicyFundingStreamPeriod);
                context.SaveChanges();
            }
        }
    }
}
