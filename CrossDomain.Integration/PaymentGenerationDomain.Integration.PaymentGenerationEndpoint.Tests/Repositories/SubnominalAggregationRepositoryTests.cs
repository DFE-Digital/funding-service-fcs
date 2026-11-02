namespace PaymentGenerationDomain.Integration.PaymentGeneration.Repositories
{
    using System.Linq;
    using DataStore;
    using DataStore.Model;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.DTOs;
    using PaymentGenerationEndpoint.AggregatePaymentEndpoint.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class SubnominalAggregationRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_ShouldGetGetSubnominalAggregations()
        {
            // arrange
            const string allocationNumber = "AN";
            const string period = "201910";
            const string fspCode = "fsp test";
            const string fundingStreamCode = "Test FS";
            const string subnominalCode = "12";
            const string otherSubnominalCode = "13";

            CreateTestFspInNotPresent(fspCode, fundingStreamCode);
            DeleteSubnominalAggregationsForAllocation(allocationNumber);
            CreateSubnominalIfNotPresent(subnominalCode);
            CreateSubnominalIfNotPresent(otherSubnominalCode);

            CreateSubnominalAggregation(allocationNumber, period, paymentType: "PROFILE", subnominalCode: subnominalCode, fspCode: fspCode, isPosted:false);
            CreateSubnominalAggregation(allocationNumber, period, paymentType: "PROFILE", subnominalCode: otherSubnominalCode, fspCode: fspCode, isPosted:false);

            // act
            using (var context = new PaymentGenerationDbContext())
            {
                var subnominalAggregations = new SubnominalAggregationRepository().GetSubnominalAggregations(allocationNumber, period,
                    ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.AreEqual(2, subnominalAggregations.Count, "The number of subnominals is incorrect");
            }
            DeleteSubnominalAggregationsForAllocation(allocationNumber);
            DeleteTestFsp(fspCode);
            DeleteTestFundingStream("Test FS");
            DeleteSubnominal(subnominalCode);
            DeleteSubnominal(otherSubnominalCode);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_ShouldUpdate()
        {
            // arrange
            const string allocationNumber = "AN";
            const string period = "201910";
            const string fspCode = "fsp test";
            const string fundingStreamCode = "Test FS";
            const string subnominalCode = "12";
            const string paymentType = "PROFILE";
            const decimal aggregatedValue = 10M;

            CreateTestFspInNotPresent(fspCode, fundingStreamCode);
            DeleteSubnominalAggregationsForAllocation(allocationNumber);
            CreateSubnominalIfNotPresent(subnominalCode);

            CreateSubnominalAggregation(allocationNumber, period, paymentType: paymentType, subnominalCode: subnominalCode, fspCode: fspCode, isPosted: false);
            
            // act
            using (var context = new PaymentGenerationDbContext())
            {
                new SubnominalAggregationRepository().Update(new SimpleSubnominalAggregation(
                    allocationNumber,
                    period,
                    subnominalCode,
                    paymentType,
                    isPosted:false)
                {
                    AggregatedValue = aggregatedValue,
                    VersionNumber = 2
                }, ConnectionInfo.CreateFrom(context.Database.Connection));
            }

            // assert
            using (var context = new PaymentGenerationDbContext())
            {
                var subnominalAggregation =
                    context.SubnominalAggregations.First(a => a.AllocationNumber == allocationNumber);
                Assert.AreEqual(aggregatedValue, subnominalAggregation.AggregatedValue, "The aggregated value is incorrect");
                Assert.AreEqual(2, subnominalAggregation.AllocationVersionNumber, "The version number is incorrect");
            }
            DeleteSubnominalAggregationsForAllocation(allocationNumber);
            DeleteTestFsp(fspCode);
            DeleteTestFundingStream("Test FS");
            DeleteSubnominal(subnominalCode);
        }

        private void DeleteSubnominalAggregationsForAllocation(string allocationNumber)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.Where(sa => sa.AllocationNumber == allocationNumber)
                    .ToList()
                    .ForEach(sa => context.SubnominalAggregations.Remove(sa));

                context.SaveChanges();
            }
        }

        private static void DeleteTestFsp(string fspCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreamPeriods.Where(fsp => fsp.Code == fspCode)
                    .ToList()
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private void DeleteTestFundingStream(string fsCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreams.Where(fs => fs.Code == fsCode)
                    .ToList()
                    .ForEach(fs => context.FundingStreams.Remove(fs));

                context.SaveChanges();
            }
        }

        private void DeleteSubnominal(string subnominalCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.Subnominals.Where(sn => sn.Code == subnominalCode)
                    .ToList()
                    .ForEach(sn => context.Subnominals.Remove(sn));

                context.SaveChanges();
            }
        }


        private static void CreateSubnominalAggregation(
            string allocationNumber,
            string period,
            string paymentType,
            string subnominalCode,
            string fspCode,
            bool isPosted)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.SubnominalAggregations.Add(new SubnominalAggregation
                {
                    AllocationNumber = allocationNumber,
                    Period = period,
                    SubnominalCode = subnominalCode,
                    PaymentType = paymentType,
                    FundingStreamPeriodCode = fspCode,
                    Ukprn = 101,
                    PostedFlag = isPosted
                });

                context.SaveChanges();
            }
        }

        private static void CreateTestFspInNotPresent(string fspCode, string fundingStreamCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                if (context.FundingStreamPeriods.Any(fsp => fsp.Code == fspCode) == false)
                {
                    context.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
                    FundingStream fundingStream = context.FundingStreams.Any(fs => fs.Code == fundingStreamCode) == false
                        ? new FundingStream
                        {
                            Code = fundingStreamCode,
                            Name = "Test FS Name",
                            AgencyCode = "AC",
                            FinanceShortCode = "FSC"
                        }
                        : null;

                    context.FundingStreamPeriods.Add(new FundingStreamPeriod
                    {
                        FundingStream = fundingStream,
                        Code = fspCode,
                        FundingStreamCode = fundingStreamCode,
                        Name = "FSP Name"
                    });
                }

                context.SaveChanges();
            }
        }

        private static void CreateSubnominalIfNotPresent(string subnominalCode)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                if (context.Subnominals.Any(s => s.Code == subnominalCode) == false)
                {
                    context.Subnominals.Add(new Subnominal
                    {
                        Code = subnominalCode,
                        ShortDescription = "SD"
                    });
                }

                context.SaveChanges();
            }
        }
    }
}
