namespace PaymentGenerationDomain.Integration.DataStore.Tests
{
    using System;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using MoreLinq;
    using PaymentGenerationDomain.Integration.DataStore.Model;
    using PaymentGenerationDomain.Integration.DataStore.Repositories;

    [TestClass]
    public class FundingStreamPeriodQueryRepositoryTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public async Task FundingStreamPeriodQueryRepository_ShouldGetFspWithFundingStreamPopulated()
        {
            // arrange
            const string fsp = "TestFSP";
            const string fs = "TestFS";

            DeleteFundingStream(fs);
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreamPeriods.Add(new FundingStreamPeriod
                {
                    Code = fsp,
                  
                    StartDate = DateTime.Today,
                    EndDate = DateTime.Today,
                    FundingStream = new FundingStream
                    {
                        AgencyCode = "A",
                        Code = fs,
                        FinanceShortCode = "F",
                        Name = "name"
                    },
                    FundingStreamCode = fsp,
                    Name = "X"
                });

                context.SaveChanges();
            }

            using (var context = new PaymentGenerationDbContext())
            {
                FundingStreamPeriodQueryRepository repository = new FundingStreamPeriodQueryRepository(context);

                // act
                var returnedFsp = await repository.GetFundingStreamPeriodWithFundingStream(fsp);
                var x = await repository.GetFundingStreamPeriodWithFundingStream(fsp);

                // assert
                Assert.IsNotNull(returnedFsp, "The returnedFsp is null");
                Assert.IsNotNull(returnedFsp.FundingStream, "The funding stream has not been returned");
                Assert.AreEqual(fs, returnedFsp.FundingStream.Code, "The funding stream code is not correct");
            }
            DeleteFundingStream(fs);
        }

        private void DeleteFundingStream(string fundingStream)
        {
            using (var context = new PaymentGenerationDbContext())
            {
                context.FundingStreams.Where(fs => fs.Code == fundingStream)
                    .ForEach(fs => context.FundingStreams.Remove(fs));

                context.SaveChanges();
            }
        }
    }
}
