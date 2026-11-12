namespace AllocationDeliveryDomain.Endpoint.Tests.MonitoringDeliverablesEnrichment
{
    using System.Collections.Generic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Events;

    [TestClass]
    public class ContractApprovedEventValidatorTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventValidator_ShouldReturnFalse_WhenMultipleChildContracts()
        {
            // arrange
            var message = new ContractApprovedEvent
            {
                CorporateContract = new Contract
                {
                    contracts = new List<contractType>
                    {
                        new contractType(),
                        new contractType()
                    }
                }
            };

            // act
            var result = ContractApprovedEventValidator.Validate(message);

            // assert
            Assert.IsFalse(result.Result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventValidator_ShouldReturnFalse_WhenNoChildContracts()
        {
            // arrange
            var message = new ContractApprovedEvent
            {
                CorporateContract = new Contract
                {
                    contracts = new List<contractType>()
                }
            };

            // act
            var result = ContractApprovedEventValidator.Validate(message);

            // assert
            Assert.IsFalse(result.Result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void ContractApprovedEventValidator_ShouldReturnFalse_WhenNotMasterContract()
        {
            // arrange
            var message = new ContractApprovedEvent
            {
                CorporateContract = new Contract
                {
                    hierarchyType = hierarchyType.CONTRACT,
                    contracts = new List<contractType>
                    {
                        new contractType()
                    }
                }
            };

            // act
            var result = ContractApprovedEventValidator.Validate(message);

            // assert
            Assert.IsFalse(result.Result);
        }
    }
}
