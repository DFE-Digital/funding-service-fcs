namespace SFA.FCT.ContractCreateDomain.Implementation.Tests.IntegrationTests
{
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using CrmConnectionFactory = SFA.FCS.Worker.Common.Crm.CrmConnectionFactory;

    [TestClass]
    public class XrmNumberRequestManagerTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmNumberRequestManager_ShouldPopulateContractAllocationNumbersOnly_When_PopulateContractAllocationNumbersIsCalled()
        {
            const string masterContractNumber = "MCN";
            const string contractNumber = "CN";

            var numberRequestManager = new XrmNumberRequestManager(
                new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                new SequenceRepository());

            contractRequestType contract = CreateContractRequestType(masterContractNumber, contractNumber);

            // act
            var contractAllocations = contract.contract.contracts.First().contractAllocations;

            ConnectionInfo connectionInfo = new ConnectionInfo(
                null,
                new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            numberRequestManager.PopulateContractAllocationNumbers(contract, connectionInfo);

            // assert
            foreach (var contractAllocation in contractAllocations)
            {
                Assert.IsTrue(!string.IsNullOrEmpty(contractAllocation.contractAllocationNumber));
            }
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void XrmNumberRequestManager_ShouldNotPopulateContractNumbers_When_PopulateContractAllocationNumbersIsCalled()
        {
            const string masterContractNumber = "MCN";
            const string contractNumber = "CN";
            // arrange

            var numberRequestManager = new XrmNumberRequestManager(
                new NumberPrefixRepository(CrmConnectionFactory.GetRetryOnErrorOrganizationService()),
                new SequenceRepository());

            contractRequestType contract = CreateContractRequestType(masterContractNumber, contractNumber);

            ConnectionInfo connectionInfo = new ConnectionInfo(
                null,
                new SqlConnection(ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString));

            // act
            numberRequestManager.PopulateContractAllocationNumbers(contract, connectionInfo);

            // assert
            Assert.AreEqual(contractNumber, contract.contract.contracts.First().contractNumber);
        }

        private contractRequestType CreateContractRequestType(string masterContractNumber, string contractNumber)
        {
            periodType period = new periodType
            {
                periodType1 = new periodTypeType
                {
                    periodTypeCode = "AY"
                },
                period = "1516"
            };

            // arrange
            contractAllocation allocation1 = new contractAllocation
            {
                fundingStreamCode = "AGE",
                period = period,
                fundingStreamPeriodCode = "AGE1718"
            };

            contractAllocation allocation2 = new contractAllocation
            {
                fundingStreamCode = "16-18 APPS",
                period = period,
                fundingStreamPeriodCode = "16-18APPS1718"
            };

            return new contractRequestType
            {
                contract = new contractType
                {
                    contractNumber = masterContractNumber,
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    fundingTypeCode = "MAIN",
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            hierarchyType = hierarchyType.CONTRACT,
                            contractNumber = contractNumber,
                            fundingTypeCode = "MAIN",
                            contractAllocations = new List<contractAllocation>
                            {
                                allocation1,
                                allocation2
                            }
                        }
                    }
                },
                correlationInfo = new correlationInfoType
                {
                    batchId = "X"
                }
            };
        }
    }
}
