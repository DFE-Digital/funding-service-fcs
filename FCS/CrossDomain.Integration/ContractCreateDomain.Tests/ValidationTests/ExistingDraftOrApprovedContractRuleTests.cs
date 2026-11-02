namespace ContractCreateDomain.Tests.ValidationTests
{
    using System;
    using System.Linq;

    using Microsoft.VisualStudio.TestTools.UnitTesting;

    using SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    [TestClass]
    public class ExistingDraftOrApprovedContractRuleTests
    {
        [TestMethod, TestCategory("IntegrationTest")]
        public void ExistingDraftOrApprovedContractRule_Should_ReturnFailureIfRelevantPropertyIsSetToTrue()
        {
            // Arrange
            var rule = new ExistingDraftOrApprovedContractRule();
            var correlationId = Guid.NewGuid();
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new System.Collections.Generic.List<contractType>
                    {
                        new contractType
                        {
                            IsDraftOrApprovedContractForUkprnPresentInCrm= true,
                            correlationId = correlationId.ToString()
                        }
                    }
                }
            };

            // Act
            var actual = rule.GetFailuresForItem(contractRequest).ToList();

            // Assert
            Assert.AreEqual(1, actual.Count);
            Assert.AreEqual(correlationId.ToString(), actual[0]);
        }

        [TestMethod, TestCategory("IntegrationTest")]
        public void ExistingDraftOrApprovedContractRule_Should_NotReturnFailureIfRelevantPropertyIsSetToFalse()
        {
            // Arrange
            var rule = new ExistingDraftOrApprovedContractRule();
            var correlationId = Guid.NewGuid();
            var contractRequest = new contractRequestType
            {
                contract = new contractType
                {
                    contracts = new System.Collections.Generic.List<contractType>
                    {
                        new contractType
                        {
                            IsDraftOrApprovedContractForUkprnPresentInCrm= false,
                            correlationId = correlationId.ToString()
                        }
                    }
                }
            };

            // Act
            var actual = rule.GetFailuresForItem(contractRequest).ToList();

            // Assert
            Assert.AreEqual(0, actual.Count);
        }
    }
}