namespace FCT.Console.Config.Tests.PaaS.Writers
{
    using System.Collections.Generic;
    using System.Linq;
    using Config.Transformers;
    using ExcelTypes;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationDomain.Integration.DataStore;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using Synchronizers.Writers;
    using Synchronizers.Writers.PAAS;

    [TestClass]
    public class PayGenSubnominalWriterTests : TestBase
    {
        private const string TestSubnominalToInsert = "SubCode";
        private const string TestSubnominalDesc = "SubnominalDesc";

        [TestCleanup]
        public void CleanUp()
        {
            using (var context = new PaymentGenerationDbContext())
            {
                var subnominalsToRemove = new List<Subnominal>
                {
                    context.Subnominals.Find(TestSubnominalToInsert)
                };

                foreach (var sub in subnominalsToRemove.Where(s => s != null))
                {
                    context.Subnominals.Remove(sub);
                }

                context.SaveChanges();
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aNewSubnominal_NewSubnominal_IsInserted_InPaasTable()
        {
            //arrange
            List<SubnominalsSheetType> testSubnominals = CreateTestSubnominals();

            // act
            PayGenSubnominalWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                Assert.IsNotNull(context.Subnominals.Find(TestSubnominalToInsert));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_anUpdatedSubnominal_ExistingSubnominal_IsUpdated_InPaasTable()
        {
            // arrange
            var updatedValue = "UpdatedDescToInsert";

            //Setup data
            using (var context = new PaymentGenerationDbContext())
            {
                var originalTestSubnominals = CreateTestSubnominals();
                context.Subnominals.AddRange(TypeTransformer.TransformCollection<SubnominalsSheetType, Subnominal>(originalTestSubnominals));
                context.SaveChanges();
            }

            //Setup data received from config spreadsheet
            var newTestSubnominals = CreateTestSubnominals();
            newTestSubnominals[0].ShortDescription = updatedValue;

            // act
            PayGenSubnominalWriter.WriteToPaaSDatabase(newTestSubnominals, WriterBehaviour.AddOrUpdate);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var updatedRecord = context.Subnominals.Find(TestSubnominalToInsert);
                Assert.IsNotNull(updatedRecord);
                Assert.AreEqual(updatedValue, updatedRecord.ShortDescription);
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void WhenConfigContains_aSubnominalToBeDeleted_TheSubnominal_IsDeleted_InPaasTable()
        {
            // arrange
            var testSubnominals = CreateTestSubnominals();
            testSubnominals[0].PolicyStatus = PolicyStatus.Removed;

            //Setup data to delete
            using (var context = new PaymentGenerationDbContext())
            {
                context.Subnominals.AddRange(TypeTransformer.TransformCollection<SubnominalsSheetType, Subnominal>(testSubnominals));
                context.SaveChanges();
            }

            // act
            PayGenSubnominalWriter.WriteToPaaSDatabase(testSubnominals, WriterBehaviour.Delete);

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var deletedRecord = context.Subnominals.Find(TestSubnominalToInsert);
                Assert.IsNull(deletedRecord);
            }
        }

        private static List<SubnominalsSheetType> CreateTestSubnominals()
        {
            return new List<SubnominalsSheetType>
            {
                new SubnominalsSheetType
                {
                    SubnominalCode = TestSubnominalToInsert,
                    ShortDescription = TestSubnominalDesc,
                    PaymentType = "Capping",
                    PolicyStatus = PolicyStatus.Approved
                }
            };
        }
    }
}
