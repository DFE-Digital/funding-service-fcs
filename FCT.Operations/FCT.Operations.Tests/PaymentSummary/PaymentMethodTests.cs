namespace FCT.Operations.Tests.PaymentSummary
{
    using System;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.PaymentSummary;
    using Operations.PaymentSummary.Extensions;
    using System.Collections.Generic;
    using FCT.Operations.PaymentSummary.Repositories;

    [TestClass]
    public class PaymentMethodTests
    {
       
        [TestMethod, TestCategory("UnitTest")]
        public void PaymentMethod_ShouldReturnPOPPaymentMethodon3rdWorkingDay()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 06));

            // act
            var pMethod = PaymentLineSummaryRepository.GetPaymentInfo(reportingPeriod.Day);

            // assert
            Assert.AreEqual(1, pMethod.Count, "Payment Method count is invalid");           
            
        }


        [TestMethod, TestCategory("UnitTest")]
        public void PaymentMethod_ShouldReturnAllPaymentMethodAfteron7thWorkingDay()
        {
            // arrange
            ReportingPeriod reportingPeriod = new ReportingPeriod(new DateTime(2022, 12, 07));

            // act
            var pMethod = PaymentLineSummaryRepository.GetPaymentInfo(reportingPeriod.Day);

            // assert
            Assert.AreEqual(3, pMethod.Count, "Payment Method count is invalid");

        }
     
    }
}
