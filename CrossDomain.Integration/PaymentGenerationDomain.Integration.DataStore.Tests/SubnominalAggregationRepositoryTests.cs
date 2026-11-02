namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System;
    using System.Linq;
    using MoreLinq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class SubnominalAggregationRepositoryTests
    {
        private const string PaymentType = "TESTPT";
        private const string OrgId = "ORG1";
        private const int Ukprn = 10018923;
        private const decimal AggregatedValue = 100m;
        private const string AgencyCode = "ESFA";
        private const string FinanceShortCode = "TFSC";
        private const string ShortDesc = "TESTDESC";
        private const string AllocSuffix = "TALLOC";
        private const string DummyFundingStreamCode = "FSTEST2";
        private const string DummyFspCode = "T1112";
        private const string DummySubnominalCode = "SCTEST1";

        private readonly DateTime _startDate = new DateTime(2012, 1, 1);
        private readonly DateTime _endDate = new DateTime(2014, 1, 1);

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_GetSubnominalAggregationsForPaymentByFspAndPeriod_ShouldPopulateAllPropertiesOfDto()
        {
            // arrange
            const string fundingStreamCode = "FSTEST2";
            const string period = "1";
            const string fspCode = "T1112";
            const string subnominalCode = "SCTEST1";

            ClearDownData(fundingStreamCode, new[] { fspCode }, new[] { subnominalCode });

            AddSubnominalAggregationsToDbForFspCodeAndPeriod(fundingStreamCode, fspCode, period, subnominalCode, count: 1);

            using (var context = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                // act
                var subnominalAggregation = repository.GetSubnominalAggregationsForPaymentByFspAndPeriod(fspCode, period, ConnectionInfo.CreateFrom(context.Database.Connection)).Single();

                // assert
                Assert.AreEqual(subnominalCode, subnominalAggregation.SubnominalCode, "SubnominalCode was not as expected");
                Assert.AreEqual(PaymentType, subnominalAggregation.PaymentType, "PaymentType was not as expected");
                Assert.AreEqual(OrgId, subnominalAggregation.OrganisationId, "OrganisationId was not as expected");
                Assert.AreEqual(Ukprn, subnominalAggregation.Ukprn, "Ukprn was not as expected");
                Assert.AreEqual(AggregatedValue, subnominalAggregation.AggregatedValue, "AggregatedValue was not as expected");
                Assert.AreEqual(FinanceShortCode, subnominalAggregation.FinanceShortCode, "FinanceShortCode was not as expected");
                Assert.AreEqual(AgencyCode, subnominalAggregation.AgencyCode, "AgencyCode was not as expected");
                Assert.AreEqual(ShortDesc, subnominalAggregation.ShortDescription, "ShortDescription was not as expected");
                Assert.AreEqual(_startDate, subnominalAggregation.StartDate, "StartDate was not as expected");
                Assert.AreEqual(_endDate, subnominalAggregation.EndDate, "EndDate was not as expected");
                Assert.AreEqual($"0{AllocSuffix}", subnominalAggregation.AllocationNumber, "AllocationNumber was not as expected");
                Assert.AreEqual(2, subnominalAggregation.AllocationVersionNumber, "AllocationVersionNumber was not as expected");
            }
            ClearDownData(fundingStreamCode, new[] { fspCode }, new[] { subnominalCode });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_GetSubnominalAggregationsForPaymentByFspAndPeriod_ShouldOnlyGetSubnominalInformationForFspCodeAndPeriodSpecified()
        {
            // arrange
            const string fundingStreamCode = "FSTEST";
            const string period = "1";

            string[] fspCodes = { "T1213", "T1314" };
            string[] subnominalCodes = { "SCTEST1", "SCTEST2", "SCTEST3" };
            int expectedCount = 5;

            ClearDownData(fundingStreamCode, fspCodes, subnominalCodes);

            AddSubnominalAggregationsToDbForFspCodeAndPeriod(fundingStreamCode: fundingStreamCode, fspCode: fspCodes[0], period: period, subnominalCode: subnominalCodes[0], count: expectedCount);
            AddSubnominalAggregationsToDbForFspCodeAndPeriod(fundingStreamCode: fundingStreamCode, fspCode: fspCodes[0], period: "2", subnominalCode: subnominalCodes[1], count: 2);
            AddSubnominalAggregationsToDbForFspCodeAndPeriod(fundingStreamCode: fundingStreamCode, fspCode: fspCodes[1], period: period, subnominalCode: subnominalCodes[2], count: 2);

            // act
            using (var ctx = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                var subnominalAggregations = repository.GetSubnominalAggregationsForPaymentByFspAndPeriod(fspCodes[0], period, ConnectionInfo.CreateFrom(ctx.Database.Connection));

                // assert
                Assert.AreEqual(expectedCount, subnominalAggregations.Count, "Count of Subnominal Aggregations was incorrect");
            }
            ClearDownData(fundingStreamCode, new[] { fundingStreamCode }, subnominalCodes );
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_HasOutstandingPaymentsForAllocation_WhenAllocationNumberHasPostedFlagAsFalseAndZeroAggregationValue_ShouldReturnFalse()
        {
            // arrange
            string allocationNumberUnderTest = "Allocation-testmain";

            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201801", false, 0);
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201802", true, 100m);

            AddSubnominalAggregationsToDbForAllocationAndPeriod("Other-Allocation", "201801", false, 200m);
            using (var context = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                // act
                bool returnValue = repository.HasOutstandingPaymentsForAllocation(allocationNumberUnderTest, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(returnValue);
            }
            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_HasOutstandingPaymentsForAllocation_WhenAllocationNumberHasPostedFlagAsFalseAndNonZeroAggregationValue_ShouldReturnTrue()
        {
            // arrange
            string allocationNumberUnderTest = "Allocation-testmain";

            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201801", false, 100m);
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201802", false, 0);

            using (var context = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                // act
                bool returnValue = repository.HasOutstandingPaymentsForAllocation(allocationNumberUnderTest, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsTrue(returnValue);
            }
            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_HasOutstandingPaymentsForAllocation_WhenAllocationNumberHasPostedFlagAsTrueAndNonZeroAggregationValue_ShouldReturnFalse()
        {
            // arrange
            string allocationNumberUnderTest = "Allocation-testmain";

            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201801", true, 100m);

            AddSubnominalAggregationsToDbForAllocationAndPeriod("Other-Allocation", "201801", false, 200m);
            using (var context = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                // act
                bool returnValue = repository.HasOutstandingPaymentsForAllocation(allocationNumberUnderTest, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(returnValue);
            }
            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void SubnominalAggregationRepository_HasOutstandingPaymentsForAllocation_WhenAllocationNumberHasPostedFlagAsTrueAndZeroAggregationValue_ShouldReturnFalse()
        {
            // arrange
            string allocationNumberUnderTest = "Allocation-testmain";

            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
            AddSubnominalAggregationsToDbForAllocationAndPeriod(allocationNumberUnderTest, "201801", true, 0);

            AddSubnominalAggregationsToDbForAllocationAndPeriod("Other-Allocation", "201801", false, 200m);
            using (var context = new PaymentGenerationDbContext())
            {
                var repository = new SubnominalAggregationRepository();

                // act
                bool returnValue = repository.HasOutstandingPaymentsForAllocation(allocationNumberUnderTest, ConnectionInfo.CreateFrom(context.Database.Connection));

                // assert
                Assert.IsFalse(returnValue);
            }
            ClearDownData(DummyFundingStreamCode, new[] { DummyFspCode }, new[] { DummySubnominalCode });
        }

        private static void ClearDownData(string fundingStreamCode, string[] fspCodes, string[] subnominalCodes)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                ClearDownFundingStreamPeriodsAndSubnominalAggregations(fspCodes, context);
                ClearDownSubnominals(subnominalCodes, context);
                ClearDownFundingStream(fundingStreamCode, context);
            }
        }

        private static void ClearDownFundingStreamPeriodsAndSubnominalAggregations(string[] fspCodes, PaymentGenerationDbContext context)
        {
            foreach (var code in fspCodes)
            {
                context.SubnominalAggregations
                    .Where(sa => sa.FundingStreamPeriodCode == code)
                    .ForEach(sa => context.SubnominalAggregations.Remove(sa));

                context.SaveChanges();

                context.FundingStreamPeriods
                    .Where(fsp => fsp.Code == code)
                    .ForEach(fsp => context.FundingStreamPeriods.Remove(fsp));

                context.SaveChanges();
            }
        }

        private static void ClearDownFundingStream(string fundingStreamCode, PaymentGenerationDbContext context)
        {
            FundingStream fs = context.FundingStreams.Find(fundingStreamCode);

            if (fs != null)
            {
                context.FundingStreams.Remove(fs);
                context.SaveChanges();
            }
        }

        private static void ClearDownSubnominals(string[] subnominalCodes, PaymentGenerationDbContext context)
        {
            foreach (var code in subnominalCodes)
            {
                Subnominal s = context.Subnominals.Find(code);

                if (s != null)
                {
                    context.Subnominals.Remove(s);
                    context.SaveChanges();
                }
            }
        }

        private void AddSubnominalAggregationsToDbForFspCodeAndPeriod(string fundingStreamCode, string fspCode, string period, string subnominalCode, int count)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                FundingStream fs = GetOrAddFundingStream(fundingStreamCode, context);
                FundingStreamPeriod fsp = GetOrAddFsp(fspCode, fs, context);
                Subnominal s = GetOrAddSubnominal(subnominalCode, context);

                Enumerable.Range(0, count)
                    .Select(i => new SubnominalAggregation
                    {
                        AllocationNumber = $"{i}{AllocSuffix}",
                        AllocationVersionNumber = 2,
                        FundingStreamPeriodCode = fspCode,
                        Period = period,
                        SubnominalCode = subnominalCode,
                        PaymentType = PaymentType,
                        PeriodTypeCode = "CM",
                        OrganisationId = OrgId,
                        Ukprn = Ukprn,
                        PostedFlag = false,
                        AggregatedValue = AggregatedValue,
                        IsSelectedForPayment = true,
                        Subnominal = s,
                        FundingStreamPeriod = fsp
                    })
                    .ForEach(sa =>
                    {
                        context.SubnominalAggregations.Add(sa);
                    });

                context.SaveChanges();
            }
        }

        private void AddSubnominalAggregationsToDbForAllocationAndPeriod(string allocationNumber, string period, bool postegFlag, decimal aggregatedValue)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                FundingStream fs = GetOrAddFundingStream(DummyFundingStreamCode, context);
                FundingStreamPeriod fsp = GetOrAddFsp(DummyFspCode, fs, context);
                Subnominal s = GetOrAddSubnominal(DummySubnominalCode, context);
                context.SubnominalAggregations.Add(new SubnominalAggregation
                {
                    AllocationNumber = allocationNumber,
                    FundingStreamPeriodCode = DummyFspCode,
                    Period = period,
                    SubnominalCode = DummySubnominalCode,
                    PaymentType = PaymentType,
                    PeriodTypeCode = "CM",
                    OrganisationId = OrgId,
                    Ukprn = Ukprn,
                    PostedFlag = postegFlag,
                    AggregatedValue = aggregatedValue,
                    IsSelectedForPayment = true,
                    Subnominal = s,
                    FundingStreamPeriod = fsp
                });
                context.SaveChanges();
            }
        }

        private static Subnominal GetOrAddSubnominal(string subnominalCode, PaymentGenerationDbContext context)
        {
            Subnominal subnominal = context.Subnominals.FirstOrDefault(s => s.Code == subnominalCode);

            if (subnominal == null)
            {
                subnominal = new Subnominal
                {
                    Code = subnominalCode,
                    ShortDescription = ShortDesc
                };

                context.Subnominals.Add(subnominal);
            }

            return subnominal;
        }

        private static FundingStream GetOrAddFundingStream(string fundingStreamCode, PaymentGenerationDbContext context)
        {
            FundingStream fundingStream = context.FundingStreams.FirstOrDefault(fs => fs.Code == fundingStreamCode);

            if (fundingStream == null)
            {
                fundingStream = new FundingStream
                {
                    Code = fundingStreamCode,
                    Name = fundingStreamCode,
                    AgencyCode = AgencyCode,
                    FinanceShortCode = FinanceShortCode
                };

                context.FundingStreams.Add(fundingStream);
            }

            return fundingStream;
        }

        private FundingStreamPeriod GetOrAddFsp(string fundingStreamPeriodCode, FundingStream fs, PaymentGenerationDbContext context)
        {
            var fundingStreamPeriod = context.FundingStreamPeriods.FirstOrDefault(fsp => fsp.Code == fundingStreamPeriodCode);

            if (fundingStreamPeriod == null)
            {
                fundingStreamPeriod = new FundingStreamPeriod
                {
                    Code = fundingStreamPeriodCode,
                    Name = fundingStreamPeriodCode,
                    FundingStreamCode = fs.Code,
                    StartDate = _startDate,
                    EndDate = _endDate,
                    FundingStream = fs
                };

                context.FundingStreamPeriods.Add(fundingStreamPeriod);
            }

            return fundingStreamPeriod;
        }
    }
}
