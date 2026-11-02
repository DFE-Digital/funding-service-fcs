namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.UnitTests
{
    using System;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using PolicyCache.DataStore.Model;

    [TestClass]
    public class PolicyFundingStreamPeriodTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsCalculationRequiredForApproval_ShouldReturnTrueForPaymentMethodsRequiringCalculation()
        {
            Assert.IsTrue(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.NoPay }.IsCalculationRequiredForApproval());
            Assert.IsTrue(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnActuals }.IsCalculationRequiredForApproval());
            Assert.IsTrue(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnProfile }.IsCalculationRequiredForApproval());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsCalculationRequiredForApproval_ShouldReturnFalseForPaymentMethodsNotRequiringCalculation()
        {
            Assert.IsFalse(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnInstruction }.IsCalculationRequiredForApproval());
            Assert.IsFalse(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.NoCalcAndNoPay }.IsCalculationRequiredForApproval());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsCalculationRequiredForActuals_ShouldReturnTrueForPaymentMethodsRequiringCalculation()
        {
            Assert.IsTrue(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.NoPay }.IsCalculationRequiredForActuals());
            Assert.IsTrue(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnActuals }.IsCalculationRequiredForActuals());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsCalculationRequiredForActuals_ShouldReturnFalseForPaymentMethodsNotRequiringCalculation()
        {
            Assert.IsFalse(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnProfile }.IsCalculationRequiredForActuals());
            Assert.IsFalse(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.PayOnInstruction }.IsCalculationRequiredForActuals());
            Assert.IsFalse(new PolicyFundingStreamPeriod { PaymentMethod = PaymentMethod.NoCalcAndNoPay }.IsCalculationRequiredForActuals());
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsActive_ShouldReturnTrueWhenCurrentDateIsLessThanActivityCloseDate()
        {
            // arrange
            DateTime now = DateTime.Now;
            PolicyFundingStreamPeriod fsp = new PolicyFundingStreamPeriod
            {
                ActivityCloseDate = now.Date,
                PaymentMethod = PaymentMethod.PayOnActuals
            };

            // act
            bool isActive = fsp.IsActive(now.AddDays(-1));

            // assert
            Assert.IsTrue(isActive);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsActive_ShouldReturnTrueWhenCurrentDateIsSameDayAsActivityCloseDate()
        {
            // arrange
            DateTime now = DateTime.Now;
            PolicyFundingStreamPeriod fsp = new PolicyFundingStreamPeriod
            {
                ActivityCloseDate = now.Date,
                PaymentMethod = PaymentMethod.PayOnActuals
            };

            // act
            bool isActive = fsp.IsActive(now);

            // assert
            Assert.IsTrue(isActive);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsActive_ShouldReturnTrueWhenActivityCloseDateIsNull()
        {
            // arrange
            DateTime now = DateTime.Now;
            PolicyFundingStreamPeriod fsp = new PolicyFundingStreamPeriod
            {
                ActivityCloseDate = null,
                PaymentMethod = PaymentMethod.PayOnActuals
            };

            // act
            bool isActive = fsp.IsActive(now);

            // assert
            Assert.IsTrue(isActive);
        }

        [TestMethod, TestCategory("UnitTest")]
        public void PolicyFundingStreamPeriod_IsActive_ShouldReturnFalseWhenActivityCloseDateIsLessThanCurrentDate()
        {
            // arrange
            DateTime now = DateTime.Now;
            PolicyFundingStreamPeriod fsp = new PolicyFundingStreamPeriod
            {
                ActivityCloseDate = now.Date,
                PaymentMethod = PaymentMethod.PayOnActuals
            };

            // act
            bool isActive = fsp.IsActive(now.AddDays(1));

            // assert
            Assert.IsFalse(isActive);
        }
    }
}
