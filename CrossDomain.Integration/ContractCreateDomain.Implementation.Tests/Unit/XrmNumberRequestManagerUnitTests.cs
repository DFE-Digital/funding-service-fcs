namespace ContractCreateDomain.Implementation.Tests.Unit
{
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.ContractCreateDomain.Implementation.Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    [TestClass]
    public class XrmNumberRequestManagerUnitTests
    {
        private Mock<INumberPrefixRepository> _prefixRepository;
        private Mock<ISequenceRepository> _sequenceRepository;
        private XrmNumberRequestManager _manager;
        private ConnectionInfo _connectionInfo;

        [TestInitialize]
        public void Setup()
        {
            _prefixRepository = new Mock<INumberPrefixRepository>();
            _prefixRepository.Setup(r => r.GetMasterContractPrefix(It.IsAny<string>())).Returns("MPFX");
            _prefixRepository.Setup(r => r.GetContractPrefix(It.IsAny<string>())).Returns("CPFX");
            _prefixRepository.Setup(r => r.GetAllocationPrefix(It.IsAny<string>())).Returns("APFX");

            _sequenceRepository = new Mock<ISequenceRepository>();
            _sequenceRepository
                .Setup(r => r.GetNextNumber(SequenceType.Master, It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(1));
            _sequenceRepository
                .Setup(r => r.GetNextNumber(SequenceType.Contract, It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(2));
            _sequenceRepository
                .Setup(r => r.GetNextNumber(SequenceType.Allocation, It.IsAny<string>(), It.IsAny<ConnectionInfo>()))
                .Returns(Task.FromResult(3));

            _manager = new XrmNumberRequestManager(_prefixRepository.Object, _sequenceRepository.Object);
            _connectionInfo = new ConnectionInfo(null, new Mock<IDbConnection>().Object);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequests_ShouldRequestNumbersForEverythingWithoutOne()
        {
            var request = CreateRequest(null, null, null, null);

            var requests = _manager.GetNumberRequests(request);

            Assert.AreEqual(4, requests.Count);
            Assert.IsInstanceOfType(requests[0], typeof(MasterContractNumberRequest));
            Assert.IsInstanceOfType(requests[1], typeof(ContractNumberRequest));
            Assert.IsInstanceOfType(requests[2], typeof(AllocationNumberRequest));
            Assert.IsInstanceOfType(requests[3], typeof(AllocationNumberRequest));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequests_ShouldSkipItemsThatAlreadyHaveNumbers()
        {
            var request = CreateRequest("MASTER", "CONTRACT", "ALLOC1", null);

            var requests = _manager.GetNumberRequests(request);

            Assert.AreEqual(1, requests.Count);
            var allocation = (AllocationNumberRequest)requests[0];
            Assert.AreEqual("FS2", allocation.FundingStreamCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequests_ShouldFallBackToContractPeriodWhenAllocationHasNone()
        {
            var request = CreateRequest("MASTER", "CONTRACT", null, null);
            var contract = request.contract.contracts[0];
            contract.period = CreatePeriod("1718", "CY");
            contract.contractAllocations[0].period = null;

            var requests = _manager.GetNumberRequestsForAllocations(request);

            var fromContractPeriod = (AllocationNumberRequest)requests.First();
            Assert.AreEqual("1718", fromContractPeriod.Period);
            Assert.AreEqual("CY", fromContractPeriod.PeriodTypeCode);
            var fromAllocationPeriod = (AllocationNumberRequest)requests.Last();
            Assert.AreEqual("1516", fromAllocationPeriod.Period);
            Assert.AreEqual("AY", fromAllocationPeriod.PeriodTypeCode);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequests_ShouldTolerateContractsWithoutAllocations()
        {
            var request = CreateRequest(null, null, null, null);
            request.contract.contracts[0].contractAllocations = null;

            Assert.AreEqual(2, _manager.GetNumberRequests(request).Count);
            Assert.AreEqual(0, _manager.GetNumberRequestsForAllocations(request).Count);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetNumberRequestsForAllocations_ShouldOnlyRequestAllocationNumbers()
        {
            var request = CreateRequest(null, null, "ALLOC1", null);

            var requests = _manager.GetNumberRequestsForAllocations(request);

            Assert.AreEqual(1, requests.Count);
            Assert.IsInstanceOfType(requests[0], typeof(AllocationNumberRequest));
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractNumbers_ShouldPopulateAllNumbersUsingPrefixAndSequence()
        {
            var request = CreateRequest(null, null, null, null);

            var result = _manager.GetContractNumbers(request, _connectionInfo);

            Assert.AreSame(request, result);
            Assert.AreEqual("MPFX-1", request.contract.contractNumber);
            Assert.AreEqual("CPFX-2", request.contract.contracts[0].contractNumber);
            Assert.AreEqual("APFX-3", request.contract.contracts[0].contractAllocations[0].contractAllocationNumber);
            Assert.AreEqual("APFX-3", request.contract.contracts[0].contractAllocations[1].contractAllocationNumber);
            _prefixRepository.Verify(r => r.GetMasterContractPrefix("MAIN"), Times.Once);
            _prefixRepository.Verify(r => r.GetContractPrefix("MAIN"), Times.Once);
            _prefixRepository.Verify(r => r.GetAllocationPrefix("FSP1"), Times.Once);
            _prefixRepository.Verify(r => r.GetAllocationPrefix("FSP2"), Times.Once);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Master, "MPFX", _connectionInfo), Times.Once);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Contract, "MAIN", _connectionInfo), Times.Once);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Allocation, "FS1", _connectionInfo), Times.Once);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Allocation, "FS2", _connectionInfo), Times.Once);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractNumbers_ShouldNotOverwriteExistingNumbers()
        {
            var request = CreateRequest("MASTER", "CONTRACT", "ALLOC1", null);

            _manager.GetContractNumbers(request, _connectionInfo);

            Assert.AreEqual("MASTER", request.contract.contractNumber);
            Assert.AreEqual("CONTRACT", request.contract.contracts[0].contractNumber);
            Assert.AreEqual("ALLOC1", request.contract.contracts[0].contractAllocations[0].contractAllocationNumber);
            Assert.AreEqual("APFX-3", request.contract.contracts[0].contractAllocations[1].contractAllocationNumber);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Master, It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never);
            _sequenceRepository.Verify(r => r.GetNextNumber(SequenceType.Contract, It.IsAny<string>(), It.IsAny<ConnectionInfo>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PopulateContractAllocationNumbers_ShouldOnlyPopulateAllocations()
        {
            var request = CreateRequest(null, null, null, null);

            _manager.PopulateContractAllocationNumbers(request, _connectionInfo);

            Assert.IsNull(request.contract.contractNumber);
            Assert.IsNull(request.contract.contracts[0].contractNumber);
            Assert.AreEqual("APFX-3", request.contract.contracts[0].contractAllocations[0].contractAllocationNumber);
            Assert.AreEqual("APFX-3", request.contract.contracts[0].contractAllocations[1].contractAllocationNumber);
            _prefixRepository.Verify(r => r.GetMasterContractPrefix(It.IsAny<string>()), Times.Never);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void GetContractNumbers_ShouldThrowWhenSequenceTypeIsNotSet()
        {
            var notSet = new Mock<NumberRequest> { CallBase = false };
            notSet.Setup(n => n.GetSequenceType()).Returns(SequenceType.NotSet);
            notSet.Setup(n => n.GetPrefixContext()).Returns("ctx");

            try
            {
                _manager.GetContractNumbers(new List<NumberRequest> { notSet.Object }, _connectionInfo);
            }
            catch (InvalidOperationException)
            {
                return;
            }

            Assert.Fail("Expected InvalidOperationException");
        }

        private static periodType CreatePeriod(string period, string periodTypeCode)
        {
            return new periodType
            {
                period = period,
                periodType1 = new periodTypeType { periodTypeCode = periodTypeCode }
            };
        }

        private static contractRequestType CreateRequest(
            string masterNumber,
            string contractNumber,
            string firstAllocationNumber,
            string secondAllocationNumber)
        {
            return new contractRequestType
            {
                contract = new contractType
                {
                    contractNumber = masterNumber,
                    hierarchyType = hierarchyType.MASTERCONTRACT,
                    fundingTypeCode = "MAIN",
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            contractNumber = contractNumber,
                            hierarchyType = hierarchyType.CONTRACT,
                            fundingTypeCode = "MAIN",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    contractAllocationNumber = firstAllocationNumber,
                                    hierarchyType = contractAllocationHierarchyType.CONTRACTALLOCATION,
                                    fundingStreamCode = "FS1",
                                    fundingStreamPeriodCode = "FSP1",
                                    period = CreatePeriod("1516", "AY")
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = secondAllocationNumber,
                                    hierarchyType = contractAllocationHierarchyType.CONTRACTALLOCATION,
                                    fundingStreamCode = "FS2",
                                    fundingStreamPeriodCode = "FSP2",
                                    period = CreatePeriod("1516", "AY")
                                }
                            }
                        }
                    }
                }
            };
        }
    }
}
