namespace FCT.Operations.Tests.FundingConfirmationReport.Extensions
{
    using System.Collections.Generic;
    using FluentAssertions;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Operations.FundingConfirmationReport.DTOs;
    using Operations.FundingConfirmationReport.Extensions;

    [TestClass]
    public class ReportRowsExtensionsTests
    {
        [TestMethod, TestCategory("UnitTest")]
        public void ReportRowsExtensions_GetDistinctFspsAndOrder_ShouldReturnDistinctSet()
        {
            // arrange
            List<ReportRow> reportRows = new List<ReportRow>
            {
                new ReportRow(1, string.Empty, string.Empty, new List<FspAllocationAndFunded>
                {
                    new FspAllocationAndFunded("FSP1", "FSP1", 1, 2, 1, PaymentMethod.PayOnProfile),
                    new FspAllocationAndFunded("FSP2", "FSP2", 1, 2, 2, PaymentMethod.PayOnInstruction),
                }),
                new ReportRow(1, string.Empty, string.Empty, new List<FspAllocationAndFunded>
                {
                    new FspAllocationAndFunded("FSP3", "FSP3", 1, 2, 3, PaymentMethod.PayOnActuals),
                    new FspAllocationAndFunded("FSP2", "FSP2", 1, 2, 2, PaymentMethod.PayOnInstruction),
                    new FspAllocationAndFunded("FSP5", "FSP5", 1, 2, 5, PaymentMethod.PayOnProfile),
                }),
                new ReportRow(1, string.Empty, string.Empty, new List<FspAllocationAndFunded>
                {
                    new FspAllocationAndFunded("FSP1", "FSP1", 1, 2, 1, PaymentMethod.PayOnProfile),
                    new FspAllocationAndFunded("FSP4", "FSP4", 1, 2, 4, PaymentMethod.PayOnActuals),
                }),
            };

            // act
            var fsps = reportRows.GetDistinctFspsAndOrder();

            // assert
            fsps.Count.Should().Be(5);
        }
    }
}
