namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PolicyFundingStreamPeriodWriterTests
    {
        private string TestFundingStreamPeriodCode = "GGGHHH";
        
        [TestInitialize]
        public void Initialize()
        {
            CleanUp();
        }

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod updatedObject =
                    context.PolicyFundingStreamPeriods.Find(TestFundingStreamPeriodCode);

                if (updatedObject != null)
                {
                    context.PolicyFundingStreamPeriods.Remove(updatedObject);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodWriter_ShouldUpdateTableWhenRowKeyMatches()
        {
            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod testPolicyFundingStreamPeriod = new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = TestFundingStreamPeriodCode,
                    PaymentMethod = PaymentMethod.PayOnActuals
                };

                context.PolicyFundingStreamPeriods.Add(testPolicyFundingStreamPeriod);
                context.SaveChanges();
            }

            // act
            IList<FundingStreamPeriodSheetType> sheetObjects = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    PaymentMethod = "Pay On Profile",
                    PolicyStatus = PolicyStatus.Approved
                }
            };
            
            PolicyFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod updatedObject =
                    context.PolicyFundingStreamPeriods.Find(TestFundingStreamPeriodCode);

                Assert.AreEqual(PaymentMethod.PayOnProfile, updatedObject.PaymentMethod);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodWriter_ShouldInsertRowWhenRowKeyDoesNotMatch()
        {
            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod existingPolicyFundingStreamPeriod = context.PolicyFundingStreamPeriods.Find(TestFundingStreamPeriodCode);

                if (existingPolicyFundingStreamPeriod != null)
                {
                    context.PolicyFundingStreamPeriods.Remove(existingPolicyFundingStreamPeriod);
                    context.SaveChanges();
                }
            }

            // act
            IList<FundingStreamPeriodSheetType> sheetObjects = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    PaymentMethod = "Pay On Profile",
                    PolicyStatus = PolicyStatus.Approved
                }
            };

            PolicyFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod insertedObject =
                    context.PolicyFundingStreamPeriods.Find(TestFundingStreamPeriodCode);

                Assert.IsNotNull(insertedObject);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void PolicyFundingStreamPeriodWriter_ShouldDeleteRowWhenPolicyStatusSetToDelete()
        {
            // arrange
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod testPolicyFundingStreamPeriod = new PolicyFundingStreamPeriod
                {
                    FundingStreamPeriod = TestFundingStreamPeriodCode,
                    PaymentMethod = PaymentMethod.PayOnActuals
                };

                context.PolicyFundingStreamPeriods.Add(testPolicyFundingStreamPeriod);
                context.SaveChanges();
            }

            // act
            IList<FundingStreamPeriodSheetType> sheetObjects = new List<FundingStreamPeriodSheetType>
            {
                new FundingStreamPeriodSheetType
                {
                    FundingStreamPeriodCode = TestFundingStreamPeriodCode,
                    PaymentMethod = "Pay On Actuals",
                    PolicyStatus = PolicyStatus.Removed
                }
            };

            PolicyFundingStreamPeriodWriter.WriteToPaaSDatabase(sheetObjects, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentManagementPolicyContext())
            {
                PolicyFundingStreamPeriod insertedObject =
                    context.PolicyFundingStreamPeriods.Find(TestFundingStreamPeriodCode);

                Assert.IsNull(insertedObject);
            }
        }
    }
}
