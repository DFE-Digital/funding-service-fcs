namespace ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Text.RegularExpressions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class CrmContractNumberTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void GetContractNumbersTest()
        {
            var manager = new XrmNumberRequestManager(
                new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                new SequenceRepository());

            var data = new List<NumberRequest>()
            {
                new MasterContractNumberRequest("MASTERCONTRACT", "MAIN"),
                new ContractNumberRequest("CONTRACT", "AGE"),
                new AllocationNumberRequest("CONTRACTALLOCATION", "AGE", "AGE", "1516", "AY", "AGE1516")
            };

            ConnectionInfo connectionInfo = new ConnectionInfo(
                null,
                new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            var result = manager.GetContractNumbers(data, connectionInfo);

            //Checks each entered NumberRequest has returned contract numbers. 
            foreach (NumberRequest requestResult in result)
            {
                Assert.IsFalse(string.IsNullOrEmpty(requestResult.ContractNumber));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void GetAndCompareContractNumbersTest()
        {
            var manager = new XrmNumberRequestManager(
                new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                new SequenceRepository());

            var data = new List<NumberRequest>()
            {
                new MasterContractNumberRequest("MASTERCONTRACT", "MAIN"),
                new ContractNumberRequest("CONTRACT", "MAIN"),
                new AllocationNumberRequest("CONTRACTALLOCATION", "MAIN", "ASTO", "1516", "AY", "ASTO1516")
            };

            var secondaryData = new List<NumberRequest>()
            {
                new MasterContractNumberRequest("MASTERCONTRACT", "MAIN"),
                new ContractNumberRequest("CONTRACT", "MAIN"),
                new AllocationNumberRequest("CONTRACTALLOCATION", "MAIN", "ASTO", "1516", "AY", "ASTO1516")
            };

            ConnectionInfo connectionInfo = new ConnectionInfo(
                null,
                new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));
            
            var initialResults = manager.GetContractNumbers(data, connectionInfo);

            var secondaryResults = manager.GetContractNumbers(secondaryData, connectionInfo);

            for (int i = 0; i < initialResults.Count; i++)
            {
                int initial = Convert.ToInt32(Regex.Match(initialResults[i].ContractNumber, @"\d+").Value);
                int secondary = Convert.ToInt32(Regex.Match(secondaryResults[i].ContractNumber, @"\d+").Value);
                Assert.IsTrue(initial + 1 == secondary);
            }
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NumberRequest_ShouldReturnSequenceType()
        {
            // arrange
            MasterContractNumberRequest masterContractNumberRequest = new MasterContractNumberRequest("MASTER", "AGE");
            ContractNumberRequest contractNumberRequest = new ContractNumberRequest("CONTRACT", "AGE");
            AllocationNumberRequest allocationNumberRequest = new AllocationNumberRequest("CONTRACTALLOCATION", "AGE", "AGE", "1718", "FY", "AGE1718");

            // act
            SequenceType masterContractSequenceType = masterContractNumberRequest.GetSequenceType();
            SequenceType contractSequenceType = contractNumberRequest.GetSequenceType();
            SequenceType allocationSequenceType = allocationNumberRequest.GetSequenceType();

            // assert
            Assert.AreEqual(SequenceType.Master, masterContractSequenceType);
            Assert.AreEqual(SequenceType.Contract, contractSequenceType);
            Assert.AreEqual(SequenceType.Allocation, allocationSequenceType);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void NumberRequest_ShouldReturnPrefixContext()
        {
            // arrange
            MasterContractNumberRequest masterContractNumberRequest = new MasterContractNumberRequest("MASTER", "AGE");
            ContractNumberRequest contractNumberRequest = new ContractNumberRequest("CONTRACT", "AGE");
            AllocationNumberRequest allocationNumberRequest = new AllocationNumberRequest("CONTRACTALLOCATION", "AGE", "AGE", "1718", "FY", "AGE1718");

            // act
            string masterContractPrefixContext = masterContractNumberRequest.GetPrefixContext();
            string contractPrefixContext = contractNumberRequest.GetPrefixContext();
            string allocationPrefixContext = allocationNumberRequest.GetPrefixContext();

            // assert
            Assert.AreEqual("AGE", masterContractPrefixContext);
            Assert.AreEqual("AGE", contractPrefixContext);
            Assert.AreEqual("AGE1718", allocationPrefixContext);
        }
    }
}
