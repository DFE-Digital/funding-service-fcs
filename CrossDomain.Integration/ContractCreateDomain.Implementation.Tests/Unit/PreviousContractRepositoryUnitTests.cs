namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Optional;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;
    using Microsoft.Xrm.Sdk;
    using Microsoft.Xrm.Sdk.Query;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;

    [TestClass]
    public class PreviousContractRepositoryUnitTests
    {
        private static readonly Guid ContractId = Guid.NewGuid();
        private static readonly string[] ContractColumns = { "sfa_number", "sfa_startdate", "sfa_enddate", "sfa_description", "sfa_contracttype", "sfa_contractid", "sfa_lastapprovedversion", "sfa_latestversion" };
        private static readonly string[] AllocationColumns = { "sfa_contractallocationnumber", "sfa_fundingstreamcode", "sfa_fundingstreamperiodcode", "sfa_description" };

        [TestMethod, TestCategory("UnitTest")]
        public void GetLastApprovedContract_ShouldReturnContractWithAllocations()
        {
            var fake = CreateService(lastApproved: true, latest: false, withAllocation: true);

            var result = new PreviousContractRepository(fake.Service).GetLastApprovedContract("C-1");

            var contract = ExtractValue(result);
            Assert.AreEqual("M-1", contract.MasterContractReferenceNumber);
            Assert.AreEqual("Description", contract.ContractDescription);
            Assert.AreEqual(new DateTime(2018, 8, 1), contract.ContractStartDate);
            Assert.AreEqual(new DateTime(2019, 7, 31), contract.ContractEndDate);
            Assert.AreEqual(1, contract.PreviousAllocations.Count);
            var allocation = contract.PreviousAllocations.Single();
            Assert.AreEqual("A-1", allocation.AllocationNumber);
            Assert.AreEqual("FS", allocation.FundingStreamCode);
            Assert.AreEqual("FSP", allocation.FundingStreamPeriodCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldReturnContractFlaggedAsLatest()
        {
            var fake = CreateService(lastApproved: false, latest: true, withAllocation: false);

            var result = new PreviousContractRepository(fake.Service).GetLatestContract("C-1");

            var contract = ExtractValue(result);
            Assert.AreEqual("M-1", contract.MasterContractReferenceNumber);
            Assert.AreEqual(0, contract.PreviousAllocations.Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLastApprovedContract_ShouldReturnNone_WhenNoContractIsFlaggedAsLastApproved()
        {
            var fake = CreateService(lastApproved: false, latest: true, withAllocation: false);

            var result = new PreviousContractRepository(fake.Service).GetLastApprovedContract("C-1");

            Assert.IsNull(ExtractValueOrNull(result));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetLatestContract_ShouldReturnNone_WhenNoContractMatches()
        {
            var fake = new FakeXrmService(query => new Entity[0]);

            var result = new PreviousContractRepository(fake.Service).GetLatestContract("C-1");

            Assert.IsNull(ExtractValueOrNull(result));
        }

        private static FakeXrmService CreateService(bool lastApproved, bool latest, bool withAllocation)
        {
            return new FakeXrmService(query =>
            {
                if (query.EntityName == "sfa_contractallocation")
                {
                    return withAllocation
                        ? new[] { FakeXrmService.Row(query, AllocationValue, AllocationColumns) }
                        : new Entity[0];
                }

                return new[]
                {
                    FakeXrmService.Row(query, (entity, column) => ContractValue(column, lastApproved, latest), ContractColumns)
                };
            });
        }

        private static object ContractValue(string column, bool lastApproved, bool latest)
        {
            switch (column)
            {
                case "sfa_number": return "M-1";
                case "sfa_startdate": return new DateTime(2018, 8, 1);
                case "sfa_enddate": return new DateTime(2019, 7, 31);
                case "sfa_description": return "Description";
                case "sfa_contracttype": return new EntityReference("sfa_contracttype", Guid.NewGuid()) { Name = "Type" };
                case "sfa_contractid": return ContractId;
                case "sfa_lastapprovedversion": return lastApproved;
                case "sfa_latestversion": return latest;
                default: return null;
            }
        }

        private static object AllocationValue(string entity, string column)
        {
            switch (column)
            {
                case "sfa_contractallocationnumber": return "A-1";
                case "sfa_fundingstreamcode": return "FS";
                case "sfa_fundingstreamperiodcode": return "FSP";
                case "sfa_description": return "Alloc description";
                default: return null;
            }
        }

        private static PreviousContract ExtractValue(Option<PreviousContract> option)
        {
            var value = ExtractValueOrNull(option);
            Assert.IsNotNull(value, "Expected the repository to return a contract");
            return value;
        }

        private static PreviousContract ExtractValueOrNull(Option<PreviousContract> option)
        {
            return option.ValueOr((PreviousContract)null);
        }
    }
}
