
namespace ADMonitoringDomain.Endpoint.Tests.Unit
{
    using System.Data.Entity;
    using ADMonitoringDomain.Endpoint.BusinessLogic;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Moq;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Model;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore;
    using SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Model;

    [TestClass]
    public class RulesEngineTests
    {
        private readonly Mock<IPaymentSchedulePolicyContext> _paymentSchedulePolicyContextMock = new Mock<IPaymentSchedulePolicyContext>();
        private readonly Mock<IPaymentManagementPolicyContext> _paymentManagementPolicyContextMock = new Mock<IPaymentManagementPolicyContext>();
        const string AllocationNumber = "MAIN-123";
        const string WrongAllocationNumber = "MAIN-333";
        const int ContractVersionNumber = 1;
        const string FundingStreamPeriodCode = "16-18APPS1516";

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationActualRuleForPaymentAggregated_WhenPaymentTypeIsPoA()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentAggregated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentAggregated_WhenPaymentTypeIsPoP()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnProfile));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentAggregated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentAggregated_WhenPaymentTypeIsNoPay()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.NoPay));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentAggregated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentAggregated_WhenAllocationNumberIsNotFound()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentAggregated,
               WrongAllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForAllocationActualsVerified_WhenPaymentTypeIsPoA()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.AllocationActualsVerified,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationActualRuleForAllocationActualsVerified_WhenPaymentTypeIsPoP()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnProfile));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.AllocationActualsVerified,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForAllocationActualsVerified_WhenPaymentTypeIsNoPay()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.NoPay));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.AllocationActualsVerified,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForAllocationActualsVerified_WhenAllocationNumberIsNotFound()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.AllocationActualsVerified,
               WrongAllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentCalculated_WhenPaymentTypeIsPoA()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentCalculated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentCalculated_WhenPaymentTypeIsPoP()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnProfile));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentCalculated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationActualRuleForPaymentCalculated_WhenPaymentTypeIsNoPay()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.NoPay));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentCalculated,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationActualRuleForPaymentCalculated_WhenAllocationNumberIsNotFound()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentCalculated,
               WrongAllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationPaymentPostedRuleForPaymentPosted_WhenPaymentTypeIsPoA()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationPaymentPosted, RulesEngine.EventName.PaymentPosted,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationPaymentPostedRuleForPaymentPosted_WhenPaymentTypeIsPoP()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnProfile));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationPaymentPosted, RulesEngine.EventName.PaymentPosted,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForEvaluateContractAllocationPaymentPostedRuleForPaymentPosted_WhenPaymentTypeIsPoI()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnInstruction));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationPaymentPosted, RulesEngine.EventName.PaymentPosted,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }


        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationPaymentPostedRuleForPaymentPosted_WhenPaymentTypeIsNoPay()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.NoPay));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationPaymentPosted, RulesEngine.EventName.PaymentPosted,
                AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnFalseForEvaluateContractAllocationPaymentPostedRuleForPaymentPosted_WhenAllocationNumberIsNotFound()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.PayOnActuals));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationPaymentPosted, RulesEngine.EventName.PaymentPosted,
               WrongAllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsFalse(result);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void RulesEngine_ShouldReturnTrueForContractAllocationActualsReceivedRuleForPaymentCalculated_WhenPaymentMethodIsNoCalcNoPay()
        {
            // arrange
            _paymentSchedulePolicyContextMock.Setup(ps => ps.Allocations).Returns(GetAllocationsDbSet());
            _paymentManagementPolicyContextMock.Setup(pm => pm.PolicyFundingStreamPeriods)
                .Returns(GetPolicyFundingStreamPeriodDbSet(PaymentMethod.NoCalcAndNoPay));

            RulesEngine rulesEngine = new RulesEngine(_paymentSchedulePolicyContextMock.Object, _paymentManagementPolicyContextMock.Object);

            // act
            var result = rulesEngine.EvaluateRule(RulesEngine.RuleName.ContractAllocationActualsReceived, RulesEngine.EventName.PaymentCalculated,
               AllocationNumber, ContractVersionNumber);

            // assert
            Assert.IsTrue(result);
        }

        private IDbSet<Allocation> GetAllocationsDbSet()
        {
            IDbSet<Allocation> allocations = EfHelper.GetQueryableMockDbSet(
                new Allocation
                {
                    AllocationNumber = AllocationNumber,
                    VersionNumber = ContractVersionNumber,
                    FundingStreamPeriodCode = FundingStreamPeriodCode
                });

            return allocations;
        }

        private IDbSet<PolicyFundingStreamPeriod> GetPolicyFundingStreamPeriodDbSet(PaymentMethod paymentMethod)
        {
            var policyFundingStreamPeriodCode = new PolicyFundingStreamPeriod
            {
                FundingStreamPeriod = FundingStreamPeriodCode
            };

            switch (paymentMethod)
            {
                case PaymentMethod.PayOnActuals:
                    policyFundingStreamPeriodCode.PaymentMethod = PaymentMethod.PayOnActuals;
                    break;
                case PaymentMethod.PayOnProfile:
                    policyFundingStreamPeriodCode.PaymentMethod = PaymentMethod.PayOnProfile;
                    break;
                case PaymentMethod.PayOnInstruction:
                    policyFundingStreamPeriodCode.PaymentMethod = PaymentMethod.PayOnInstruction;
                    break;
                default:
                    policyFundingStreamPeriodCode.PaymentMethod = PaymentMethod.NoPay;
                    break;
            }

            IDbSet<PolicyFundingStreamPeriod> fundingStreamPeriods = EfHelper.GetQueryableMockDbSet(policyFundingStreamPeriodCode);
           return fundingStreamPeriods;
        }
    }
}
