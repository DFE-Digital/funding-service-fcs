namespace ContractRequestDomain.Tests
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class SagaContractRequestResultTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void DefaultConstructor_LeavesSerializedResultUnset()
        {
            var sagaResult = new SagaContractRequestResult();

            Assert.IsNull(sagaResult.SerializedContractRequestResult);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ConstructorAndGetContractRequestResult_RoundTripSuccessfulRequest()
        {
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { correlationId = "request-1" },
                contract = new contractType
                {
                    contractNumber = "master-1",
                    contracts = new List<contractType>
                    {
                        new contractType
                        {
                            correlationId = "contract-1",
                            contractNumber = "contract-number-1",
                            contractAllocations = new List<contractAllocation>
                            {
                                new contractAllocation
                                {
                                    correlationId = "allocation-1",
                                    contractAllocationNumber = "allocation-number-1"
                                },
                                new contractAllocation
                                {
                                    contractAllocationNumber = "allocation-number-without-correlation"
                                }
                            }
                        }
                    }
                }
            };

            var sagaResult = new SagaContractRequestResult(request);
            var result = sagaResult.GetContractRequestResult();

            Assert.AreEqual("request-1", result.CorrelationId);
            Assert.AreEqual("master-1", result.ContractNumbers["request-1"]);
            Assert.AreEqual("contract-number-1", result.ContractNumbers["contract-1"]);
            Assert.AreEqual("allocation-number-1", result.ContractNumbers["allocation-1"]);
            Assert.AreEqual(3, result.ContractNumbers.Count);
            Assert.IsTrue(sagaResult.SerializedContractRequestResult.Length > 0);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ConstructorAndGetContractRequestResult_RoundTripRequestErrors()
        {
            var error = new errorInfoType { Value = "Invalid contract" };
            var request = new contractRequestType
            {
                correlationInfo = new correlationInfoType { correlationId = "request-2" },
                errorInfo = new List<errorInfoType> { error }
            };

            var result = new SagaContractRequestResult(request).GetContractRequestResult();

            Assert.AreEqual("request-2", result.CorrelationId);
            Assert.AreEqual(error.Value, result.Errors[0].Value);
            Assert.IsNull(result.ContractNumbers);
        }
    }
}
