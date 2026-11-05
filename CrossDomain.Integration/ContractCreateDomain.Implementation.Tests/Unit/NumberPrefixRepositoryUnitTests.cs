namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;

    [TestClass]
    public class NumberPrefixRepositoryUnitTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void GetMasterContractPrefix_ShouldReturnAgencyPrefix()
        {
            var fake = new FakeXrmService(query => new[]
            {
                FakeXrmService.Row(query, (entity, column) => column == "sfa_contractreferenceprefix" ? "MAST" : null)
            });

            var prefix = new NumberPrefixRepository(fake.Service).GetMasterContractPrefix("FT");

            Assert.AreEqual("MAST", prefix);
            Assert.AreEqual("sfa_fundingtype", fake.Queries.Single().EntityName);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractPrefix_ShouldReturnFundingTypePrefix()
        {
            var fake = new FakeXrmService(query => new[]
            {
                FakeXrmService.Row(query, (entity, column) => column == "sfa_contractreferenceprefix" ? "CON" : null)
            });

            var prefix = new NumberPrefixRepository(fake.Service).GetContractPrefix("FT");

            Assert.AreEqual("CON", prefix);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetAllocationPrefix_ShouldReturnFundingStreamPeriodPrefix()
        {
            var fake = new FakeXrmService(query => new[]
            {
                FakeXrmService.Row(query, (entity, column) => column == "sfa_allocationreferenceprefix" ? "ALLOC" : null)
            });

            var prefix = new NumberPrefixRepository(fake.Service).GetAllocationPrefix("FSP");

            Assert.AreEqual("ALLOC", prefix);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractPrefix_ShouldThrow_WhenNoFundingTypeMatches()
        {
            var fake = new FakeXrmService(query => new Entity[0]);

            ThrowsHelper.Throws<InvalidOperationException>(
                () => new NumberPrefixRepository(fake.Service).GetContractPrefix("UNKNOWN"));
        }
    }
}
